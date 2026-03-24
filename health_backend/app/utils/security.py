from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext
from app.settings import settings
import redis

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

r = redis.Redis.from_url(settings.REDIS_URL or "redis://localhost:6379/0")

def hash_password(password: str) -> str:
    # Bcrypt max 72 bytes — truncate safely (standard practice)
    password_bytes = password.encode('utf-8')[:72]
    return pwd_context.hash(password_bytes)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    # Truncate input the same way for verification consistency
    plain_bytes = plain_password.encode('utf-8')[:72]
    return pwd_context.verify(plain_bytes, hashed_password)

def create_access_token(subject: str, expires_delta: timedelta | None = None):
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode = {"sub": subject, "exp": expire}
    return jwt.encode(to_encode, str(settings.SECRET_KEY), algorithm=settings.ALGORITHM)

def verify_access_token(token: str):
    try:
        payload = jwt.decode(token, str(settings.SECRET_KEY), algorithms=[settings.ALGORITHM])
        email = payload.get("sub")
        if not email or r.exists(f"blacklist:{token}"):
            raise JWTError
        return email
    except JWTError:
        raise JWTError("Invalid token")
    
def create_refresh_token(subject: str, expires_delta: timedelta | None = None):
    expire = datetime.utcnow() + (expires_delta or timedelta(days=7))  # 7 days default
    to_encode = {"sub": subject, "exp": expire, "type": "refresh"}
    return jwt.encode(to_encode, str(settings.SECRET_KEY), algorithm=settings.ALGORITHM)

def verify_refresh_token(token: str):
    try:
        payload = jwt.decode(token, str(settings.SECRET_KEY), algorithms=[settings.ALGORITHM])
        email = payload.get("sub")
        token_type = payload.get("type")
        if not email or token_type != "refresh" or r.exists(f"blacklist:{token}"):
            raise JWTError
        return email
    except JWTError:
        raise JWTError("Invalid refresh token")

def blacklist_token(token: str, expire: int):
    r.set(f"blacklist:{token}", "1", ex=expire)