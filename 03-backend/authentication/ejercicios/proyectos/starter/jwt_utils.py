"""
Utilidades JWT para el sistema de autenticación de FiltroPro.
Crea y verifica JWT con HMAC-SHA256 sin librerías externas.
"""
import base64
import json
import hmac
import hashlib
import time


def b64url_encode(data: bytes) -> str:
    """Codifica bytes a base64url sin padding."""
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode("ascii")


def b64url_decode(s: str) -> bytes:
    """Decodifica base64url (con o sin padding)."""
    padding = 4 - len(s) % 4
    if padding != 4:
        s += "=" * padding
    return base64.urlsafe_b64decode(s)


def create_jwt(payload: dict, secret: bytes, ttl: int = 900) -> str:
    """Crea un JWT firmado con HMAC-SHA256."""
    header = {"alg": "HS256", "typ": "JWT"}
    now = int(time.time())
    payload = {**payload, "iat": now, "exp": now + ttl}

    header_b64 = b64url_encode(json.dumps(header, separators=(",", ":")).encode())
    payload_b64 = b64url_encode(json.dumps(payload, separators=(",", ":")).encode())

    signing_input = f"{header_b64}.{payload_b64}".encode()
    signature = hmac.new(secret, signing_input, hashlib.sha256).digest()
    sig_b64 = b64url_encode(signature)

    return f"{header_b64}.{payload_b64}.{sig_b64}"


def verify_jwt(token: str, secret: bytes) -> dict | None:
    """Verifica un JWT: firma + expiración. Retorna el payload o None."""
    try:
        parts = token.split(".")
        if len(parts) != 3:
            return None
        header_b64, payload_b64, sig_b64 = parts

        # Verificar firma
        signing_input = f"{header_b64}.{payload_b64}".encode()
        expected_sig = hmac.new(secret, signing_input, hashlib.sha256).digest()
        expected_sig_b64 = b64url_encode(expected_sig)
        if not hmac.compare_digest(expected_sig_b64, sig_b64):
            return None

        # Verificar expiración
        payload = json.loads(b64url_decode(payload_b64))
        if payload.get("exp", 0) < time.time():
            return None

        return payload
    except Exception:
        return None


def create_access_token(user_id: str, email: str, role: str, secret: bytes, ttl: int = 900) -> str:
    """Crea un access token JWT."""
    payload = {
        "sub": user_id,
        "email": email,
        "role": role,
        "type": "access",
    }
    return create_jwt(payload, secret, ttl)


def create_refresh_token(user_id: str, family_id: str, secret: bytes, ttl: int = 604800) -> str:
    """Crea un refresh token JWT."""
    payload = {
        "sub": user_id,
        "type": "refresh",
        "family_id": family_id,
    }
    return create_jwt(payload, secret, ttl)
