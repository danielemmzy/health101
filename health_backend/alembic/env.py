# alembic/env.py

import os
from logging.config import fileConfig

from sqlalchemy import engine_from_config
from sqlalchemy import pool

from alembic import context
from dotenv import load_dotenv
from app.database import Base  # your declarative base

from sqlalchemy.ext.asyncio import create_async_engine
from app.models.doctor import Doctor
from app.models.user import User
from app.models.consultation import Consultation
from app.models.chat_message import ChatMessage
from app.models.pharmacy import Pharmacy
from app.models.products import Product  



target_metadata = Base.metadata

load_dotenv()

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

from app.database import Base
target_metadata = Base.metadata

def run_migrations_offline():
    url = os.getenv("DATABASE_URL")
    if not url:
        raise ValueError("DATABASE_URL not found")

    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online() -> None:
    full_url = os.getenv("DATABASE_URL")
    if not full_url:
        raise ValueError("DATABASE_URL not found")

    # Strip query params for sync compatibility
    from urllib.parse import urlparse, urlunparse
    parsed = urlparse(full_url)
    clean_url = urlunparse((parsed.scheme, parsed.netloc, parsed.path, parsed.params, '', parsed.fragment))

    connectable = create_async_engine(
        clean_url,
        pool_pre_ping=True,
        pool_size=5,
        max_overflow=10
    )

    async def do_run():
        async with connectable.connect() as connection:
            await connection.run_sync(
                lambda conn: context.configure(
                    connection=conn,
                    target_metadata=target_metadata
                )
            )
            with context.begin_transaction():
                context.run_migrations()

    import asyncio
    asyncio.run(do_run())