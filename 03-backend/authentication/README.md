# Authentication

> Guía de estudio + ejercicios por niveles. Autenticación y autorización de 0 a experto: fundamentos de identidad, sesiones y cookies, JWT, OAuth 2.0 / OIDC, MFA y seguridad de producción.

## Guías

| Guía | Qué cubre |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Autenticación vs autorización, identidad, credenciales, factores de autenticación (algo que sabes, tienes, eres), sesiones, tokens, hashing de contraseñas (bcrypt, scrypt, argon2), salt, por qué NO guardar contraseñas en texto plano, flujo básico de login (registro, login, verificación) |
| [02 — Sesiones y Cookies](02-sesiones-y-cookies.md) | Sesiones server-side (session ID en cookie, almacenamiento en memoria/Redis/DB), cookies (HttpOnly, Secure, SameSite, Path, Domain), ciclo de vida, expiración y renovación, CSRF (tokens CSRF, SameSite), logout e invalidación, sesiones distribuidas (sticky sessions, Redis shared store) |
| [03 — JWT y Tokens](03-jwt-y-tokens.md) | JSON Web Tokens (header, payload, signature), base64url, HMAC vs RSA, flujo de JWT (login emite token, cliente envía Authorization Bearer), verificación de JWT (firma, expiración, claims), refresh tokens, token rotation, access token corto vs refresh token largo, blacklisting, JWT vs sesiones (pros y contras) |
| [04 — OAuth y OIDC](04-oauth-y-oidc.md) | OAuth 2.0 (roles, grant types: authorization code, client credentials, password, refresh token, device code), PKCE, flow completo (redirect, authorization code, token), OpenID Connect (ID token, userinfo), scopes y consent, proveedores (Google, GitHub, Auth0), implicit flow y por qué está deprecado |
| [05 — MFA y Seguridad](05-mfa-y-seguridad.md) | Multi-Factor Authentication (TOTP, SMS OTP, WebAuthn/FIDO2), SSO (SAML, CAS), passwordless (magic links, biometric), rate limiting y brute force protection, account takeover protection, session fixation, password policies, credential stuffing, security headers, best practices de producción |

## Ejercicios

Ver [ejercicios/](ejercicios/)

| Nivel | Qué cubre | Estado |
|---|---|---|
| [nivel-01-fundamentos](ejercicios/nivel-01-fundamentos/) | Hashing bcrypt, verificar contraseña, generar salt, flujo de registro, flujo de login, comparación timing-safe | ⬜ |
| [nivel-02-basico](ejercicios/nivel-02-basico/) | Session ID, cookie Set-Cookie, expiración de sesión, CSRF token, logout invalidar, renovación de sesión | ⬜ |
| [nivel-03-intermedio](ejercicios/nivel-03-intermedio/) | Crear JWT, verificar JWT, refresh token, token rotation, blacklisting, claims y roles en JWT | ⬜ |
| [nivel-04-avanzado](ejercicios/nivel-04-avanzado/) | OAuth authorization code flow, PKCE, OIDC ID token, scopes, proveedor simulado, OAuth refresh token | ⬜ |
| [nivel-05-experto](ejercicios/nivel-05-experto/) | TOTP MFA, SSO SAML, passwordless magic link, rate limiting brute force, WebAuthn, session fixation | ⬜ |
| [proyectos](ejercicios/proyectos/) | Sistema completo de autenticación | ⬜ |
