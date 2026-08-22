# 03 — JWT y Tokens

> JSON Web Tokens: estructura (header, payload, signature), base64url, HMAC vs RSA, verificación de firma y claims, refresh tokens, token rotation y blacklisting. El estándar de autenticación stateless.

## Objetivos

- [ ] Entender la estructura de un JWT: header, payload, signature
- [ ] Saber cómo funciona el encoding base64url
- [ ] Diferenciar firma simétrica (HMAC) de asimétrica (RSA/ECDSA)
- [ ] Trazar el flujo completo: login emite token, cliente envía Bearer
- [ ] Verificar un JWT: firma, expiración, claims
- [ ] Entender refresh tokens y token rotation
- [ ] Implementar blacklisting de tokens
- [ ] Comparar JWT vs sesiones con criterios técnicos

## ¿Qué es un JWT?

Un **JSON Web Token** (RFC 7519) es un string compacto y autocontenido que transmite claims (afirmaciones) entre dos partes de forma verificable. A diferencia de las sesiones, el servidor no necesita consultar un almacén: la información va dentro del propio token, protegida por una firma.

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjMiLCJlbWFpbCI6ImFsaWNlQGV4YW1wbGUuY29tIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzAwMDAwMDAwLCJleHAiOjE3MDAwMDM2MDB9.s7nK3xQ9vF2mBpL8hR1tYwZcA4bD6eG0iJkMnO5pQsU
│                              │                                                                                              │
└──────────┬───────────────────┘ └──────────────────────────────────┬───────────────────────────────────────────────────┘
           │                                                        │
       HEADER                                                 PAYLOAD
       (base64url)                                           (base64url)
                                                                    └─── SIGNATURE (HMAC)
```

## Estructura de un JWT

### Header

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

| Campo | Significado |
|---|---|
| `alg` | Algoritmo de firma (HS256, RS256, ES256, none) |
| `typ` | Tipo de token (siempre "JWT") |

### Payload (claims)

```json
{
  "sub": "123",
  "email": "alice@example.com",
  "role": "admin",
  "iat": 1700000000,
  "exp": 1700003600
}
```

| Claim | Significado | Ejemplo |
|---|---|---|
| `iss` | Emisor (issuer) | `auth.example.com` |
| `sub` | Sujeto (user ID) | `123` |
| `aud` | Audiencia (destinatario) | `api.example.com` |
| `exp` | Expiración (timestamp) | `1700003600` |
| `nbf` | No antes de (not before) | `1700000000` |
| `iat` | Emitido en (issued at) | `1700000000` |
| `jti` | ID único del token | `uuid-abc123` |

### Signature

```
HMACSHA256(
  base64url(header) + "." + base64url(payload),
  secret
)
```

La firma garantiza que el token no ha sido modificado. Solo quien tiene el secret puede firmar; cualquiera puede verificar (en HMAC, verificar requiere el mismo secret).

## base64url encoding

JWT usa **base64url**, una variante de base64 que es segura para URLs:

```
Base64 estándar:  usa + y /
Base64url:        usa - y _  (sin padding =)
```

```python
import base64

def b64url_encode(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b'=').decode('ascii')

def b64url_decode(s: str) -> bytes:
    padding = 4 - len(s) % 4
    if padding != 4:
        s += '=' * padding
    return base64.urlsafe_b64decode(s)

# Ejemplo
header = b'{"alg":"HS256","typ":"JWT"}'
print(b64url_encode(header))
# eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
```

## HMAC vs RSA

| Aspecto | HMAC (HS256) | RSA (RS256) | ECDSA (ES256) |
|---|---|---|---|
| Tipo de clave | Simétrica (un secret compartido) | Asimétrica (clave pública/privada) | Asimétrica |
| Firmar | Necesita el secret | Necesita clave privada | Necesita clave privada |
| Verificar | Necesita el secret | Necesita clave pública | Necesita clave pública |
| Tamaño de clave | 256 bits | 2048+ bits | 256 bits |
| Rendimiento | Rápido | Más lento | Medio |
| Cuándo usar | Un solo servidor verifica | Múltiples servicios verifican | Móvil/IoT |

```
HMAC (simétrico)                     RSA (asimétrico)

  Auth Service                          Auth Service
  ┌──────────┐                          ┌──────────┐
  │  secret  │── firma                  │ priv key │── firma
  └────┬─────┘                          └──────────┘
       │                                       │
  API Server                               API Server
  ┌──────────┐                              ┌──────────┐
  │  secret  │── verifica                   │ pub key  │── verifica
  └──────────┘                              └──────────┘
