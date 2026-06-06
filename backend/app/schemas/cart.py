from pydantic import BaseModel
from typing import List, Optional

# For adding item to cart (Request Body)
class CartItem(BaseModel):
    product_id: int
    quantity: int = 1


# For returning cart items (Response)
class CartItemOut(BaseModel):
    product_id: int
    quantity: int
    product_name: Optional[str] = None
    price: Optional[float] = None
    total: Optional[float] = None

    class Config:
        from_attributes = True


# Full cart response
class CartResponse(BaseModel):
    items: List[CartItemOut]
    total_items: int
    total_amount: float = 0.0

    class Config:
        from_attributes = True