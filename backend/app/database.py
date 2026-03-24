# app/database.py
from sqlalchemy.ext.asyncio import AsyncEngine, AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.orm import DeclarativeBase
from app.settings import settings
from urllib.parse import urlparse, parse_qs, urlunparse

# Parse the URL and rebuild without query params (SQLAlchemy doesn't like them as kwargs)
parsed = urlparse(str(settings.DATABASE_URL))
clean_url = urlunparse((
    parsed.scheme,
    parsed.netloc,
    parsed.path,
    parsed.params,
    '',  # remove query
    parsed.fragment
))

# asyncpg will use sslmode from the original string internally if present
engine: AsyncEngine = create_async_engine(
    clean_url,
    echo=True,
    pool_pre_ping=True,
    pool_size=5,
    max_overflow=5,
    # Optional: force SSL context if needed (rare)
    # connect_args={"ssl": {"sslmode": "require"}}
)

AsyncSessionLocal = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autoflush=False
)

class Base(DeclarativeBase):
    pass

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session