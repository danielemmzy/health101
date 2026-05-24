from sqlalchemy import ForeignKey, String, Float, Boolean
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.types import DateTime, JSON
from datetime import datetime
from app.database import Base


class Doctor(Base):
    __tablename__ = "doctors"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    
    
    user_id: Mapped[int] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"), 
        unique=True, 
        nullable=False
    )

    specialty: Mapped[str] = mapped_column(String(100), nullable=False)
    bio: Mapped[str | None] = mapped_column(String(500))
    experience_years: Mapped[int] = mapped_column(default=0)
    rating: Mapped[float] = mapped_column(default=0.0)
    location: Mapped[dict | None] = mapped_column(JSON)
    is_available: Mapped[bool] = mapped_column(default=True)
    is_verified: Mapped[bool] = mapped_column(default=False)
    availability_slots: Mapped[list | None] = mapped_column(ARRAY(DateTime), nullable=True)
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)

    
    user = relationship("User", back_populates="doctor_profile", uselist=False)

    consultations = relationship(
        "Consultation",
        back_populates="doctor",
        cascade="all, delete-orphan",
        passive_deletes=True
    )

   
    sent_messages = relationship(
        "ChatMessage",
        primaryjoin="Doctor.user_id == ChatMessage.sender_id",
        foreign_keys="[ChatMessage.sender_id]",
        viewonly=True
    )