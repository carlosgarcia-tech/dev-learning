#!/usr/bin/env python3
"""Genera 3 tokens JWT de prueba para el ejercicio de verificación.
- token_1: válido (firma correcta, no expirado)
- token_2: firma inválida (payload modificado tras firmar)
- token_3: expirado (firma correcta pero exp en el pasado)
"""
import base64
import json
import hmac
import hashlib

SECRET = b"super-secreto-2024"


def b64url(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode("ascii")


def make_jwt(payload: dict) -> str:
    header = {"alg": "HS256", "typ": "JWT"}
    header_b64 = b64url(json.dumps(header, separators=(",", ":")).encode())
    payload_b64 = b64url(json.dumps(payload, separators=(",", ":")).encode())
    signing_input = f"{header_b64}.{payload_b64}".encode()
    sig = hmac.new(SECRET, signing_input, hashlib.sha256).digest()
    sig_b64 = b64url(sig)
    return f"{header_b64}.{payload_b64}.{sig_b64}"


# Token 1: válido, no expirado (exp lejano)
token_1 = make_jwt({
    "sub": "123",
    "role": "admin",
    "iat": 1700000000,
    "exp": 9999999999,
})

# Token 2: firma inválida (payload reemplazado tras firmar)
token_2_valid = make_jwt({
    "sub": "456",
    "role": "user",
    "iat": 1700000000,
    "exp": 9999999999,
})
parts = token_2_valid.split(".")
tampered_payload = b64url(json.dumps({
    "sub": "999",
    "role": "admin",
    "iat": 1700000000,
    "exp": 9999999999,
}).encode())
token_2 = f"{parts[0]}.{tampered_payload}.{parts[2]}"

# Token 3: expirado (firma correcta, exp en el pasado)
token_3 = make_jwt({
    "sub": "789",
    "role": "user",
    "iat": 1700000000,
    "exp": 1700000001,
})

data = {
    "secret": "super-secreto-2024",
    "tokens": {
        "token_1_valido": token_1,
        "token_2_firma_invalida": token_2,
        "token_3_expirado": token_3,
    },
}

with open("tokens.json", "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)

print("Tokens generados en tokens.json")
for name, tok in data["tokens"].items():
    print(f"  {name}: {tok[:50]}...")
