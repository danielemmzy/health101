from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update
from fastapi import HTTPException
from app.models.doctor import Doctor
from app.models.pharmacy import Pharmacy
from app.models.products import Product

# Pending Doctors
async def get_pending_doctors(db: AsyncSession):
    stmt = select(Doctor).where(Doctor.is_verified == False)
    result = await db.execute(stmt)
    return result.scalars().all()

async def approve_doctor(db: AsyncSession, doctor_id: int):
    stmt = update(Doctor).where(Doctor.id == doctor_id).values(is_verified=True).returning(Doctor)
    result = await db.execute(stmt)
    await db.commit()
    return result.scalar_one_or_none() is not None

# Pending Pharmacies
async def get_pending_pharmacies(db: AsyncSession):
    stmt = select(Pharmacy).where(Pharmacy.is_verified == False)
    result = await db.execute(stmt)
    return result.scalars().all()

async def approve_pharmacy(db: AsyncSession, pharmacy_id: int):
    stmt = update(Pharmacy).where(Pharmacy.id == pharmacy_id).values(is_verified=True).returning(Pharmacy)
    result = await db.execute(stmt)
    await db.commit()
    return result.scalar_one_or_none() is not None

# Pending Products (if you have is_verified on Product)
async def get_pending_products(db: AsyncSession):
    stmt = select(Product).where(Product.is_active == False)
    result = await db.execute(stmt)
    return result.scalars().all()

async def approve_product(db: AsyncSession, product_id: int):
    stmt = update(Product).where(Product.id == product_id).values(is_verified=True).returning(Product)
    result = await db.execute(stmt)
    await db.commit()
    return result.scalar_one_or_none() is not None