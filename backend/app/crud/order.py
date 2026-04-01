from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update
from app.models.orders import Order, OrderStatus
from app.models.order_item import OrderItem
from app.models.products import Product
from app.crud.cart import get_cart, clear_cart
from fastapi import HTTPException
from datetime import datetime
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload

async def create_order_from_cart(db: AsyncSession, user_id: int, pharmacy_id: int, delivery_address: str):
    cart = await get_cart(user_id)
    if not cart:
        raise HTTPException(status_code=400, detail="Cart is empty")

    total = 0.0
    order_items = []

    for item in cart:
        product = await db.get(Product, item["product_id"])
        if not product:
            raise HTTPException(status_code=404, detail=f"Product {item['product_id']} not found")
        
        if product.stock_quantity < item["quantity"]:
            raise HTTPException(status_code=400, detail=f"Insufficient stock for {product.name}")

        item_total = product.price * item["quantity"]
        total += item_total

        order_items.append(OrderItem(
            product_id=item["product_id"],
            quantity=item["quantity"],
            price_at_purchase=product.price
        ))

        # Reduce stock
        product.stock_quantity -= item["quantity"]

    # Ensure pharmacy_id is integer
    order = Order(
        user_id=user_id,
        pharmacy_id=int(pharmacy_id),
        total_amount=total,
        delivery_address=delivery_address,
        status=OrderStatus.PENDING
    )

    db.add(order)
    await db.commit()
    await db.refresh(order)

    # Add order items
    for item in order_items:
        item.order_id = order.id
        db.add(item)
    await db.commit()

    # Eager-load items and products to prevent async serialization errors
    stmt = select(Order).options(
        selectinload(Order.items).selectinload(OrderItem.product)
    ).where(Order.id == order.id)
    result = await db.execute(stmt)
    order_with_items = result.scalars().first()

    await clear_cart(user_id)

    return order_with_items

async def get_user_orders(db: AsyncSession, user_id: int, skip: int = 0, limit: int = 10):
    stmt = select(Order).where(Order.user_id == user_id).offset(skip).limit(limit).order_by(Order.created_at.desc())
    result = await db.execute(stmt)
    return result.scalars().all()

async def get_order_by_id(db: AsyncSession, order_id: int):
    stmt = select(Order).where(Order.id == order_id)
    result = await db.execute(stmt)
    return result.scalar_one_or_none()

async def update_order_status(db: AsyncSession, order_id: int, status: OrderStatus):
    stmt = update(Order).where(Order.id == order_id).values(status=status, updated_at=datetime.utcnow()).returning(Order)
    result = await db.execute(stmt)
    await db.commit()
    return result.scalar_one_or_none()