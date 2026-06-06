# app/database.py
from sqlalchemy.ext.asyncio import AsyncEngine, AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.orm import DeclarativeBase
from app.settings import settings
from urllib.parse import urlparse, parse_qs, urlunparse

from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)
from sqlalchemy.orm import DeclarativeBase
from app.settings import settings

from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)
from sqlalchemy.orm import DeclarativeBase
from app.settings import settings

# =========================
# BASE MODEL
# =========================
class Base(DeclarativeBase):
    pass


# =========================
# DATABASE URL
# =========================
DATABASE_URL = settings.DATABASE_URL

# Convert to asyncpg format for runtime
ASYNC_DATABASE_URL = DATABASE_URL.replace(
    "postgresql://",
    "postgresql+asyncpg://"
)

# =========================
# ASYNC ENGINE (FASTAPI)
# =========================
engine: AsyncEngine = create_async_engine(
    ASYNC_DATABASE_URL,
    echo=True,
    pool_pre_ping=True,
    pool_size=5,
    max_overflow=5,
    connect_args={"ssl": True},  # REQUIRED for Neon
)

AsyncSessionLocal = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autoflush=False,
)

# =========================
# DB SESSION DEPENDENCY
# =========================
async def get_db():
    async with AsyncSessionLocal() as session:
        yield session