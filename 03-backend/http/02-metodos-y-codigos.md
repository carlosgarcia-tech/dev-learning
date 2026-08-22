# 02 — Métodos y Códigos de Estado

> Semántica detallada de los métodos HTTP (safe/unsafe, idempotencia), códigos de estado por familia, headers de petición y respuesta, y la diferencia clave entre PUT y PATCH.

## Objetivos

- [ ] Distinguir métodos **safe** vs **unsafe** y **idempotentes** vs no idempotentes.
- [ ] Explicar la semántica exacta de GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS.
- [ ] Conocer los códigos de estado más usados y cuándo aplicar cada uno.
- [ ] Dominar los headers de petición más relevantes.
- [ ] Dominar los headers de respuesta más relevantes.
- [ ] Explicar la diferencia entre PUT y PATCH con ejemplos.

## Safe, unsafe, idempotente

Dos propiedades ortogonales definen el comportamiento de un método:

### Safe (seguro)

Un método es **safe** si no altera el estado del servidor (solo lectura). El cliente puede llamarlo sin preocuparse de modificar datos. **GET, HEAD, OPTIONS** son safe.

> No se trata de si el servidor registra logs o métricas, sino de si cambia los **recursos** que expone.

### Idempotente

Un método es **idempotente** si repetir la **misma petición** N veces produce el mismo resultado que una sola. Importante para reintentos seguros (redes inestables). **GET, PUT, DELETE, HEAD, OPTIONS** son idempotentes. **POST no lo es** (cada POST crea un recurso nuevo).

| Método | Safe | Idempotente | Cacheable |
|---|---|---|---|
| GET | ✅ | ✅ | ✅ |
| HEAD | ✅ | ✅ | ✅ |
| OPTIONS | ✅ | ✅ | ❌ |
| POST | ❌ | ❌ | ❌ (salvo `Cache-Control` explícito) |
| PUT | ❌ | ✅ | ❌ |
| PATCH | ❌ | ✅ (definido así en RFC 7396) | ❌ |
| DELETE | ❌ | ✅ | ❌ |

## Métodos en detalle

### GET

- Lee/obtiene un recurso o colección.
- **No debe** llevar body (aunque algunos servidores lo toleran, rompe caches y proxies).
- Es **safe** e **idempotente**: repetirlo no cambia nada.
- Debe ser **cacheable**: la respuesta puede guardarse.
- Los parámetros van en el **query string**.

```
GET /v1/products?limit=10&page=2 HTTP/1.1
Host: api.tienda.com
Accept: application/json
```

```
HTTP/1.1 200 OK
Content-Type: application/json

[{"id":1,"name":"Teclado"}, {"id":2,"name":"Ratón"}]
```

### POST

- Crea un recurso subordinado a la colección.
- **No idempotente**: repetir el mismo POST crea recursos duplicados.
- El body porta los datos del nuevo recurso.
- Respuesta típica: **201 Created** + `Location` apuntando al recurso creado.
- También se usa para acciones que no encajan en el CRUD (ej. `/login`, `/checkout`).

```
POST /v1/products HTTP/1.1
Host: api.tienda.com
Content-Type: application/json

{"name":"Monitor","price":199}
```

```
HTTP/1.1 201 Created
Location: /v1/products/42
Content-Type: application/json

{"id":42,"name":"Monitor","price":199}
```

### PUT

- **Reemplaza por completo** el recurso destino con la representación enviada.
- **Idempotente**: el mismo PUT repetido deja el recurso idéntico.
- Si el recurso no existe, puede **crearlo** (upsert).
- Campos omitidos en el body se **borran** (porque reemplaza el recurso entero).

```
PUT /v1/products/42 HTTP/1.1
Host: api.tienda.com
Content-Type: application/json

{"name":"Monitor 4K","price":249,"stock":30}
```

```
HTTP/1.1 200 OK
Content-Type: application/json

{"id":42,"name":"Monitor 4K","price":249,"stock":30}
```

### PATCH

- **Modifica parcialmente** el recurso: solo cambia los campos enviados.
- Debería ser idempotente (RFC 7396 JSON Merge Patch lo es: aplicar el mismo patch dos veces = una vez).
- Campos omitidos se **conservan**.

```
PATCH /v1/products/42 HTTP/1.1
Host: api.tienda.com
Content-Type: application/json

{"price":229}
```

```
HTTP/1.1 200 OK
Content-Type: application/json

{"id":42,"name":"Monitor 4K","price":229,"stock":30}
```

### DELETE

- Borra el recurso.
- **Idempotente**: borrar algo ya borrado sigue dando el mismo estado final (no existe).
- Respuesta habitual: **204 No Content** (sin body) o **200 OK** con un cuerpo descriptivo.

```
DELETE /v1/products/42 HTTP/1.1
Host: api.tienda.com
```

```
HTTP/1.1 204 No Content
```

