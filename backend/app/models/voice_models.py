from enum import Enum
from typing import Literal, Optional

from pydantic import BaseModel, Field


class Action(str, Enum):
    """WHITELIST. Must match VoiceAction in Flutter. Nothing else is ever returned."""
    OPEN_HOME = "OPEN_HOME"
    OPEN_APPOINTMENT = "OPEN_APPOINTMENT"
    OPEN_APPOINTMENTS = "OPEN_APPOINTMENTS"
    OPEN_RECORDS = "OPEN_RECORDS"
    OPEN_REFERRAL = "OPEN_REFERRAL"
    OPEN_MEDICINES = "OPEN_MEDICINES"
    START_CONSULTATION = "START_CONSULTATION"
    OPEN_HELP = "OPEN_HELP"
    OPEN_EMERGENCY = "OPEN_EMERGENCY"
    GO_BACK = "GO_BACK"
    EXPLAIN_SCREEN = "EXPLAIN_SCREEN"
    NEXT_STEP = "NEXT_STEP"
    REPEAT = "REPEAT"
    START_GUIDE = "START_GUIDE"
    SHOW_APPOINTMENT = "SHOW_APPOINTMENT"
    SHOW_MEDICINES = "SHOW_MEDICINES"
    SHOW_REFERRAL = "SHOW_REFERRAL"
    SPEAK_ONLY = "SPEAK_ONLY"


class VoiceIntentRequest(BaseModel):
    text: str = Field(min_length=1, max_length=300)
    language: Literal["hi", "en", "hinglish"] = "hi"
    screen: str = Field(default="unknown", max_length=40, pattern=r"^[a-z_]+$")
    step: Optional[str] = Field(default=None, max_length=40, pattern=r"^[a-z_]+$")
    patient_id: Optional[str] = Field(default=None, max_length=64, pattern=r"^[A-Za-z0-9_\-]+$")


class VoiceIntentResponse(BaseModel):
    success: bool = True
    intent: str
    action: Action
    response_text: str
    language: Literal["hi", "en"]
    requires_confirmation: bool = False
    requires_backend_data: bool = False
    guide_topic: Optional[Literal["app", "appointment"]] = None


class GuideResponse(BaseModel):
    screen: str
    language: Literal["hi", "en"]
    explanation: str
    steps: list[str] = []
