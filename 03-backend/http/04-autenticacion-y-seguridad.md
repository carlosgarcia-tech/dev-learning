# 04 — Autenticación y Seguridad

> Autenticación HTTP (Basic, Bearer, Digest), sesiones vs tokens, JWT por dentro, OAuth 2.0 (authorization code + refresh), headers de seguridad, HTTPS y TLS, rate limiting.

## Objetivos

- [ ] Explicar los esquemas de autenticación HTTP: **Basic**, **Bearer**, **Digest**.
- [ ] Comparar **sesiones** vs **tokens** y cuándo usar cada uno.
- [ ] Decodificar y validar un **JWT** (header, payload, signature).
- [ ] Describir el flujo **OAuth 2.0 Authorization Code** con PKCE y los **refresh tokens**.
- [ ] Conocer los **headers de seguridad**: HSTS, `X-Content-Type-Options`, `X-Frame-Options`, CSP.
- [ ] Entender **HTTPS y TLS**: handshake, certificados y CA.
- [ ] Aplicar **rate limiting** básico.

## Autenticación vs autorización

- **Autenticación (AuthN):** ¿quién eres? Verificar identidad (usuario + contraseña, token).
- **Autorización (AuthZ):** ¿qué puedes hacer? Verificar permisos (roles, scopes).

El header `Authorization` transporta la credencial; el código de estado `401 Unauthorized` (en realidad “Unauthenticated”) y `403 Forbidden` comunican el fallo.

## Esquemas de autenticación HTTP

### HTTP Basic

El cliente envía `usuario:contraseña` codificado en **Base64**.

```
Authorization: Basic dXN1YXJpbzpzZWNyZXQ=
```

`dXN1YXJpbzpzZWNyZXQ=` es `base64("usuario:secreto")`.

```bash
curl -u usuario:secreto https://api.tienda.com/profile
```

Características:

- **Inseguro por sí solo:** Base64 no es cifrado. Se debe usar **solo sobre HTTPS**.
- El browser muestra el diálogo nativo de login.
- El cliente reenvía las credenciales en cada petición.
- Útil para scripts simples, APIs internas o dispositivos.

### HTTP Bearer

El cliente envía un **token** opaco o JWT:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

El servidor valida el token y responde. Si no hay o es inválido: `401`.

```bash
curl -H "Authorization: Bearer eyJhbGc..." https://api.tienda.com/profile
```

- El token tiene una vida limitada.
- El servidor no necesita guardarlo (si es JWT).
- Es el estándar de hecho para APIs.

### HTTP Digest

Retar-respuesta con hash (MD5). El servidor envía un `nonce`; el cliente responde con un hash de `usuario:contraseña:nonce`. Nunca envía la contraseña en claro.

```
WWW-Authenticate: Digest realm="api", nonce="abc123", qop="auth"
```

- Mejor que Basic sin HTTPS, pero **obsoleto** (MD5) y engorroso. Hoy se prefiere Bearer + TLS.

## Sesiones vs tokens

### Sesiones (server-side)

1. El cliente hace login (usuario + contraseña).
2. El servidor **crea una sesión** en su almacenamiento (memoria, Redis) con un ID.
3. Devuelve ese ID en una **cookie** (`Set-Cookie: session=abc123; HttpOnly; Secure`).
4. En cada petición, el cliente envía la cookie; el servidor busca la sesión.

```
POST /login  →  200 OK + Set-Cookie: session=abc123
GET /profile  (Cookie: session=abc123)  →  200 OK
```

- **Ventaja:** el servidor puede revocar la sesión en cualquier momento (borrarla).
- **Desventaja:** requiere estado en el servidor; no escala horizontalmente sin almacenamiento compartido (Redis).

### Tokens (stateless, JWT)

1. El cliente hace login.
2. El servidor **firma** un JWT con su clave secreta y lo devuelve.
3. El cliente lo guarda (localStorage, memoria) y lo envía en `Authorization: Bearer`.
4. El servidor **verifica la firma** del JWT en cada petición, sin consultarlo en base de datos.

```
POST /login  →  200 OK + {"token":"eyJhbGc..."}
GET /profile  (Authorization: Bearer eyJhbGc...)  →  200 OK
```

- **Ventaja:** stateless, escala horizontalmente, perfecto para microservicios.
- **Desventaja:** no se puede revocar fácilmente hasta que expire (se usan listas negras o rotación de claves).

