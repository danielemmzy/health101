# app/schemas/order.py
from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional
from app.models.orders import OrderStatus

class OrderItemOut(BaseModel):
    product_id: int
    quantity: int
    price_at_purchase: float
    product_name: Optional[str] = None   # Added for better UX

    class Config:
        from_attributes = True

class OrderCreate(BaseModel):
    pharmacy_id: int
    delivery_address: str
    payment_method: str = "stripe" or "cash_on_delivery"  # Default to Stripe, can be extended later

class OrderOut(BaseModel):
    id: int
    user_id: int
    pharmacy_id: Optional[int] = None
    total_amount: float
    status: str
    delivery_address: Optional[str] = None
    tracking_number: Optional[str] = None
    created_at: datetime
    updated_at: datetime
    items: List[OrderItemOut] = []

    class Config:
        from_attributes = True