from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.crud.user import create_user
from app.database import get_db
from app.schemas.pharmacy import PharmacyCreate, PharmacyUpdate, PharmacyOut
from app.crud.pharmacy import create_pharmacy, get_pharmacies_nearby, get_pharmacy_by_id, update_pharmacy, delete_pharmacy
from app.dependencies import get_current_user
from app.models.user import User, UserRole

router = APIRouter(prefix="/pharmacies", tags=["pharmacies"])


# ==================== PUBLIC ROUTES ====================

# Improved Nearby Pharmacies
@router.get("/nearby", response_model=list[PharmacyOut])
async def get_nearby_pharmacies(
    lat: float = Query(..., description="Latitude"),
    lon: float = Query(..., description="Longitude"),
    radius_km: float = Query(10.0, ge=1.0, le=100.0, description="Search radius in km"),
    limit: int = Query(10, ge=1, le=50),
    db: AsyncSession = Depends(get_db)
):
    """Get pharmacies near a location"""
    pharmacies = await get_pharmacies_nearby(
        db, 
        lat=lat, 
        lon=lon, 
        radius_km=radius_km, 
        limit=limit
    )
    return pharmacies


# Get single pharmacy by ID
@router.get("/{pharmacy_id}", response_model=PharmacyOut)
async def get_single_pharmacy(
    pharmacy_id: int,
    db: AsyncSession = Depends(get_db)
):
    pharmacy = await get_pharmacy_by_id(db, pharmacy_id)
    if not pharmacy:
        raise HTTPException(status_code=404, detail="Pharmacy not found")
    return pharmacy


# ==================== ADMIN / PHARMACY OWNER ROUTES ====================

# Register new pharmacy (Admin only)
@router.post("/register", response_model=PharmacyOut, status_code=201)
async def register_pharmacy(
    pharmacy_data: PharmacyCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Only administrators can register new pharmacies")

    user = await create_user(
        db=db,
        email=pharmacy_data.email,
        password=pharmacy_data.password,
        full_name=pharmacy_data.name,
        role=UserRole.PHARMACY
    )

    if not user:
        raise HTTPException(status_code=400, detail="Email already registered")

    pharmacy = await create_pharmacy(
        db=db,
        pharmacy_data=pharmacy_data,
        user_id=user.id
    )

    return pharmacy


# Update pharmacy profile
@router.patch("/{pharmacy_id}", response_model=PharmacyOut)
async def update_pharmacy_profile(
    pharmacy_id: int,
    pharmacy_data: PharmacyUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role not in [UserRole.ADMIN, UserRole.PHARMACY]:
        raise HTTPException(status_code=403, detail="Not authorized to update this pharmacy")

    pharmacy = await update_pharmacy(db, pharmacy_id, pharmacy_data)
    if not pharmacy:
        raise HTTPException(status_code=404, detail="Pharmacy not found")
    return pharmacy


# Delete pharmacy
@router.delete("/{pharmacy_id}", status_code=204)
async def delete_pharmacy_profile(
    pharmacy_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Only administrators can delete pharmacies")

    success = await delete_pharmacy(db, pharmacy_id)
    if not success:
        raise HTTPException(status_code=404, detail="Pharmacy not found")