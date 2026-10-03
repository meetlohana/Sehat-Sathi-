"""Data-access boundary. The AI/NLP layer NEVER touches this - only
voice_service does, after authentication + authorization.

Replace DemoPatientRepository with a PostgreSQL implementation
(SQLAlchemy / asyncpg) using DATABASE_URL. Return only the minimum fields.
"""
from typing import Optional, Protocol


class PatientRepository(Protocol):
    def next_appointment_date(self, patient_id: str) -> Optional[str]: ...
    def medicine_count(self, patient_id: str) -> int: ...
    def referral_status(self, patient_id: str) -> Optional[str]: ...  # pending|accepted|completed


class DemoPatientRepository:
    """In-memory demo data so the prototype works without a database."""

    def next_appointment_date(self, patient_id: str) -> Optional[str]:
        return "5 October"

    def medicine_count(self, patient_id: str) -> int:
        return 3

    def referral_status(self, patient_id: str) -> Optional[str]:
        return "pending"


def get_repository() -> PatientRepository:
    return DemoPatientRepository()
