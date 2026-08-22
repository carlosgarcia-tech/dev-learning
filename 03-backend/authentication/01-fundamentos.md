# 01 — Fundamentos de Autenticación

> Identidad, credenciales, factores de autenticación, hashing de contraseñas y el flujo básico de registro y login. La base sobre la que se construye todo lo demás.

## Objetivos

- [ ] Entender la diferencia entre autenticación (AuthN) y autorización (AuthZ)
- [ ] Conocer los tres factores de autenticación y cuándo aplicarlos
- [ ] Explicar por qué NO se guardan contraseñas en texto plano
- [ ] Comprender qué es un salt y por qué es indispensable
- [ ] Comparar bcrypt, scrypt y argon2 con criterios técnicos
- [ ] Diferenciar sesiones (stateful) de tokens (stateless)
- [ ] Trazar el flujo completo de registro y login

## Autenticación vs Autorización

| Concepto | Pregunta que responde | Ejemplo |
|---|---|---|
| **Autenticación (AuthN)** | ¿Quién eres? | Usuario introduce email + contraseña → el servidor verifica que es alice@example.com |
| **Autorización (AuthZ)** | ¿Qué puedes hacer? | Alice tiene rol `admin` → puede eliminar usuarios |

```
Autenticación          Autorización
┌─────────┐            ┌─────────┐
│ ¿Quién? │  ───────►  │ ¿Puede?  │
│  eres?  │  identidad │  hacer?  │
└─────────┘            └─────────┘
   AuthN                  AuthZ
```

La autenticación establece **identidad**. La autorización establece **permisos**. La autenticación es un prerrequisito de la autorización: no puedes decidir qué puede hacer alguien sin saber primero quién es.

## Identidad y Credenciales

**Identidad**: el conjunto de atributos que distinguen a un usuario o entidad. En un sistema típico incluye:

- Identificador único (UUID, ID numérico)
- Datos de contacto (email, teléfono)
- Atributos (nombre, avatar, preferencias)

**Credenciales**: la prueba que presenta un usuario para demostrar que posee esa identidad. Las más comunes:

| Tipo de credencial | Ejemplo |
|---|---|
| Algo que **sabes** | Contraseña, PIN, respuesta de seguridad |
| Algo que **tienes** | Token físico, teléfono (SMS OTP), llave de seguridad |
| Algo que **eres** | Huella dactilar, rostro, iris (biometría) |

## Factores de Autenticación

Los tres factores clásicos de autenticación:

```
┌──────────────────────────────────────────────┐
│           FACTORES DE AUTENTICACIÓN          │
├──────────────┬──────────────┬───────────────┤
│  ALGO QUE    │  ALGO QUE    │  ALGO QUE     │
│    SABES     │    TIENES    │     ERES      │
├──────────────┼──────────────┼───────────────┤
│ Contraseña   │ App TOTP     │ Huella        │
│ PIN          │ SMS OTP     │ Rostro        │
│ Pregunta     │ Llave USB    │ Iris          │
│ secreta      │ (WebAuthn)   │ Voz           │
└──────────────┴──────────────┴───────────────┘
```

- **1FA** (un factor): solo contraseña → vulnerable a robo de credencial.
- **2FA** (dos factores): contraseña + código TOTP → el atacante necesita ambos.
- **MFA** (multi-factor): tres o más factores → máxima seguridad.

> Cuantos más factores exijas, más fuerte es la autenticación, pero peor es la experiencia de usuario. El equilibrio depende del contexto: un banco pide más factores que un blog.

## Sesiones vs Tokens

| Aspecto | Sesiones (stateful) | Tokens (stateless) |
|---|---|---|
| Estado | Servidor almacena la sesión | No hay estado en servidor |
| Almacenamiento | Memoria, Redis, DB | Token en cliente (cookie/localStorage) |
| Escalado | Reiere store compartido | Escala sin estado |
| Invalidación | Borrar sesión del servidor | Difícil (blacklist, exp corta) |
| Tamaño | Session ID corto | Token más grande (cientos de bytes) |

```
SESIÓN (Stateful)                     TOKEN (Stateless)
                                       
Cliente ──cookie──► Servidor           Cliente ──Bearer token──► Servidor
                      │                                           │
                 ┌────▼────┐                                 ┌───▼───┐
                 │ Session │                                 │Verify│
                 │  Store  │                                 │ firma│
                 │ (Redis) │                                 └───────┘
                 └─────────┘
```

