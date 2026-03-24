from pydantic import BaseModel, field_validator
from datetime import datetime, timezone
from typing import List, Optional, Dict

class DoctorBase(BaseModel):
    id: int
    name: str
    specialty: str
    bio: Optional[str] = None
    experience_years: int
    rating: float
    location: Optional[Dict[str, float]] = None       # {"lat": float, "lon": float} or null
    is_available: bool
    availability_slots: Optional[List[datetime]] = None  # list of UTC datetimes or null

class DoctorOut(DoctorBase):
    model_config = {
        "from_attributes": True,
        "json_encoders": {
            datetime: lambda v: v.isoformat()  # ensure ISO 8601 strings in JSON
        }
    }

class ConsultationCreate(BaseModel):
    doctor_id: int
    scheduled_time: datetime
    duration_minutes: int = 30
    notes: Optional[str] = None

    @field_validator("scheduled_time")
    @classmethod
    def ensure_utc(cls, v: datetime):
        if v.tzinfo is None:
            raise ValueError("scheduled_time must include timezone (e.g. '2026-02-20T10:00:00Z')")
        return v.astimezone(timezone.utc)  # normalize to UTC

class ConsultationOut(BaseModel):
    id: int
    user_id: int
    doctor_id: int
    status: str
    scheduled_time: datetime
    duration_minutes: int
    notes: Optional[str] = None
    created_at: datetime

    model_config = {
        "from_attributes": True,
        "json_encoders": {
            datetime: lambda v: v.isoformat()
        }
    }