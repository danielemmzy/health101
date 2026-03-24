from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.product import ProductOut
from app.crud.product import get_products_by_pharmacy

router = APIRouter(prefix="/products", tags=["products"])

@router.get("/pharmacy/{pharmacy_id}", response_model=list[ProductOut])
async def get_pharmacy_products(
    pharmacy_id: int,
    skip: int = 0,
    limit: int = 20,
    db: AsyncSession = Depends(get_db)
):
    products = await get_products_by_pharmacy(db, pharmacy_id, skip, limit)
    return products