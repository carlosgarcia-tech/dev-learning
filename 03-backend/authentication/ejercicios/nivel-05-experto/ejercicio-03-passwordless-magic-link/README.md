# Ejercicio 03 — Passwordless magic link

- **Nivel:** 5/5
- **Tema:** Autenticación sin contraseña con magic links
- **Tiempo estimado:** 40 min

## Enunciado

La autenticación sin contraseña elimina el factor "algo que sabes" (contraseña) en favor de "algo que tienes" (acceso al email). El servidor envía un enlace único de un solo uso al email del usuario.

Tu tarea es completar el flujo de magic link en `magic_link.json`.

Flujo:

1. Usuario introduce su email → `POST /magic-link`.
2. Servidor genera un token de un solo uso (TTL=15 min).
3. Servidor envía email con `https://app.com/auth?token=xxx`.
4. Usuario pulsa el enlace → `GET /auth?token=xxx`.
5. Servidor valida el token (existe, no usado, no expirado).
6. Si es válido: crea sesión, marca token como usado.
7. Si el token se reusa: denegado (un solo uso).

Pasos:

1. Completa `magic_link.json` con el token, la URL y el flujo completo.
2. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `magic_link.json` es JSON válido
- [ ] `email` es `"alice@example.com"`
- [ ] `token` no está vacío y tiene al menos 32 caracteres
- [ ] `url_magic` empieza por `https://` y contiene `token=`
- [ ] `ttl_segundos` es `900` (15 min)
- [ ] `usado` es `false` (inicialmente)
- [ ] `flujo` tiene al menos 5 pasos
- [ ] `verificacion_reuso.denegado` es `true` (un token usado no se puede reusar)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El token debe ser aleatorio y de un solo uso: `secrets.token_urlsafe(32)`.
- El TTL es corto (15 min) para limitar la ventana de ataque.
- Tras usar el token, se marca como `usado: true` en el store.
- Si alguien intenta usar el mismo token de nuevo, el servidor lo rechaza.
- La URL del magic link debe ser HTTPS (nunca HTTP).
- No reveles si el email existe o no en el sistema (anti enumeración).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`magic_link.json`:

```json
{
  "email": "alice@example.com",
  "token": "ml_vZ8mF3kQ9wP2xN7tR5sL8jB6fH0cA4dG",
  "url_magic": "https://app.com/auth?token=ml_vZ8mF3kQ9wP2xN7tR5sL8jB6fH0cA4dG",
  "ttl_segundos": 900,
  "usado": false,
  "flujo": [
    { "paso": 1, "accion": "Usuario introduce email en POST /magic-link" },
    { "paso": 2, "accion": "Servidor genera token de un solo uso (TTL=15min)" },
    { "paso": 3, "accion": "Servidor envía email con URL magic link" },
    { "paso": 4, "accion": "Usuario pulsa el enlace → GET /auth?token=xxx" },
    { "paso": 5, "accion": "Servidor valida token (existe, no usado, no expirado)" },
    { "paso": 6, "accion": "Servidor crea sesión y marca token como usado" }
  ],
  "verificacion_reuso": {
    "descripcion": "Intento de reusar un token ya usado",
    "denegado": true,
    "motivo": "El token ya fue usado; cada magic link es de un solo uso"
  }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
