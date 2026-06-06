import json

from app.schemas.cart import CartItem
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.crud.cart import (
    add_to_cart, 
    get_cart, 
    clear_cart, 
    get_cart_count,
    apply_coupon
)
from app.schemas.cart import CartResponse
from redis.asyncio import Redis
from app.settings import settings

redis = Redis.from_url(settings.REDIS_URL)

router = APIRouter(prefix="/cart", tags=["cart"])

@router.post("/add")
async def add_item_to_cart(
    item: CartItem,                    
    current_user: User = Depends(get_current_user)
):
    cart = await add_to_cart(current_user.id, item.product_id, item.quantity)
    count = await get_cart_count(current_user.id)
    return {
        "message": "Item added to cart",
        "count": count,
        "cart": cart
    }


@router.get("/", response_model=CartResponse)
async def view_cart(current_user: User = Depends(get_current_user)):
    cart = await get_cart(current_user.id)
    return {
        "items": cart,
        "total_items": await get_cart_count(current_user.id),
        "total_amount": 0.0   # Calculate if needed
    }


@router.delete("/clear")
async def clear_user_cart(current_user: User = Depends(get_current_user)):
    await clear_cart(current_user.id)
    return {"message": "Cart cleared"}


@router.get("/count")
async def get_cart_count_endpoint(current_user: User = Depends(get_current_user)):
    count = await get_cart_count(current_user.id)
    return {"count": count}


@router.post("/coupon")
async def apply_coupon_endpoint(
    coupon_code: str,
    current_user: User = Depends(get_current_user)
):
    result = await apply_coupon(coupon_code)
    return result