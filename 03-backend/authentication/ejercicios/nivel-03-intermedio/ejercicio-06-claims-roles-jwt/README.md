# Ejercicio 06 — Claims y roles en JWT

- **Nivel:** 3/5
- **Tema:** Claims personalizados, roles y permisos en JWT
- **Tiempo estimado:** 30 min

## Enunciado

Los JWT pueden llevar **claims personalizados** con información del usuario: rol, permisos, scopes. El resource server usa estos claims para autorizar peticiones sin consultar la base de datos.

Tu tarea es construir un JWT con claims de rol y permisos, y luego implementar la lógica de autorización.

Pasos:

1. Crea un JWT con el secret `super-secreto-2024` y el siguiente payload:

```json
{
  "sub": "usr_7f3a2b",
  "email": "alice@example.com",
  "role": "admin",
  "permissions": ["users:read", "users:write", "users:delete"],
  "iat": 1700000000,
  "exp": 9999999999
}
```

2. Guarda el JWT en `token.jwt`.
3. Completa `autorizacion.json` con el resultado de 3 checks de permisos.
4. Ejecuta `bash test.sh`.

Checks de autorización:

| Recurso solicitado | ¿Permitido? |
|---|---|
| `users:read` | ✅ |
| `users:delete` | ✅ |
| `posts:write` | ❌ (no está en permissions) |

## Requisitos

- [ ] `token.jwt` contiene un JWT válido con firma HMAC-SHA256
- [ ] El payload del JWT tiene `role: "admin"` y `permissions` (array)
- [ ] `autorizacion.json` es JSON válido
- [ ] `autorizacion.json` decodifica el JWT y verifica la firma
- [ ] Check `users:read`: `permitido: true`
- [ ] Check `users:delete`: `permitido: true`
- [ ] Check `posts:write`: `permitido: false`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El payload del JWT debe incluir el array `permissions` con los permisos del usuario.
- La autorización se hace comprobando si el recurso solicitado está en el array `permissions`.
- El `role` puede dar permisos implícitos: un `admin` podría tener todos los permisos, pero es mejor ser explícito.
- El JWT va en `token.jwt` como texto plano (sin JSON wrapper).
- En `autorizacion.json`, además de los checks, incluye el payload decodificado.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`autorizacion.json`:

```json
{
  "secret_usado": "super-secreto-2024",
  "payload_decodificado": {
    "sub": "usr_7f3a2b",
    "email": "alice@example.com",
    "role": "admin",
    "permissions": ["users:read", "users:write", "users:delete"],
    "iat": 1700000000,
    "exp": 9999999999
  },
  "checks": [
    {
      "recurso": "users:read",
      "permitido": true,
      "motivo": "users:read está en el array permissions"
    },
    {
      "recurso": "users:delete",
      "permitido": true,
      "motivo": "users:delete está en el array permissions"
    },
    {
      "recurso": "posts:write",
      "permitido": false,
      "motivo": "posts:write NO está en el array permissions"
    }
  ]
}
```

`token.jwt` (generado con):

```python
import base64, json, hmac, hashlib

SECRET = b"super-secreto-2024"

def b64url(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode("ascii")

payload = {
    "sub": "usr_7f3a2b",
    "email": "alice@example.com",
    "role": "admin",
    "permissions": ["users:read", "users:write", "users:delete"],
    "iat": 1700000000,
    "exp": 9999999999
}

header = {"alg": "HS256", "typ": "JWT"}
header_b64 = b64url(json.dumps(header, separators=(",", ":")).encode())
payload_b64 = b64url(json.dumps(payload, separators=(",", ":")).encode())
signing_input = f"{header_b64}.{payload_b64}".encode()
sig = hmac.new(SECRET, signing_input, hashlib.sha256).digest()

with open("token.jwt", "w") as f:
    f.write(f"{header_b64}.{payload_b64}.{b64url(sig)}")
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
