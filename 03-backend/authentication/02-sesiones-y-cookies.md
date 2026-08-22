# 02 — Sesiones y Cookies

> Sesiones server-side, cookies y sus atributos de seguridad, ciclo de vida, CSRF, logout, invalidación y sesiones distribuidas. Cómo mantener a un usuario autenticado entre peticiones sin exponerle a ataques.

## Objetivos

- [ ] Entender cómo funciona una sesión server-side con session ID en cookie
- [ ] Conocer los atributos de cookie: HttpOnly, Secure, SameSite, Path, Domain
- [ ] Diferenciar almacenamiento de sesión en memoria, Redis y base de datos
- [ ] Explicar el ciclo de vida de una sesión: creación, renovación, expiración
- [ ] Entender CSRF y cómo defenderse (tokens CSRF, SameSite)
- [ ] Implementar logout e invalidación real de sesiones
- [ ] Entender sesiones distribuidas: sticky sessions y Redis shared store

## Cómo funciona una sesión

Una sesión es **estado en el servidor** que identifica a un usuario a lo largo de múltiples peticiones HTTP (que son stateless por defecto).

```
Petición 1 (Login)
Cliente ───POST /login {email,pass}──► Servidor
                                      │
                              ┌───────▼────────┐
                              │ Crear sesión   │
                              │ id=sess_abc123 │
                              │ user_id=42     │
                              │ expires=...    │
                              └───────┬────────┘
                                      │
Cliente ◄───Set-Cookie: sid=sess_abc123; HttpOnly; Secure─── Servidor

Petición 2 (Autenticada)
Cliente ───Cookie: sid=sess_abc123──► Servidor
                                      │
                              ┌───────▼────────┐
                              │ Buscar sesión  │
                              │ sess_abc123 →  │
                              │   user_id=42   │
                              └────────────────┘
```

El **session ID** es un string aleatorio y opaco: no contiene información del usuario, solo es una clave para buscar la sesión en el almacén del servidor.

```python
import secrets

# Session ID seguro: al menos 128 bits de entropía
session_id = secrets.token_urlsafe(32)  # ~43 chars, 256 bits
```

## Almacenamiento de sesiones

| Almacenamiento | Velocidad | Persistencia | Escalado | Cuándo usarlo |
|---|---|---|---|---|
| **Memoria del proceso** | ⚡ Muy rápida | ❌ Se pierde al reiniciar | ❌ No comparte entre instancias | Desarrollo, single-instance |
| **Redis** | ⚡ Muy rápida | ✅ Configurable (persistencia) | ✅ Compartido entre instancias | Producción recomendada |
| **Base de datos** | ⚠️ Media | ✅ Sí | ✅ Sí | Si ya tienes DB y poco tráfico |

### En memoria (no para producción)

```python
# ❌ Solo desarrollo: se pierde al reiniciar y no escala
sessions = {}

def create_session(user_id):
    sid = secrets.token_urlsafe(32)
    sessions[sid] = {
        "user_id": user_id,
        "created_at": time.time(),
        "expires_at": time.time() + 3600,
    }
    return sid

def get_session(sid):
    session = sessions.get(sid)
    if session and session["expires_at"] > time.time():
        return session
    return None
```

### Redis (recomendado para producción)

```python
import redis
import json
import secrets
import time

r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)

def create_session(user_id, ttl=3600):
    sid = secrets.token_urlsafe(32)
    session = {
        "user_id": user_id,
        "created_at": int(time.time()),
    }
    # Redis expira automáticamente la clave tras ttl segundos
    r.setex(f"session:{sid}", ttl, json.dumps(session))
    return sid

def get_session(sid):
    data = r.get(f"session:{sid}")
    if data:
        return json.loads(data)
    return None

def destroy_session(sid):
    r.delete(f"session:{sid}")
```

## Cookies

Una cookie es un par clave-valor que el navegador envía en cada petición al dominio que la emitió. Es el mecanismo estándar para transportar el session ID.

### Atributos de seguridad de cookies