### HEAD

- Igual que GET, pero el servidor **no devuelve body** (solo headers).
- Útil para comprobar tamaño (`Content-Length`), existencia (`200` vs `404`) o `Last-Modified` sin descargar el cuerpo.
- Safe e idempotente.

```
HEAD /v1/products/42 HTTP/1.1
Host: api.tienda.com
```

```
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 78
```

### OPTIONS

- Describe las opciones de comunicación del recurso: qué métodos permite, requisitos de CORS.
- **Safe** e **idempotente**.
- La respuesta incluye `Allow` (métodos permitidos) o, en CORS, headers `Access-Control-Allow-*`.

```
OPTIONS /v1/products HTTP/1.1
Host: api.tienda.com
Origin: https://app.tienda.com
```

```
HTTP/1.1 204 No Content
Allow: GET, POST, HEAD, OPTIONS
Access-Control-Allow-Origin: https://app.tienda.com
```

## PUT vs PATCH (la diferencia clave)

| Aspecto | PUT | PATCH |
|---|---|---|
| Semántica | Reemplazar el recurso entero | Modificar parcialmente |
| Campos omitidos | Se **borran** | Se **conservan** |
| Idempotente | Sí | Sí (en JSON Merge Patch) |
| Body completo | Requerido (representación completa) | Solo los cambios |
| Crea si no existe | Puede (upsert) | Depende de la implementación |

Ejemplo que ilustra la diferencia. Recurso actual:

```json
{"id":42,"name":"Monitor 4K","price":249,"stock":30}
```

Quiero cambiar solo el precio.

**PUT (mal)** — borraría `stock` porque no está:

```json
PUT /v1/products/42
{"name":"Monitor 4K","price":229}
→ {"id":42,"name":"Monitor 4K","price":229}  // stock desapareció
```

**PATCH (correcto para cambio parcial)**:

```json
PATCH /v1/products/42
{"price":229}
→ {"id":42,"name":"Monitor 4K","price":229,"stock":30}
```

> **Regla:** si envías la representación completa → PUT. Si envías solo los campos cambiados → PATCH.

## Códigos de estado en detalle

### 2xx — Éxito

| Código | Nombre | Cuándo |
|---|---|---|
| 200 | OK | Petición exitosa con body |
| 201 | Created | Recurso creado. Acompañar de `Location` |
| 202 | Accepted | Petición aceptada para procesar después (async) |
| 204 | No Content | Éxito sin body (DELETE, PUT sin body de respuesta) |
| 206 | Partial Content | Respuesta parcial (rangos, descargas resumibles) |

### 3xx — Redirección

| Código | Nombre | Cuándo |
|---|---|---|
| 301 | Moved Permanently | Recurso movido para siempre. El cliente cachea el destino |
| 302 | Found | Redirección temporal. **No cachea.** Método puede cambiar a GET |
| 303 | See Other | Redirige con GET (tras POST, patrón PRG) |
| 304 | Not Modified | Caché válida; el cliente usa su copia. No body |
| 307 | Temporary Redirect | Redirección temporal **preservando el método** |
| 308 | Permanent Redirect | Redirección permanente **preservando el método** |

> **301/302 vs 307/308:** los antiguos (301/302) permiten que el browser cambie POST→GET al seguir la redirección; los nuevos (307/308) garantizan que el método se conserva. Prefiere 307/308 si dependes del método.

### 4xx — Error del cliente

| Código | Nombre | Cuándo |
|---|---|---|
| 400 | Bad Request | Sintaxis/validación incorrecta |
| 401 | Unauthorized | No autenticado (falta o inválida la credencial) |
| 403 | Forbidden | Autenticado pero sin permiso |
| 404 | Not Found | Recurso no existe |
| 405 | Method Not Allowed | Recurso existe pero no soporta ese método. Devolver `Allow` |
| 409 | Conflict | Conflicto de estado (ej. duplicado, versión concurrente) |
| 410 | Gone | Recurso borrado permanentemente (vs 404 que es “no sé”) |
| 422 | Unprocessable Entity | Sintaxis OK pero semántica inválida (validación de negocio) |
| 429 | Too Many Requests | Rate limit exceeded |

### 5xx — Error del servidor

| Código | Nombre | Cuándo |
|---|---|---|
| 500 | Internal Server Error | Error genérico del servidor |
| 501 | Not Implemented | El servidor no soporta el método/funcionalidad |
| 502 | Bad Gateway | Un proxy/gateway recibió respuesta inválida del upstream |
| 503 | Service Unavailable | Servidor caído o en mantenimiento |
| 504 | Gateway Timeout | El upstream no respondió a tiempo |

## Headers de petición