## Hashing de Contraseñas

### Por qué NO guardar contraseñas en texto plano

Si guardas contraseñas en texto plano y tu base de datos se filtra:

```
-- Suposición: la base de datos se filtró
SELECT email, password FROM users;
-- email              | password
-- alice@example.com  | Secr3tP@ss
-- bob@example.com    | 12345678
```

Cualquiera con acceso a la base de datos puede ver, reutilizar y suplantar a todos los usuarios. La solución es **almacenar un hash criptográfico** de la contraseña, nunca la contraseña en sí.

### Hashing con bcrypt

```python
import bcrypt

# REGISTRO: hashear contraseña del usuario
password = b"Secr3tP@ss"
salt = bcrypt.gensalt(rounds=12)
hash = bcrypt.hashpw(password, salt)
# hash = b'$2b$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'

# LOGIN: verificar contraseña contra el hash almacenado
intentos = b"Secr3tP@ss"
if bcrypt.checkpw(intentos, hash):
    print("Acceso concedido")
else:
    print("Contraseña incorrecta")
```

### Salt: qué es y por qué es indispensable

Un **salt** es un valor aleatorio que se añade a la contraseña antes de hashearla.

```
Sin salt:                             Con salt:
hash("password123") → abc123          hash("password123" + salt_A) → x7y8z9
hash("password123") → abc123          hash("password123" + salt_B) → m4n5o6
```

Sin salt, dos usuarios con la misma contraseña producen el mismo hash. Un atacante puede usar tablas arcoíris (rainbow tables) para descifrar masivamente. Con salt, cada hash es único incluso para contraseñas idénticas.

> bcrypt genera el salt internamente y lo incluye dentro del hash resultante. No necesitas almacenar el salt por separado.

### Comparación de algoritmos

| Algoritmo | Año | Tipo | Resistencia GPU/ASIC | Memoria | Recomendación |
|---|---|---|---|---|---|
| **MD5** | 1992 | Hash rápido | ❌ Vulnerable | Baja | ❌ NUNCA para contraseñas |
| **SHA-1** | 1995 | Hash rápido | ❌ Vulnerable | Baja | ❌ No para contraseñas |
| **PBKDF2** | 2000 | Hash iterativo | ⚠️ Limitada | Baja | ⚠️ Aceptable pero no óptimo |
| **bcrypt** | 1999 | Hash adaptativo | ✅ Buena | Media | ✅ Ampliamente usado |
| **scrypt** | 2009 | Hard-memory | ✅ Excelente | Alta | ✅ Muy fuerte |
| **argon2** | 2015 | Hard-memory + paralelismo | ✅ Excelente | Configurable | ✅ Recomendado (PHC 2015) |

```python
# argon2 (recomendado para proyectos nuevos)
from argon2 import PasswordHasher

ph = PasswordHasher()
hash = ph.hash("Secr3tP@ss")
# hash = '$argon2id$v=19$m=65536,t=3,p=4$...'

ph.verify(hash, "Secr3tP@ss")  # True
```

## Flujo Básico de Registro

```
Cliente                  Servidor                    Base de datos
  │                         │                            │
  │ POST /register          │                            │
  │ {email, password}       │                            │
  ├────────────────────────►│                            │
  │                         │ 1. Validar email único      │
  │                         │ 2. Generar salt             │
  │                         │ 3. hash = bcrypt(password,  │
  │                         │       salt, rounds=12)      │
  │                         │                            │
  │                         │ INSERT INTO users           │
  │                         │ (email, password_hash)     │
  │                         ├───────────────────────────►│
  │                         │                            │
  │                         │◄─────── 201 Created ────────│
  │◄─────────────────────────│                            │
  │  201 Created            │                            │
  │  {id, email}            │                            │
```

## Flujo Básico de Login

```
Cliente                  Servidor                    Base de datos
  │                         │                            │
  │ POST /login             │                            │
  │ {email, password}       │                            │
  ├────────────────────────►│                            │
  │                         │ SELECT password_hash        │
  │                         │ FROM users WHERE email=?    │
  │                         ├───────────────────────────►│
  │                         │◄───── password_hash ───────│
  │                         │                            │
  │                         │ bcrypt.checkpw(             │
  │                         │   password, password_hash)  │
  │                         │                            │
  │                         │   ¿Coincide?                │
  │                         │   SÍ → crear sesión/token   │
  │                         │   NO → 401 Unauthorized     │
  │                         │                            │
  │  200 OK                 │                            │
  │  Set-Cookie: session=… │                            │
  │◄─────────────────────────│                            │
```

