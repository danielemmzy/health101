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