```

> Con HMAC, quien puede verificar también puede firmar. Si un microservicio se ve comprometido, el atacante puede emitir tokens válidos. Con RSA, el servicio de auth tiene la clave privada; los demás servicios solo tienen la pública y no pueden firmar.

## Flujo completo de JWT

```
1. LOGIN
Cliente ──POST /login {email,password}──► Servidor
                                              │
                                      verificar credenciales
                                              │
                                      generar access_token
                                      (exp=15min)
                                              │
Cliente ◄──{access_token, refresh_token}──── Servidor

2. PETICIÓN AUTENTICADA
Cliente ──GET /api/perfil────────────────► Servidor
         Authorization: Bearer eyJhb...
                                              │
                                      extraer token del header
                                      verificar firma + exp
                                              │
Cliente ◄──────200 OK {perfil}──────────── Servidor

3. TOKEN EXPIRADO → REFRESH
Cliente ──POST /token/refresh────────────► Servidor
         {refresh_token}
                                              │
                                      verificar refresh_token
                                      emitir nuevo access_token
                                              │
Cliente ◄──{access_token: nuevo}────────── Servidor
```

### Ejemplo de emisión de JWT

```python
import hmac
import hashlib
import json
import time
import base64

SECRET = "super-secreto-no-en-codigo"

def b64url(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b'=').decode('ascii')

def create_jwt(payload: dict, secret: str, ttl: int = 900) -> str:
    header = {"alg": "HS256", "typ": "JWT"}
    now = int(time.time())
    payload = {**payload, "iat": now, "exp": now + ttl}
    
    header_b64 = b64url(json.dumps(header, separators=(',', ':')).encode())
    payload_b64 = b64url(json.dumps(payload, separators=(',', ':')).encode())
    
    signing_input = f"{header_b64}.{payload_b64}".encode()
    signature = hmac.new(secret.encode(), signing_input, hashlib.sha256).digest()
    sig_b64 = b64url(signature)
    
    return f"{header_b64}.{payload_b64}.{sig_b64}"
```

### Envío del token: Authorization Bearer

```http
GET /api/perfil HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjMi...
```

## Verificación de JWT

```python
def verify_jwt(token: str, secret: str) -> dict | None:
    try:
        header_b64, payload_b64, sig_b64 = token.split('.')
    except ValueError:
        return None  # Formato inválido
    
    # 1. Recalcular la firma
    signing_input = f"{header_b64}.{payload_b64}".encode()
    expected_sig = hmac.new(secret.encode(), signing_input, hashlib.sha256).digest()
    expected_sig_b64 = b64url(expected_sig)
    
    # 2. Comparación timing-safe
    if not hmac.compare_digest(expected_sig_b64, sig_b64):
        return None  # Firma inválida
    
    # 3. Verificar expiración
    payload = json.loads(b64url_decode(payload_b64))
    if payload.get("exp", 0) < time.time():
        return None  # Token expirado
    
    return payload
```

| Paso | Qué verifica | Qué previene |
|---|---|---| 
| Decodificar formato | 3 partes separadas por `.` | Tokens malformados |
| Verificar firma | HMAC coincide | Tampering, modificación de claims |
| Verificar `exp` | No ha expirado | Uso de tokens viejos |
| Verificar `iss` (opcional) | Emisor correcto | Tokens de otros sistemas |
| Verificar `aud` (opcional) | Audiencia correcta | Tokens emitidos para otra API |

## Access Token vs Refresh Token

| Aspecto | Access Token | Refresh Token |
|---|---|---|
| Duración | Corta (15 min) | Larga (7-30 días) |
| Uso | Acceder a recursos | Renovar access token |
| Almacenamiento | Memoria / localStorage | HttpOnly cookie |
| Verificación | Stateless (verificar firma) | Stateful (consultar store) |
| Exposición | Se envía en cada petición | Se envía raramente |

> El access token es de corta duración para limitar el daño si se roba. El refresh token permite renovar sin que el usuario vuelva a escribir su contraseña.

## Token Rotation

Con rotation, cada vez que se usa el refresh token para obtener un nuevo access token, **se emite también un nuevo refresh token** y se invalida el anterior.

```
1. Login → access_1 + refresh_1
2. refresh_1 → access_2 + refresh_2  (refresh_1 invalidado)
3. refresh_2 → access_3 + refresh_3  (refresh_2 invalidado)
```

```python
def refresh_rotation(old_refresh_token):
    # 1. Verificar que el refresh token es válido
    payload = verify_refresh_token(old_refresh_token)
    if not payload:
        raise Unauthorized("refresh token inválido")
    
    # 2. Comprobar que no está ya usado (replay detection)
    if is_blacklisted(old_refresh_token):
        # ¡Alguien intenta reusar un token ya rotado!
        # Posible robo: invalidar toda la familia
        invalidate_token_family(payload["family_id"])
        raise SecurityAlert("Reuse detected")
    
    # 3. Invalidar el refresh token antiguo
    blacklist(old_refresh_token, ttl=86400)
    
    # 4. Emitir nuevo access + refresh
    new_access = create_access_token(payload["sub"])
    new_refresh = create_refresh_token(payload["sub"], payload["family_id"])
    
    return new_access, new_refresh
