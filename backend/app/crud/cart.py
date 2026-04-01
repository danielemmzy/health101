from redis.asyncio import Redis
from sqlalchemy import select
from app.settings import settings
import json
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.coupon import Coupon
from fastapi import HTTPException

redis = Redis.from_url(settings.REDIS_URL or "redis://localhost:6379/0")

async def add_to_cart(user_id: int, product_id: int, quantity: int = 1):
    key = f"cart:{user_id}"
    cart = await get_cart(user_id)
    
    for item in cart:
        if item["product_id"] == product_id:
            item["quantity"] += quantity
            break
    else:
        cart.append({"product_id": product_id, "quantity": quantity})
    
    await redis.set(key, json.dumps(cart), ex=86400)  # 24 hours
    return cart

async def get_cart(user_id: int):
    key = f"cart:{user_id}"
    data = await redis.get(key)
    return json.loads(data) if data else []

async def clear_cart(user_id: int):
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