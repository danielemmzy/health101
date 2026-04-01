

from pydantic import BaseModel, EmailStr, ConfigDict, field_validator
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
    email: EmailStr                    # ← Added
    password: str                      # ← Added

    @field_validator("password")
    @classmethod
    def validate_password(cls, v: str):
        byte_len = len(v.encode('utf-8'))
        if len(v) < 8:
            raise ValueError("Password must be at least 8 characters long")
        if byte_len > 72:
            raise ValueError("Password too long (max 72 bytes)")
        return v

class PharmacyUpdate(PharmacyBase):
    """Used for partial updates by admin or pharmacy owner"""
    name: Optional[str] = None
    address: Optional[str] = None
    contact_phone: Optional[str] = None
    whatsapp: Optional[str] = None
    location: Optional[Dict[str, float]] = None
    opening_hours: Optional[str] = None
    delivery_radius_km: Optional[float] = None

class PharmacyOut(BaseModel):
    id: int
    user_id: int
    name: str
    address: Optional[str] = None
    contact_phone: Optional[str] = None
    whatsapp: Optional[str] = None
    location: Optional[Dict[str, float]] = None
    opening_hours: Optional[str] = None
    delivery_radius_km: float = 0.0
    is_verified: bool
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)