# Guía 01 — Fundamentos de REST

> Qué es REST, sus principios, recursos y URIs, métodos HTTP, representaciones, status codes y diseño de URLs RESTful.

## Objetivos

- [ ] Entender qué es REST y de dónde viene (Fielding, 2000)
- [ ] Explicar los 6 principios REST (client-server, stateless, cacheable, uniform interface, layered, code-on-demand)
- [ ] Identificar recursos, colecciones e items a partir de URIs
- [ ] Asociar cada método HTTP (GET/POST/PUT/PATCH/DELETE) con su semántica REST
- [ ] Diferenciar representaciones (JSON, XML) y cabeceras de Content-Type
- [ ] Elegir el status code correcto para cada situación
- [ ] Diseñar URLs RESTful legibles y predecibles

## Qué es REST

**REST** (Representational State Transfer) es un estilo arquitectónico para sistemas distribuidos hipertextuales, descrito por Roy Fielding en el año 2000 en su tesis doctoral. No es un protocolo ni un formato: es un conjunto de **restricciones** que, al cumplirlas, producen un sistema **RESTful**.

Lo más habitual es aplicarlo sobre **HTTP**, y por eso "API REST" y "API sobre HTTP" se confunden, pero no son lo mismo: HTTP es el transporte; REST son las restricciones de diseño.

La idea central: **todo es un recurso**, identificado por una **URI**, y se manipula intercambiando **representaciones** de ese recurso mediante **métodos HTTP** estándar.

```
Cliente  --HTTP-->  Recurso (URI)  --representación-->  Cliente
GET /users/123   →   User   →   { "id": 123, "name": "Ana" }
```

### REST vs RPC vs SOAP vs GraphQL

| Estilo | Cómo se invoca | Ejemplo |
|---|---|---|
| RPC | Llamada a "función" por URL | `POST /getUser?id=123` |
| SOAP | XML sobre HTTP con envelope | `POST /` + XML body |
| REST | Verbo sobre recurso | `GET /users/123` |
| GraphQL | Un endpoint, query en body | `POST /graphql` + `{ user(id:123){name} }` |

En REST, **el verbo HTTP expresa la intención** y **la URL identifica el recurso**. No inventes verbos en la URL (`/getUser`, `/createOrder`): eso es RPC.

## Principios REST (las 6 restricciones)

### 1. Client-Server (cliente-servidor)

Separación estricta de responsabilidades entre el **cliente** (UI, consume la API) y el **servidor** (lógica + datos). El cliente no sabe cómo se almacena nada; el servidor no sabe cómo se pinta la UI. Esto permite evolucionar cada parte por separado y mejorar la portabilidad.

### 2. Stateless (sin estado)

Cada petición debe contener **toda** la información necesaria para entenderse; el servidor **no guarda estado de sesión** entre peticiones. No hay "sesión abierta": cada request es autónoma. El estado de la aplicación vive en el cliente (o en la BD), no en la memoria del servidor.

- ✅ Correcto: enviar `Authorization: Bearer <token>` en cada petición.
- ❌ Incorrecto: confiar en una cookie de sesión que el servidor mantiene en memoria.

**Ventaja:** cualquier servidor puede atender cualquier petición → escalado horizontal trivial. **Desventaja:** payloads un poco más grandes (se repite el contexto).

### 3. Cacheable (cacheable)

Las respuestas deben indicar explícitamente si son **cacheables** o no, y por cuánto tiempo. Se logra con cabeceras: `Cache-Control`, `ETag`, `Last-Modified`, `Expires`. Cachear reduce latencia, carga del servidor y tráfico de red.

```
HTTP/1.1 200 OK
Cache-Control: public, max-age=60
ETag: "abc123"
```

### 4. Uniform Interface (interfaz uniforme)

Es la restricción central de REST. Se descompone en 4 subrestricciones:

1. **Identificación de recursos**: cada recurso tiene una URI (`/users/123`).
2. **Manipulación de recursos vía representaciones**: el cliente manipula el recurso enviando una representación (JSON, XML); no opera directamente sobre el dato interno.
3. **Mensajes auto-descriptivos**: cada mensaje dice qué es (`Content-Type`), cómo cachearlo y qué hacer (`GET`/`POST`...).
4. **HATEOAS** (Hypermedia As The Engine Of Application State): las respuestas incluyen **links** a acciones relacionadas, como en la web. El cliente "navega" la API. (Ver guía 02.)

