"""Orchestrates: classify -> (authorize -> fetch minimal data) -> response."""
import logging
from typing import Optional

from fastapi import HTTPException, status

from app.core.security import AuthUser, authorize_patient_access
from app.models.voice_models import Action, VoiceIntentRequest, VoiceIntentResponse
from app.services import guidance_service as g
from app.services.intent_service import classify, detect_language, normalize
from app.services.patient_repository import PatientRepository

# Safe logs: event + intent names only. NEVER the utterance, token or health data.
log = logging.getLogger("voice")


def process_intent(
    req: VoiceIntentRequest,
    user: Optional[AuthUser],
    repo: PatientRepository,
) -> VoiceIntentResponse:
    lang = detect_language(normalize(req.text), "en" if req.language == "en" else "hi")
    result = classify(req.text)
    log.info("intent_detected intent=%s action=%s screen=%s", result.intent, result.action.value, req.screen)

    if result.requires_data:
        if user is None:
            raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Login required")
        patient_id = authorize_patient_access(user, req.patient_id)
        response_text = _data_response(result.action, patient_id, lang, repo)
    else:
        response_text = g.text(result.text_key, lang)

    return VoiceIntentResponse(
        intent=result.intent,
        action=result.action,
        response_text=response_text,
        language=lang,
        requires_confirmation=result.requires_confirmation,
        requires_backend_data=result.requires_data,
        guide_topic=result.guide_topic,  # type: ignore[arg-type]
    )


def _data_response(action: Action, patient_id: str, lang: str, repo: PatientRepository) -> str:
    """Facts are inserted into fixed templates by THIS code, not by an AI."""
    if action == Action.SHOW_APPOINTMENT:
        d = repo.next_appointment_date(patient_id)
        return g.text("appt_next", lang, date=d) if d else g.text("appt_none", lang)
    if action == Action.SHOW_MEDICINES:
        n = repo.medicine_count(patient_id)  # count only - no names/doses spoken
        return g.text("meds_count", lang, n=str(n)) if n else g.text("meds_none", lang)
    if action == Action.SHOW_REFERRAL:
        st = repo.referral_status(patient_id)
        if not st or st not in g.REFERRAL_STATUS_WORDS:
            return g.text("referral_none", lang)
        return g.text("referral_status", lang, status=g.REFERRAL_STATUS_WORDS[st][lang])
    return g.text("client_side", lang)
