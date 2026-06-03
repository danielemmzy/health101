from pydantic import BaseModel, ConfigDict, field_validator
from typing import Optional, List
from datetime import datetime
from enum import Enum as PyEnum

class ProductCategory(str, PyEnum):
    PAIN_RELIEF = "pain_relief"
    VITAMINS_SUPPLEMENTS = "vitamins_supplements"
    COLD_FLU = "cold_flu"
    DIGESTIVE = "digestive"
    SKIN_CARE = "skin_care"
    BABY_KIDS = "baby_kids"
    MEDICAL_DEVICES = "medical_devices"
    OTHER = "other"

class ProductBase(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    stock_quantity: int = 0
    category: ProductCategory
    prescription_required: bool = False
    image_urls: Optional[List[str]] = None      # Multiple images
    thumbnail_url: Optional[str] = None
    is_featured: bool = False

class ProductCreate(ProductBase):
    pharmacy_id: int

    @field_validator("price")
    @classmethod
    def price_positive(cls, v: float):
        if v <= 0:
            raise ValueError("Price must be positive")
        return v

class ProductUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    price: Optional[float] = None
    stock_quantity: Optional[int] = None
    category: Optional[ProductCategory] = None
    prescription_required: Optional[bool] = None
    image_urls: Optional[List[str]] = None
    thumbnail_url: Optional[str] = None
    is_featured: Optional[bool] = None

class ProductOut(ProductBase):
    id: int
    pharmacy_id: int
    is_active: bool
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)