| Atributo | Qué hace | Por qué importa |
|---|---|---|
| `HttpOnly` | Impide acceso vía JavaScript (`document.cookie`) | Previene robo por XSS |
| `Secure` | Solo se envía sobre HTTPS | Previene interceptación en HTTP |
| `SameSite=Strict` | No se envía en peticiones cross-site (ni navegación) | Previene CSRF fuerte |
| `SameSite=Lax` | Se envía en navegación top-level GET cross-site | Balance CSRF + UX (por defecto en navegadores modernos) |
| `SameSite=None` | Se envía siempre (requiere `Secure`) | Necesario para third-party cookies |
| `Path=/` | Ámbito de ruta | Restringe a qué rutas se envía |
| `Domain=ejemplo.com` | Ámbito de dominio | Incluye subdominios |
| `Max-Age=3600` | Expira tras N segundos | Controla duración |
| `Expires=...` | Expira en fecha absoluta | Alternativa a Max-Age |

### Cookie correcta para un session ID

```http
Set-Cookie: sid=sess_a8b9c0d1e2f3; HttpOnly; Secure; SameSite=Lax; Path=/; Max-Age=3600
```

```python
from http.cookies import SimpleCookie

def set_session_cookie(response_headers, session_id, max_age=3600):
    cookie = SimpleCookie()
    cookie["sid"] = session_id
    cookie["sid"]["httponly"] = True
    cookie["sid"]["secure"] = True
    cookie["sid"]["samesite"] = "Lax"
    cookie["sid"]["path"] = "/"
    cookie["sid"]["max-age"] = max_age
    # Serializa a formato Set-Cookie
    response_headers["Set-Cookie"] = cookie.output(header="").strip()
```

## Ciclo de vida de una sesión

```
CREACIÓN                  USO                      EXPIRACIÓN
   │                        │                          │
   ▼                        ▼                          ▼
┌────────┐              ┌────────┐               ┌──────────┐
│ Login  │──sid cookie──│ Request│──busca sid──► │ TTL > 0? │
│ crea   │              │ con sid│   en store     └────┬─────┘
│ sesión │              └────────┘                     │
└────────┘                              ┌────────────────┴───┐
                                        │                   │
                                       SÍ                  NO
                                        │                   │
                                        ▼                   ▼
                                   Procesar          Rechazar (401)
                                   petición          + borrar cookie
```

### Expiración y renovación (sliding session)

- **Absolute timeout**: la sesión expira a una hora fija desde la creación, sin importar la actividad.
- **Idle timeout (sliding)**: cada petición renueva el TTL. Si el usuario está inactivo, expira.

```python
# Sliding session: renovar TTL en cada petición
def touch_session(sid, ttl=3600):
    if r.exists(f"session:{sid}"):
        r.expire(f"session:{sid}", ttl)  # Reinicia el contador
        return True
    return False
```

## CSRF (Cross-Site Request Forgery)

CSRF engaña al navegador de un usuario autenticado para que envíe una petición al sitio víctima. Como la cookie de sesión se envía automáticamente, el servidor la procesa como si fuera legítima.

```
1. Usuario logueado en banco.com (cookie sid activa)
2. Usuario visita sitio-malicioso.com
3. sitio-malicioso.com envía:
   <form action="https://banco.com/transferir" method="POST">
     <input name="cuenta" value="atacante">
     <input name="monto" value="10000">
   </form>
4. El navegador envía la cookie de banco.com → la transferencia se ejecuta
```

### Defensa contra CSRF

**1. Token CSRF (synchronizer token pattern)**

El servidor genera un token aleatorio, lo guarda en la sesión y lo incluye en el formulario HTML. En cada POST se compara.

```python
import secrets

# Generar token CSRF vinculado a la sesión
def generate_csrf_token(session_id):
    token = secrets.token_urlsafe(32)
    r.setex(f"csrf:{session_id}", 3600, token)
    return token

# Verificar token en POST/PUT/DELETE
def verify_csrf_token(session_id, token):
    stored = r.get(f"csrf:{session_id}")
    if stored and secrets.compare_digest(stored, token):
        return True
    return False
```

```html
<!-- En el formulario -->
<form method="POST" action="/transferir">
  <input type="hidden" name="csrf_token" value="{{ csrf_token }}">
  <input name="cuenta">
  <button>Transferir</button>
</form>
```

**2. SameSite=Lax o Strict**

El atributo `SameSite` es la defensa más simple. Con `Lax`, la cookie no se envía en peticiones POST cross-site, bloqueando el CSRF clásico.

