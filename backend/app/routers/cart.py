from fastapi import APIRouter, Depends, HTTPException
from app.crud.cart import add_to_cart, get_cart, clear_cart, apply_coupon
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.schemas.cart import CartItem, CartResponse
from app.schemas.coupon import CouponApply
from app.models.products import Product
from sqlalchemy.ext.asyncio import AsyncSession

router = APIRouter(prefix="/cart", tags=["cart"])

@router.post("/add")
async def add_item_to_cart(item: CartItem, current_user: User = Depends(get_current_user)):
    cart = await add_to_cart(current_user.id, item.product_id, item.quantity)
    return {"message": "Item added", "cart": cart}

@router.get("/", response_model=CartResponse)
async def view_cart(current_user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    cart_items = await get_cart(current_user.id)  # returns list of dicts with product_id & quantity
    total_amount = 0.0
    items_with_price = []

    for item in cart_items:
        product = await db.get(Product, item["product_id"])
        if product is None:
            continue  # skip missing products
        item_total = product.price * item["quantity"]
        total_amount += item_total
        items_with_price.append({
            "product_id": item["product_id"],
            "quantity": item["quantity"],
            "price": product.price,  # optional
            "total": item_total      # optional
        })

    return {
        "items": items_with_price,
        "total_items": len(items_with_price),
        "total_amount": total_amount
    }

@router.delete("/clear")
async def clear_user_cart(current_user: User = Depends(get_current_user)):
    await clear_cart(current_user.id)
    return {"message": "Cart cleared"}

@router.post("/coupon")
async def apply_coupon_endpoint(coupon: CouponApply, current_user: User = Depends(get_current_user), db = Depends(get_db)):
    result = await apply_coupon(db, current_user.id, coupon.code)
    return result