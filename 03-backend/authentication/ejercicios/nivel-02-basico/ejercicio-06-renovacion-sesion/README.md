# Ejercicio 06 — Renovación de sesión

- **Nivel:** 2/5
- **Tema:** Sliding session y rotación de session ID
- **Tiempo estimado:** 25 min

## Enunciado

La **renovación de sesión** tiene dos aspectos:

1. **Renovar el TTL** (sliding): cada petición del usuario reinicia el contador de expiración.
2. **Rotar el session ID**: tras cierto tiempo o tras login, se genera un nuevo session ID para prevenir session fixation.

Tu tarea es completar el flujo de renovación en `renovacion.json`.

Escenario:

1. Sesión inicial: `sess_a8b9c0d1e2f3`, creada en `t=1700000000`, TTL=3600s.
2. Usuario activo hace una petición en `t=1700001800` (30 min después).
3. El servidor renueva el TTL (sliding) y rota el session ID por seguridad.
4. Nueva sesión: nuevo ID, nuevo TTL, session ID antiguo invalidado.

Pasos:

1. Examina `sesion.json` con la sesión inicial.
2. Completa `renovacion.json` con la sesión antigua y la nueva.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `renovacion.json` es JSON válido
- [ ] `sesion_antigua.id` es `"sess_a8b9c0d1e2f3"`
- [ ] `sesion_antigua.invalidada` es `true`
- [ ] `sesion_nueva.id` es distinto de `sess_a8b9c0d1e2f3`
- [ ] `sesion_nueva.id` empieza por `sess_`
- [ ] `sesion_nueva.id` tiene al menos 32 caracteres
- [ ] `sesion_nueva.created_at` es `1700001800` (momento de la renovación)
- [ ] `sesion_nueva.expires_at` es `1700005400` (created_at + ttl)
- [ ] `ttl_renovado` es `true`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Al rotar el session ID, el antiguo se invalida (se borra del store) y se crea uno nuevo con los mismos datos del usuario.
- El nuevo `created_at` es el momento de la renovación (`1700001800`).
- El nuevo `expires_at` = nuevo `created_at` + TTL = `1700001800 + 3600 = 1700005400`.
- Genera un nuevo session ID aleatorio con `secrets.token_urlsafe(32)`.
- La rotación de session ID previene session fixation.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`renovacion.json`:

```json
{
  "sesion_antigua": {
    "id": "sess_a8b9c0d1e2f3",
    "invalidada": true
  },
  "sesion_nueva": {
    "id": "sess_vZ8mF3kQ9wP2xN7tR5sL8jB6fH0cA4dG7eY1bK3mN9oP",
    "created_at": 1700001800,
    "expires_at": 1700005400
  },
  "ttl_renovado": true,
  "motivo": "Sliding session: el usuario estuvo activo, se renueva el TTL y se rota el session ID para prevenir session fixation"
}
```

Código equivalente:

```python
import secrets
import redis
import json

r = redis.Redis(decode_responses=True)

def renew_session(old_sid, user_id, ttl=3600):
    # 1. Leer datos de la sesión vieja
    data = r.get(f"session:{old_sid}")
    if not data:
        return None
    
    # 2. Invalidar la sesión vieja
    r.delete(f"session:{old_sid}")
    
    # 3. Crear nueva sesión con nuevo ID
    new_sid = f"sess_{secrets.token_urlsafe(32)}"
    r.setex(f"session:{new_sid}", ttl, data)
    
    return new_sid
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
