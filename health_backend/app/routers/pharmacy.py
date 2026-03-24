from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.pharmacy import PharmacyOut
from app.crud.pharmacy import get_nearby_pharmacies
from app.dependencies import get_current_user
from app.models.user import User, UserRole

router = APIRouter(prefix="/pharmacies", tags=["pharmacies"])

@router.get("/nearby", response_model=list[PharmacyOut])
async def get_nearby_pharmacies(
    lat: float = Query(...),
    lon: float = Query(...),
    radius_km: float = Query(10.0, ge=1.0, le=100.0),
    limit: int = Query(10, ge=1, le=100),
    db: AsyncSession = Depends(get_db)
):
    pharmacies = await get_nearby_pharmacies(db, lat, lon, radius_km, limit)
    return pharmacies