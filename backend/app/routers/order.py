from fastapi import APIRouter, Depends, HTTPException, Body
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User, UserRole
from app.crud.order import create_order_from_cart, get_user_orders, get_order_by_id, update_order_status
from app.schemas.order import OrderOut, OrderCreate

router = APIRouter(prefix="/orders", tags=["orders"])

@router.post("/checkout", response_model=OrderOut, status_code=201)
async def checkout(
    checkout_data: OrderCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    order = await create_order_from_cart(
        db=db,
        user_id=current_user.id,
        pharmacy_id=checkout_data.pharmacy_id,
        delivery_address=checkout_data.delivery_address
    )
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
    status_update: dict,   # {"status": "shipped"}
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role not in [UserRole.ADMIN, UserRole.PHARMACY]:
        raise HTTPException(status_code=403, detail="Not authorized")

    order = await update_order_status(db, order_id, status_update.get("status"))
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return order

@router.post("/checkout", response_model=OrderOut, status_code=201)
async def checkout(
    order_data: OrderCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create order from cart"""
    order = await create_order_from_cart(
        db=db,
        user_id=current_user.id,
        pharmacy_id=order_data.pharmacy_id,
        delivery_address=order_data.delivery_address
    )
    return order