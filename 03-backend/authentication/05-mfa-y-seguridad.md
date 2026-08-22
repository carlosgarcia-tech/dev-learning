# 05 — MFA y Seguridad

> Multi-Factor Authentication (TOTP, SMS OTP, WebAuthn/FIDO2), Single Sign-On (SAML, CAS), passwordless (magic links, biometría), rate limiting, brute force protection, credential stuffing, session fixation, password policies, security headers y best practices de producción.

## Objetivos

- [ ] Entender los métodos de MFA: TOTP, SMS OTP, WebAuthn/FIDO2
- [ ] Conocer Single Sign-On (SSO) con SAML y CAS
- [ ] Explicar passwordless: magic links y biometría
- [ ] Implementar rate limiting y protección contra brute force
- [ ] Entender credential stuffing y cómo mitigarlo
- [ ] Prevenir session fixation
- [ ] Definir password policies efectivas
- [ ] Configurar security headers en producción

## Multi-Factor Authentication (MFA)

MFA exige dos o más factores de autenticación independientes. Si un factor se compromete, el atacante aún necesita el otro.

| Método | Factor | UX | Seguridad | Coste |
|---|---|---|---|---|
| **TOTP** (Google Authenticator) | Algo que tienes | Media | ✅ Buena | Gratis |
| **SMS OTP** | Algo que tienes | Alta | ⚠️ Media (SIM swap) | Pago |
| **Email OTP** | Algo que tienes | Alta | ⚠️ Media | Gratis |
| **Hardware key (WebAuthn)** | Algo que tienes | Baja | ✅ Excelente | Pago |
| **Biometría** | Algo que eres | Alta | ✅ Buena | Variable |

### TOTP (Time-based One-Time Password)

TOTP (RFC 6238) genera códigos de 6 dígitos que cambian cada 30 segundos, a partir de un **secret compartido** y la hora actual.

```
REGISTRO:
1. Servidor genera secret aleatorio (20 bytes → base32)
2. Muestra QR con URI otpauth://
3. Usuario escanea con app (Google Authenticator, Authy)
4. Servidor guarda secret asociado al usuario

VERIFICACIÓN (login):
1. Usuario introduce password (factor 1)
2. App muestra código TOTP actual (factor 2)
3. Servidor recalcula TOTP con el secret guardado
4. Si coinciden → acceso concedido
```

```python
import hmac
import hashlib
import struct
import time
import base64

def generate_totp_secret():
    """Genera un secret TOTP de 20 bytes en base32."""
    return base64.b32encode(secrets.token_bytes(20)).decode('ascii')

def totp_code(secret_b32: str, timestamp: int = None) -> str:
    """Genera el código TOTP de 6 dígitos."""
    if timestamp is None:
        timestamp = int(time.time())
    # Ventana de 30 segundos
    counter = timestamp // 30
    
    key = base64.b32decode(secret_b32)
    msg = struct.pack('>Q', counter)
    digest = hmac.new(key, msg, hashlib.sha1).digest()
    
    # Dynamic truncation
    offset = digest[-1] & 0x0F
    code = struct.unpack('>I', digest[offset:offset+4])[0] & 0x7FFFFFFF
    return str(code % 1000000).zfill(6)

def verify_totp(secret_b32: str, user_code: str) -> bool:
    now = int(time.time())
    # Aceptar código actual y ±1 ventana (±30s) para desincronía de reloj
    for window in [-1, 0, 1]:
        if hmac.compare_digest(
            totp_code(secret_b32, now + window * 30),
            user_code
        ):
            return True
    return False
```

URI del QR code:

```
otpauth://totp/FiltroPro:alice@example.com?secret=JBSWY3DPEHPK3PXP&issuer=FiltroPro&digits=6&period=30
```

### SMS OTP

```json
// Servidor genera código y envía por SMS
{
  "method": "sms",
  "phone": "+34655123456",
  "code": "482915",
  "expires_at": "2025-01-15T10:35:00Z",
  "attempts": 0,
  "max_attempts": 3
}
```

> SMS OTP es menos seguro que TOTP: vulnerable a SIM swap e interceptación. Usar solo si no hay alternativa (TOTP preferible).

### WebAuthn / FIDO2

WebAuthn (Web Authentication) usa claves públicas/privadas generadas en un **autenticador** (llave USB, Secure Enclave, Touch ID). El servidor nunca ve la clave privada.

