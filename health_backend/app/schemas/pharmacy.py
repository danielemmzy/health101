from pydantic import BaseModel, ConfigDict
from typing import Optional, Dict
from datetime import datetime

class PharmacyBase(BaseModel):
    name: str
    address: Optional[str] = None
    contact_phone: Optional[str] = None
    whatsapp: Optional[str] = None
    location: Optional[Dict[str, float]] = None
    opening_hours: Optional[str] = None
    delivery_radius_km: float = 0.0

class PharmacyCreate(PharmacyBase):
    """Used by admin to create a new pharmacy profile"""
    pass

class PharmacyUpdate(BaseModel):
    """Used for partial updates by admin or pharmacy owner"""
    name: Optional[str] = None
    address: Optional[str] = None
    contact_phone: Optional[str] = None
    whatsapp: Optional[str] = None
    location: Optional[Dict[str, float]] = None
    opening_hours: Optional[str] = None
    delivery_radius_km: Optional[float] = None

class PharmacyOut(PharmacyBase):
    id: int
    user_id: int
    is_verified: bool
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)