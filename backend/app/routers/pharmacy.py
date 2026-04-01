from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.crud.user import create_user
from app.database import get_db
from app.schemas.pharmacy import PharmacyCreate, PharmacyUpdate, PharmacyOut
from app.crud.pharmacy import create_pharmacy, get_pharmacies_nearby, get_pharmacy_by_id, update_pharmacy, delete_pharmacy
from app.dependencies import get_current_user
from app.models.user import User, UserRole

router = APIRouter(prefix="/pharmacies", tags=["pharmacies"])

# Public: Get nearby pharmacies
@router.get("/nearby", response_model=list[PharmacyOut])
async def get_nearby_pharmacies(
    lat: float = Query(...),
    lon: float = Query(...),
    radius_km: float = Query(10.0, ge=1.0, le=100.0),
    limit: int = Query(10, ge=1, le=50),
    db: AsyncSession = Depends(get_db)
):
    pharmacies = await get_pharmacies_nearby(db, lat, lon, radius_km, limit)
    return pharmacies


# Public: Get single pharmacy by ID
@router.get("/{pharmacy_id}", response_model=PharmacyOut)
async def get_single_pharmacy(
    pharmacy_id: int,
    db: AsyncSession = Depends(get_db)
):
    pharmacy = await get_pharmacy_by_id(db, pharmacy_id)
    if not pharmacy:
        raise HTTPException(status_code=404, detail="Pharmacy not found")
    return pharmacy


# Admin Only: Register new pharmacy
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

    return {
        "id": pharmacy.id,
        "user_id": pharmacy.user_id,
        "email": user.email,
        "name": pharmacy.name,
        "address": pharmacy.address,
        "contact_phone": pharmacy.contact_phone,
        "whatsapp": pharmacy.whatsapp,
        "location": pharmacy.location,
        "opening_hours": pharmacy.opening_hours,
        "delivery_radius_km": pharmacy.delivery_radius_km,
        "is_verified": pharmacy.is_verified,
        "created_at": pharmacy.created_at,
        "updated_at": pharmacy.updated_at
    }


# Admin or Pharmacy Owner: Update pharmacy profile
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


# Admin Only: Delete pharmacy (soft delete recommended in production)
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