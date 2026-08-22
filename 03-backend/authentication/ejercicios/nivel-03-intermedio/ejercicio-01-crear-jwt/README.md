# Ejercicio 01 — Crear JWT

- **Nivel:** 3/5
- **Tema:** Creación de un JWT con HMAC-SHA256
- **Tiempo estimado:** 30 min

## Enunciado

Vas a construir un JWT (JSON Web Token) a mano, sin librerías, entendiendo cada parte. Un JWT tiene 3 partes separadas por `.`: `header.payload.signature`.

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjMiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MDAwMDAwMDAsImV4cCI6MTcwMDAwMzYwMH0.s7nK3xQ9vF2mBpL8hR1tYwZcA4bD6eG0iJkMnO5pQsU
│           header                │               payload                          │      signature      │
```

Pasos:

1. Lee el `header.json` y `payload.json` (ya creados).
2. Codifica ambos a base64url.
3. Calcula la firma HMAC-SHA256 con el secret `super-secreto-2024`.
4. Construye el JWT completo en `token.jwt`.
5. Ejecuta `bash test.sh`.

### Algoritmo

```
header_b64  = base64url(header_json)
payload_b64 = base64url(payload_json)
signing_input = header_b64 + "." + payload_b64
signature   = HMACSHA256(signing_input, secret)
sig_b64     = base64url(signature)
jwt         = header_b64 + "." + payload_b64 + "." + sig_b64
```

### base64url

Base64url sustituye `+` por `-`, `/` por `_` y elimina el padding `=`.

## Requisitos

- [ ] `token.jwt` contiene un JWT con 3 partes separadas por `.`
- [ ] El header decodificado tiene `alg: "HS256"` y `typ: "JWT"`
- [ ] El payload decodificado tiene `sub`, `role`, `iat`, `exp`
- [ ] La firma es un HMAC-SHA256 válido del `header.payload` con el secret
- [ ] El JWT no contiene padding `=` (base64url sin padding)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa Python para generar el JWT. Importa: `base64`, `json`, `hmac`, `hashlib`.
- `base64.urlsafe_b64encode(data).rstrip(b'=')` da base64url sin padding.
- El JSON antes de codificar debe ser compacto: `json.dumps(obj, separators=(',', ':'))`.
- El secret es `super-secreto-2024`.
- La firma se calcula sobre el string `header_b64.payload_b64` (como bytes), no sobre el JSON.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

Generar el JWT:

```python
import base64, json, hmac, hashlib

def b64url(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b'=').decode('ascii')

header = {"alg": "HS256", "typ": "JWT"}
payload = {"sub": "123", "role": "admin", "iat": 1700000000, "exp": 1700003600}

header_b64 = b64url(json.dumps(header, separators=(',', ':')).encode())
payload_b64 = b64url(json.dumps(payload, separators=(',', ':')).encode())

signing_input = f"{header_b64}.{payload_b64}".encode()
signature = hmac.new(b"super-secreto-2024", signing_input, hashlib.sha256).digest()
sig_b64 = b64url(signature)

jwt_token = f"{header_b64}.{payload_b64}.{sig_b64}"
print(jwt_token)
```

`token.jwt` contendrá:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjMiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MDAwMDAwMDAsImV4cCI6MTcwMDAwMzYwMH0.<signature>
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
