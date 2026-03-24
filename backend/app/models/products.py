from datetime import datetime

from sqlalchemy import Enum, String, Float, Boolean, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base

class ProductCategory(str, Enum):
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
    name: Mapped[str] = mapped_column(String(150), nullable=False, index=True)
    slug: Mapped[str] = mapped_column(String(200), nullable=False, unique=True, index=True)  # for SEO/URLs
    description: Mapped[str] = mapped_column(String(2000), nullable=True)
    price: Mapped[float] = mapped_column(Float(precision=2), nullable=False)
    stock_quantity: Mapped[int] = mapped_column(default=0, index=True)  # for inventory
    category: Mapped[str] = mapped_column(index=True)
    prescription_required: Mapped[bool] = mapped_column(default=False, index=True)
    image_url: Mapped[str] = mapped_column(String(500), nullable=True)
    is_active: Mapped[bool] = mapped_column(default=True, index=True)
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(default=datetime.utcnow, onupdate=datetime.utcnow)

    pharmacy = relationship("Pharmacy", back_populates="products")