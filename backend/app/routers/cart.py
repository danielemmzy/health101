from fastapi import APIRouter, Depends, HTTPException
from app.dependencies import get_current_user
from app.models.user import User
from app.crud.cart import (
    add_to_cart, 
    get_cart, 
    clear_cart, 
    get_cart_count,
    apply_coupon
)
from app.schemas.cart import CartItem, CartResponse
from app.schemas.coupon import CouponApply

router = APIRouter(prefix="/cart", tags=["cart"])


# Get cart item count (for badge)
@router.get("/count")
async def get_cart_count_endpoint(
    current_user: User = Depends(get_current_user)
):
    count = await get_cart_count(current_user.id)
    return {"count": count}


# Add item to cart
@router.post("/add")
async def add_item_to_cart(
    item: CartItem,                    # Using schema
    current_user: User = Depends(get_current_user)
):
    cart = await add_to_cart(
        current_user.id, 
        item.product_id, 
        item.quantity
    )
    count = await get_cart_count(current_user.id)
    return {
        "message": "Item added to cart",
        "count": count,
        "cart": cart
    }


# View full cart
@router.get("/", response_model=CartResponse)
async def view_cart(current_user: User = Depends(get_current_user)):
    cart = await get_cart(current_user.id)
    return {
        "items": cart,
        "total_items": len(cart)
    }


# Clear cart
@router.delete("/clear")
async def clear_user_cart(current_user: User = Depends(get_current_user)):
    await clear_cart(current_user.id)
    return {"message": "Cart cleared successfully"}


# Apply coupon
@router.post("/coupon")
async def apply_coupon_endpoint(
    coupon: CouponApply, 
    current_user: User = Depends(get_current_user)
):
    result = await apply_coupon(coupon.code)   # Pass only code if no db needed
    return result