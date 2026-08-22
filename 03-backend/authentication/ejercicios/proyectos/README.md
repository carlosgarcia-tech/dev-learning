# Proyecto Final — Sistema Completo de Autenticación

> Proyecto integrador que combina todos los conceptos del tema Authentication: registro, login con JWT, refresh tokens con rotation, MFA con TOTP, OAuth con Google simulado, rate limiting, password reset con email, roles y permisos.

## Contexto

Vas a construir el sistema de autenticación de una aplicación llamada **FiltroPro**, una app de gestión de fotos. El sistema debe ser seguro, escalable y seguir las best practices de producción.

No necesitas levantar un servidor real: el proyecto se valida con **archivos JSON** que representan el estado y los flujos del sistema. Cada módulo produce archivos JSON que el `test.sh` valida.

## Requisitos del sistema

El sistema de autenticación de FiltroPro debe implementar:

| Módulo | Funcionalidad |
|---|---|
| **Registro** | Email + contraseña, validación, hashing bcrypt, verificación de email |
| **Login con JWT** | Access token (15 min) + refresh token (7 días) |
| **Refresh token rotation** | Rotación en cada uso, detección de reuso |
| **MFA con TOTP** | Setup TOTP, verificación en login sensible |
| **OAuth con Google (simulado)** | Authorization code flow + PKCE |
| **Rate limiting** | 5 intentos/IP, backoff exponencial |
| **Password reset** | Reset por email con token de un solo uso |
| **Roles y permisos** | Roles (user, admin) + permisos granulares |

## Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                    SISTEMA DE AUTENTICACIÓN                  │
├──────────────┬──────────────┬──────────────┬───────────────┤
│   Registro   │   Login JWT  │   MFA TOTP   │   OAuth Google │
│              │              │              │   (simulado)   │
├──────────────┼──────────────┼──────────────┼───────────────┤
│   Refresh    │   Password   │   Rate       │   Roles y      │
│   Rotation   │   Reset      │   Limiting   │   Permisos     │
└──────────────┴──────────────┴──────────────┴───────────────┘
```

## Estructura de archivos

```
proyectos/
├── README.md              ← Este archivo
├── config.json            ← Configuración del sistema
├── db.json                ← Base de datos simulada (usuarios)
├── test.sh                ← Validación completa del proyecto
├── modulos/
│   ├── 01-registro.json          ← Resultado del módulo registro
│   ├── 02-login-jwt.json         ← Resultado del módulo login JWT
│   ├── 03-refresh-rotation.json  ← Resultado del módulo refresh rotation
│   ├── 04-mfa-totp.json          ← Resultado del módulo MFA TOTP
│   ├── 05-oauth-google.json      ← Resultado del módulo OAuth Google
│   ├── 06-rate-limiting.json     ← Resultado del módulo rate limiting
│   ├── 07-password-reset.json    ← Resultado del módulo password reset
│   └── 08-roles-permisos.json    ← Resultado del módulo roles y permisos
└── starter/
    ├── auth_config.py            ← Configuración base (Python)
    └── jwt_utils.py              ← Utilidades JWT (Python)
```

## Fases del proyecto

### Fase 1: Registro de usuarios

Implementa el registro con:

- Validación de email (formato + único)
- Política de contraseñas (mínimo 8 caracteres)
- Hashing bcrypt (cost 12)
- Generación de user_id
- Token de verificación de email

Completa `modulos/01-registro.json` con el resultado de registrar 2 usuarios:
1. `alice@example.com` con contraseña `Secr3tP@ss` (válido)
2. `alice@example.com` duplicado (debe fallar con 409)

### Fase 2: Login con JWT

Implementa el login que emite:

- Access token JWT (HS256, TTL=900s=15min)
- Refresh token JWT (HS256, TTL=604800s=7d)
- Claims: `sub`, `email`, `role`, `type`, `iat`, `exp`

Completa `modulos/02-login-jwt.json` con los tokens emitidos para `alice@example.com`.

### Fase 3: Refresh token rotation

Implementa la rotación:

- Canje del refresh token → nuevo access + nuevo refresh
- Invalidación del refresh token anterior
- Detección de reuso → invalidación de toda la familia

Completa `modulos/03-refresh-rotation.json` con 3 rotaciones + 1 intento de reuso.

### Fase 4: MFA con TOTP

Implementa:

- Generación de secret TOTP (base32)
- URI otpauth:// para QR
- Verificación de código TOTP (ventana ±30s)

Completa `modulos/04-mfa-totp.json` con el secret, el código para un timestamp fijo y la verificación.

### Fase 5: OAuth con Google (simulado)

Implementa el flujo completo:

- Authorization code flow + PKCE
- Token exchange
- UserInfo

Completa `modulos/05-oauth-google.json` con la configuración del proveedor y el flujo.

### Fase 6: Rate limiting

Implementa:

- Rate limiting por IP (5 intentos / 15 min)
- Backoff exponencial tras 5 fallos

Completa `modulos/06-rate-limiting.json` con 8 intentos simulados.

### Fase 7: Password reset

Implementa:

- Solicitud de reset → token de un solo uso (TTL=15min)
- Email con reset link
- Canje del token → nueva contraseña
- Invalidación del token tras uso

Completa `modulos/07-password-reset.json` con el flujo completo.

### Fase 8: Roles y permisos

Implementa:

- Roles: `user`, `admin`
- Permisos: `users:read`, `users:write`, `users:delete`, `photos:read`, `photos:write`
- Middleware de autorización (check permission)

Completa `modulos/08-roles-permisos.json` con la matriz de permisos por rol y checks de autorización.

## Criterios de aceptación

- [ ] Los 8 módulos están completos en `modulos/`
- [ ] `config.json` tiene la configuración del sistema (secret, endpoints, TTLs)
- [ ] `db.json` tiene al menos 2 usuarios registrados
- [ ] Los JWT generados tienen firma HMAC-SHA256 válida
- [ ] El refresh token rotation detecta el reuso
- [ ] El código TOTP es correcto para el timestamp dado
- [ ] El flujo OAuth tiene PKCE con `code_challenge` válido
- [ ] El rate limiting aplica backoff exponencial
- [ ] El password reset usa tokens de un solo uso
- [ ] Los roles y permisos están correctamente definidos
- [ ] `bash test.sh` pasa todas las validaciones

## Cómo ejecutar

```bash
# Completar todos los módulos en modulos/
# Ejecutar el test final
bash test.sh
```

## Notas técnicas

- **Secret JWT**: `filtropro-secret-key-2024`
- **Algoritmo JWT**: HS256 (HMAC-SHA256)
- **Access token TTL**: 900s (15 min)
- **Refresh token TTL**: 604800s (7 días)
- **TOTP**: HMAC-SHA1, 6 dígitos, ventana 30s
- **bcrypt cost**: 12
- **Rate limit**: 5 intentos/IP/15min, backoff 2^n

## Best practices aplicadas

```
✓ Contraseñas hasheadas con bcrypt (cost 12)
✓ Salt único por contraseña
✓ Access token corto (15 min)
✓ Refresh token con rotation
✓ MFA con TOTP
✓ OAuth con PKCE
✓ Rate limiting con backoff exponencial
✓ Password reset con token de un solo uso
✓ Roles y permisos granulares
✓ Mensajes de error genéricos (anti enumeración)
✓ HTTPS obligatorio (configurado)
✓ Cookies HttpOnly + Secure + SameSite
```
