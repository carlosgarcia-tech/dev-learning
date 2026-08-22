# 04 — OAuth 2.0 y OpenID Connect

> OAuth 2.0: roles, grant types, PKCE y el flujo de authorization code. OpenID Connect: ID token y userinfo. Scopes, consentimiento, proveedores (Google, GitHub, Auth0) y por qué el implicit flow está deprecado.

## Objetivos

- [ ] Conocer los 4 roles de OAuth 2.0
- [ ] Diferenciar los grant types y saber cuándo usar cada uno
- [ ] Entender PKCE y por qué es obligatorio en SPAs y móviles
- [ ] Trazar el flujo completo de authorization code con PKCE
- [ ] Entender OpenID Connect: ID token vs access token
- [ ] Comprender scopes y consentimiento del usuario
- [ ] Conocer los proveedores: Google, GitHub, Auth0
- [ ] Entender por qué el implicit flow está deprecado

## ¿Qué es OAuth 2.0?

**OAuth 2.0** (RFC 6749) es un framework de **delegación de autorización**: permite que un usuario conceda a una aplicación acceso a sus recursos en otra aplicación, **sin compartir sus credenciales**.

> Ejemplo: que una app de fotos acceda a tus fotos de Google sin que le des tu contraseña de Google.

### Los 4 roles de OAuth

| Rol | Descripción | Ejemplo |
|---|---|---|
| **Resource Owner (RO)** | El usuario que posee los recursos | Tú, con tu cuenta de Google |
| **Client** | La app que quiere acceder a los recursos | App de fotos "FiltroPro" |
| **Authorization Server (AS)** | Emite tokens tras autenticar al RO | Google Accounts |
| **Resource Server (RS)** | Sirve los recursos protegidos | Google Photos API |

```
┌───────────────────┐
│  Resource Owner   │  (tú)
└────────┬──────────┘
         │ 1. "Permito que FiltroPro acceda a mis fotos"
         ▼
┌───────────────────┐        ┌───────────────────────┐
│     Client        │  2.►   │ Authorization Server   │
│  (FiltroPro app)  │◄───3.  │  (Google Accounts)    │
└────────┬──────────┘  token └───────────────────────┘
         │
         │ 4. GET /fotos con access_token
         ▼
┌───────────────────┐
│  Resource Server  │  (Google Photos API)
└───────────────────┘
```

## Grant Types

Un **grant type** es el método por el que un client obtiene un access token.

| Grant Type | Quién lo usa | Flujo | Seguridad |
|---|---|---|---|
| **Authorization Code** | Apps web con backend | Redirect → code → token | ✅ Seguro |
| **Authorization Code + PKCE** | SPAs, móviles | Igual + PKCE | ✅ Recomendado |
| **Client Credentials** | Server-to-server (M2M) | Directo con client_secret | ✅ Para servicios |
| **Resource Owner Password** | Apps de confianza legacy | Usuario da contraseña al client | ❌ Deprecado |
| **Refresh Token** | Renovar access token | Usar refresh_token | ✅ |
| **Device Code** | TVs, consolas, IoT | Device muestra código, usuario autoriza en otro dispositivo | ✅ |
| **Implicit** | SPAs antiguas | Redirect directo al token | ❌ Deprecado |

### 1. Authorization Code (con PKCE)

El flujo más común y seguro para apps con navegador.

```
Cliente (SPA/Móvil)        Authorization Server          Resource Server
      │                            │                            │
      │ 1. Generar code_verifier   │                            │
      │    y code_challenge        │                            │
      │                            │                            │
      │ 2. Redirect a /authorize   │                            │
      ├───────────────────────────►│                            │
      │  ?response_type=code       │                            │
      │  &client_id=...             │                            │
      │  &redirect_uri=...          │                            │
      │  &code_challenge=...        │ 3. Usuario se loguea       │
      │  &code_challenge_method=S256│     y da consentimiento    │
      │  &scope=photos.read         │                            │
      │                            │                            │
      │ 4. Redirect de vuelta       │                            │
      │◄───────────────────────────┤                            │
      │  ?code=AUTH_CODE           │                            │
      │                            │                            │
      │ 5. POST /token             │                            │
      │  {code, code_verifier,      │                            │
      │   client_id}                │                            │
      ├───────────────────────────►│                            │
      │                            │ 6. Verificar code_verifier │
      │                            │    contra code_challenge   │
      │  7. access_token +         │                            │
      │     refresh_token          │                            │
      │◄───────────────────────────┤                            │
      │                            │                            │
      │ 8. GET /api/fotos           │                            │
      │  Authorization: Bearer ...  │                            │
      ├──────────────────────────────────────────────────────────►│
      │  9. 200 OK {fotos}          │                            │
      │◄──────────────────────────────────────────────────────────┤
```

