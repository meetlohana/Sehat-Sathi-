import os
os.environ.setdefault("JWT_SECRET", "test-secret")
import pytest
from fastapi.testclient import TestClient
from jose import jwt
from app.main import app
from app.services.intent_service import classify

client = TestClient(app)

@pytest.mark.parametrize("text,intent", [
    ("I want to book a doctor appointment.", "BOOK_APPOINTMENT"),
    ("Mujhe doctor ki appointment leni hai.", "BOOK_APPOINTMENT"),
    ("Doctor se milna hai", "BOOK_APPOINTMENT"),
    ("Meri reports dikhao.", "OPEN_HEALTH_RECORD"),
    ("Show my health reports.", "OPEN_HEALTH_RECORD"),
    ("Report dekhni hai", "OPEN_HEALTH_RECORD"),
    ("मुझे रिपोर्ट देखनी है", "OPEN_HEALTH_RECORD"),
    ("Mujhe referral ka status dekhna hai", "OPEN_REFERRAL"),
    ("Meri medicines dikhao", "MY_MEDICINES"),
    ("Mujhe doctor se baat karni hai", "START_CONSULTATION"),
    ("Home par jao", "OPEN_HOME"),
    ("Back jao", "GO_BACK"),
    ("Mujhe help chahiye", "HELP"),
    ("Emergency hai", "EMERGENCY"),
    ("Mujhe app use karna nahi aata", "START_GUIDE"),
    ("Ab kya karna hai?", "NEXT_STEP"),
    ("Yahan kya hai?", "EXPLAIN_SCREEN"),
    ("Am I having pneumonia?", "MEDICAL_QUESTION"),
    ("what is the weather", "UNKNOWN"),
])
def test_intents(text, intent):
    assert classify(text).intent == intent

def tok(pid="P1", role="patient"):
    return jwt.encode({"sub": pid, "role": role, "patient_id": pid}, "test-secret", algorithm="HS256")

def post(text, token=None, **extra):
    h = {"Authorization": f"Bearer {token}"} if token else {}
    return client.post("/api/voice/intent", json={"text": text, "language": "hi", "screen": "home", **extra}, headers=h)

def test_navigation_without_login():
    r = post("Meri report dikhao").json()
    assert r["action"] == "OPEN_RECORDS" and r["requires_backend_data"] is False

def test_data_requires_login():
    assert post("Meri appointment kab hai?").status_code == 401

def test_data_with_login():
    r = post("Meri appointment kab hai?", tok()).json()
    assert r["action"] == "SHOW_APPOINTMENT" and "5 October" in r["response_text"]

def test_patient_cannot_read_other_patient():
    assert post("Meri appointment kab hai?", tok("P1"), patient_id="P2").status_code == 403

def test_diagnosis_refused():
    r = post("Am I having pneumonia?").json()
    assert r["action"] == "SPEAK_ONLY" and "can't diagnose" in r["response_text"]

def test_validation():
    assert client.post("/api/voice/intent", json={"text": "", "screen": "home"}).status_code == 422
