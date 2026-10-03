from typing import Optional

from fastapi import APIRouter, Depends, Query

from app.core.security import AuthUser, get_optional_user
from app.models.voice_models import GuideResponse, VoiceIntentRequest, VoiceIntentResponse
from app.services import guidance_service as g
from app.services.patient_repository import PatientRepository, get_repository
from app.services.voice_service import process_intent

router = APIRouter(prefix="/api/voice", tags=["voice"])


@router.post("/intent", response_model=VoiceIntentResponse)
def voice_intent(
    req: VoiceIntentRequest,
    user: Optional[AuthUser] = Depends(get_optional_user),
    repo: PatientRepository = Depends(get_repository),
):
    """Text -> structured intent. Navigation intents work without login;
    patient-data intents require a valid JWT and are authorized per patient."""
    return process_intent(req, user, repo)


@router.get("/guide", response_model=GuideResponse)
def guide(
    screen: str = Query("home", pattern=r"^[a-z_]+$", max_length=40),
    language: str = Query("hi", pattern=r"^(hi|en)$"),
):
    """Static, cacheable help text for a screen."""
    return GuideResponse(
        screen=screen,
        language=language,  # type: ignore[arg-type]
        explanation=g.explain_screen(screen, language),
        steps=list(g.steps_for(screen, language)),
    )
