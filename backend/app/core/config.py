"""Settings come from environment variables only. No secrets in code."""
import os
from functools import lru_cache

from dotenv import load_dotenv

load_dotenv()


class Settings:
    def __init__(self) -> None:
        self.app_env = os.getenv("APP_ENV", "development")
        self.jwt_secret = os.getenv("JWT_SECRET", "")
        self.jwt_algorithm = os.getenv("JWT_ALGORITHM", "HS256")
        self.cors_origins = [
            o.strip() for o in os.getenv("CORS_ORIGINS", "").split(",") if o.strip()
        ]
        self.database_url = os.getenv("DATABASE_URL", "")
        self.llm_enabled = os.getenv("LLM_ENABLED", "false").lower() == "true"
        if not self.jwt_secret:
            raise RuntimeError("JWT_SECRET is not set. Copy .env.example to .env")


@lru_cache
def get_settings() -> Settings:
    return Settings()
