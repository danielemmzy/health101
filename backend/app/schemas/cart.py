from pydantic import BaseModel
from typing import List

class CartItemOut(BaseModel):
    product_id: int
    quantity: int
    product_name: str
    price: float
    total: float

class CartResponse(BaseModel):
    items: List[CartItemOut]
    total_items: int
    total_amount: float