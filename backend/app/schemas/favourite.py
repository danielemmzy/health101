from pydantic import BaseModel
from typing import List

class FavouriteOut(BaseModel):
    id: int
    product_id: int
    product_name: str
    price: float
    image_url: str

    class Config:
        from_attributes = True