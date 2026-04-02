from datetime import datetime
from pydantic import BaseModel, ConfigDict, EmailStr, field_validator
from typing import Optional, Dict

class DoctorRegister(BaseModel):
    email: EmailStr
    password: str
    full_name: Optional[str] = None
    specialty: str
    bio: Optional[str] = None
    location: Optional[Dict[str, float]] = None
    experience_years: int = 0

    @field_validator("password")
    @classmethod
    def validate_password(cls, v: str):
        byte_len = len(v.encode('utf-8'))
        if len(v) < 8:
            raise ValueError("Password must be at least 8 characters long")
        if byte_len > 72:
            raise ValueError("Password too long (max 72 bytes)")
        return v
    
    class DoctorOut(BaseModel):
        id: int
        user_id: int
        full_name: Optional[str] = None
        specialty: str
        bio: Optional[str] = None
        experience_years: int
        location: Optional[Dict[str, float]] = None
        is_available: bool = True
        is_verified: bool = False
        created_at: datetime

        model_config = ConfigDict(from_attributes=True)