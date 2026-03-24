from datetime import timezone, datetime
import logging
from fastapi import APIRouter, Depends, HTTPException, Query, logger, status, WebSocket, WebSocketDisconnect, Request, Body
from sqlalchemy.ext.asyncio import AsyncSession
from app.crud.user import get_user_by_email
from app.database import get_db
from app.dependencies import get_current_user
from app.models.chat_message import ChatMessage
from app.schemas.consultation import ConsultationCreate, ConsultationOut, DoctorOut
from app.crud.consultation import create_consultation, get_consultation, get_doctor_by_user_id, get_user_consultations, is_doctor_of_consultation, update_consultation_status, list_available_doctors
from app.models.user import User
from typing import Dict, Optional, List
from app.celery import send_notification
from app.models.consultation import ConsultationStatus
from app.crud.chat import save_chat_message
from app.schemas.user import UserRole
from app.utils.security import verify_access_token
from sqlalchemy import select
from app.schemas.chat import ChatMessageOut


# In-memory connections per consultation 
connected_clients: Dict[int, List[WebSocket]] = {}  
logger = logging.getLogger(__name__)

router = APIRouter(prefix="/consultations", tags=["consultations"])

@router.get("/doctors", response_model=List[DoctorOut])
async def get_doctors(
    specialty: Optional[str] = None,
    location: Optional[Dict[str, float]] = None,
    skip: int = 0,
    limit: int = 10,
    db: AsyncSession = Depends(get_db)
):
    doctors = await list_available_doctors(db, specialty, location, skip, limit)
    return doctors

@router.post("/", response_model=ConsultationOut, status_code=201)
async def book_consultation(
    consultation_data: ConsultationCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
   
    # 1. Validate timezone presence
    if consultation_data.scheduled_time.tzinfo is None:
        raise HTTPException(
            status_code=422,
            detail="scheduled_time must include timezone (e.g. '2026-02-20T10:00:00Z' or '2026-02-20T11:00:00+01:00')"
        )

    # 2. Normalize to UTC 
    scheduled_time_utc = consultation_data.scheduled_time.astimezone(timezone.utc)

    # 3. Prevent booking in the past (UTC comparison)
    now_utc = datetime.now(timezone.utc)
    if scheduled_time_utc < now_utc:
        raise HTTPException(
            status_code=400,
            detail="Cannot book a consultation in the past"
        )

    # 4. Delegate to CRUD (pass UTC time)
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

    except HTTPException as e:
        # Re-raise any HTTP exceptions from CRUD (e.g. 409 conflict)
        raise e

    except Exception as e:
        # Catch unexpected errors (e.g. DB failure)
        raise HTTPException(
            status_code=500,
            detail="Failed to book consultation. Please try again."
        ) from e

@router.get("/me", response_model=List[ConsultationOut])
async def get_my_consultations(
    skip: int = 0,
    limit: int = 10,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    consultations = await get_user_consultations(db, current_user.id, skip, limit)
    return consultations

@router.post("/{consultation_id}/status")
async def update_status(
    consultation_id: int,
    body: dict = Body(...),  # Accept any JSON body
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    # Extract status from body
    status_str = body.get("status")
    if status_str is None:
        raise HTTPException(status_code=422, detail="Missing 'status' field in body")

    try:
        status = ConsultationStatus(status_str)
    except ValueError:
        raise HTTPException(
            status_code=422,
            detail=f"Invalid status value. Must be one of: {', '.join(ConsultationStatus.__members__.keys())}"
        )

    consultation = await update_consultation_status(db, consultation_id, status)
    if not consultation:
        raise HTTPException(status_code=404, detail="Consultation not found")

    # Optional notification (uncomment when ready)
    # send_notification.delay(consultation.user_id, f"Consultation status updated to {status.value}")

    return consultation

# WebSocket for chat
@router.websocket("/chat/{consultation_id}")
async def chat_endpoint(
    websocket: WebSocket,
    consultation_id: int,
    token: str = Query(...),
    db: AsyncSession = Depends(get_db)
):
    try:
        email = verify_access_token(token)
        user = await get_user_by_email(db, email)
        if not user or not user.is_active:
            await websocket.close(code=1008, reason="Invalid user")
            return
    except:
        await websocket.close(code=1008, reason="Invalid token")
        return

    consultation = await get_consultation(db, consultation_id)
    if not consultation:
        await websocket.close(code=1008, reason="Consultation not found")
        return

    # Allow patient or doctor
    is_patient = consultation.user_id == user.id
    is_doctor = user.role == UserRole.DOCTOR and consultation.doctor_id == user.id

    if not is_patient and not is_doctor:
        await websocket.close(code=1008, reason="Not authorized")
        return
    
    # NEW: Doctor verification check
    if is_doctor:
        doctor = await get_doctor_by_user_id(db, user.id)
        if not doctor or not doctor.is_verified:
            await websocket.close(code=1008, reason="Your doctor account is pending verification")
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

            # Save message
            saved_message = await save_chat_message(
                db=db,
                consultation_id=consultation_id,
                sender_id=user.id,
                content=data
            )

            # Broadcast
            broadcast_msg = f"{sender_label}: {data}"
            for client in connected_clients.get(consultation_id, []):
                try:
                    await client.send_text(broadcast_msg)
                except:
                    pass  # cleanup later

    except WebSocketDisconnect:
        connected_clients[consultation_id].remove(websocket)
        if not connected_clients[consultation_id]:
            del connected_clients[consultation_id]
        logger.info(f"{sender_label} {user.id} disconnected")


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

    # Only patient or doctor can see messages
    if consultation.user_id != current_user.id and not await is_doctor_of_consultation(db, current_user.id, consultation_id):
        raise HTTPException(status_code=403, detail="Not authorized to view this chat")

    stmt = (
        select(ChatMessage)
        .where(ChatMessage.consultation_id == consultation_id)
        .order_by(ChatMessage.created_at.asc())
        .offset(skip)
        .limit(limit)
    )

    result = await db.execute(stmt)
    messages = result.scalars().all()

    return messages