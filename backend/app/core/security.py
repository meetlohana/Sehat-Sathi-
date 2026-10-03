"""JWT authentication + RBAC.

Principle: right information, to the right person, for the right purpose.
"""
from typing import Optional

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import JWTError, jwt
from pydantic import BaseModel

from app.core.config import get_settings

bearer = HTTPBearer(auto_error=False)

ROLE_PATIENT = "patient"
STAFF_ROLES = {"doctor", "asha_worker", "admin"}


class AuthUser(BaseModel):
    sub: str                       # user id
    role: str                      # patient | doctor | asha_worker | admin
    patient_id: Optional[str] = None


def decode_token(token: str) -> AuthUser:
    s = get_settings()
    try:
        payload = jwt.decode(token, s.jwt_secret, algorithms=[s.jwt_algorithm])
        return AuthUser(
            sub=str(payload["sub"]),
            role=str(payload.get("role", ROLE_PATIENT)),
            patient_id=payload.get("patient_id"),
        )
    except (JWTError, KeyError):
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Invalid or expired token")


def get_optional_user(
    creds: Optional[HTTPAuthorizationCredentials] = Depends(bearer),
) -> Optional[AuthUser]:
    """Navigation-only commands work before login; data commands need a user."""
    return decode_token(creds.credentials) if creds else None


def authorize_patient_access(user: AuthUser, requested_patient_id: Optional[str]) -> str:
    """Return the patient id this user may read, or raise 401/403."""
    if user.role == ROLE_PATIENT:
        own = user.patient_id or user.sub
        # A patient can only ever read their OWN data.
        if requested_patient_id and requested_patient_id != own:
            raise HTTPException(status.HTTP_403_FORBIDDEN, "Not allowed")
        return own
    if user.role in STAFF_ROLES:
        if not requested_patient_id:
            raise HTTPException(status.HTTP_400_BAD_REQUEST, "patient_id required")
        # TODO(production): verify this staff member is assigned to the patient.
        return requested_patient_id
    raise HTTPException(status.HTTP_403_FORBIDDEN, "Not allowed")