```

> Si un atacante roba un refresh token y lo usa, el legítimo usuario también intentará usar el anterior. El servidor detecta el reuso e invalida toda la familia de tokens, forzando un nuevo login.

## Blacklisting tokens

JWT es stateless: no hay forma de invalidar un token válido sin estado adicional. El **blacklisting** guarda los `jti` (IDs únicos) de tokens revocados.

```python
def revoke_token(token, secret):
    payload = verify_jwt(token, secret)
    if payload:
        # Guardar jti hasta que expire naturalmente
        ttl = payload["exp"] - int(time.time())
        if ttl > 0:
            r.setex(f"blacklist:{payload['jti']}", ttl, "1")

def is_revoked(payload):
    return r.exists(f"blacklist:{payload.get('jti')}")
```

> El blacklist solo necesita guardar el token hasta su `exp`. No es tan costoso como las sesiones porque los access tokens son de corta duración.

## JWT vs Sesiones

| Criterio | JWT (stateless) | Sesiones (stateful) |
|---|---|---|
| Estado en servidor | ❌ No | ✅ Sí (Redis/DB) |
| Escalabilidad | ✅ Excelente (cualquier servidor verifica) | Requiere store compartido |
| Invalidación inmediata | ❌ Difícil (blacklist) | ✅ Borrar sesión |
| Tamaño en cada petición | Grande (~500 bytes) | Pequeño (session ID) |
| Información en cliente | ✅ Claims visibles (no sensibles) | ❌ Nada |
| Cross-domain | ✅ Funciona | Difícil (cookies) |
| Revocación masiva | Difícil (cambiar secret) | ✅ Flush Redis |
| Adecuado para | APIs, microservicios, móviles | Apps web tradicionales |

## Tabla de referencia: algoritmos JWT

| Algoritmo | Tipo | Clave | Uso recomendado |
|---|---|---|---|
| HS256 | HMAC + SHA-256 | Simétrica 256-bit | Single service |
| HS384 | HMAC + SHA-384 | Simétrica 384-bit | Single service |
| HS512 | HMAC + SHA-512 | Simétrica 512-bit | Single service |
| RS256 | RSA + SHA-256 | Asimétrica 2048-bit | Multi-service |
| RS512 | RSA + SHA-512 | Asimétrica 2048-bit | Multi-service |
| ES256 | ECDSA P-256 | Asimétrica 256-bit | Móvil/IoT |
| none | Sin firma | — | ❌ NUNCA usar |

## Conceptos clave

- **JWT autocontenido**: a diferencia del session ID, el token contiene claims del usuario. El servidor no necesita consultar un almacén para saber quién es.
- **Firma, no cifrado**: JWT garantiza **integridad** (no se ha modificado), no **confidencialidad**. El payload es legible por cualquiera. Nunca poner datos sensibles en el payload.
- **base64url**: encoding seguro para URLs que sustituye `+`/`/` por `-`/`_` y elimina el padding. Permite que el token viaje en headers y query params.
- **`exp` es obligatorio**: sin expiración, un token robado es válido para siempre. Access tokens: 15 min. Refresh tokens: 7-30 días.
- **Token rotation**: renovar el refresh token en cada uso permite detectar reuso (robo de token) e invalidar la familia.
- **Blacklist con `jti`**: el único mecanismo de invalidación stateless. Guarda IDs de tokens revocados hasta su expiración natural.

## Errores comunes

- **Aceptar `alg: none`**: un atacante crea un token sin firma y el servidor lo acepta si no fuerza un algoritmo. Siempre verificar `alg == HS256` explícitamente.
- **Guardar el secret en código fuente**: si el repo se filtra, cualquiera puede firmar tokens. Usar variables de entorno o un gestor de secretos.
- **Poner información sensible en el payload**: el payload es solo base64, no cifrado. Cualquiera puede leerlo. Nunca poner contraseñas, datos bancarios, etc.
- **Access token de larga duración**: si se roba, el atacante tiene acceso durante mucho tiempo. Mantener access tokens en 15 min.
- **No implementar rotation en refresh tokens**: sin rotation, un refresh token robado es válido hasta su expiración (días/semanas).
- **Usar JWT donde una sesión sería mejor**: si necesitas invalidación inmediata frecuente, las sesiones son más simples que el blacklist.
- **No verificar `exp`**: un token con `exp` vencido sigue siendo válido en firma. Siempre comprobar la expiración.
- **Usar localStorage para el token**: vulnerable a XSS. Preferir HttpOnly cookie; si se usa localStorage, mitigar XSS agresivamente.
