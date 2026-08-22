# Ejercicio 04 — Flujo de registro

- **Nivel:** 1/5
- **Tema:** Flujo de registro de usuario
- **Tiempo estimado:** 25 min

## Enunciado

Vas a construir el flujo de registro de un usuario: recibir email y contraseña, validarlas, hashear la contraseña y almacenar el resultado. Completa `registro.json` con el resultado simulado de un registro correcto.

El cliente envía:

```json
{
  "email": "alice@example.com",
  "password": "Secr3tP@ss"
}
```

Pasos:

1. Examina el input en `input.json`.
2. Valida que el email tiene formato correcto y la contraseña cumple la política (mínimo 8 caracteres).
3. Genera el hash bcrypt de la contraseña.
4. Completa `registro.json` con el resultado del registro (status, user_id, email, password_hash, created_at).
5. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `registro.json` es JSON válido
- [ ] `status` es `"success"`
- [ ] `email` es `"alice@example.com"`
- [ ] `email_valido` es `true`
- [ ] `password_valida` es `true` (mínimo 8 caracteres)
- [ ] `password_hash` tiene formato bcrypt válido (`$2[aby]$NN$...`)
- [ ] `password_hash` NO contiene la contraseña original
- [ ] `user_id` es un string no vacío
- [ ] `created_at` es un string ISO 8601 (`YYYY-MM-DDTHH:MM:SSZ`)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Validación de email: contiene `@` y un dominio con `.`.
- Política de contraseña: mínimo 8 caracteres. Más allá de eso, no fuerces reglas complejas.
- El hash bcrypt se genera con `bcrypt.hashpw(password.encode(), bcrypt.gensalt(rounds=12))`.
- Nunca almacenes ni devuelvas la contraseña original. Solo el hash.
- `created_at` debe seguir ISO 8601 con timezone Z (UTC).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`registro.json`:

```json
{
  "status": "success",
  "user_id": "usr_7f3a2b",
  "email": "alice@example.com",
  "email_valido": true,
  "password_valida": true,
  "password_hash": "$2b$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy",
  "created_at": "2025-01-15T10:30:00Z"
}
```

Código equivalente:

```python
import bcrypt
import re
import secrets
from datetime import datetime, timezone

def registrar(email, password):
    # 1. Validar email
    email_valido = bool(re.match(r'^[^@]+@[^@]+\.[^@]+$', email))
    
    # 2. Validar password (mín 8 chars)
    password_valida = len(password) >= 8
    
    if not (email_valido and password_valida):
        return {"status": "error", "message": "credenciales inválidas"}
    
    # 3. Hashear password
    salt = bcrypt.gensalt(rounds=12)
    password_hash = bcrypt.hashpw(password.encode(), salt).decode()
    
    # 4. Generar user_id
    user_id = "usr_" + secrets.token_hex(3)
    
    # 5. Timestamp ISO 8601
    created_at = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    
    return {
        "status": "success",
        "user_id": user_id,
        "email": email,
        "email_valido": True,
        "password_valida": True,
        "password_hash": password_hash,
        "created_at": created_at
    }
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
