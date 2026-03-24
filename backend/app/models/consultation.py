from sqlalchemy.types import DateTime
from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime
from app.database import Base
from enum import Enum as PyEnum

class ConsultationStatus(str, PyEnum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    COMPLETED = "completed"
    CANCELLED = "cancelled"

class Consultation(Base):
    __tablename__ = "consultations"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), index=True, nullable=False)
    doctor_id: Mapped[int] = mapped_column(ForeignKey("doctors.id"), index=True, nullable=False)
    status: Mapped[ConsultationStatus] = mapped_column(default=ConsultationStatus.PENDING)
    scheduled_time: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True, nullable=False)
    duration_minutes: Mapped[int] = mapped_column(default=30)
    notes: Mapped[str] = mapped_column(String(500), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="consultations")
    doctor = relationship("Doctor", back_populates="consultations")
    messages = relationship(
        "ChatMessage",
        back_populates="consultation",
        cascade="all, delete-orphan",
        passive_deletes=True,
        order_by="ChatMessage.created_at"
    )