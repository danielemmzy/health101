from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.crud.admin import get_pending_products, approve_product
from app.schemas.product import ProductOut
from .base import admin_router, require_admin
from app.models.user import User

router = APIRouter(prefix="/admin", tags=["admin"])

@router.get("/products/pending", response_model=list[ProductOut])
async def list_pending_products(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin)
):
    products = await get_pending_products(db)
    return products

@router.post("/products/{product_id}/approve")
async def approve_product_endpoint(
    product_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_admin)
):
    success = await approve_product(db, product_id)
    if not success:
        raise HTTPException(status_code=404, detail="Product not found")
    return {"message": "Product approved successfully"}