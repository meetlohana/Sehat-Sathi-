import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api import voice
from app.core.config import get_settings

logging.basicConfig(level=logging.INFO)
settings = get_settings()

app = FastAPI(title="Sehat Sathi Voice Guide API", version="1.0.0")

# CORS is configurable via CORS_ORIGINS (mobile apps don't need it; web/dev does).
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_methods=["GET", "POST"],
    allow_headers=["Authorization", "Content-Type"],
)

app.include_router(voice.router)


@app.get("/health")
def health():
    return {"status": "ok"}
