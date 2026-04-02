from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.crud.admin import get_pending_doctors, approve_doctor
from app.routers import admin
from app.schemas.consultation import DoctorOut
from app.schemas.user import UserOut, UserUpdate
from .base import admin_router, require_admin
from app.dependencies import get_current_user
from app.models.user import User, UserRole

router = APIRouter(prefix="/admin", tags=["admin"])

@router.get("/profile", response_model=UserOut)
async def get_admin_profile(current_user: User = Depends(get_current_user)):
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Admin access required")
    return current_user

@router.patch("/profile")
async def update_admin_profile(
    update_data: UserUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Admin access required")
    
    # Update logic here
    return {"message": "Profile updated"}