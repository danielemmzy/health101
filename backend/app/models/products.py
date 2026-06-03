# app/models/products.py
from sqlalchemy import String, Float, Boolean, ForeignKey, Text, JSON
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime
from app.database import Base
from enum import Enum as PyEnum

class ProductCategory(str, PyEnum):
    PAIN_RELIEF = "pain_relief"
    VITAMINS_SUPPLEMENTS = "vitamins_supplements"
    COLD_FLU = "cold_flu"
    DIGESTIVE = "digestive"
    SKIN_CARE = "skin_care"
    BABY_KIDS = "baby_kids"
    MEDICAL_DEVICES = "medical_devices"
    OTHER = "other"


class Product(Base):
    __tablename__ = "products"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    pharmacy_id: Mapped[int] = mapped_column(ForeignKey("pharmacies.id"), nullable=False, index=True)
    
    name: Mapped[str] = mapped_column(String(200), nullable=False, index=True)
    slug: Mapped[str] = mapped_column(String(250), unique=True, index=True, nullable=False)   # SEO
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    price: Mapped[float] = mapped_column(Float(precision=2), nullable=False)
    stock_quantity: Mapped[int] = mapped_column(default=0, index=True)
    low_stock_threshold: Mapped[int] = mapped_column(default=10, index=True)   # Alert when low

    category: Mapped[ProductCategory] = mapped_column(index=True)
    prescription_required: Mapped[bool] = mapped_column(default=False, index=True)
    
    # Multiple Images Support (Industry Standard)
    image_urls: Mapped[list[str] | None] = mapped_column(JSON, nullable=True)   # ["url1.jpg", "url2.jpg"]
    thumbnail_url: Mapped[str | None] = mapped_column(String(500), nullable=True)

    is_active: Mapped[bool] = mapped_column(default=True, index=True)
    is_featured: Mapped[bool] = mapped_column(default=False, index=True)   # For homepage featured

    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    pharmacy = relationship("Pharmacy", back_populates="products")
    cart_items = relationship("CartItem", back_populates="product", cascade="all, delete-orphan")
    order_items = relationship("OrderItem", back_populates="product")