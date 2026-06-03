# app/models/__init__.py
# Import all models so Base.metadata knows about them

from .user import User
from .doctor import Doctor
from .consultation import Consultation, ConsultationStatus
from .chat_message import ChatMessage
from .pharmacy import Pharmacy       
from .products import Product          
from .order_item import OrderItem
from .coupon import Coupon 
from .cart import CartItem 
from .orders import Order,  OrderStatus
from .payment import Payment
         

__all__ = ["User", "Doctor", "Consultation", "ConsultationStatus", "ChatMessage", "Pharmacy", "Product", "Order", "OrderStatus", "OrderItem", "Coupon", "CartItem", "Payment"]