### 2. Client Credentials (server-to-server)

Sin intervención del usuario. Un servicio se autentica con su propio `client_id` + `client_secret`.

```http
POST /token HTTP/1.1
Host: auth.example.com
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&client_id=servicio_a
&client_secret=secret_super_seguro
&scope=service_b.read
```

```json
{
  "access_token": "eyJhbGci...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "service_b.read"
}
```

### 3. Device Code (TVs, IoT)

```
1. TV muestra: "Ve a google.com/device e introduce código ABCD-1234"
2. Usuario entra en su ordenador/móvil, introduce el código y autoriza
3. TV sondea /token hasta obtener el access_token
```

```http
POST /device_authorization HTTP/1.1
Host: auth.example.com

client_id=tv_app&scope=photos.read
```

```json
{
  "device_code": "device_abc123",
  "user_code": "ABCD-1234",
  "verification_uri": "https://auth.example.com/device",
  "expires_in": 1800,
  "interval": 5
}
```

## PKCE (Proof Key for Code Exchange)

PKCE protege el authorization code flow en clientes públicos (SPAs, móviles) que no pueden guardar un `client_secret` de forma segura.

```
Cliente                    Authorization Server
   │                                │
   │ 1. code_verifier = random(43) │
   │    code_challenge = SHA256(    │
   │      code_verifier)            │
   │                                │
   │ 2. /authorize?code_challenge=  │
   ├───────────────────────────────►│
   │  <-- code -->                  │
   │◄───────────────────────────────┤
   │                                │
   │ 3. /token?code_verifier=...    │
   ├───────────────────────────────►│
   │                          Verifica:  │
   │                          SHA256(   │
   │                          code_verifier)│
   │                          == code_challenge?│
   │                                │
   │  <-- access_token -->          │
   │◄───────────────────────────────┤
```

- `code_verifier`: string aleatorio secreto (43-128 chars).
- `code_challenge`: `BASE64URL(SHA256(code_verifier))`.

Si un atacante intercepta el `code` en el redirect, no puede canjearlo porque no tiene el `code_verifier`.

```python
import secrets
import hashlib
import base64

def generate_pkce():
    code_verifier = secrets.token_urlsafe(64)
    digest = hashlib.sha256(code_verifier.encode()).digest()
    code_challenge = base64.urlsafe_b64encode(digest).rstrip(b'=').decode('ascii')
    return code_verifier, code_challenge
```

## OpenID Connect (OIDC)

**OAuth 2.0** es para **autorización** (delegar acceso a recursos). **OpenID Connect** es una capa **encima** de OAuth 2.0 que añade **autenticación**: permite saber *quién* es el usuario.

```
OAuth 2.0: "¿Puede esta app acceder a mis fotos?"
OIDC:      "¿Quién es este usuario?"
```

OIDC añade:
- **ID Token**: un JWT con claims de identidad del usuario.
- **userinfo endpoint**: endpoint que devuelve info del usuario autenticado.
- `openid` scope: activa la emisión del ID token.

### ID Token vs Access Token

| Aspecto | ID Token | Access Token |
|---|---|---|
| Para qué | Autenticar al usuario (AuthN) | Acceder a APIs (AuthZ) |
| Formato | Siempre JWT | JWT u opaco |
| Quién lo consume | El Client | El Resource Server |
| Claims | `sub`, `email`, `name`, `picture` | `scope`, `aud` |
| Expiración | Corta | Media |

```json
// ID Token (JWT decodificado)
{
  "iss": "https://auth.example.com",
  "sub": "user-123",
  "aud": "client-app-xyz",
  "email": "alice@example.com",
  "email_verified": true,
  "name": "Alice García",
  "picture": "https://auth.example.com/avatar/123.png",
  "iat": 1700000000,
  "exp": 1700003600
}
```

## Scopes y Consentimiento

Un **scope** define qué permisos solicita el client. El usuario debe **consentir** explícitamente.

```
┌─────────────────────────────────────────┐
│  FiltroPro quiere acceder a tu cuenta   │
│                                         │
│  Permisos solicitados:                  │
│  ✓ Leer tus fotos                       │
│  ✓ Leer tu perfil                        │
│  ✗ No podrá: eliminar fotos,            │
│            enviar emails                │
│                                         │
│   [ Denegar ]      [ Permitir ]         │
└─────────────────────────────────────────┘
```