| Header | Qué hace | Ejemplo |
|---|---|---|
| `Accept` | Tipos MIME que el cliente acepta | `Accept: application/json` |
| `Accept-Language` | Idiomas preferidos | `Accept-Language: es-ES, es;q=0.9, en;q=0.8` |
| `Accept-Encoding` | Compresiones soportadas | `Accept-Encoding: gzip, deflate, br` |
| `Authorization` | Credenciales | `Authorization: Bearer eyJhb...` |
| `Cache-Control` | Directivas de caché del cliente | `Cache-Control: no-cache` |
| `Content-Type` | Tipo del body | `Content-Type: application/json` |
| `Content-Length` | Bytes del body | `Content-Length: 46` |
| `User-Agent` | Identifica al cliente | `User-Agent: curl/8.0` |
| `Host` | Dominio (obligatorio en 1.1) | `Host: api.tienda.com` |
| `If-None-Match` | ETag del caché del cliente | `If-None-Match: "abc123"` |
| `If-Modified-Since` | Fecha del caché del cliente | `If-Modified-Since: Wed, 21 Oct 2025 07:28:00 GMT` |

### Content negotiation con `Accept`

El cliente declara qué quiere y el servidor responde en ese formato (o con `406 Not Acceptable`).

```http
GET /products HTTP/1.1
Accept: application/json
Accept-Language: es-ES
Accept-Encoding: gzip
```

```http
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Language: es-ES
Content-Encoding: gzip
```

## Headers de respuesta

| Header | Qué hace | Ejemplo |
|---|---|---|
| `Location` | URI del recurso creado o destino de redirección | `Location: /v1/products/42` |
| `Cache-Control` | Directivas de caché | `Cache-Control: public, max-age=3600` |
| `ETag` | Hash/versión del recurso | `ETag: "v1.2"` |
| `Last-Modified` | Fecha de última modificación | `Last-Modified: Wed, 21 Oct 2025 07:28:00 GMT` |
| `Vary` | Headers que afectan a la caché | `Vary: Accept, Accept-Language` |
| `Allow` | Métodos permitidos (para 405) | `Allow: GET, POST, HEAD` |
| `Content-Type` | Tipo del body de respuesta | `Content-Type: application/json` |
| `Retry-After` | Segundos/fecha para reintentar (429/503) | `Retry-After: 120` |

### `Location` en redirecciones y creación

- **201 Created** → `Location` apunta al recurso nuevo.
- **3xx** → `Location` es la URL a la que saltar.

```http
HTTP/1.1 201 Created
Location: /v1/products/42
```

### `Allow` con 405

```http
DELETE /v1/products HTTP/1.1
Host: api.tienda.com
```

```http
HTTP/1.1 405 Method Not Allowed
Allow: GET, POST
```

## Conceptos clave

- **Safe = solo lectura; idempotente = reintentable sin efectos secundarios acumulativos.**
- **POST crea (no idempotente); PUT reemplaza (idempotente); PATCH modifica parcial.**
- **DELETE es idempotente:** borrar lo ya borrado deja el mismo estado final.
- **PUT reemplaza el recurso entero; PATCH solo los campos enviados.** En PUT, los campos omitidos se borran.
- **El código de estado comunica el resultado** de forma estándar; no inventes tus propios códigos.
- **401 ≠ 403:** 401 es “no autenticado”, 403 es “autenticado sin permiso”.
- **422 vs 400:** 400 = sintaxis mal; 422 = sintaxis bien pero semántica inválida (validación de negocio).
- **307/308 preservan el método; 301/302 pueden cambiar POST→GET.**
- **Content negotiation** se hace con `Accept`/`Accept-Language`/`Accept-Encoding`.

## Errores comunes

- **Usar PUT para actualizaciones parciales.** Si solo envías el precio, PUT borraría el resto de campos. Usa PATCH.
- **Devolver 200 en una creación.** Lo correcto es 201 Created con `Location`.
- **Devolver 404 en lugar de 401/403.** No ocultes permisos con 404: si el recurso existe pero no tienes acceso, es 403.
- **Mezclar 401 y 403.** 401 = falta auth; 403 = hay auth pero no permiso.
- **Olvidar `Allow` en 405.** El cliente no puede saber qué métodos son válidos sin ese header.
- **Tratar 301 como temporal.** El cliente cachea la redirección; si luego cambias, los clientes siguen cacheando la vieja. Para temporales usa 302/307.
- **Usar 500 para errores del cliente.** Si el cliente envió datos inválidos es 4xx, no 5xx.
- **Devolver 204 con body.** 204 significa “sin contenido”; incluir body es una contradicción.
- **No respetar la idempotencia de DELETE.** Un DELETE que falla a mitad puede reintentarse sin riesgo.
- **Pensar que PATCH siempre es idempotente.** Depende del formato del patch (JSON Patch vs JSON Merge Patch).

## Siguiente

Continúa con [03 — Headers, Cookies y CORS](03-headers-cookies-y-cors.md) para profundizar en headers, cookies, CORS y caché HTTP.
