"""Rule-based intent classification: Hindi / English / Hinglish / Devanagari.

No LLM is needed for simple navigation. An optional LLM fallback exists but is
OFF by default and its output is validated against the same whitelist.
Mirror of Flutter local_intent_matcher.dart.
"""
import re
from dataclasses import dataclass
from typing import Optional

from app.models.voice_models import Action

SERIOUS = [
    "chest pain", "seene mein dard", "saans nahi", "behosh", "unconscious",
    "bahut khoon", "heavy bleeding", "सीने में दर्द", "सांस नहीं", "बेहोश",
]
MEDICAL_ADVICE = [
    "diagnose", "diagnosis", "pneumonia", "typhoid", "malaria", "dengue",
    "cancer", "am i having", "do i have", "kaun si bimari", "kaun si dawai",
    "kaunsi dawai", "dawai band", "dawa band", "dose", "kitni goli",
    "prescribe", "stop my medicine", "stop taking", "दवाई बंद",
]


@dataclass(frozen=True)
class Rule:
    intent: str
    action: Action
    text_key: str
    phrases: tuple[str, ...]
    data_hints: tuple[str, ...] = ()
    data_action: Optional[Action] = None  # action used when patient data is requested


RULES: list[Rule] = [
    Rule("EMERGENCY", Action.OPEN_EMERGENCY, "open_emergency", (
        "emergency", "emergncy", "ambulance", "turant madad", "bachao", "accident",
        "इमरजेंसी", "एमरजेंसी", "आपातकाल", "एम्बुलेंस", "बचाओ", "दुर्घटना")),
    Rule("REPEAT", Action.REPEAT, "client_side", (
        "dobara", "dobara sunao", "phir se", "fir se", "repeat", "repeat that",
        "say again", "दोबारा", "फिर से")),
    Rule("NEXT_STEP", Action.NEXT_STEP, "client_side", (
        "ab kya karna hai", "ab kya karu", "ab kya karun", "aage kya", "what next",
        "what now", "next step", "what do i do now", "अब क्या करना है", "अब क्या करूं", "आगे क्या")),
    Rule("EXPLAIN_SCREEN", Action.EXPLAIN_SCREEN, "client_side", (
        "yahan kya hai", "ye kya hai", "is screen par kya", "what is here",
        "what is this screen", "where am i", "main kahan hoon", "main kya kar sakta hoon",
        "main kya kar sakti hoon", "kya kar sakta hoon", "what can i do here",
        "what can i do", "यहां क्या है", "यहाँ क्या है", "मैं क्या कर सकता हूं", "मैं क्या कर सकती हूं")),
    Rule("START_GUIDE", Action.START_GUIDE, "guide_app_start", (
        "app use karna nahi aata", "use karna nahi aata", "nahi aata", "nahi aati",
        "samajh nahi aa raha", "sikhao", "sikha do", "kaise use karu", "kaise use kare",
        "teach me", "how to use", "how do i use", "guide me", "help me use",
        "इस्तेमाल करना नहीं आता", "चलाना नहीं आता", "नहीं आता", "सिखाओ", "कैसे चलाऊं")),
    Rule("GO_BACK", Action.GO_BACK, "go_back", (
        "back", "back jao", "peeche", "peeche jao", "wapas", "wapas jao", "go back",
        "previous", "पीछे", "वापस", "पीछे जाओ")),
    Rule("HELP", Action.OPEN_HELP, "help_text", (
        "help", "help chahiye", "madad", "sahayata", "मदद", "सहायता", "हेल्प")),
    Rule("START_CONSULTATION", Action.START_CONSULTATION, "start_consultation", (
        "doctor se baat", "doctor se baat karni", "baat karni hai", "teleconsultation",
        "teleconsult", "consultation", "video call", "call doctor", "talk to doctor",
        "talk to a doctor", "speak to doctor", "doctor se call", "डॉक्टर से बात",
        "वीडियो कॉल", "परामर्श")),
    Rule("MY_APPOINTMENTS", Action.OPEN_APPOINTMENTS, "open_appointments", (
        "meri appointment", "meri appointments", "my appointment", "my appointments",
        "appointment kab", "next appointment", "upcoming appointment", "appointment status",
        "appointment dekhni", "appointment dikhao", "मेरी अपॉइंटमेंट", "अपॉइंटमेंट कब"),
        data_hints=("kab", "when", "next", "agli", "कब"), data_action=Action.SHOW_APPOINTMENT),
    Rule("BOOK_APPOINTMENT", Action.OPEN_APPOINTMENT, "open_appointment", (
        "appointment", "appointments", "apointment", "book", "booking", "doctor se milna",
        "doctor se mil", "doctor ko dikhana", "doctor ki appointment", "doctor appointment",
        "see a doctor", "meet a doctor", "meet doctor", "अपॉइंटमेंट", "अपॉइन्टमेंट",
        "डॉक्टर से मिलना", "डॉक्टर से मिल")),
    Rule("OPEN_HEALTH_RECORD", Action.OPEN_RECORDS, "open_records", (
        "report", "reports", "record", "records", "health record", "health records",
        "medical record", "jaanch", "test result", "test results", "रिपोर्ट", "रिपोर्ट्स",
        "रिकॉर्ड", "जांच")),
    Rule("OPEN_REFERRAL", Action.OPEN_REFERRAL, "open_referral", (
        "referral", "referrals", "refer", "रेफरल", "रेफर"),
        data_hints=("status", "sthiti", "स्थिति"), data_action=Action.SHOW_REFERRAL),
    Rule("MY_MEDICINES", Action.OPEN_MEDICINES, "open_medicines", (
        "medicine", "medicines", "dawai", "dawa", "dawaiyan", "davai", "tablet", "tablets",
        "दवाई", "दवा", "दवाइयां", "दवाइयाँ", "गोली"),
        data_hints=("kya", "what", "which", "kaun"), data_action=Action.SHOW_MEDICINES),
    Rule("OPEN_HOME", Action.OPEN_HOME, "open_home", (
        "home", "home page", "ghar", "main page", "होम", "घर")),
]

