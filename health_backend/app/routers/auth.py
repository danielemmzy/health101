from fastapi import APIRouter, Depends, HTTPException, status, Request
from fastapi.security import OAuth2PasswordRequestForm
from slowapi import Limiter
from slowapi.util import get_remote_address
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.user import UserCreate, UserOut, UserRole
from app.crud.user import create_user, authenticate_user, get_user_by_email
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

limiter = Limiter(key_func=get_remote_address)

router = APIRouter(prefix="/auth", tags=["auth"])

class Token(BaseModel):
    access_token: str
    refresh_token: str | None = None
    token_type: str = "bearer"

class RefreshRequest(BaseModel):
    refresh_token: str

@router.post("/register", response_model=UserOut, status_code=201)
@limiter.limit("10/minute")
async def register(
    request: Request,
    user_data: UserCreate,
    db: AsyncSession = Depends(get_db)
):
    user = await create_user(
        db,
        email=user_data.email,
        password=user_data.password,
        full_name=user_data.full_name,
        role=UserRole.PATIENT  # default for normal users
    )
    if not user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
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