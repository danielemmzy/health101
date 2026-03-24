from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import PostgresDsn, SecretStr, Field
from typing import List, Optional

class Settings(BaseSettings):
    PROJECT_NAME: str = "Health101 API"
    ENVIRONMENT: str = Field(default="development")
    DEBUG: bool = True  # ← default to True in dev; override via .env or prod env

    SECRET_KEY: SecretStr = Field(...)
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    DATABASE_URL: PostgresDsn = Field(...)

    REDIS_URL: Optional[str] = None
    CELERY_BROKER_URL: Optional[str] = None
    CELERY_RESULT_BACKEND: Optional[str] = None

    BACKEND_CORS_ORIGINS: List[str] = Field(default_factory=list)

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )


settings = Settings()