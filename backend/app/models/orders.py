# app/models/order.py
from sqlalchemy import String, Float, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime
from enum import Enum as PyEnum
from app.database import Base

class OrderStatus(str, PyEnum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    PROCESSING = "processing"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"

class Order(Base):
    __tablename__ = "orders"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=False, index=True)
    pharmacy_id: Mapped[int | None] = mapped_column(ForeignKey("pharmacies.id"), nullable=True, index=True)
    
    total_amount: Mapped[float] = mapped_column(Float(precision=2), nullable=False)
    status: Mapped[OrderStatus] = mapped_column(default=OrderStatus.PENDING, index=True)
    delivery_address: Mapped[str] = mapped_column(String(255), nullable=False)
    tracking_number: Mapped[str | None] = mapped_column(String(100), nullable=True, unique=True, index=True)
    payment_method: Mapped[str | None] = mapped_column(String(50))
    payment_status: Mapped[str] = mapped_column(String(50), default="pending")

    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship("User", back_populates="orders")
    pharmacy = relationship("Pharmacy")
    items = relationship("OrderItem", back_populates="order", cascade="all, delete-orphan")
    payment = relationship("Payment", back_populates="order", uselist=False)
    