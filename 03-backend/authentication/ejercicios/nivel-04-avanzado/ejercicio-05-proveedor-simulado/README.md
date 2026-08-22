# Ejercicio 05 — Proveedor simulado

- **Nivel:** 4/5
- **Tema:** Configuración de un proveedor OAuth simulado (Google-like)
- **Tiempo estimado:** 35 min

## Enunciado

Vas a configurar un proveedor OAuth simulado (estilo Google) con sus endpoints, credenciales y el flujo completo de integración.

Tu tarea es completar `proveedor.json` con la configuración del proveedor y `flow.json` con el flujo de login usando ese proveedor.

Pasos:

1. Completa `proveedor.json` con los endpoints y credenciales de un proveedor OAuth simulado.
2. Completa `flow.json` con el flujo de integración (authorization request, callback, token exchange).
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `proveedor.json` es JSON válido
- [ ] `proveedor` tiene `nombre`, `issuer`, `authorization_endpoint`, `token_endpoint`, `userinfo_endpoint`
- [ ] `cliente` tiene `client_id`, `client_secret`, `redirect_uri`
- [ ] `scopes_disponibles` es un array con `openid`, `email`, `profile`
- [ ] `flow.json` es JSON válido
- [ ] `flow.json` tiene `authorization_url` con los parámetros correctos
- [ ] `flow.json` tiene `token_exchange` con los parámetros correctos
- [ ] `flow.json` tiene `userinfo_response` con email y name
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa endpoints de Google reales en la configuración (como ejemplo):
  - Authorization: `https://accounts.google.com/o/oauth2/v2/auth`
  - Token: `https://oauth2.googleapis.com/token`
  - UserInfo: `https://openidconnect.googleapis.com/v1/userinfo`
- El `client_id` simula el formato de Google: `xxxxx.apps.googleusercontent.com`.
- El `redirect_uri` debe ser una URL HTTPS válida del cliente.
- En `flow.json`, la `authorization_url` debe incluir `response_type=code`, `client_id`, `redirect_uri`, `scope`, `state`.
- La `userinfo_response` es lo que devuelve el endpoint de userinfo tras validar el access token.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`proveedor.json`:

```json
{
  "proveedor": {
    "nombre": "Google",
    "issuer": "https://accounts.google.com",
    "authorization_endpoint": "https://accounts.google.com/o/oauth2/v2/auth",
    "token_endpoint": "https://oauth2.googleapis.com/token",
    "userinfo_endpoint": "https://openidconnect.googleapis.com/v1/userinfo"
  },
  "cliente": {
    "client_id": "123456789-abc.apps.googleusercontent.com",
    "client_secret": "GOCSPX-secret-only-backend",
    "redirect_uri": "https://app.com/auth/callback"
  },
  "scopes_disponibles": ["openid", "email", "profile"]
}
```

`flow.json`:

```json
{
  "authorization_url": "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&client_id=123456789-abc.apps.googleusercontent.com&redirect_uri=https://app.com/auth/callback&scope=openid+email+profile&state=xyz123",
  "token_exchange": {
    "method": "POST",
    "url": "https://oauth2.googleapis.com/token",
    "params": {
      "grant_type": "authorization_code",
      "code": "GOOGLE_AUTH_CODE",
      "redirect_uri": "https://app.com/auth/callback",
      "client_id": "123456789-abc.apps.googleusercontent.com",
      "client_secret": "GOCSPX-secret-only-backend"
    }
  },
  "userinfo_response": {
    "sub": "123456789",
    "email": "alice@example.com",
    "email_verified": true,
    "name": "Alice García",
    "picture": "https://lh3.googleusercontent.com/photo.jpg"
  }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