| | Sesiones | Tokens (JWT) |
|---|---|---|
| Estado | En el servidor | Stateless |
| Almacenamiento | Cookie | localStorage/memoria |
| Revocación | Fácil (borrar sesión) | Difícil (lista negra) |
| Escalado | Requiere Redis | Horizontal sin estado |
| Tamaño | Cookie corta | JWT largo |
| Uso típico | Web renderizada en servidor | SPA, móvil, microservicios |

## JWT en profundidad

Un **JWT** (JSON Web Token) es un token firmado (no cifrado) con tres partes separadas por `.`:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjMiLCJyb2xlIjoiYWRtaW4iLCJleHAiOjE3MjQzMDQwMDB9.K7g...sig
\_____________________________________/ \_______________________________________________________________/ \__________/
              Header                                          Payload                                    Signature
```

### Header

Metadatos del token, en JSON Base64URL:

```json
{"alg": "HS256", "typ": "JWT"}
```

- `alg`: algoritmo de firma (`HS256`, `RS256`...).
- `typ`: tipo (siempre `JWT`).

### Payload

Claims (afirmaciones) en JSON Base64URL. **No cifrado**: cualquiera puede leerlo. Nunca pongas secretos aquí.

```json
{
  "sub": "123",
  "role": "admin",
  "iat": 1724304000,
  "exp": 1724307600
}
```

Claims estándar:

| Claim | Significado |
|---|---|
| `iss` | Emisor del token |
| `sub` | Subject (ID del usuario) |
| `aud` | Audiencia (para quién es el token) |
| `exp` | Expiración (timestamp) |
| `iat` | Issued at (cuándo se emitió) |
| `nbf` | Not before (válido desde) |
| `jti` | ID único del token (para revocación) |

### Signature

Firma que garantiza integridad. Con HS256:

```
HMAC-SHA256(
  base64url(header) + "." + base64url(payload),
  SECRET
)
```

El servidor recalcula la firma con su secreto; si coincide, el token es válido y no ha sido modificado.

### Verificación en el servidor

El servidor debe comprobar:

1. **Firma válida** (recalculada con su secreto/clave pública).
2. **`exp` no ha pasado** (token no expirado).
3. **`iss`/`aud`** correctos (opcional pero recomendado).
4. **`alg` esperado** (rechaza `alg=none` o algoritmos no permitidos).

### Decodificar un JWT a mano

```bash
# Payload en Base64URL → JSON
echo "eyJzdWIiOiIxMjMiLCJyb2xlIjoiYWRtaW4iLCJleHAiOjE3MjQzMDQwMDB9" \
  | tr '_-' '/+' \
  | base64 -d 2>/dev/null
# → {"sub":"123","role":"admin","exp":1724304000}
```

### Peligros del JWT

- **No cifrado:** el payload es legible. No guardes datos sensibles.
- **No revocable** hasta que expire. Usa `exp` corto + refresh tokens.
- **`alg=none`**: históricamente permitía tokens sin firma. **Recházalo siempre.**
- **Fuga del secreto:** permite firmar tokens válidos. Rota el secreto y todos los tokens caducan.

## OAuth 2.0

**OAuth 2.0** es un framework de **autorización delegada**: permite que una app acceda a recursos de un usuario en otra API sin que la app vea la contraseña del usuario.

### Roles

| Rol | Ejemplo |
|---|---|
| **Resource Owner** | El usuario |
| **Client** | La app que quiere acceder |
| **Authorization Server** | Emite tokens (ej. Google, Auth0) |
| **Resource Server** | La API con los datos |

### Authorization Code Grant (flujo estándar)

1. La app redirige al usuario al Authorization Server:
   ```
   https://auth.ejemplo.com/authorize?
     response_type=code&
     client_id=APP123&
     redirect_uri=https://app.com/callback&
     scope=read:profile&
     state=xyz
   ```
2. El usuario se logea y **consiente**.
3. El Authorization Server redirige a `redirect_uri` con un **código** de un solo uso:
   ```
   https://app.com/callback?code=ABC123&state=xyz
   ```
4. La app intercambia el código por tokens en el backend (POST):
   ```
   POST /token
   grant_type=authorization_code
   code=ABC123
   client_id=APP123
   client_secret=SECRET
   redirect_uri=https://app.com/callback
   ```
5. Recibe **access token** + **refresh token**:
   ```json
   {
     "access_token": "eyJhbGc...",
     "token_type": "Bearer",
     "expires_in": 3600,
     "refresh_token": "r3fr3sh..."
   }
   ```
6. Usa el access token:
   ```
   GET /api/profile
   Authorization: Bearer eyJhbGc...
   ```

### PKCE (Proof Key for Code Exchange)

Para SPAs y móviles (que no pueden guardar un `client_secret`), se usa **PKCE**: el cliente genera un `code_verifier` aleatorio, envía su hash (`code_challenge`) en el paso 1 y demuestra el `code_verifier` al canjear el código. Evita el robo del código de autorización.

### Refresh tokens

El `access_token` expira rápido (ej. 1h). El `refresh_token` (vida larga, guardado seguro) permite pedir uno nuevo sin re-login:

```
POST /token
grant_type=refresh_token
refresh_token=r3fr3sh...
client_id=APP123
```

```json
{"access_token": "eyJNEW...", "expires_in": 3600}
```

## Headers de seguridad

### Strict-Transport-Security (HSTS)

Fuerza HTTPS: el browser recordará usar solo HTTPS para el dominio durante N segundos.

```
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

