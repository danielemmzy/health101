from sqlalchemy import ForeignKey, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime
from app.database import Base

class ChatMessage(Base):
    __tablename__ = "chat_messages"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    consultation_id: Mapped[int] = mapped_column(ForeignKey("consultations.id"), nullable=False, index=True)
    sender_id: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=False, index=True)  # user or doctor
    content: Mapped[str] = mapped_column(Text, nullable=False)
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow, index=True)
    is_read: Mapped[bool] = mapped_column(default=False)

    # Relationships
    consultation = relationship("Consultation", back_populates="messages")
    sender = relationship("User", foreign_keys=[sender_id], back_populates="sent_messages")