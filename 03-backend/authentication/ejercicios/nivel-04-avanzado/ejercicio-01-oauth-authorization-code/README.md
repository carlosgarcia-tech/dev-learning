# Ejercicio 01 — OAuth authorization code flow

- **Nivel:** 4/5
- **Tema:** Flujo completo de OAuth 2.0 Authorization Code
- **Tiempo estimado:** 40 min

## Enunciado

El **authorization code flow** es el flujo estándar de OAuth 2.0. El usuario autoriza en el navegador, el authorization server devuelve un code de un solo uso, y el client canjea ese code por un access token en el backend.

Tu tarea es completar `flow.json` con los 6 pasos del flujo, incluyendo URLs, parámetros y respuestas.

Pasos:

1. Examina `config.json` con la configuración del client OAuth.
2. Completa `flow.json` con los 6 pasos del authorization code flow.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `flow.json` es JSON válido
- [ ] Hay 6 pasos en el array `pasos`
- [ ] Paso 1 (`authorization_request`): URL a `/authorize` con `response_type=code`, `client_id`, `redirect_uri`, `scope`, `state`
- [ ] Paso 2 (`user_consent`): usuario autoriza, `consent: true`
- [ ] Paso 3 (`redirect_code`): redirect a `redirect_uri` con `code` y `state`
- [ ] Paso 4 (`token_exchange`): POST a `/token` con `grant_type=authorization_code`, `code`, `redirect_uri`, `client_id`, `client_secret`
- [ ] Paso 5 (`token_response`): `access_token`, `token_type: "Bearer"`, `expires_in`, `scope`
- [ ] Paso 6 (`api_call`): GET a la API con `Authorization: Bearer <token>`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El paso 1 es un redirect del navegador al authorization server.
- `state` es un valor aleatorio que protege contra CSRF. Debe ser el mismo en el paso 1 y 3.
- El `code` del paso 3 es de un solo uso y corta duración (~10 min).
- El paso 4 es una petición server-to-server (backend del client → authorization server).
- El `client_secret` solo se usa en el paso 4, nunca en el navegador.
- El paso 6 usa el access token para acceder a los recursos del usuario.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`flow.json`:

```json
{
  "pasos": [
    {
      "num": 1,
      "nombre": "authorization_request",
      "metodo": "GET",
      "url": "https://auth.example.com/authorize?response_type=code&client_id=client_123&redirect_uri=https://app.com/callback&scope=openid+profile+email&state=random_state_abc",
      "descripcion": "El navegador redirige al authorization server para que el usuario autorice"
    },
    {
      "num": 2,
      "nombre": "user_consent",
      "consent": true,
      "descripcion": "El usuario se loguea y autoriza los scopes solicitados"
    },
    {
      "num": 3,
      "nombre": "redirect_code",
      "metodo": "GET",
      "url": "https://app.com/callback?code=AUTH_CODE_xyz789&state=random_state_abc",
      "descripcion": "El authorization server redirige al redirect_uri con el code y el state"
    },
    {
      "num": 4,
      "nombre": "token_exchange",
      "metodo": "POST",
      "url": "https://auth.example.com/token",
      "body": {
        "grant_type": "authorization_code",
        "code": "AUTH_CODE_xyz789",
        "redirect_uri": "https://app.com/callback",
        "client_id": "client_123",
        "client_secret": "secret_super_seguro"
      },
      "descripcion": "El backend del client canjea el code por tokens"
    },
    {
      "num": 5,
      "nombre": "token_response",
      "status": 200,
      "body": {
        "access_token": "eyJhbGci...",
        "token_type": "Bearer",
        "expires_in": 3600,
        "scope": "openid profile email",
        "refresh_token": "rt_abc123"
      },
      "descripcion": "El authorization server devuelve el access token"
    },
    {
      "num": 6,
      "nombre": "api_call",
      "metodo": "GET",
      "url": "https://api.example.com/userinfo",
      "headers": {
        "Authorization": "Bearer eyJhbGci..."
      },
      "descripcion": "El client usa el access token para acceder a los recursos del usuario"
    }
  ]
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
