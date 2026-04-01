from fastapi import APIRouter, Body, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User, UserRole
from app.crud.order import create_order_from_cart, get_user_orders, get_order_by_id, update_order_status
from app.schemas.order import OrderOut, OrderStatusUpdate

router = APIRouter(prefix="/orders", tags=["orders"])

@router.post("/checkout", response_model=OrderOut, status_code=201)
async def checkout(
    checkout_data: dict = Body(...),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    delivery_address = checkout_data.get("delivery_address")
    pharmacy_id = checkout_data.get("pharmacy_id")   # ← Added

    if not delivery_address:
        raise HTTPException(status_code=422, detail="delivery_address is required")
    if not pharmacy_id:
        raise HTTPException(status_code=422, detail="pharmacy_id is required")

    order = await create_order_from_cart(db, current_user.id, pharmacy_id, delivery_address)
    return order

@router.get("/me", response_model=list[OrderOut])
async def get_my_orders(
    skip: int = 0,
    limit: int = 10,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    orders = await get_user_orders(db, current_user.id, skip, limit)
    return orders

@router.get("/{order_id}", response_model=OrderOut)
async def get_order_detail(
    order_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    order = await get_order_by_id(db, order_id)
    if not order or order.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Order not found")
    return order

@router.patch("/{order_id}/status")
async def update_order_status_endpoint(
    order_id: int,
    status_update: OrderStatusUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role not in [UserRole.ADMIN, UserRole.PHARMACY]:
        raise HTTPException(status_code=403, detail="Not authorized")
    
    order = await update_order_status(db, order_id, status_update.status)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return order