### Ejemplo de flujo completo en JSON

```json
// POST /register
{
  "email": "alice@example.com",
  "password": "Secr3tP@ss"
}

// Respuesta del servidor
{
  "id": "usr_7f3a2b",
  "email": "alice@example.com",
  "created_at": "2025-01-15T10:30:00Z"
}

// POST /login
{
  "email": "alice@example.com",
  "password": "Secr3tP@ss"
}

// Respuesta del servidor
{
  "user": {
    "id": "usr_7f3a2b",
    "email": "alice@example.com"
  },
  "session_id": "sess_a8b9c0d1e2f3",
  "expires_in": 3600
}
```

## Formato de un hash bcrypt

```
$2b$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
│  │  │ │                      │
│  │  │ │                      └── Hash (31 bytes en base64)
│  │  │ └── Salt (22 chars en base64)
│  │  └── Cost factor (2^12 = 4096 iteraciones)
│  └── Versión del algoritmo (a, b, y)
└── Prefijo de bcrypt
```

| Parte | Valor | Significado |
|---|---|---|
| Algoritmo | `$2b$` | bcrypt versión b |
| Coste | `12` | 2^12 iteraciones |
| Salt | `N9qo8uLOickgx2ZMRZoMye` | 22 caracteres base64 |
| Hash | `IjZAgcfl7p92ldGxad68LJZdL17lhWy` | 31 caracteres base64 |

## Tabla de referencia: Respuestas HTTP en autenticación

| Código | Significado | Cuándo usarlo |
|---|---|---|
| 200 OK | Login correcto | Credenciales válidas |
| 201 Created | Registro correcto | Nuevo usuario creado |
| 401 Unauthorized | No autenticado | Token ausente o inválido |
| 403 Forbidden | No autorizado | Autenticado pero sin permisos |
| 409 Conflict | Email duplicado | Registro con email existente |
| 429 Too Many Requests | Rate limit | Demasiados intentos de login |

## Conceptos clave

- **AuthN vs AuthZ**: autenticar es verificar identidad; autorizar es verificar permisos. Nunca confundirlos.
- **Hashing**: transformación unidireccional. No se puede revertir el hash a la contraseña original. Se usa para almacenar contraseñas de forma segura.
- **Salt**: valor aleatorio único por contraseña que previene rainbow tables y ataques de hashes duplicados.
- **Cost factor (rounds)**: número de iteraciones del hash. Más alto = más seguro pero más lento. bcrypt usa 2^rounds. Recomendado: 12 para bcrypt.
- **Timing attack**: un atacante mide el tiempo de respuesta para adivinar caracteres de la contraseña. Se previene con comparación de tiempo constante (`hmac.compare_digest` en Python, `bcrypt.checkpw` ya lo hace).
- **Stateful vs Stateless**: las sesiones guardan estado en el servidor; los tokens no. Cada enfoque tiene ventajas en escalabilidad e invalidación.

## Errores comunes

- **Guardar contraseñas en texto plano o cifradas reversiblemente**: si puedes desencriptar la contraseña, también puede un atacante. Solo hashes unidireccionales.
- **Usar MD5 o SHA-256 para contraseñas**: son hashes rápidos diseñados para integridad de datos, no para contraseñas. Un atacante con GPU puede probar miles de millones por segundo. Usar bcrypt/scrypt/argon2.
- **Reutilizar el mismo salt para todos los usuarios**: anula la protección contra rainbow tables. Cada contraseña debe tener su salt único.
- **Devolver información en mensajes de error**: responder "ese email no existe" vs "contraseña incorrecta" permite enumeración de usuarios. Usar un mensaje genérico: "credenciales incorrectas".
- **No validar la contraseña en el servidor**: confiar solo en validación del lado del cliente. El cliente nunca es de confianza.
- **Usar comparación de strings normal para verificar hashes**: vulnerable a timing attacks. Usar comparación de tiempo constante.
- **Olvidar el rate limiting en el endpoint de login**: permite ataques de fuerza bruta sin límite.
