from redis.asyncio import Redis
from sqlalchemy import select
from app.settings import settings
import json
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.coupon import Coupon
from fastapi import HTTPException

redis = Redis.from_url(settings.REDIS_URL)

async def get_cart(user_id: int):
    """Get user's cart from Redis"""
    key = f"cart:{user_id}"
    data = await redis.get(key)
    return json.loads(data) if data else []


async def add_to_cart(user_id: int, product_id: int, quantity: int = 1):
    """Add product to cart - with check if already exists"""
    key = f"cart:{user_id}"
    cart = await get_cart(user_id)

    # Check if product already in cart
    for item in cart:
        if item["product_id"] == product_id:
            item["quantity"] += quantity
            break
    else:
        # Product not in cart, add new
        cart.append({"product_id": product_id, "quantity": quantity})

    # Save back to Redis (24 hours expiry)
    await redis.set(key, json.dumps(cart), ex=86400)
    return cart


async def get_cart_count(user_id: int) -> int:
    """Return total number of items in cart"""
    cart = await get_cart(user_id)
    return sum(item.get("quantity", 0) for item in cart)


async def clear_cart(user_id: int):
    """Clear entire cart"""
    await redis.delete(f"cart:{user_id}")

async def apply_coupon(db: AsyncSession, user_id: int, code: str):
    stmt = select(Coupon).where(Coupon.code == code.upper(), Coupon.is_active == True)
    result = await db.execute(stmt)
    coupon = result.scalar_one_or_none()
    
    if not coupon:
        raise HTTPException(status_code=400, detail="Invalid or expired coupon code")
    
    return {
        "code": coupon.code,
        "discount_percent": coupon.discount_percent,
        "message": f"{coupon.discount_percent}% discount applied successfully!"
    }