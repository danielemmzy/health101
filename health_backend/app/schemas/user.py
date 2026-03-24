from datetime import datetime
from pydantic import BaseModel, EmailStr, field_validator, ConfigDict
from typing import Optional, Dict
from enum import Enum as PyEnum
from app.models.user import UserRole  # assuming this is where UserRole lives


class UserBase(BaseModel):
    email: EmailStr
    full_name: Optional[str] = None
    role: UserRole = UserRole.PATIENT
    location: Optional[Dict[str, float]] = None  # {"lat": float, "lon": float} or null


class UserCreate(UserBase):
    password: str

    @field_validator("password")
    @classmethod
    def validate_password(cls, v: str):
        byte_len = len(v.encode('utf-8'))
        if len(v) < 8:
            raise ValueError("Password must be at least 8 characters long")
        if byte_len > 72:
            raise ValueError("Password too long (max 72 bytes for bcrypt)")
        # Optional: enforce complexity (uncomment if needed)
        # if not any(c.isupper() for c in v):
        #     raise ValueError("Password must contain at least one uppercase letter")
        # if not any(c.isdigit() for c in v):
        #     raise ValueError("Password must contain at least one digit")
        return v


class UserUpdate(UserBase):
    password: Optional[str] = None

    @field_validator("password")
    @classmethod
    def validate_password(cls, v: Optional[str]):
        if v is not None:
            byte_len = len(v.encode('utf-8'))
            if len(v) < 8:
                raise ValueError("Password must be at least 8 characters long")
            if byte_len > 72:
                raise ValueError("Password too long (max 72 bytes)")
        return v


class UserOut(UserBase):
    id: int
    is_active: bool
    created_at: datetime

    model_config = ConfigDict(
        from_attributes=True,
        json_encoders={datetime: lambda v: v.isoformat()},
        # exclude={"hashed_password"}  # ← use this instead of exclude dict for clarity
        exclude_unset=True,          # only include fields that were set (cleaner responses)
        populate_by_name=True,       # allow aliasing if needed later
    )