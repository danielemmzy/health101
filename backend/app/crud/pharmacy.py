from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update, delete
from app.models.pharmacy import Pharmacy
from app.schemas.pharmacy import PharmacyCreate, PharmacyUpdate
from fastapi import HTTPException
from datetime import datetime

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
        is_verified=False
    )
    db.add(pharmacy)
    await db.commit()
    await db.refresh(pharmacy)
    return pharmacy


async def get_pharmacies_nearby(db: AsyncSession, lat: float, lon: float, radius_km: float = 10.0, limit: int = 10):
    stmt = select(Pharmacy).where(Pharmacy.is_verified == True).limit(limit)
    result = await db.execute(stmt)
    return result.scalars().all()


async def get_pharmacy_by_id(db: AsyncSession, pharmacy_id: int):
    stmt = select(Pharmacy).where(Pharmacy.id == pharmacy_id)
    result = await db.execute(stmt)
    return result.scalar_one_or_none()


async def update_pharmacy(db: AsyncSession, pharmacy_id: int, pharmacy_data: PharmacyUpdate):
    update_values = {}
    if pharmacy_data.name is not None:
        update_values["name"] = pharmacy_data.name
    if pharmacy_data.address is not None:
        update_values["address"] = pharmacy_data.address
    if pharmacy_data.contact_phone is not None:
        update_values["contact_phone"] = pharmacy_data.contact_phone
    if pharmacy_data.whatsapp is not None:
        update_values["whatsapp"] = pharmacy_data.whatsapp
    if pharmacy_data.location is not None:
        update_values["location"] = pharmacy_data.location
    if pharmacy_data.opening_hours is not None:
        update_values["opening_hours"] = pharmacy_data.opening_hours
    if pharmacy_data.delivery_radius_km is not None:
        update_values["delivery_radius_km"] = pharmacy_data.delivery_radius_km

    if not update_values:
        return None  # nothing to update

    update_values["updated_at"] = datetime.utcnow()

    stmt = (
        update(Pharmacy)
        .where(Pharmacy.id == pharmacy_id)
        .values(**update_values)
        .returning(Pharmacy)
    )

    result = await db.execute(stmt)
    await db.commit()
    updated_pharmacy = result.scalar_one_or_none()

    return updated_pharmacy


async def delete_pharmacy(db: AsyncSession, pharmacy_id: int):
    stmt = delete(Pharmacy).where(Pharmacy.id == pharmacy_id)
    result = await db.execute(stmt)
    await db.commit()
    return result.rowcount > 0