| Scope de Google | Permiso |
|---|---|
| `openid` | Autenticar (OIDC) |
| `email` | Ver email |
| `profile` | Nombre, foto |
| `https://www.googleapis.com/auth/photoslibrary.readonly` | Leer fotos |

## Proveedores OAuth

| Proveedor | Authorization URL | Token URL | Scopes básicos |
|---|---|---|---|
| **Google** | `accounts.google.com/o/oauth2/v2/auth` | `oauth2.googleapis.com/token` | `openid email profile` |
| **GitHub** | `github.com/login/oauth/authorize` | `github.com/login/oauth/access_token` | `user:email read:user` |
| **Auth0** | `<tenant>.auth0.com/authorize` | `<tenant>.auth0.com/oauth/token` | `openid profile email` |
| **Microsoft** | `login.microsoftonline.com/{tenant}/oauth2/v2.0/authorize` | `login.microsoftonline.com/{tenant}/oauth2/v2.0/token` | `openid email profile` |

### Configuración de un client OAuth (JSON)

```json
{
  "client_id": "123456789-abc.apps.googleusercontent.com",
  "client_secret": "GOCSPX-secret-only-backend",
  "redirect_uri": "https://filtrophecho.com/auth/callback",
  "scope": "openid email profile",
  "authorization_endpoint": "https://accounts.google.com/o/oauth2/v2/auth",
  "token_endpoint": "https://oauth2.googleapis.com/token",
  "userinfo_endpoint": "https://openidconnect.googleapis.com/v1/userinfo"
}
```

## Implicit Flow: por qué está deprecado

El **implicit flow** devolvía el access token directamente en el redirect URL (`#access_token=...`), sin paso de canje. Era popular en SPAs antiguas que no tenían backend.

```
Implicit flow (DEPRECADO):
GET /authorize?response_type=token
   → redirect: https://app.com/cb#access_token=eyJ...
```

**Problemas**:
- El token queda en la URL (logs, historial, referer).
- No hay refresh tokens.
- Vulnerable a token interception.
- No hay forma de verificar la audiencia del token.

> La recomendación actual (OAuth 2.1, BCP) es usar **Authorization Code + PKCE** para todo, incluidas SPAs y móviles.

## Tabla de referencia: Grant types

| Grant Type | ¿Usuario presente? | Client confidencial? | Caso de uso |
|---|---|---|---|
| Authorization Code + PKCE | Sí | No (público) | SPA, móvil |
| Authorization Code | Sí | Sí (backend) | Web app con backend |
| Client Credentials | No | Sí | M2M, microservicios |
| Refresh Token | No (renueva) | Ambos | Renovar access token |
| Device Code | Sí (en otro device) | No | TV, IoT, consolas |
| Password (ROPC) | Sí | Sí | ❌ Legacy, evitar |
| Implicit | Sí | No | ❌ Deprecado |

## Conceptos clave

- **OAuth 2.0 vs OIDC**: OAuth 2.0 es **autorización** (delegar acceso); OIDC es **autenticación** (identidad), una capa sobre OAuth.
- **Authorization Code**: el flujo estándar. El client recibe un code de corta duración y lo canjea por un token en el backend.
- **PKCE**: protege el code en clientes públicos demostrando que quien canjea el code es quien lo solicitó.
- **Scopes**: granularidad de permisos. El usuario consiente explícitamente qué scopes concede.
- **ID Token**: JWT con claims de identidad. Se usa para autenticar al usuario en el client, no para llamar a APIs.
- **Client público vs confidencial**: los públicos (SPA, móvil) no pueden guardar un secret de forma segura; por eso usan PKCE.

## Errores comunes

- **Usar implicit flow en SPAs nuevas**: está deprecado. Usar Authorization Code + PKCE.
- **No usar PKCE en clientes públicos**: el authorization code puede ser interceptado en el redirect.
- **Usar password grant (ROPC)**: expone la contraseña del usuario al client. Deprecado en OAuth 2.1.
- **No validar el `state` parameter**: protege contra CSRF en el redirect. Debe ser aleatorio y verificarse.
- **Confundir ID token con access token**: el ID token autentica al usuario; el access token autoriza el acceso a recursos.
- **Almacenar el `client_secret` en una SPA**: es accesible por JavaScript. SPAs son clients públicos, usan PKCE.
- **No validar la audiencia (`aud`) del token**: un token emitido para otra app podría ser aceptado por error.
- **Solicitar scopes de más**: viola el principio de mínimo privilegio. Solo pedir lo necesario.
