from datetime import timezone, datetime
import logging
import json
import asyncio

from fastapi import APIRouter, Depends, HTTPException, Query, WebSocket, WebSocketDisconnect
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import List

# Redis
from redis.asyncio import Redis
from app.settings import settings

# Your app modules
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User, UserRole
from app.models.chat_message import ChatMessage
from app.schemas.chat import ChatMessageCreate, ChatMessageOut
from app.schemas.consultation import ConsultationCreate, ConsultationOut, DoctorOut

from app.crud.consultation import (
    create_consultation,
    get_consultation,
    get_user_consultations,
    is_doctor_of_consultation,
    list_available_doctors,
    get_doctor_by_user_id
)
from app.crud.chat import create_chat_message
from app.crud.user import get_user_by_email
from app.utils.security import verify_access_token

# Initialize Redis (place this after imports)
redis = Redis.from_url(settings.REDIS_URL, decode_responses=True)

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/consultations", tags=["consultations"])

# In-memory active connections (for WebSocket)
connected_clients: dict[int, list[WebSocket]] = {}


# ====================== PUBLIC ROUTES ======================
@router.get("/doctors", response_model=List[DoctorOut])
async def get_doctors(
    specialty: str | None = None,
    location: dict[str, float] | None = None,
    skip: int = 0,
    limit: int = 10,
    db: AsyncSession = Depends(get_db)
):
    return await list_available_doctors(db, specialty, location, skip, limit)


@router.post("/", response_model=ConsultationOut, status_code=201)
async def book_consultation(
    consultation_data: ConsultationCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    if consultation_data.scheduled_time.tzinfo is None:
        raise HTTPException(status_code=422, detail="scheduled_time must include timezone")

    scheduled_time_utc = consultation_data.scheduled_time.astimezone(timezone.utc)
    if scheduled_time_utc < datetime.now(timezone.utc):
        raise HTTPException(status_code=400, detail="Cannot book in the past")

    return await create_consultation(
        db=db,
        user_id=current_user.id,
        doctor_id=consultation_data.doctor_id,
        scheduled_time=scheduled_time_utc,
        duration_minutes=consultation_data.duration_minutes,
        notes=consultation_data.notes
    )


@router.get("/me", response_model=List[ConsultationOut])
async def get_my_consultations(
    skip: int = 0,
    limit: int = 10,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    return await get_user_consultations(db, current_user.id, skip, limit)


# ====================== CHAT WITH REDIS PUB/SUB ======================
@router.websocket("/chat/{consultation_id}")
async def chat_endpoint(
    websocket: WebSocket,
    consultation_id: int,
    token: str = Query(...),
    db: AsyncSession = Depends(get_db)
):
    """Real-time chat using Redis Pub/Sub"""
    listen_task = None  # ← Fix for UnboundLocalError

    try:
        email = verify_access_token(token)
        user = await get_user_by_email(db, email)
        if not user or not user.is_active:
            await websocket.close(code=1008, reason="Invalid user")
            return
    except Exception:
        await websocket.close(code=1008, reason="Invalid token")
        return

    consultation = await get_consultation(db, consultation_id)
    if not consultation:
        await websocket.close(code=1008, reason="Consultation not found")
        return

    is_patient = consultation.user_id == user.id
    is_doctor = (user.role == UserRole.DOCTOR and consultation.doctor_id == user.id)

    if not is_patient and not is_doctor:
        await websocket.close(code=1008, reason="Not authorized")
        return

    if is_doctor:
        doctor = await get_doctor_by_user_id(db, user.id)
        if not doctor or not doctor.is_verified:
            await websocket.close(code=1008, reason="Doctor account pending verification")
            return

    sender_label = "Doctor" if is_doctor else "Patient"
    channel = f"chat:{consultation_id}"

    await websocket.accept()

    pubsub = redis.pubsub()
    await pubsub.subscribe(channel)

    try:
        async def listener():
            async for message in pubsub.listen():
                if message['type'] == 'message':
                    try:
                        await websocket.send_text(message['data'])
                    except:
                        break

        listen_task = asyncio.create_task(listener())

        while True:
            data = await websocket.receive_text()

            await create_chat_message(
                db=db,
                consultation_id=consultation_id,
                sender_id=user.id,
                content=data
            )

            message_payload = json.dumps({
                "sender_name": user.full_name or sender_label,
                "content": data,
                "sender_id": user.id,
                "created_at": datetime.utcnow().isoformat()
            })
            await redis.publish(channel, message_payload)

    except WebSocketDisconnect:
        logger.info(f"{sender_label} {user.id} disconnected from chat {consultation_id}")
    finally:
        if listen_task:
            listen_task.cancel()
        await pubsub.unsubscribe(channel)
        await pubsub.close()

@router.get("/{consultation_id}/messages", response_model=List[ChatMessageOut])
async def get_chat_history(
    consultation_id: int,
    skip: int = 0,
    limit: int = 50,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    consultation = await get_consultation(db, consultation_id)
    if not consultation:
        raise HTTPException(status_code=404, detail="Consultation not found")

    is_patient = consultation.user_id == current_user.id
    is_doctor = await is_doctor_of_consultation(db, current_user.id, consultation_id)

    if not is_patient and not is_doctor:
        raise HTTPException(status_code=403, detail="Not authorized")

    stmt = (
        select(
            ChatMessage,
            User.full_name.label("sender_name"),
            User.role.label("sender_role")
        )
        .join(User, ChatMessage.sender_id == User.id)
        .where(ChatMessage.consultation_id == consultation_id)
        .order_by(ChatMessage.created_at.asc())
        .offset(skip)
        .limit(limit)
    )

    result = await db.execute(stmt)
    rows = result.all()

    messages = []
    for row in rows:
        msg = row[0]
        messages.append({
            "id": msg.id,
            "consultation_id": msg.consultation_id,
            "sender_id": msg.sender_id,
            "sender_name": row.sender_name or "Unknown",
            "sender_role": row.sender_role,
            "content": msg.content,
            "created_at": msg.created_at,
            "is_read": msg.is_read,
        })

    return messages


@router.post("/{consultation_id}/messages", response_model=ChatMessageOut)
async def send_chat_message(
    consultation_id: int,
    message_data: ChatMessageCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    consultation = await get_consultation(db, consultation_id)
    if not consultation:
        raise HTTPException(status_code=404, detail="Consultation not found")

    is_patient = consultation.user_id == current_user.id
    is_doctor = (current_user.role == UserRole.DOCTOR and consultation.doctor_id == current_user.id)

    if not is_patient and not is_doctor:
        raise HTTPException(status_code=403, detail="Not authorized")

    message = await create_chat_message(
        db=db,
        consultation_id=consultation_id,
        sender_id=current_user.id,
        content=message_data.content
    )

    return message