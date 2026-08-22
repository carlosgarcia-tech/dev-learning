# Ejercicio 06 — OAuth refresh token

- **Nivel:** 4/5
- **Tema:** Renovación de access token con OAuth refresh token
- **Tiempo estimado:** 35 min

## Enunciado

En OAuth 2.0, el refresh token permite renovar el access token sin pedir al usuario que vuelva a autorizar. Tu tarea es completar el flujo de renovación con el grant type `refresh_token`.

Escenario:

1. El client ya tiene un access token expirado y un refresh token.
2. El client hace POST al token endpoint con `grant_type=refresh_token`.
3. El authorization server valida el refresh token y emite un nuevo access token.
4. El client usa el nuevo access token para acceder a la API.

Pasos:

1. Examina `tokens_iniciales.json` con el access token expirado y el refresh token.
2. Completa `flow.json` con el flujo de renovación.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `flow.json` es JSON válido
- [ ] `refresh_request` tiene `method: "POST"`, `url` (token endpoint) y `body`
- [ ] `body.grant_type` es `"refresh_token"`
- [ ] `body.refresh_token` no está vacío
- [ ] `body.client_id` no está vacío
- [ ] `body.client_secret` no está vacío
- [ ] `refresh_response` tiene `access_token` (nuevo), `token_type: "Bearer"`, `expires_in`
- [ ] `refresh_response` tiene `refresh_token` (opcional: rotado o no)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El grant type para renovar es `refresh_token` (no `authorization_code`).
- El body incluye: `grant_type`, `refresh_token`, `client_id`, `client_secret`.
- La respuesta incluye un nuevo access token. Puede incluir también un nuevo refresh token (si el proveedor soporta rotation).
- El access token antiguo ya no sirve; el nuevo reemplaza al anterior.
- No todos los proveedores rotan el refresh token. Google no rota; Auth0 sí puede.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`flow.json`:

```json
{
  "refresh_request": {
    "method": "POST",
    "url": "https://auth.example.com/token",
    "body": {
      "grant_type": "refresh_token",
      "refresh_token": "rt_abc123xyz_old",
      "client_id": "client_123",
      "client_secret": "secret_super_seguro"
    }
  },
  "refresh_response": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.new_access_token_payload.newSig",
    "token_type": "Bearer",
    "expires_in": 3600,
    "refresh_token": "rt_def456uvw_new"
  }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