- `max-age`: segundos (1 año típico).
- `includeSubDomains`: aplica a subdominios.
- `preload`: lista de browsers para ser incluido en HSTS preload.

### X-Content-Type-Options

Evita el **MIME sniffing**: el browser respetará el `Content-Type` declarado.

```
X-Content-Type-Options: nosniff
```

### X-Frame-Options

Evita que la página sea embebida en un `<iframe>` (defensa contra clickjacking).

```
X-Frame-Options: DENY
```

Valores: `DENY` (nunca), `SAMEORIGIN` (solo mismo origen). Hoy se prefiere la directiva `frame-ancestors` de CSP.

### Content-Security-Policy (CSP)

Restringe desde dónde se pueden cargar scripts, estilos, imágenes, etc. Es la defensa principal contra **XSS**.

```
Content-Security-Policy: default-src 'self'; script-src 'self' https://cdn.ejemplo.com; object-src 'none'; base-uri 'self'
```

Directivas comunes:

| Directiva | Controla |
|---|---|
| `default-src` | Default para todo |
| `script-src` | Scripts JS |
| `style-src` | Estilos CSS |
| `img-src` | Imágenes |
| `connect-src` | fetch, WebSocket, XHR |
| `frame-ancestors` | Quién puede embeberte (reemplaza X-Frame-Options) |
| `object-src 'none'` | Prohíbe Flash/Java/plugins |

### Otros headers útiles

| Header | Para |
|---|---|
| `Referrer-Policy: strict-origin-when-cross-origin` | Controla cuánto `Referer` se envía |
| `Permissions-Policy: geolocation=(), camera=()` | Desactiva APIs del browser |
| `Cross-Origin-Opener-Policy: same-origin` | Aislamiento contra Spectre |
| `Cross-Origin-Embedder-Policy: require-corp` | Requiere CORS/`Cross-Origin-Resource-Policy` en recursos |

## HTTPS y TLS

**HTTPS** = HTTP sobre **TLS** (antes SSL). Cifra el contenido, autentica al servidor y garantiza integridad.

### TLS handshake (simplificado)

1. **ClientHello:** el cliente envía versión TLS soportada, cifrados y un random.
2. **ServerHello:** el servidor elige versión/cifrado y envía su random + **certificado**.
3. El cliente **verifica el certificado** contra una CA de confianza.
4. Intercambio de claves (ECDHE): se derivan claves de sesión simétricas.
5. **Finished:** ambos confirdan con claves de sesión; ya viaja cifrado.

```
Cliente                              Servidor
  │  ── ClientHello ──────────────────> │
  │  <──── ServerHello + Cert ────────── │
  │  ── Key Exchange ──────────────────> │
  │  <────── Finished ──────────────────│
  │  ====== tráfico cifrado =========== │
```

### Certificados y CA

