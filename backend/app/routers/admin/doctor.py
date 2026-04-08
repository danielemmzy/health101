from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.crud.admin import get_pending_doctors, approve_doctor
from app.schemas.consultation import DoctorOut
from .base import admin_router, require_admin
from app.dependencies import get_current_user
from app.models.user import User, UserRole

router = APIRouter(prefix="/admin", tags=["admin"])

@router.get("/doctors/pending", response_model=list[DoctorOut])
async def list_pending_doctors(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Admin access required")

    doctors = await get_pending_doctors(db)
    return doctors

@router.post("/doctors/{doctor_id}/approve")
async def approve_doctor_endpoint(
    doctor_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Admin access required")

    success = await approve_doctor(db, doctor_id)
    if not success:
        raise HTTPException(status_code=404, detail="Doctor not found or already approved")
    
    return {"message": "Doctor approved successfully"}