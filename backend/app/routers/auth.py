from app.celery import send_verification_email_task
from fastapi import APIRouter, Depends, HTTPException, status, Request
from fastapi.security import OAuth2PasswordRequestForm
from slowapi import Limiter
from slowapi.util import get_remote_address
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.user import UserCreate, UserOut, UserRole
from app.crud.user import create_user, authenticate_user, generate_and_send_code, get_user_by_email
from app.utils.security import (
    create_access_token,
    create_refresh_token,
    verify_refresh_token,
    blacklist_token
)
from app.settings import settings
from datetime import timedelta
from pydantic import BaseModel
from app.dependencies import oauth2_scheme
import random
from redis.asyncio import Redis
from app.settings import settings

limiter = Limiter(key_func=get_remote_address)

router = APIRouter(prefix="/auth", tags=["auth"])

class Token(BaseModel):
    access_token: str
    refresh_token: str | None = None
    token_type: str = "bearer"

class RefreshRequest(BaseModel):
    refresh_token: str


    # ==================== EMAIL VERIFICATION ====================

class SendVerificationCode(BaseModel):
    email: str

class VerifyCode(BaseModel):
    email: str
    code: str

@router.post("/register", response_model=UserOut, status_code=201)
@limiter.limit("10/minute")
async def register(
    request: Request,
    user_data: UserCreate,
    db: AsyncSession = Depends(get_db)
):
    # Create user with is_verified = False and is_active = True
    user = await create_user(
        db=db,
        email=user_data.email,
        password=user_data.password,
        full_name=user_data.full_name,
        role=UserRole.PATIENT,
        is_active=False
    )

    if not user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    
    try:
        await generate_and_send_code(user.email)
    except Exception as e:
        print(f"[ERROR] Failed to send verification code: {e}")
        

    return user



@router.post("/login", response_model=Token)
@limiter.limit("5/minute")
async def login(
    request: Request,
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: AsyncSession = Depends(get_db)
):
    user = await authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token = create_access_token(
        subject=user.email,
        expires_delta=timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    )

    refresh_token = create_refresh_token(
        subject=user.email,
        expires_delta=timedelta(days=7)
    )

    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
    }

@router.post("/refresh", response_model=Token)
@limiter.limit("5/minute")
async def refresh_token(
    request: Request,
    refresh_data: RefreshRequest,
    db: AsyncSession = Depends(get_db)
):
    try:
        email = verify_refresh_token(refresh_data.refresh_token)
        user = await get_user_by_email(db, email)
        if not user or not user.is_active:
            raise HTTPException(status_code=401, detail="Invalid refresh token")

        new_access_token = create_access_token(
            subject=user.email,
            expires_delta=timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        )

        return {
            "access_token": new_access_token,
            "token_type": "bearer"
        }
    except Exception as e:
        raise HTTPException(status_code=401, detail="Invalid or expired refresh token")

@router.post("/logout")
@limiter.limit("10/minute")
async def logout(
    request: Request,
    token: str = Depends(oauth2_scheme)
):
    # Blacklist current access token
    expire_access = int(settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60)
    blacklist_token(token, expire_access)

    # Note: To fully logout, client should also delete refresh token
    # Optional: if you have refresh token in body, blacklist it too

    return {"message": "Logged out successfully"}

@router.post("/resend-code")
@limiter.limit("3/minute")
async def resend_code(
    request: Request,
    data: SendVerificationCode,
    db: AsyncSession = Depends(get_db)
):
    user = await get_user_by_email(db, data.email)

    if not user:
        raise HTTPException(404, "User not found")

    if user.is_active:
        raise HTTPException(400, "User already verified")

    try:
        await generate_and_send_code(user.email)
        return {"message": "Verification code resent"}

    except Exception as e:
        print(f"[ERROR] Resend failed: {e}")
        raise HTTPException(500, "Failed to resend code")
    

@router.post("/verify-code")
@limiter.limit("10/minute")
async def verify_code(
    request: Request,
    data: VerifyCode,
    db: AsyncSession = Depends(get_db)
):
    redis = Redis.from_url(settings.REDIS_URL)

    email = data.email.strip().lower()
    code = data.code.strip()

    stored_code = await redis.get(f"verify:{email}")

    if not stored_code:
        raise HTTPException(400, "Code expired or not found")

    # IMPORTANT FIX: decode safely
    stored_code = stored_code.decode() if isinstance(stored_code, bytes) else stored_code

    if stored_code != code:
        raise HTTPException(400, "Invalid verification code")

    user = await get_user_by_email(db, email)

    if not user:
        raise HTTPException(404, "User not found")

    user.is_active = True
    await db.commit()

    await redis.delete(f"verify:{email}")

    return {"message": "Account verified successfully"}