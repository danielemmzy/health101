from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.products import Product
from app.schemas.product import ProductCreate



async def create_product(db: AsyncSession, pharmacy_id: int, product_data: ProductCreate):
    product = Product(
        pharmacy_id=pharmacy_id,
        name=product_data.name,
        description=product_data.description,
        price=product_data.price,
        stock=product_data.stock,
        category=product_data.category,
        prescription_required=product_data.prescription_required,
        image_url=product_data.image_url
    )
    db.add(product)
    await db.commit()
    await db.refresh(product)
    return product

async def get_products_by_pharmacy(db: AsyncSession, pharmacy_id: int, skip: int = 0, limit: int = 20):
    stmt = select(Product).where(Product.pharmacy_id == pharmacy_id, Product.is_active == True).offset(skip).limit(limit)
    result = await db.execute(stmt)
    return result.scalars().all()