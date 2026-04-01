from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.product import ProductCreate, ProductUpdate, ProductOut
from app.crud.product import create_product, get_product_by_id, get_products_by_pharmacy, update_product, delete_product
from app.dependencies import get_current_user
from app.models.user import User, UserRole

router = APIRouter(prefix="/products", tags=["products"])

# Public: Get products from a specific pharmacy
@router.get("/pharmacy/{pharmacy_id}", response_model=list[ProductOut])
async def get_pharmacy_products(
    pharmacy_id: int,
    skip: int = 0,
    limit: int = 20,
    db: AsyncSession = Depends(get_db)
):
    products = await get_products_by_pharmacy(db, pharmacy_id, skip, limit)
    return products


# Public: Get single product
@router.get("/{product_id}", response_model=ProductOut)
async def get_single_product(
    product_id: int,
    db: AsyncSession = Depends(get_db)
):
    product = await get_product_by_id(db, product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product


# Admin Only: Create new product
@router.post("/", response_model=ProductOut, status_code=201)
async def create_new_product(
    product_data: ProductCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Only administrators can add new products")

    product = await create_product(db, product_data.pharmacy_id, product_data)
    return product


# Admin or Pharmacy Owner: Update product
@router.patch("/{product_id}", response_model=ProductOut)
async def update_existing_product(
    product_id: int,
    product_data: ProductUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role not in [UserRole.ADMIN, UserRole.PHARMACY]:
        raise HTTPException(status_code=403, detail="Not authorized")

    product = await update_product(db, product_id, product_data)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product


# Admin or Pharmacy Owner: Delete product
@router.delete("/{product_id}", status_code=204)
async def delete_existing_product(
    product_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role not in [UserRole.ADMIN, UserRole.PHARMACY]:
        raise HTTPException(status_code=403, detail="Not authorized to delete this product")

    success = await delete_product(db, product_id)
    if not success:
        raise HTTPException(status_code=404, detail="Product not found")
    return {"message": "Product deleted successfully"}