| Valor | GET top-level cross-site | POST cross-site | Recomendación |
|---|---|---|---|
| `Strict` | ❌ No envía | ❌ No envía | Máxima seguridad, peor UX |
| `Lax` | ✅ Envía | ❌ No envía | Balance recomendado |
| `None` | ✅ Envía | ✅ Envía | Solo con `Secure`, third-party |

## Logout e invalidación

```python
def logout(session_id):
    # 1. Borrar la sesión del almacén
    r.delete(f"session:{session_id}")
    r.delete(f"csrf:{session_id}")
    # 2. El servidor responde con Set-Cookie expirada
    # Set-Cookie: sid=; HttpOnly; Secure; Max-Age=0
```

> Invalidar = borrar la sesión del servidor. **No basta con borrar la cookie del cliente**: un atacante que robó el session ID antes del logout podría seguir usándolo si el servidor no lo invalidó.

## Sesiones distribuidas

Cuando tienes múltiples instancias del servidor detrás de un balanceador:

### Opción A: Sticky sessions

El balanceador dirige siempre al usuario a la misma instancia (por IP o cookie de routing). Problema: si esa instancia cae, se pierde la sesión.

### Opción B: Redis shared store (recomendado)

Todas las instancias leen/escriben sesiones en el mismo Redis. Cualquier instancia puede atender a cualquier usuario.

```
              Balanceador
            ┌──────────────┐
            │  round-robin  │
            └──┬─────┬─────┬─┘
               │     │     │
          ┌────▼┐ ┌──▼──┐ ┌▼────┐
          │App 1│ │App 2│ │App 3│
          └────┬┘ └──┬──┘ └┬────┘
               │     │     │
               └─────┼─────┘
                     │
                ┌────▼────┐
                │  Redis  │ ← sesiones compartidas
                └─────────┘
```

## Tabla de referencia: comparativa de almacenamiento

| Criterio | Memoria | Redis | Base de datos |
|---|---|---|---|
| Latencia | ~0 ms | ~1 ms | ~10 ms |
| Persistencia | ❌ | ✅ Configurable | ✅ |
| Compartido entre instancias | ❌ | ✅ | ✅ |
| Escalado | ❌ | ✅ Horizontal | ⚠️ Limitado por DB |
| Complejidad | Baja | Media | Alta |
| Invalidación inmediata | ✅ | ✅ | ✅ |
| Apto para producción | ❌ | ✅ | ⚠️ Solo tráfico bajo |

## Conceptos clave

- **Sesión server-side**: el estado vive en el servidor; el cliente solo guarda un identificador opaco (session ID). La cookie transporta ese ID.
- **Session ID aleatorio**: debe tener al menos 128 bits de entropía y generarse con un CSPRNG (`secrets.token_urlsafe`). Nunca secuencial ni predecible.
- **HttpOnly + Secure + SameSite**: la triada de atributos que protege la cookie contra XSS, interceptación y CSRF.
- **Sliding session**: renovar el TTL en cada petición mejora UX sin sacrificar seguridad, mientras el usuario esté activo.
- **Invalidación real**: logout debe borrar la sesión del store del servidor, no solo la cookie del navegador.
- **Redis shared store**: la solución estándar para sesiones distribuidas en producción. Permite que cualquier instancia atienda a cualquier usuario.

## Errores comunes

- **Usar sessionStorage/localStorage para el session ID**: son accesibles por JavaScript → vulnerables a XSS. Usar cookies HttpOnly.
- **Olvidar `HttpOnly`**: un XSS puede leer `document.cookie` y robar la sesión.
- **Olvidar `Secure`**: la cookie se envía por HTTP plano en redes inseguras.
- **Session ID predecible o secuencial**: permite session hijacking. Usar siempre un CSPRNG.
- **No renovar el TTL (idle timeout)**: una sesión robada es válida hasta el absolute timeout.
- **Solo borrar la cookie en logout**: el session ID sigue vivo en el servidor. Un atacante que lo robó sigue dentro.
- **Usar `SameSite=None` sin `Secure`**: los navegadores modernos rechazan la cookie. `None` requiere `Secure`.
- **No proteger endpoints POST con CSRF token**: SameSite=Lax no cubre todos los casos (mismo sitio, subdominios).