```
REGISTRO (attestation):
1. Servidor envía challenge aleatorio
2. Autenticador genera par de claves (priv/públic)
3. Autenticador firma el challenge con la clave privada
4. Servidor guarda la clave pública

LOGIN (assertion):
1. Servidor envía challenge aleatorio
2. Autenticador firma el challenge con la clave privada
3. Servidor verifica con la clave pública guardada
```

- **Phishing-resistant**: el autenticador solo responde al dominio correcto.
- **No hay secreto compartido**: el servidor no guarda secretos, solo claves públicas.

```json
// PublicKeyCredentialCreationOptions (registro)
{
  "challenge": "random_bytes_base64url",
  "rp": {"name": "FiltroPro", "id": "filtrophecho.com"},
  "user": {
    "id": "user_123",
    "name": "alice@example.com",
    "displayName": "Alice García"
  },
  "pubKeyCredParams": [
    {"type": "public-key", "alg": -7},
    {"type": "public-key", "alg": -257}
  ],
  "authenticatorSelection": {
    "authenticatorAttachment": "platform",
    "userVerification": "required"
  },
  "timeout": 60000
}
```

## Single Sign-On (SSO)

SSO permite que un usuario se autentique **una vez** y acceda a **múltiples aplicaciones** sin volver a loguearse.

```
              ┌─────────────┐
              │  Identity    │
              │  Provider     │
              │   (IdP)      │
              └──────┬───────┘
                     │
       ┌─────────────┼─────────────┐
       │             │             │
       ▼             ▼             ▼
   ┌───────┐    ┌───────┐    ┌───────┐
   │ App A │    │ App B │    │ App C │
   └───────┘    └───────┘    └───────┘
   
   Usuario se loguea una vez en el IdP →
   accede a A, B y C sin re-login.
```

### SAML (Security Assertion Markup Language)

SAML es el estándar de SSO empresarial basado en XML. Roles:
- **IdP** (Identity Provider): emite aserciones.
- **SP** (Service Provider): la aplicación que confía en el IdP.

```xml
<!-- Aserción SAML simplificada -->
<saml:Assertion xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion">
  <saml:Subject>
    <saml:NameID Format="...:emailAddress">alice@example.com</saml:NameID>
  </saml:Subject>
  <saml:AttributeStatement>
    <saml:Attribute Name="role">
      <saml:AttributeValue>admin</saml:AttributeValue>
    </saml:Attribute>
  </saml:AttributeStatement>
  <saml:AuthnStatement AuthnInstant="2025-01-15T10:30:00Z"/>
</saml:Assertion>
```

### CAS (Central Authentication Service)

Protocolo de SSO académico/universitario. El usuario se loguea en el servidor CAS; las apps validan tickets de servicio con el servidor.

## Passwordless

La autenticación sin contraseña elimina el factor "algo que sabes" (contraseña) en favor de "algo que tienes" o "algo que eres".

### Magic Links

El servidor envía un enlace único de un solo uso al email del usuario. Al pulsar, se autentica.

```
1. Usuario introduce email → POST /magic-link
2. Servidor genera token de un solo uso (ttl=15min)
3. Servidor envía email con https://app.com/auth?token=xyz
4. Usuario pulsa el enlace
5. Servidor valida token → crea sesión
```

```json
{
  "token": "magic_8f3a2b9c1d4e5f6a",
  "email": "alice@example.com",
  "expires_at": "2025-01-15T10:45:00Z",
  "used": false
}
```

### Biometría

Huella (Touch ID), rostro (Face ID), voz. Siempre combinada con un factor de respaldo (passcode), ya que la biometría no es secreto: no se puede cambiar si se compromete.

> WebAuthn permite usar la biometría del dispositivo como autenticador (platform authenticator), uniendo passwordless y phishing-resistance.

## Rate Limiting y Brute Force Protection

**Brute force**: probar todas las contraseñas posibles. **Credential stuffing**: usar pares email/contraseña filtrados de otros brechas.

### Estrategias de rate limiting

| Estrategia | Qué limita | Ejemplo |
|---|---|---|
| **Por IP** | Nº de intentos por IP | 10 intentos/min |
| **Por cuenta** | Nº de intentos por cuenta | 5 fallos → lockout |
| **Por IP + cuenta** | Combinación | 10/IP, 5/cuenta |
| **Backoff exponencial** | Cada fallo duplica el tiempo de espera | 1s, 2s, 4s, 8s... |
| **CAPTCHA progresivo** | Tras N fallos, requiere CAPTCHA | 3 fallos → CAPTCHA |