HINDI_MARKERS = {
    "mujhe", "meri", "mera", "mere", "hai", "hain", "karna", "karni", "dikhao", "jao",
    "dekhni", "dekhna", "chahiye", "kab", "kya", "nahi", "aata", "se", "ko", "ki", "ka",
    "ab", "yahan", "baat", "milna", "dawai", "madad",
}
ENGLISH_MARKERS = {
    "i", "want", "my", "show", "the", "to", "please", "book", "open", "what", "how",
    "can", "go", "me", "need",
}


@dataclass
class IntentResult:
    intent: str
    action: Action
    text_key: str
    requires_data: bool = False
    requires_confirmation: bool = False
    guide_topic: Optional[str] = None


def normalize(text: str) -> str:
    s = re.sub(r"[^\u0900-\u097Fa-z0-9\s]", " ", text.lower())
    return " " + re.sub(r"\s+", " ", s).strip() + " "


def detect_language(norm: str, hint: str = "hi") -> str:
    """Returns 'hi' (Hindi/Hinglish) or 'en'."""
    if re.search(r"[\u0900-\u097F]", norm):
        return "hi"
    words = norm.split()
    hi = sum(w in HINDI_MARKERS for w in words)
    en = sum(w in ENGLISH_MARKERS for w in words)
    if hi != en:
        return "hi" if hi > en else "en"
    return "en" if hint == "en" else "hi"


def _has(norm: str, phrases) -> bool:
    return any(f" {p.lower()} " in norm for p in phrases)


def classify(text: str) -> IntentResult:
    norm = normalize(text)
    if _has(norm, SERIOUS):
        # Never diagnose: just route to the existing emergency workflow.
        return IntentResult("EMERGENCY", Action.OPEN_EMERGENCY, "serious_symptom")
    if _has(norm, MEDICAL_ADVICE):
        return IntentResult("MEDICAL_QUESTION", Action.SPEAK_ONLY, "medical_refusal")
    for r in RULES:
        if not _has(norm, r.phrases):
            continue
        wants_data = bool(r.data_hints) and _has(norm, r.data_hints)
        topic = None
        if r.action == Action.START_GUIDE:
            topic = "appointment" if ("appointment" in norm or "अपॉइंटमेंट" in norm) else "app"
        return IntentResult(
            r.intent,
            r.data_action if (wants_data and r.data_action) else r.action,
            r.text_key,
            requires_data=wants_data and r.data_action is not None,
            guide_topic=topic,
        )
    llm = llm_fallback(text)
    return llm or IntentResult("UNKNOWN", Action.SPEAK_ONLY, "error_unrelated")


# ---------------------------------------------------------------------------
# Optional LLM fallback (OFF by default). The model may ONLY pick an intent;
# the output is validated against the whitelist; it never sees patient data.
# ---------------------------------------------------------------------------
def llm_fallback(text: str) -> Optional[IntentResult]:
    from app.core.config import get_settings

    if not get_settings().llm_enabled:
        return None
    # TODO: call your LLM here with ONLY the utterance + the list of allowed
    # intents, ask for JSON {"intent": "..."}, then pass it to validate_llm_output.
    return None


def validate_llm_output(data: dict) -> Optional[IntentResult]:
    """Accept an LLM suggestion only if it maps to a known rule."""
    wanted = str(data.get("intent", ""))
    for r in RULES:
        if r.intent == wanted:
            return IntentResult(r.intent, r.action, r.text_key)
    return None
