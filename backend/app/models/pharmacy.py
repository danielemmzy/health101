from sqlalchemy import String, Boolean, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.types import JSON
from datetime import datetime
from app.database import Base

class Pharmacy(Base):
    __tablename__ = "pharmacies"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), unique=True, nullable=False, index=True)
    name: Mapped[str] = mapped_column(String(150), nullable=False, index=True)
    address: Mapped[str] = mapped_column(String(255), nullable=True)
    contact_phone: Mapped[str] = mapped_column(String(20), nullable=True)
    whatsapp: Mapped[str] = mapped_column(String(20), nullable=True)
    location: Mapped[dict | None] = mapped_column(JSON, nullable=True)          # geo-search ready
    is_verified: Mapped[bool] = mapped_column(default=False, index=True)        # admin approval
    opening_hours: Mapped[str] = mapped_column(String(255), nullable=True)      # text for now
    delivery_radius_km: Mapped[float] = mapped_column(default=0.0)
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(default=datetime.utcnow, onupdate=datetime.utcnow)

    products = relationship("Product", back_populates="pharmacy", cascade="all, delete-orphan")
    user = relationship("User", back_populates="pharmacy", uselist=False)
    orders = relationship("Order", back_populates="pharmacy", cascade="all, delete-orphan")