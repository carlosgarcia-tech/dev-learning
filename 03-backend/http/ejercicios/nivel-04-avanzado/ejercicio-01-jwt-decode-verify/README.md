# Ejercicio 01 — JWT Decode y Verify

- **Nivel:** 4/5
- **Tema:** JSON Web Tokens (decodificación y verificación)
- **Tiempo estimado:** 35 min

## Enunciado

Tienes un JWT en `token.txt`. El servidor `server.sh` (puerto 8095) emite tokens con el secreto `supersecreto` y verifica cualquier token enviado en `Authorization: Bearer <token>` a `GET /me`.

Tu tarea:

1. Completa `expected.json` con el **payload decodificado** del token.
2. Completa `peticiones.http` con la petición `GET /me` usando el Bearer token.
3. El `test.sh` decodificará el token y verificará la firma con python3.

El token en `token.txt` tiene este payload:

```json
{"sub": "user_42", "role": "admin", "iat": 1724304000, "exp": 9999999999}
```

> `exp` muy alto para que no expire durante el test.

## Requisitos

- [ ] `expected.json` es JSON válido con el payload decodificado
- [ ] `expected.json` tiene `sub: "user_42"`, `role: "admin"`
- [ ] `peticiones.http` tiene `GET /me` con `Authorization: Bearer <token>`
- [ ] El `test.sh` verifica la firma HMAC-SHA256 del token con el secreto
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un JWT son 3 partes Base64URL separadas por `.`: header.payload.signature.
- El payload **no está cifrado**, solo codificado en Base64URL.
- Para decodificar: reemplaza `_` por `/` y `-` por `+`, añade padding, y decodifica Base64.
- La firma es `HMAC-SHA256(base64url(header) + "." + base64url(payload), secreto)`.
- En python: `import hmac, hashlib, base64, json`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`expected.json`:

```json
{
  "sub": "user_42",
  "role": "admin",
  "iat": 1724304000,
  "exp": 9999999999
}
```

`peticiones.http`:

```http
GET /me HTTP/1.1
Host: localhost:8095
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyXzQyIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzI0MzA0MDAwLCJleHAiOjk5OTk5OTk5OTl9.SIGNATURA
```

Decodificar el payload en bash:

```bash
echo "eyJzdWIiOiJ1c2VyXzQyIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzI0MzA0MDAwLCJleHAiOjk5OTk5OTk5OTl9" \
  | tr '_-' '/+' | base64 -d
```

Verificar firma en Python:

```python
import hmac, hashlib, base64, json
secret = b"supersecreto"
token = open("token.txt").read().strip()
h, p, s = token.split(".")
signing_input = (h + "." + p).encode()
expected = hmac.new(secret, signing_input, hashlib.sha256).digest()
# comparar con base64url(s)
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
