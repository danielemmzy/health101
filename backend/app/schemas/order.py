from pydantic import BaseModel, ConfigDict
from typing import List, Optional
from datetime import datetime
from app.schemas.product import ProductOut

class OrderItemOut(BaseModel):
    product_id: int
    quantity: int
    price_at_purchase: float
    product: Optional[ProductOut] = None

    model_config = ConfigDict(from_attributes=True)

class OrderOut(BaseModel):
    id: int
    user_id: int
    pharmacy_id: int
    total_amount: float
    status: str
    delivery_address: Optional[str] = None
    created_at: datetime
    updated_at: datetime
    items: List[OrderItemOut] = []

    model_config = ConfigDict(from_attributes=True)

class OrderStatusUpdate(BaseModel):
    status: str