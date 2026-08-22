# Ejercicio 05 — Blacklisting tokens

- **Nivel:** 3/5
- **Tema:** Invalidación de JWT mediante blacklist de `jti`
- **Tiempo estimado:** 30 min

## Enunciado

JWT es stateless: no hay forma de invalidar un token válido sin estado adicional. El **blacklisting** guarda los `jti` (IDs únicos) de tokens revocados. Solo hay que guardarlos hasta su `exp` natural.

Tu tarea es completar el flujo de blacklisting en `blacklist.json`.

Escenario:

1. Usuario hace login → access token con `jti: "tok_abc123"`, `exp: 1700003600`.
2. Usuario hace logout → el servidor añade `jti: "tok_abc123"` al blacklist (TTL hasta exp).
3. Alguien intenta usar el token → el servidor comprueba el blacklist → **denegado**.
4. Tras la expiración natural, el blacklist ya no necesita el `jti` (se auto-expira en Redis).

Pasos:

1. Completa `blacklist.json` con el estado del token en cada punto.
2. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `blacklist.json` es JSON válido
- [ ] `jti` es `"tok_abc123"`
- [ ] `token_revocado` es `true` tras el logout
- [ ] `razon_revocacion` explica que el usuario hizo logout
- [ ] `ttl_blacklist_segundos` es `3600` (exp - ahora)
- [ ] `verificacion` tiene 3 estados: antes_logout, despues_logout, despues_expiracion
- [ ] `antes_logout`: `acceso_permitido: true`
- [ ] `despues_logout`: `acceso_permitido: false`
- [ ] `despues_expiracion`: `acceso_permitido: false` (también expirado)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `jti` (JWT ID) es un claim único por token. Es lo que se guarda en el blacklist.
- En Redis: `SET blacklist:tok_abc123 1 EX 3600` → el `jti` se borra solo tras el TTL.
- El TTL del blacklist es `exp - ahora`. No tiene sentido guardarlo más tiempo.
- Tras la expiración natural del token, ya no es válido por sí mismo (incluso si no estuviera en el blacklist).
- El blacklist solo es necesario para access tokens; los refresh tokens se gestionan con rotation.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`blacklist.json`:

```json
{
  "jti": "tok_abc123",
  "token_exp": 1700003600,
  "ahora_logout": 1700000000,
  "token_revocado": true,
  "razon_revocacion": "El usuario hizo logout; el token se invalida antes de su expiración natural",
  "ttl_blacklist_segundos": 3600,
  "verificacion": {
    "antes_logout": {
      "en_blacklist": false,
      "expirado": false,
      "acceso_permitido": true
    },
    "despues_logout": {
      "en_blacklist": true,
      "expirado": false,
      "acceso_permitido": false
    },
    "despues_expiracion": {
      "en_blacklist": false,
      "expirado": true,
      "acceso_permitido": false
    }
  }
}
```

Código equivalente:

```python
import redis
import time

r = redis.Redis(decode_responses=True)

def revoke_token(jti, exp):
    """Añade el jti al blacklist hasta su expiración natural."""
    ttl = exp - int(time.time())
    if ttl > 0:
        r.setex(f"blacklist:{jti}", ttl, "1")

def is_revoked(jti):
    return r.exists(f"blacklist:{jti}")
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
