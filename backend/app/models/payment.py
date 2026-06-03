from sqlalchemy import String, Float, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime
from app.database import Base

class Payment(Base):
    __tablename__ = "payments"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    order_id: Mapped[int] = mapped_column(ForeignKey("orders.id"), nullable=False)
    amount: Mapped[float] = mapped_column(Float(precision=2), nullable=False)
    payment_method: Mapped[str] = mapped_column(String(50))   # card, cash, transfer, wallet
    status: Mapped[str] = mapped_column(String(50), default="pending")  # pending, completed, failed
    transaction_id: Mapped[str | None] = mapped_column(String(100), nullable=True, unique=True)
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)

    order = relationship("Order", back_populates="payment")