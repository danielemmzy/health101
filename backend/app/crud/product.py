from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update, delete
from app.models.products import Product
from app.schemas.product import ProductCreate, ProductUpdate
from fastapi import HTTPException
import uuid

def generate_slug(name: str) -> str:
    return f"{name.lower().replace(' ', '-')}-{uuid.uuid4().hex[:8]}"

async def create_product(db: AsyncSession, pharmacy_id: int, product_data: ProductCreate):
    slug = generate_slug(product_data.name)

    product = Product(
        pharmacy_id=pharmacy_id,
        name=product_data.name,
        slug=slug,
        description=product_data.description,
        price=product_data.price,
        stock_quantity=product_data.stock_quantity,
        category=product_data.category,
        prescription_required=product_data.prescription_required,
        image_url=product_data.image_url
    )

    db.add(product)
    await db.commit()
    await db.refresh(product)
    return product


async def get_product_by_id(db: AsyncSession, product_id: int):
    stmt = select(Product).where(Product.id == product_id)
    result = await db.execute(stmt)
    product = result.scalar_one_or_none()
    return product


async def get_products_by_pharmacy(db: AsyncSession, pharmacy_id: int, skip: int = 0, limit: int = 20):
    stmt = select(Product).where(
        Product.pharmacy_id == pharmacy_id,
        Product.is_active == True
    ).offset(skip).limit(limit)
    result = await db.execute(stmt)
    return result.scalars().all()


async def update_product(db: AsyncSession, product_id: int, product_data: ProductUpdate):
    # Build update values only for fields that are not None
    update_values = {}
    if product_data.name is not None:
        update_values["name"] = product_data.name
    if product_data.description is not None:
        update_values["description"] = product_data.description
    if product_data.price is not None:
        update_values["price"] = product_data.price
    if product_data.stock_quantity is not None:
        update_values["stock_quantity"] = product_data.stock_quantity
    if product_data.category is not None:
        update_values["category"] = product_data.category
    if product_data.prescription_required is not None:
        update_values["prescription_required"] = product_data.prescription_required
    if product_data.image_url is not None:
        update_values["image_url"] = product_data.image_url

    if not update_values:
        return None  # nothing to update

    stmt = (
        update(Product)
        .where(Product.id == product_id)
        .values(**update_values)
        .returning(Product)
    )

    result = await db.execute(stmt)
    await db.commit()
    updated_product = result.scalar_one_or_none()

    return updated_product


async def delete_product(db: AsyncSession, product_id: int):
    stmt = delete(Product).where(Product.id == product_id)
    result = await db.execute(stmt)
    await db.commit()
    return result.rowcount > 0