```python
import time

# Rate limiting por IP con backoff exponencial
def check_rate_limit(ip, max_attempts=5):
    key = f"login_attempts:{ip}"
    attempts = r.incr(key)
    if attempts == 1:
        r.expire(key, 900)  # ventana de 15 min
    
    if attempts > max_attempts:
        # Bloqueo exponencial
        block_time = 2 ** (attempts - max_attempts)
        r.setex(f"block:{ip}", block_time, "1")
        return False, f"Bloqueado {block_time}s"
    return True, "OK"
```

## Account Takeover Protection

| Señal | Acción |
|---|---|
| Login desde país nuevo | Pedir MFA adicional |
| Cambio de contraseña | Cerrar otras sesiones |
| Intento de credential stuffing | Bloquear tras fallos masivos |
| Imposible posible viaje (impossible travel) | Reautenticación |
| Dispositivo desconocido | Email de alerta + MFA |
| Veloceidad de intentos (automatización) | CAPTCHA / rate limit |

## Session Fixation

Ataque donde el atacante fija un session ID conocido en el navegador de la víctima antes de que esta se loguee. Tras el login, si el servidor no rota el session ID, el atacante usa ese ID para acceder.

```
1. Atacante obtiene un session ID válido (sid=ABC)
2. Atacante engaña a la víctima para que use la URL con sid=ABC
   (o inyecta cookie via subdominio)
3. Víctima se loguea con sid=ABC
4. Si el servidor NO rota el ID → atacante usa sid=ABC → sesión de víctima
```

**Defensa**: tras un login exitoso, **siempre generar un nuevo session ID** y destruir el anterior.

```python
def login_success(user_id, old_session_id):
    # 1. Destruir la sesión vieja
    destroy_session(old_session_id)
    # 2. Crear una sesión nueva
    new_sid = create_session(user_id)
    # 3. Devolver cookie con el nuevo session ID
    return new_sid
```

## Password Policies

Reglas para contraseñas de usuario. Evitar reglas excesivamente complejas (NIST 800-63B recomienda simplificar).

| Práctica | Recomendación | ¿Por qué |
|---|---|---|
| Longitud mínima | ≥ 8 caracteres (preferible 12) | La longitud es el factor más importante |
| Longitud máxima | ≥ 64 caracteres | No truncar contraseñas largas |
| Complejidad obligatoria | Opcional | NIST ya no exige mayúsc/minús/símbolos |
| Listas de contraseñas comunes | Bloquear top-10000 | Previene `123456`, `password` |
| Verificar contra breaches | HaveIBeenPwned API | Previene reutilización de contraseñas filtradas |
| No rotación obligatoria | Solo si hay sospecha | NIST: la rotación periódica empeora las contraseñas |
| Allow paste | Permitir pegar | Fomenta el uso de gestores de contraseñas |
| Unicode | Permitir cualquier carácter | No limitar a ASCII |

## Credential Stuffing

Ataque donde el atacante usa listas de pares email/contraseña obtenidas de **otros** brechas, sabiendo que los usuarios reutilizan contraseñas.

```
Atacante tiene 10M de pares email:password de un brecha anterior
    ↓
Recorre la lista probando login en tu sitio
    ↓
0.1%-1% de los pares funcionan (usuarios que reutilizaron)
    ↓
100,000 cuentas comprometidas sin fuerza bruta
```

**Mitigaciones**:
- Rate limiting por IP y por cuenta.
- Detectar patrones de automatización (mismo IP, muchos usuarios).
- MFA: aunque la contraseña acierte, falta el segundo factor.
- Verificar nuevas contraseñas contra bases de datos de breaches.
- Notificar al usuario logins desde dispositivos/ubicaciones nuevas.

## Security Headers

Headers HTTP que el servidor envía para reforzar la seguridad del navegador.

| Header | Qué hace | Valor recomendado |
|---|---|---|
| `Strict-Transport-Security` | Fuerza HTTPS | `max-age=31536000; includeSubDomains; preload` |
| `X-Content-Type-Options` | Evita MIME sniffing | `nosniff` |
| `X-Frame-Options` | Evita clickjacking | `DENY` o `SAMEORIGIN` |
| `Content-Security-Policy` | Restringe fuentes de contenido | `default-src 'self'` |
| `Referrer-Policy` | Controla el header Referer | `strict-origin-when-cross-origin` |
| `Permissions-Policy` | Desactiva APIs del navegador | `geolocation=(), camera=()` |

