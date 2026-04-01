from sqlalchemy import String, Float, Boolean
from sqlalchemy.orm import Mapped, mapped_column
from datetime import datetime
from app.database import Base

class Coupon(Base):
    __tablename__ = "coupons"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    code: Mapped[str] = mapped_column(String(50), unique=True, nullable=False, index=True)
    discount_percent: Mapped[float] = mapped_column(nullable=False)
    is_active: Mapped[bool] = mapped_column(default=True)
    expires_at: Mapped[datetime] = mapped_column(nullable=True)
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)