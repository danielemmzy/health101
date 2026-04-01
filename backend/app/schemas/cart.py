from pydantic import BaseModel
from typing import List

class CartItem(BaseModel):
    product_id: int
    quantity: int = 1

class CartResponse(BaseModel):
    items: List[dict]
    total_items: int
    total_amount: float = 0.0