```http
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Content-Security-Policy: default-src 'self'; script-src 'self'; object-src 'none'
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: geolocation=(), camera=(), microphone=()
```

## Best Practices de Producción

```
┌─────────────────────────────────────────────────────────────────┐
│            BEST PRACTICES DE AUTENTICACIÓN (CHECKLIST)          │
├─────────────────────────────────────────────────────────────────┤
│ ✓ Hashing: bcrypt (cost 12+), scrypt o argon2                  │
│ ✓ Salt único por contraseña                                    │
│ ✓ Rate limiting en login (por IP + cuenta)                     │
│ ✓ MFA disponible (TOTP preferible)                            │
│ ✓ Cookies: HttpOnly + Secure + SameSite=Lax                    │
│ ✓ HTTPS obligatorio (HSTS)                                     │
│ ✓ Security headers configurados                                │
│ ✓ Secretos en variables de entorno, no en código               │
│ ✓ Logging de eventos de seguridad (login, MFA, cambios)        │
│ ✓ Rotación de session ID tras login (anti session fixation)    │
│ ✓ No exponer información en mensajes de error                 │
│ ✓ Verificar contraseñas contra breaches (HIBP)                 │
│ ✓ Invalidación de sesión en logout                             │
└─────────────────────────────────────────────────────────────────┘
```

## Tabla de referencia: tipos de ataque y defensa

| Ataque | Qué es | Defensa principal |
|---|---|---|
| **Brute force** | Probar todas las contraseñas | Rate limiting + lockout |
| **Credential stuffing** | Reutilizar pares de otros brechas | MFA + verificación de breaches |
| **Phishing** | Página falsa para robar credenciales | WebAuthn (phishing-resistant) |
| **Session fixation** | Fijar session ID antes del login | Rotar session ID tras login |
| **Session hijacking** | Robar session ID | HttpOnly + Secure + HTTPS |
| **XSS** | Inyectar script en la página | CSP + HttpOnly cookies |
| **CSRF** | Petición forzada desde otro sitio | SameSite + CSRF token |
| **SIM swap** | Robar número de teléfono | Prefierir TOTP sobre SMS |
| **Token theft** | Robar access token | Corta expiración + rotation |
| **Rainbow tables** | Tablas de hashes precomputadas | Salt único por contraseña |

## Conceptos clave

- **MFA**: combinar factores independientes (sabes/tienes/eres) reduce drásticamente el riesgo de takeover.
- **TOTP**: código de 6 dígitos basado en un secret compartido y la hora. Genera un nuevo código cada 30s. Es el MFA más usado y recomendado.
- **WebAuthn/FIDO2**: autenticación phishing-resistant basada en claves públicas. El servidor guarda solo claves públicas.
- **SSO**: autenticarse una vez para acceder a múltiples apps. SAML (empresarial, XML) y OIDC (moderna, JSON/JWT).
- **Passwordless**: eliminar contraseñas mejora UX y seguridad. Magic links (email) y WebAuthn (biometría/llave).
- **Rate limiting**: la primera línea de defensa contra automatización. Combinar por IP y por cuenta.
- **Session fixation**: rotar siempre el session ID tras login exitoso.

## Errores comunes

- **Usar SMS como MFA principal**: vulnerable a SIM swap. Preferir TOTP o WebAuthn.
- **No rotar el session ID tras login**: deja la puerta abierta a session fixation.
- **Rate limiting solo por IP**: los atacantes rotan IPs con proxies. Combinar con límite por cuenta.
- **Bloquear la cuenta tras pocos fallos**: crea un vector DoS (un atacante bloquea cuentas de usuarios legítimos). Usar CAPTCHA o backoff progresivo.
- **No verificar contraseñas contra breaches**: permite credential stuffing con contraseñas reutilizadas.
- **Contraseñas con reglas demasiado complejas**: los usuarios las anotan o las simplifican. Priorizar longitud.
- **Olvidar security headers**: sin HSTS, un MITM puede degradar a HTTP. Sin CSP, un XSS puede robar tokens.
- **Registrar intentos de login fallidos en texto plano**: logs con credenciales son un riesgo. Sanitizar logs.
