# app/schemas/chat.py
from datetime import datetime
from pydantic import BaseModel
from app.schemas.user import UserRole

class ChatMessageCreate(BaseModel):
    content: str

class ChatMessageOut(BaseModel):
    id: int
    consultation_id: int
    sender_id: int
    sender_name: str
    sender_role: UserRole
    content: str
    created_at: datetime
    is_read: bool = False

    model_config = {"from_attributes": True}