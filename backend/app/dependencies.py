from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.crud.user import get_user_by_email
from app.utils.security import verify_access_token

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")

async def get_current_user(token: str = Depends(oauth2_scheme), db: AsyncSession = Depends(get_db)):
    try:
        email = verify_access_token(token)
        user = await get_user_by_email(db, email)
        if not user or not user.is_active:
            raise HTTPException(status_code=401, detail="Invalid authentication")
        return user
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")