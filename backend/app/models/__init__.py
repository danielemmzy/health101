# app/models/__init__.py
# Import all models so Base.metadata knows about them

from .user import User
from .doctor import Doctor
from .consultation import Consultation, ConsultationStatus
from .chat_message import ChatMessage
from .pharmacy import Pharmacy       
from .products import Product         
from .orders import Order  # ← Add these
from .order_item import OrderItem
from .coupon import Coupon             

__all__ = ["User", "Doctor", "Consultation", "ConsultationStatus", "ChatMessage", "Pharmacy", "Product", "Order", "OrderItem", "Coupon"]