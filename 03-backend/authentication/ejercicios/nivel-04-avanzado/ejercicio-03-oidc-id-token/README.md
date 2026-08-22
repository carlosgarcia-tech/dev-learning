# Ejercicio 03 — OIDC ID token

- **Nivel:** 4/5
- **Tema:** OpenID Connect y el ID token
- **Tiempo estimado:** 35 min

## Enunciado

OpenID Connect (OIDC) añade una capa de **autenticación** sobre OAuth 2.0. Mientras OAuth 2.0 emite un **access token** para acceder a recursos, OIDC emite además un **ID token**: un JWT con claims de identidad del usuario.

Tu tarea es crear un ID token JWT válido y diferenciarlo del access token.

Pasos:

1. Crea un ID token JWT con el secret `super-secreto-2024` y los claims de identidad:

```json
{
  "iss": "https://auth.example.com",
  "sub": "user-123",
  "aud": "client_123",
  "email": "alice@example.com",
  "email_verified": true,
  "name": "Alice García",
  "picture": "https://auth.example.com/avatar/123.png",
  "iat": 1700000000,
  "exp": 9999999999
}
```

2. Guarda el ID token en `id_token.jwt`.
3. Completa `oidc.json` comparando el ID token con el access token.
4. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `id_token.jwt` es un JWT válido con firma HMAC-SHA256
- [ ] El payload tiene `iss`, `sub`, `aud`, `email`, `email_verified`, `name`, `picture`
- [ ] `oidc.json` es JSON válido
- [ ] `oidc.json` tiene `id_token_purpose: "authentication"` y `access_token_purpose: "authorization"`
- [ ] `oidc.json` tiene `consumidor_id_token: "client"` y `consumidor_access_token: "resource_server"`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El ID token es siempre un JWT (el access token puede ser JWT u opaco).
- El ID token lo consume el **client** (para saber quién es el usuario); el access token lo consume el **resource server** (para autorizar el acceso).
- El claim `iss` identifica al emisor del token.
- El claim `aud` identifica al client para el que se emitió el token.
- `email_verified: true` indica que el email ha sido verificado por el IdP.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`oidc.json`:

```json
{
  "id_token_purpose": "authentication",
  "access_token_purpose": "authorization",
  "consumidor_id_token": "client",
  "consumidor_access_token": "resource_server",
  "comparativa": [
    {
      "aspecto": "Propósito",
      "id_token": "Autenticar al usuario (AuthN)",
      "access_token": "Autorizar acceso a recursos (AuthZ)"
    },
    {
      "aspecto": "Formato",
      "id_token": "Siempre JWT",
      "access_token": "JWT u opaco"
    },
    {
      "aspecto": "Consumidor",
      "id_token": "El client",
      "access_token": "El resource server"
    }
  ]
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
