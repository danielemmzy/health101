from fastapi import APIRouter, Depends, HTTPException
from app.dependencies import get_current_user
from app.models.user import User, UserRole

admin_router = APIRouter(prefix="/admin", tags=["admin"])

def require_admin(current_user: User = Depends(get_current_user)):
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(
            status_code=403,
            detail="Admin access required"
        )
    return current_user