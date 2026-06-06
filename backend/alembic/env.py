import os
from logging.config import fileConfig

from alembic import context
from sqlalchemy import create_engine, pool
from urllib.parse import urlparse, urlunparse
from dotenv import load_dotenv

from app.database import Base

# IMPORT ALL MODELS (IMPORTANT)
from app.models.user import User
from app.models.doctor import Doctor
from app.models.consultation import Consultation
from app.models.chat_message import ChatMessage
from app.models.pharmacy import Pharmacy
from app.models.products import Product


load_dotenv()

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata


# =========================
# CLEAN DATABASE URL FOR ALEMBIC
# =========================
def get_sync_url():
    url = os.getenv("DATABASE_URL")

    parsed = urlparse(url)

    clean = urlunparse((
        parsed.scheme,
        parsed.netloc,
        parsed.path,
        '', '', ''   # remove params + query + fragment
    ))

    return clean.replace("+asyncpg", "")


# =========================
# OFFLINE MIGRATION
# =========================
def run_migrations_offline():
    url = get_sync_url()

    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        compare_type=True,
    )

    with context.begin_transaction():
        context.run_migrations()


# =========================
# ONLINE MIGRATION
# =========================
def run_migrations_online():
    url = get_sync_url()

    engine = create_engine(
        url,
        poolclass=pool.NullPool,
    )

    with engine.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
        )

        with context.begin_transaction():
            context.run_migrations()


# =========================
# RUN
# =========================
if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()