### 5. Layered System (sistema por capas)

El cliente no sabe si habla con el servidor final o con un intermediario (proxy, load balancer, CDN, API gateway). Se pueden meter capas (caché, seguridad, balanceo) sin tocar clientes.

### 6. Code-on-demand (opcional)

El servidor puede enviar código ejecutable (JS, applets) que el cliente ejecuta. Es **opcional**: una API puede ser RESTful sin él. Poco frecuente en APIs REST modernas.

## Recursos y URIs

Un **recurso** es cualquier cosa con identidad que la API expone: un usuario, un producto, un pedido, una colección de pedidos. Se identifica con una **URI**.

- **Colección**: `GET /users` → lista de usuarios.
- **Item / recurso individual**: `GET /users/123` → un usuario concreto.
- **Sub-recurso**: `GET /users/123/orders` → pedidos de ese usuario.
- **Item de sub-recurso**: `GET /users/123/orders/456`.

| Tipo | URI | Significado |
|---|---|---|
| Colección | `/users` | Todos los usuarios |
| Item | `/users/123` | Un usuario |
| Sub-colección | `/users/123/orders` | Pedidos del usuario 123 |
| Sub-item | `/users/123/orders/456` | Un pedido concreto del usuario 123 |
| Colección filtrada | `/users?role=admin` | Usuarios admins |

Reglas prácticas:

- Los **sustantivos** identifican recursos; los **verbos** NO van en la URL (`/getUser` está mal).
- Usa **plurales** para colecciones: `/users`, no `/user`.
- Usa **kebab-case** si necesitas más de una palabra: `/order-items`, no `/orderItems` ni `/order_items`.
- Los **identificadores** van al final del path del recurso: `/users/{id}`.
- No expongas acciones como verbos: en vez de `POST /users/123/activate`, considera `PATCH /users/123` con `{"status":"active"}` o, si es muy transaccional, un sub-recurso `POST /users/123/activations`.

## Colecciones e items

La misma URI cambia de significado según el método:

| Método | `/users` (colección) | `/users/123` (item) |
|---|---|---|
| GET | Lista de usuarios (200) | Un usuario (200) o 404 |
| POST | Crea un usuario (201) | 405 (no se crea por id) |
| PUT | Reemplaza la colección entera (raro) | Reemplaza el usuario (200/204) |
| PATCH | No habitual | Modifica campos del usuario (200/204) |
| DELETE | Borra toda la colección (peligroso) | Borra el usuario (200/204) |

**POST a una colección** crea un nuevo item y el servidor le asigna la URI: `POST /users` → `201 Created` + `Location: /users/124`.

## Métodos HTTP en REST

| Método | Semántica | Safe | Idempotente | Cacheable | Body |
|---|---|---|---|---|---|
| GET | Leer | ✅ | ✅ | ✅ | No (recomendado) |
| POST | Crear / no idempotente | ❌ | ❌ | Solo si cabeceras | ✅ |
| PUT | Reemplazar recurso completo | ❌ | ✅ | ❌ | ✅ |
| PATCH | Modificar parcialmente | ❌ | ❌* | ❌ | ✅ |
| DELETE | Borrar | ❌ | ✅ | ❌ | Opcional |
| HEAD | Como GET sin body | ✅ | ✅ | ✅ | No |
| OPTIONS | Métodos permitidos | ✅ | ✅ | ❌ | No |

> *PATCH no es idempotente por definición (RFC 5789), aunque puede serlo según el formato del patch. PUT sí es idempotente.

**Safe**: no modifica estado del servidor (solo lectura). **Idempotente**: repetir N veces equivale a 1 vez.

### Ejemplos por método

**GET** — leer
```http
GET /users/123 HTTP/1.1
Accept: application/json
```
```http
HTTP/1.1 200 OK
Content-Type: application/json
{ "id": 123, "name": "Ana", "email": "ana@mail.com" }
```

**POST** — crear en una colección
```http
POST /users HTTP/1.1
Content-Type: application/json
{ "name": "Luis", "email": "luis@mail.com" }
```
```http
HTTP/1.1 201 Created
Location: /users/124
Content-Type: application/json
{ "id": 124, "name": "Luis", "email": "luis@mail.com" }
```

