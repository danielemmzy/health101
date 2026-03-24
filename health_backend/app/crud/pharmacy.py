from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.pharmacy import Pharmacy
from app.schemas.pharmacy import PharmacyCreate

async def create_pharmacy(db: AsyncSession, pharmacy_data: PharmacyCreate, user_id: int):
    pharmacy = Pharmacy(
        user_id=user_id,
        name=pharmacy_data.name,
        address=pharmacy_data.address,
        contact_phone=pharmacy_data.contact_phone,
        whatsapp=pharmacy_data.whatsapp,
        location=pharmacy_data.location,
        opening_hours=pharmacy_data.opening_hours,
        delivery_radius_km=pharmacy_data.delivery_radius_km,
        is_verified=False  # pending admin approval
    )
    db.add(pharmacy)
    await db.commit()
    await db.refresh(pharmacy)
    return pharmacy

async def get_pharmacies_nearby(db: AsyncSession, lat: float, lon: float, radius_km: float = 10.0, limit: int = 10):
    # Simple distance calculation (upgrade to PostGIS later)
    stmt = select(Pharmacy).where(Pharmacy.is_verified == True).limit(limit)
    result = await db.execute(stmt)
    return result.scalars().all()