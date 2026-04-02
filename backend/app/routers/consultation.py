# app/routers/consultation.py
from datetime import timezone, datetime
import logging
from fastapi import APIRouter, Depends, HTTPException, Query, status, WebSocket, WebSocketDisconnect, Body
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.crud.user import get_user_by_email
from app.database import get_db
from app.dependencies import get_current_user
from app.models.chat_message import ChatMessage
from app.models.user import User, UserRole
from app.schemas.consultation import ConsultationCreate, ConsultationOut, DoctorOut
from app.schemas.chat import ChatMessageOut
from app.crud.consultation import (
    create_consultation,
    get_consultation,
    get_user_consultations,
    is_doctor_of_consultation,
    list_available_doctors,
    get_doctor_by_user_id
)
from app.crud.chat import save_chat_message
from app.utils.security import verify_access_token
from app.models.consultation import ConsultationStatus

connected_clients: dict[int, list[WebSocket]] = {}
logger = logging.getLogger(__name__)

router = APIRouter(prefix="/consultations", tags=["consultations"])


# ====================== PUBLIC / PATIENT ROUTES ======================
@router.get("/doctors", response_model=list[DoctorOut])
async def get_doctors(
    specialty: str | None = None,
    location: dict[str, float] | None = None,
    skip: int = 0,
    limit: int = 10,
    db: AsyncSession = Depends(get_db)
):
    """Public: Browse available doctors"""
    return await list_available_doctors(db, specialty, location, skip, limit)


@router.post("/", response_model=ConsultationOut, status_code=201)
async def book_consultation(
    consultation_data: ConsultationCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Patient books a consultation"""
    if consultation_data.scheduled_time.tzinfo is None:
        raise HTTPException(status_code=422, detail="scheduled_time must include timezone")

    scheduled_time_utc = consultation_data.scheduled_time.astimezone(timezone.utc)
    if scheduled_time_utc < datetime.now(timezone.utc):
        raise HTTPException(status_code=400, detail="Cannot book in the past")

    try:
        consultation = await create_consultation(
            db=db,
            user_id=current_user.id,
            doctor_id=consultation_data.doctor_id,
            scheduled_time=scheduled_time_utc,
            duration_minutes=consultation_data.duration_minutes,
            notes=consultation_data.notes
        )
        return consultation
    except Exception as e:
        logger.error(f"Booking failed: {e}")
        raise HTTPException(status_code=500, detail="Failed to book consultation") from e


@router.get("/me", response_model=list[ConsultationOut])
async def get_my_consultations(
    skip: int = 0,
    limit: int = 10,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Patient views their own consultations"""
    return await get_user_consultations(db, current_user.id, skip, limit)


# ====================== SHARED ROUTES (Chat + History) ======================
@router.websocket("/chat/{consultation_id}")
async def chat_endpoint(
    websocket: WebSocket,
    consultation_id: int,
    token: str = Query(...),
    db: AsyncSession = Depends(get_db)
):
    """Real-time chat - patient or verified doctor"""
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

    # Enforce doctor verification
    if is_doctor:
        doctor = await get_doctor_by_user_id(db, user.id)
        if not doctor or not doctor.is_verified:
            await websocket.close(code=1008, reason="Doctor account pending verification")
            return

    sender_label = "Doctor" if is_doctor else "Patient"
    await websocket.accept()

    if consultation_id not in connected_clients:
        connected_clients[consultation_id] = []
    connected_clients[consultation_id].append(websocket)

    logger.info(f"{sender_label} {user.id} connected to chat {consultation_id}")

    try:
        while True:
            data = await websocket.receive_text()
            await save_chat_message(
                db=db,
                consultation_id=consultation_id,
                sender_id=user.id,
                content=data
            )

            broadcast_msg = f"{sender_label}: {data}"
            for client in connected_clients.get(consultation_id, []):
                try:
                    await client.send_text(broadcast_msg)
                except:
                    pass
    except WebSocketDisconnect:
        if consultation_id in connected_clients:
            connected_clients[consultation_id].remove(websocket)
            if not connected_clients[consultation_id]:
                del connected_clients[consultation_id]
        logger.info(f"{sender_label} {user.id} disconnected")


@router.get("/{consultation_id}/messages", response_model=list[ChatMessageOut])
async def get_chat_history(
    consultation_id: int,
    skip: int = 0,
    limit: int = 50,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Patient or doctor of this consultation can view history"""
    consultation = await get_consultation(db, consultation_id)
    if not consultation:
        raise HTTPException(status_code=404, detail="Consultation not found")

    is_patient = consultation.user_id == current_user.id
    is_doctor = await is_doctor_of_consultation(db, current_user.id, consultation_id)

    if not is_patient and not is_doctor:
        raise HTTPException(status_code=403, detail="Not authorized to view this chat")

    stmt = (
        select(ChatMessage)
        .where(ChatMessage.consultation_id == consultation_id)
        .order_by(ChatMessage.created_at.asc())
        .offset(skip)
        .limit(limit)
    )
    result = await db.execute(stmt)
    return result.scalars().all()