**PUT** — reemplazar todo
```http
PUT /users/124 HTTP/1.1
Content-Type: application/json
{ "name": "Luis García", "email": "luis.g@mail.com", "active": true }
```
```http
HTTP/1.1 200 OK
{ "id": 124, "name": "Luis García", "email": "luis.g@mail.com", "active": true }
```

**PATCH** — modificar parcial
```http
PATCH /users/124 HTTP/1.1
Content-Type: application/json
{ "email": "nuevo@mail.com" }
```
```http
HTTP/1.1 200 OK
{ "id": 124, "name": "Luis García", "email": "nuevo@mail.com", "active": true }
```

**DELETE** — borrar
```http
DELETE /users/124 HTTP/1.1
```
```http
HTTP/1.1 204 No Content
```

## Representaciones (JSON, XML)

Un recurso es una entidad abstracta; su **representación** es cómo se materializa en un mensaje. El mismo recurso puede tener varias representaciones:

```
GET /users/123 HTTP/1.1
Accept: application/json   →  { "id":123, "name":"Ana" }
Accept: application/xml    →  <user><id>123</id><name>Ana</name></user>
Accept: text/csv           →  id,name\n123,Ana
```

El cliente negocia la representación con la cabecera `Accept`; el servidor responde con `Content-Type`. Si no puede, devuelve `406 Not Acceptable`.

**JSON** es el formato dominante hoy:
- Ligero, legible, nativo en JS.
- Tipos: objeto, array, string, número, boolean, `null`.
- No admite comentarios, ni fechas nativas (se usan strings ISO 8601).
- `Content-Type: application/json` (no `text/json`).

**XML** sigue en sistemas legacy/SOAP: más verboso, con esquemas XSD, namespaces y atributos.

Ejemplo de una representación JSON rica:
```json
{
  "id": 123,
  "name": "Ana García",
  "email": "ana@mail.com",
  "createdAt": "2024-01-15T10:30:00Z",
  "roles": ["admin", "editor"],
  "address": {
    "city": "Madrid",
    "zip": "28001"
  }
}
```

Conviene: usar **camelCase** o **snake_case** de forma consistente (elige uno), fechas en **ISO 8601 UTC** (`Z`), y `null` para ausencia explícita vs omitir el campo.

## Status codes en REST

Los códigos de estado HTTP informan del resultado. Se agrupan en 5 familias:

| Familia | Significado | Ejemplos |
|---|---|---|
| 1xx | Informativo | 100 Continue |
| 2xx | Éxito | 200, 201, 204 |
| 3xx | Redirección | 301, 304 |
| 4xx | Error del cliente | 400, 401, 403, 404, 409, 422 |
| 5xx | Error del servidor | 500, 502, 503 |

Tabla de los más usados en REST:

| Código | Nombre | Cuándo |
|---|---|---|
| 200 | OK | GET/PUT/PATCH/DELETE con cuerpo |
| 201 | Created | POST que crea un recurso |
| 202 | Accepted | Petición aceptada, procesamiento asíncrono |
| 204 | No Content | Éxito sin cuerpo (DELETE, PUT opcional) |
| 301 | Moved Permanently | Recurso movido de URI |
| 304 | Not Modified | Cache hit condicional (ETag/If-None-Match) |
| 400 | Bad Request | Payload mal formado o inválido |
| 401 | Unauthorized | No autenticado / credenciales inválidas |
| 403 | Forbidden | Autenticado pero sin permiso |
| 404 | Not Found | Recurso no existe |
| 405 | Method Not Allowed | Método no permitido sobre la URI |
| 406 | Not Acceptable | No se puede servir el `Accept` pedido |
| 409 | Conflict | Conflicto (duplicado, versión) |
| 410 | Gone | Recurso borrado permanentemente |
| 422 | Unprocessable Entity | Sintaxis OK, semántica inválida |
| 429 | Too Many Requests | Rate limit superado |
| 500 | Internal Server Error | Fallo del servidor |
| 501 | Not Implemented | Método no soportado |
| 502 | Bad Gateway | Respuesta inválida de un upstream |
| 503 | Service Unavailable | Caído / en mantenimiento |

