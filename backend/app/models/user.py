from sqlalchemy import JSON, String, Boolean
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime
from app.database import Base
from enum import Enum as PyEnum


class UserRole(str, PyEnum):
    PATIENT = "PATIENT"
    DOCTOR = "DOCTOR"
    PHARMACY = "PHARMACY"
    ADMIN = "ADMIN"


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    email: Mapped[str] = mapped_column(
        String(255), unique=True, index=True, nullable=False
    )
    hashed_password: Mapped[str] = mapped_column(String(255), nullable=False)
    full_name: Mapped[str | None] = mapped_column(String(100))
    role: Mapped[UserRole] = mapped_column(default=UserRole.PATIENT)
    location: Mapped[dict | None] = mapped_column(
        JSON, nullable=True
    )  # {"lat": float, "lon": float} or null
    is_active: Mapped[bool] = mapped_column(default=True)
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)

    # Relationships
    consultations = relationship(
        "Consultation",
        back_populates="user",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )

    sent_messages = relationship(
        "ChatMessage",
        back_populates="sender",
        foreign_keys="[ChatMessage.sender_id]",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )

    # In app/models/user.py


pharmacy = relationship(
    "Pharmacy", 
    back_populates="user", 
    uselist=False)
