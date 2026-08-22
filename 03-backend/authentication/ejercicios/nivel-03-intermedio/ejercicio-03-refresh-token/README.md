# Ejercicio 03 — Refresh token

- **Nivel:** 3/5
- **Tema:** Access token corto + refresh token largo
- **Tiempo estimado:** 30 min

## Enunciado

El patrón access token + refresh token equilibra seguridad y UX:

- **Access token**: corto (15 min), se envía en cada petición.
- **Refresh token**: largo (7 días), se usa solo para renovar el access token.

Tu tarea es completar `tokens.json` con ambos tokens y sus propiedades.

Pasos:

1. Genera un access token JWT con TTL de 15 minutos.
2. Genera un refresh token (puede ser JWT u opaco) con TTL de 7 días.
3. Completa `tokens.json` con ambos tokens y sus metadatos.
4. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `tokens.json` es JSON válido
- [ ] `access_token` es un JWT con 3 partes
- [ ] `access_token` tiene `exp` = `iat + 900` (15 min = 900s)
- [ ] `refresh_token` es un JWT con 3 partes
- [ ] `refresh_token` tiene `exp` = `iat + 604800` (7 días = 604800s)
- [ ] `refresh_token` tiene `type: "refresh"`
- [ ] `access_token` tiene `type: "access"`
- [ ] Ambos tokens tienen el mismo `sub` (mismo usuario)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El secret es `super-secreto-2024`.
- `access_token.ttl_segundos = 900` (15 min)
- `refresh_token.ttl_segundos = 604800` (7 días = 7 × 24 × 3600)
- Usa un `iat` fijo (ej: 1700000000) para que la verificación sea determinista.
- El claim `type` distingue access de refresh y evita usar uno por otro.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`tokens.json`:

```json
{
  "secret": "super-secreto-2024",
  "user_id": "123",
  "access_token": {
    "token": "eyJhbGc...",
    "type": "access",
    "iat": 1700000000,
    "exp": 1700000900,
    "ttl_segundos": 900
  },
  "refresh_token": {
    "token": "eyJhbGc...",
    "type": "refresh",
    "iat": 1700000000,
    "exp": 1700604800,
    "ttl_segundos": 604800
  }
}
```

Generar los tokens:

```python
import base64, json, hmac, hashlib

SECRET = b"super-secreto-2024"
IAT = 1700000000

def b64url(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode("ascii")

def make_jwt(payload):
    header = {"alg": "HS256", "typ": "JWT"}
    header_b64 = b64url(json.dumps(header, separators=(",", ":")).encode())
    payload_b64 = b64url(json.dumps(payload, separators=(",", ":")).encode())
    signing_input = f"{header_b64}.{payload_b64}".encode()
    sig = hmac.new(SECRET, signing_input, hashlib.sha256).digest()
    return f"{header_b64}.{payload_b64}.{b64url(sig)}"

access_token = make_jwt({
    "sub": "123", "type": "access",
    "iat": IAT, "exp": IAT + 900
})

refresh_token = make_jwt({
    "sub": "123", "type": "refresh",
    "iat": IAT, "exp": IAT + 604800
})
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