**Reglas de oro**:
- No devuelvas 200 con un error dentro. Usa 4xx/5xx.
- 401 = "no sé quién eres"; 403 = "sé quién eres, pero no puedes".
- 404 para recurso que no existe; 410 si sabes que existió y se borró.
- 400 para errores de sintaxis; 422 para errores de validación semántica.
- 429 cuando el cliente hace demasiadas peticiones.

## Diseño de URLs RESTful

Buenas prácticas para URIs legibles, predecibles y mantenibles:

1. **Sustantivos en plural**: `/users`, `/orders`, `/products`.
2. **kebab-case** para varias palabras: `/order-items`, `/shipping-addresses`.
3. **Versionado en la ruta o cabecera**: `/v1/users` o `Accept: application/vnd.api+json;version=1`.
4. **IDs al final del path del recurso**: `/users/{id}`.
5. **Sub-recursos anidados con moderación** (máx. 2 niveles): `/users/123/orders` bien; `/users/123/orders/456/items/9/...` ya es demasiado.
6. **Query params para filtrar, ordenar, paginar, seleccionar campos**: `/users?role=admin&sort=-createdAt&limit=20`.
7. **No acciones como verbos**: en vez de `/users/123/activate` usa `PATCH /users/123` con `{"status":"active"}`. Si la acción es transaccional, un sub-recurso `POST /users/123/activations` o `/operations` es aceptable.
8. **Minúsculas**: las URIs son case-sensitive por definición; convención minúsculas.
9. **Sin barra final** (convención): `/users` mejor que `/users/`.
10. **Estable y predecible**: una vez publicada una URI, no la cambies sin redirección/versionado.

Ejemplo de una API coherente:

```
GET    /v1/users                      → lista
POST   /v1/users                      → crear
GET    /v1/users/{id}                  → leer uno
PUT    /v1/users/{id}                  → reemplazar
PATCH  /v1/users/{id}                  → actualizar parcial
DELETE /v1/users/{id}                  → borrar
GET    /v1/users/{id}/orders           → pedidos del usuario
GET    /v1/orders/{id}                 → leer un pedido
```

### Anti-patrones frecuentes

- ❌ `GET /getUserList` (verbo en URL, estilo RPC).
- ❌ `POST /createUser` (igual).
- ❌ `/api/v1/getAllUsersByType?type=2` (mezcla verbo + query rara).
- ❌ `/user/123` (singular para colección).
- ❌ `/Users/123` (mayúsculas).
- ❌ Devolver 200 con `{"error": "not found"}` en vez de 404.

## Conceptos clave

- **REST**: estilo arquitectónico basado en restricciones (no un protocolo).
- **Recurso**: entidad con identidad (URI) y una o varias representaciones.
- **Stateless**: cada petición es autónoma, sin sesión de servidor.
- **Uniform interface**: identificación por URI, manipulación por representación, mensajes auto-descriptivos y HATEOAS.
- **Safe / Idempotente**: propiedades de los métodos HTTP.
- **Representación**: JSON/XML/CSV del mismo recurso, negociada por `Accept`.
- **Status code**: lenguaje para comunicar el resultado de la petición.
- **Colección vs item**: `/users` vs `/users/123`; el método cambia el significado.

## Errores comunes

- **Usar verbos en la URL** (`/getUser`) en vez de sustantivos + métodos HTTP.
- **Devolver 200 siempre**, incluso en errores. Los códigos 4xx/5xx existen por algo.
- **Confundir 401 y 403**: 401 es "no autenticado", 403 es "sin permiso".
- **Confundir 400 y 422**: 400 sintaxis, 422 validación semántica.
- **No respetar idempotencia**: repetir un PUT no debería crear duplicados; si lo hace, no es RESTful.
- **Cargar estado en el servidor** (sesiones) y creer que es RESTful: rompe stateless.
- **Mezclar singular/plural** o mayúsculas/minúsculas en la misma API.
- **Anidar sub-recursos en exceso** (`/a/b/c/d/e/f`) generando URLs frágiles.
- **Olvidar `Location` en un 201**: el cliente no sabe dónde quedó el recurso creado.
- **Pasar datos sensibles en la URL** (query o path): las URLs se loguean.
