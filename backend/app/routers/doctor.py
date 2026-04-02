from typing import Dict, Optional
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, EmailStr, field_validator
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.doctor import DoctorRegister
from app.schemas.user import UserOut
from app.crud.user import create_user
from app.models.doctor import Doctor
from app.models.user import UserRole
from fastapi import APIRouter, Depends, HTTPException, status, Body
from sqlalchemy.ext.asyncio import AsyncSession
from datetime import datetime, timezone
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User, UserRole
from app.schemas.consultation import ConsultationOut
from app.crud.consultation import (
    update_consultation_status,
    get_doctor_by_user_id
)
from app.crud.doctor import (get_doctor_consultations,
    accept_consultation,
    reject_consultation,)
from app.models.consultation import ConsultationStatus

router = APIRouter(prefix="/doctors", tags=["doctors"])


@router.post("/register", response_model=UserOut, status_code=201)
async def register_doctor(
    doctor_data: DoctorRegister,
    db: AsyncSession = Depends(get_db)
):
    # Create user with DOCTOR role
    user = await create_user(
        db,
        email=doctor_data.email,
        password=doctor_data.password,
        full_name=doctor_data.full_name,
        role=UserRole.DOCTOR
    )
    if not user:
        raise HTTPException(status_code=400, detail="Email already registered")

    # Create doctor profile linked to user
    doctor = Doctor(
        user_id=user.id,
        specialty=doctor_data.specialty,
        bio=doctor_data.bio,
        location=doctor_data.location,
        experience_years=doctor_data.experience_years,
        is_verified=False
    )
    db.add(doctor)
    await db.commit()
    await db.refresh(user)  # optional: refresh user if needed

    return user



router = APIRouter(prefix="/doctors", tags=["doctors"])


@router.get("/consultations", response_model=list[ConsultationOut])
async def get_doctor_consultations_endpoint(
    skip: int = 0,
    limit: int = 20,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Doctor dashboard - view all their consultations"""
    if current_user.role != UserRole.DOCTOR:
        raise HTTPException(status_code=403, detail="Doctor access only")

    doctor = await get_doctor_by_user_id(db, current_user.id)
    if not doctor or not doctor.is_verified:
        raise HTTPException(status_code=403, detail="Your doctor account is pending verification")

    return await get_doctor_consultations(db, doctor.id, skip, limit)


@router.post("/consultations/{consultation_id}/accept", response_model=dict)
async def doctor_accept_consultation(
    consultation_id: int,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Doctor accepts a pending consultation"""
    if current_user.role != UserRole.DOCTOR:
        raise HTTPException(status_code=403, detail="Doctor access only")

    doctor = await get_doctor_by_user_id(db, current_user.id)
    if not doctor or not doctor.is_verified:
        raise HTTPException(status_code=403, detail="Doctor account pending verification")

    consultation = await accept_consultation(db, consultation_id, doctor.id)
    if not consultation:
        raise HTTPException(status_code=404, detail="Consultation not found or cannot be accepted")

    return {"message": "Consultation accepted successfully", "consultation_id": consultation_id}


@router.post("/consultations/{consultation_id}/reject", response_model=dict)
async def doctor_reject_consultation(
    consultation_id: int,
    reason: str | None = Body(None),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Doctor rejects a pending consultation"""
    if current_user.role != UserRole.DOCTOR:
        raise HTTPException(status_code=403, detail="Doctor access only")

    doctor = await get_doctor_by_user_id(db, current_user.id)
    if not doctor or not doctor.is_verified:
        raise HTTPException(status_code=403, detail="Doctor account pending verification")

    consultation = await reject_consultation(db, consultation_id, doctor.id, reason)
    if not consultation:
        raise HTTPException(status_code=404, detail="Consultation not found or cannot be rejected")

    return {"message": "Consultation rejected", "consultation_id": consultation_id}


@router.post("/consultations/{consultation_id}/status")
async def doctor_update_status(
    consultation_id: int,
    body: dict = Body(...),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Doctor updates consultation status"""
    if current_user.role != UserRole.DOCTOR:
        raise HTTPException(status_code=403, detail="Doctor access only")

    doctor = await get_doctor_by_user_id(db, current_user.id)
    if not doctor or not doctor.is_verified:
        raise HTTPException(status_code=403, detail="Doctor account pending verification")

    status_str = body.get("status")
    if not status_str:
        raise HTTPException(status_code=422, detail="Missing 'status' field")

    try:
        status = ConsultationStatus(status_str)
    except ValueError:
        raise HTTPException(status_code=422, detail=f"Invalid status. Valid values: {list(ConsultationStatus)}")

    consultation = await update_consultation_status(db, consultation_id, status)
    if not consultation:
        raise HTTPException(status_code=404, detail="Consultation not found")

    return {"message": f"Status updated to {status.value}", "consultation": consultation}