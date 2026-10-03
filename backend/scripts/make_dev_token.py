"""Create a JWT for local testing:  python scripts/make_dev_token.py P123
In production your existing Sehat Sathi login issues tokens with the same
JWT_SECRET (or switch decode_token to your identity provider's public key)."""
import sys, time
from jose import jwt
from app.core.config import get_settings

s = get_settings()
pid = sys.argv[1] if len(sys.argv) > 1 else "P123"
print(jwt.encode({"sub": pid, "role": "patient", "patient_id": pid, "exp": int(time.time()) + 86400},
                 s.jwt_secret, algorithm=s.jwt_algorithm))