- El **certificado** enlaza una **clave pública** con un **dominio**, firmado por una **Certificate Authority** (CA) de confianza.
- El browser trae una lista de CAs de confianza (Let's Encrypt, DigiCert, Sectigo...).
- **Let's Encrypt** emite certificados gratis y automáticos vía ACME.

### Por qué HTTPS importa

- **Confidencialidad:** nadie entre cliente y servidor lee el contenido.
- **Integridad:** nadie puede modificar el tráfico sin detectarse.
- **Autenticación:** el cliente sabe que habla con el dominio correcto.
- **Requisito** para HTTP/2, HTTP/3, HSTS, cookies `Secure`, Service Workers.

## Rate limiting

Limita cuántas peticiones hace un cliente en una ventana de tiempo. Defiende contra abuso, fuerza bruta y DDoS de capa de aplicación.

### Estrategias comunes

| Estrategia | Cómo |
|---|---|
| **Fixed window** | Contador por intervalo fijo (ej. 100/min) |
| **Sliding window** | Ventana móvil ponderada, más justo |
| **Token bucket** | Tokens se recargan a ritmo constante; consume 1 por petición |
| **Leaky bucket** | Cola con salida constante; suaviza picos |

### Identificación del cliente

- Por **IP** (proxy/CDN → cuidado con `X-Forwarded-For`).
- Por **usuario/token** (más preciso).
- Por **API key**.

### Respuesta al exceder

```
HTTP/1.1 429 Too Many Requests
Retry-After: 30
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1724304030
```

```bash
curl -i https://api.tienda.com/products \
  -H "Authorization: Bearer eyJhbGc..."
```

## Tabla de referencia rápida

### Esquemas de auth HTTP

| Esquema | Formato | Seguro sin HTTPS | Notas |
|---|---|---|---|
| Basic | `Basic base64(user:pass)` | ❌ | Simple, usar con TLS |
| Bearer | `Bearer <token>` | ❌ | Estándar de APIs |
| Digest | Reto-respuesta MD5 | ⚠️ | Mejor que Basic, obsoleto |

### Claims JWT

| Claim | Significado |
|---|---|
| `iss` | Emisor |
| `sub` | Subject (usuario) |
| `aud` | Audiencia |
| `exp` | Expiración |
| `iat` | Emitido en |
| `nbf` | Válido desde |
| `jti` | ID único |

### Headers de seguridad

| Header | Defiende contra |
|---|---|
| HSTS | SSL stripping |
| `X-Content-Type-Options: nosniff` | MIME sniffing |
| `X-Frame-Options: DENY` | Clickjacking |
| CSP | XSS / inyección |
| `Referrer-Policy` | Fuga de URLs |
| `Permissions-Policy` | Abuso de APIs |

## Conceptos clave

- **AuthN = quién eres; AuthZ = qué puedes hacer.** `401` responde a AuthN, `403` a AuthZ.
- **Basic/Bearer van SIEMPRE sobre HTTPS:** sin TLS son trivialmente interceptables.
- **Sesiones guardan estado en el servidor; JWT son stateless.** Cada uno tiene su sitio.
- **El payload de un JWT NO es secreto:** está solo Base64URL-codificado. Nunca pongas contraseñas.
- **La firma del JWT garantiza integridad, no confidencialidad.**
- **Verifica `exp`, `iss`, `aud` y `alg`.** Nunca aceptes `alg=none`.
- **OAuth 2.0 es autorización delegada**, no autenticación (para eso está OIDC sobre OAuth).
- **El authorization code fluye por el browser; el intercambio por tokens va en el backend** (con `client_secret` o PKCE).
- **Refresh tokens** permiten renovar el access token sin re-login; deben guardarse seguros.
- **HTTPS autentica al servidor, cifra e integra el tráfico.** Sin HTTPS, Basic/Bearer/cookies son inútiles.
- **Rate limiting** devuelve `429` con `Retry-After` y headers `X-RateLimit-*`.

## Errores comunes

- **Poner datos sensibles en el payload del JWT.** Es legible por cualquiera.
- **Aceptar `alg=none`.** Permite forjar tokens. Rechaza cualquier algoritmo no esperado.
- **No verificar `exp`.** Tokens expirados siguen siendo válidos si no lo compruebas.
- **Usar el mismo secreto en dev y prod**, o uno débil. Rota claves.
- **Guardarye tokens en localStorage sin protección XSS.** Un XSS roba el token. Considera cookies `HttpOnly`.
- **Olvidar `client_secret` en SPAs.** Usa PKCE en clientes públicos.
- **No usar HTTPS para Basic.** Las credenciales viajan en Base64, fácilmente reversibles.
- **No enviar `client_secret` por el browser.** Va en el backend.
- **Mezclar OAuth (autorización) con login.** Para login federado usa OpenID Connect.
- **Olvidar headers de seguridad** (HSTS, CSP, nosniff). Son una línea que reduce drásticamente la superficie de ataque.
- **Rate limit solo por IP** detrás de un CDN: todas las peticiones vienen de la IP del CDN. Usa `X-Forwarded-For` con cuidado o limita por token.
- **No rotar el secreto de firma de JWT.** Si se filtra, un atacante firma tokens válidos durante toda su vida.

## Siguiente

Continúa con [05 — WebSockets y Evolución](05-websockets-y-evolucion.md) para ver WebSockets, SSE, GraphQL sobre HTTP, gRPC, HTTP/2 y HTTP/3.
