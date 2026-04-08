from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.crud.admin import get_pending_pharmacies, approve_pharmacy
from app.schemas.pharmacy import PharmacyOut
from .base import admin_router, require_admin
from app.models.user import User

router = APIRouter(prefix="/admin", tags=["admin"])

@router.get("/pharmacies/pending", response_model=list[PharmacyOut])
async def list_pending_pharmacies(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin)
):
    pharmacies = await get_pending_pharmacies(db)
    return pharmacies

@router.post("/pharmacies/{pharmacy_id}/approve")
async def approve_pharmacy_endpoint(
    pharmacy_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin)
):
    success = await approve_pharmacy(db, pharmacy_id)
    if not success:
        raise HTTPException(status_code=404, detail="Pharmacy not found")
    return {"message": "Pharmacy approved successfully"}