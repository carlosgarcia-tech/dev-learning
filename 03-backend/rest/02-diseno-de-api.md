# Guía 02 — Diseño de API

> Modelado de recursos, naming, relaciones, sub-recursos, paginación, filtrado, orden, versionado, content negotiation y HATEOAS.

## Objetivos

- [ ] Modelar recursos a partir de un dominio de negocio
- [ ] Aplicar naming conventions consistentes (plurales, kebab-case)
- [ ] Decidir entre relaciones anidadas y referencias por id
- [ ] Implementar paginación (offset, cursor) y filtrado/orden por query params
- [ ] Versionar una API (path, header) sin romper clientes
- [ ] Negociar la representación con `Accept` / `Content-Type`
- [ ] Entender y aplicar HATEOAS con links hypermedia

## Modelado de recursos

Diseñar una API REST empieza por identificar los **recursos** del dominio. Un recurso es cualquier cosa que el cliente necesita leer, crear, modificar o borrar y que tiene identidad propia.

Pasos:
1. **Identifica sustantivos del dominio**: Usuario, Producto, Pedido, Categoría, Carrito, Factura.
2. **Separa agregados**: ¿qué es un recurso raíz y qué es un sub-recurso? Un `Pedido` tiene `Items`, pero un `Item` solo vive dentro de un pedido.
3. **Define atributos y relaciones**: qué campos expone cada recurso y a qué otros recursos apunta.
4. **Mapea a URIs**: cada recurso raíz tendrá su colección `/recurso`; los sub-recursos, su ruta anidada.

Ejemplo — e-commerce:

| Recurso | URI raíz | Sub-recursos |
|---|---|---|
| Productos | `/products` | `/products/{id}/reviews` |
| Categorías | `/categories` | — |
| Usuarios | `/users` | `/users/{id}/addresses`, `/users/{id}/orders` |
| Pedidos | `/orders` | `/orders/{id}/items` |
| Carrito | `/carts` | `/carts/{id}/items` |

No expongas como recurso todo lo que existe en la BD: modela para los **casos de uso** del cliente. Un `OrderItem` puede ser recurso si se gestiona individualmente, o solo un campo anidado si no.

### Errores de modelado

- Modelar como recurso lo que es una **acción transaccional** (un "checkout" se modela como `POST /carts/{id}/checkout` o `POST /orders` desde un carrito, no como un recurso `Checkout` con CRUD).
- **Sobre-anidar**: `/users/123/orders/456/items/9` es frágil; casi siempre el `Item` se accede por `/orders/456/items/9`.
- **Exponer IDs internos de BD** si son sensibles (usa UUIDs o slugs públicos).

## Naming conventions

| Convención | Regla | Ejemplo |
|---|---|---|
| Colecciones | Plural, minúsculas | `/users` |
| Recurso individual | `{id}` al final | `/users/123` |
| Varios términos | kebab-case | `/order-items` |
| Campos JSON | snake_case o camelCase (uno solo) | `created_at` o `createdAt` |
| Query params | snake_case o camelCase (uno solo) | `?page=1&sort=-name` |
| Booleanos | como bool, no string | `"active": true` |
| Fechas | ISO 8601 UTC | `"2024-01-15T10:30:00Z"` |
| Enums | strings en minúsculas | `"status": "pending"` |

**Por qué plurales**: una colección representa potencialmente muchos items; plural es coherente con `GET /users` (devuelve una lista). El id distingue el item.

**Por qué kebab-case**: en URLs, `camelCase` y `snake_case` son ambiguos para algunos proxies/regex; kebab-case (`-`) es el estándar de facto en URLs HTTP.

## Relaciones: anidadas vs referencias

Cuando un recurso se relaciona con otro, hay dos enfoques:

### 1. Referencia por id (desnormalización ligera)

El recurso incluye el id del relacionado; el cliente hace una segunda petición para el detalle.

```json
{
  "id": "ord_456",
  "userId": "usr_123",
  "total": 99.90,
  "status": "paid"
}
```
- El cliente pide `GET /users/usr_123` para el nombre del usuario.
- Ventaja: respuestas ligeras, recursos independientes.
- Inconveniente: N+1 peticiones del cliente.

### 2. Recurso embebido / expandido

El recurso incluye el objeto relacionado completo (o parcial). Se puede controlar con `?expand=user` o `?include=user`.

```json
{
  "id": "ord_456",
  "user": { "id": "usr_123", "name": "Ana" },
  "total": 99.90,
  "status": "paid"
}
```
- Ventaja: menos peticiones, mejor para clientes móviles.
- Inconveniente: respuestas más pesadas; riesgo de exponer datos de más.

**Regla**: referencia por defecto, embebido bajo demanda con `?expand=`.

### Sub-recursos anidados

Cuando una relación es de **pertenencia fuerte** (el sub-recurso no existe sin el padre), se anida:

```
GET /users/123/orders           → pedidos del usuario 123
GET /orders/456/items           → items de un pedido
GET /carts/9/items/3             → un item concreto del carrito
```

Cuándo anidar y cuándo no:

| Situación | Mejor opción |
|---|---|
| El sub-recurso solo existe dentro del padre | Anidar |
| El sub-recurso tiene identidad propia global | Referencia plana (`/orders/456`) |
| El cliente siempre llega desde el padre | Anidar |
| Acceso flexible desde varios orígenes | Plano con filtros (`/orders?userId=123`) |
| Anidamiento > 2 niveles | Aplanar: usa `/orders/456/items` en vez de `/users/123/orders/456/items` |

Ejemplo混合 (común): el pedido se accede plano (`/orders/456`) porque tiene identidad propia, pero sus items solo se acceden anidados (`/orders/456/items`) porque no tienen sentido fuera del pedido.

## Paginación

Las colecciones grandes deben paginar. Hay dos estrategias principales:

### 1. Offset / limit (clásica)

```
GET /users?limit=20&offset=40    → página 3 de 20 elementos
```

Respuesta:
```json
{
  "data": [ { "id": 41 }, { "id": 42 } ],
  "pagination": {
    "limit": 20,
    "offset": 40,
    "total": 312,
    "next": "/users?limit=20&offset=60"
  }
}
```

- Ventaja: simple, permite saltar a una página.
- Inconveniente: ** OFFSET es O(N)** en SQL (recorre y descarta), y sufre "saltos" si se insertan datos mientras se pagina.

### 2. Cursor (keyset)

```
GET /users?limit=20&cursor=eyJpZCI6NDF9
```

Respuesta:
```json
{
  "data": [ ... ],
  "pagination": {
    "limit": 20,
    "nextCursor": "eyJpZCI6NjF9",
    "hasMore": true
  }
}
```

- El cursor codifica la posición (típicamente el último id o timestamp visto).
- Ventaja: **O(1)** en BD (`WHERE id > last_id LIMIT 20`), estable ante inserciones.
- Inconveniente: no se puede saltar a una página arbitraria; solo "siguiente/anterior".

### Cuál usar

| Caso | Recomendado |
|---|---|
| Listados admin con "ir a página N" | Offset |
| Feeds infinitos, APIs de datos grandes | Cursor |
| Datos ordenados por tiempo | Cursor (timestamp) |
| Necesitas `total` exacto | Offset |

Convenio de nombres común: `limit` + `offset`, o `page` + `perPage` (page = offset/limit + 1). `cursor` para cursor. Metadatos en `pagination` o `meta`.

**No devuelvas arrays "pelones"**: envuélvelos en un objeto `{ "data": [...], "meta": {...} }` para poder añadir metadatos sin romper clientes.

## Filtrado y orden

### Filtrado

Los filtros van como query params:

```
GET /users?role=admin&active=true
GET /products?category=electronics&price_min=10&price_max=100
GET /orders?status=pending,paid        → varios valores (OR o IN)
```

Convenciones:
- Igualdad directa: `?status=active`.
- Rangos: `?price_min=10&price_max=100` o `?price[gte]=10&price[lte]=100` (estilo JSON:API/Filicidade).
- Múltiples valores: `?status=active,pending` o `?status=active&status=pending`.
- Búsqueda libre: `?q=teclado` o `?search=teclado`.
- Fechas: `?created_after=2024-01-01&created_before=2024-02-01`.

Para filtros complejos tipo `WHERE (a=1 OR b=2) AND c=3`, mejor un endpoint de búsqueda `POST /products/search` con un body JSON, o un lenguaje como RSQL/GraphQL.

### Orden (`sort`)

```
GET /users?sort=name             → asc por name
GET /users?sort=-name            → desc por name
GET /users?sort=lastName,firstName   → multi-campo
```

Convención: prefijo `-` para descendente, campos separados por coma. Algunas APIs usan `?sort=name:asc,age:desc`.

| Sintaxis | Significado |
|---|---|
| `?sort=name` | Ascendente por `name` |
| `?sort=-name` | Descendente por `name` |
| `?sort=name,age` | Asc `name`, luego asc `age` |
| `?sort=-created_at` | Más recientes primero |

Permite solo campos indexados/seguros; si no, validación estricta para evitar inyecciones en el `ORDER BY`.

## Versionado de API

Las APIs cambian. El versionado permite evolucionar sin romper clientes existentes.

### 1. Versionado en la ruta (más común)

```
GET /v1/users
GET /v2/users
```

- Ventaja: muy visible, cacheable, fácil de enrutar en el gateway.
- Inconveniente: "ensucia" la URL; el número de versión es parte del path.

### 2. Versionado por cabecera `Accept`

```
GET /users
Accept: application/vnd.myapi.v2+json
```

o

```
Accept: application/json; version=2
```

- Ventaja: URIs limpias, múltiples versiones del mismo recurso.
- Inconveniente: menos visible, más difícil de testear a mano, mala caché por URL.

### 3. Cabecera custom

```
GET /users
Api-Version: 2
```

- Simple, pero no estándar y mala para caching.

### Cuándo subir de versión

- Cambios **breaking**: eliminar campo, cambiar tipo, cambiar semántica, añadir campo obligatorio.
- Cambios **no breaking** (añadir campo opcional, nuevo endpoint, nuevo valor de enum) NO requieren nueva versión; usa *forward compatibility*: el cliente ignora lo que no conoce.

Tabla de compatibilidad:

| Cambio | ¿Breaking? |
|---|---|
| Añadir campo opcional en respuesta | No |
| Eliminar un campo de la respuesta | Sí |
| Cambiar tipo de un campo | Sí |
| Añadir nuevo endpoint | No |
| Cambiar URL de un recurso | Sí |
| Añadir valor a un enum | No (si el cliente lo tolera) |
| Hacer obligatorio un campo antes opcional | Sí |

## Content negotiation

Negociación de contenido: cliente y servidor acuerdan el formato de la representación.

- El cliente declara qué acepta: `Accept: application/json`.
- El servidor responde con `Content-Type: application/json`.

```
GET /users/123
Accept: application/json
```
```http
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
```

Si el cliente pide un formato no soportado:
```http
HTTP/1.1 406 Not Acceptable
```

Variantes comunes:
- `application/json` — JSON normal.
- `application/xml` — XML.
- `application/vnd.api+json` — JSON:API spec.
- `application/vnd.myapi.v2+json` — versionado por media type.
- `text/csv` — exportaciones.
- `application/problem+json` — errores (RFC 7807).

Negociación de idioma con `Accept-Language`:
```
GET /products/1
Accept-Language: es-ES
```

## HATEOAS

**HATEOAS** = Hypermedia As The Engine Of Application State. Es la parte de la interfaz uniforme que hace que la API sea "navegable" como la web: las respuestas incluyen **links** a las acciones posibles, y el cliente las sigue en vez de construir URLs a mano.

Respuesta sin HATEOAS:
```json
{ "id": 123, "status": "pending" }
```

Respuesta con HATEOAS (estilo HAL):
```json
{
  "id": 123,
  "status": "pending",
  "_links": {
    "self": { "href": "/orders/123" },
    "cancel": { "href": "/orders/123/cancel", "method": "POST" },
    "pay": { "href": "/orders/123/payments", "method": "POST" }
  },
  "_embedded": {
    "customer": { "id": 456, "name": "Ana" }
  }
}
```

Beneficios:
- **Acoplamiento bajo**: el cliente no conoce las URLs de antemano, las descubre.
- **Estado dinámico**: si un pedido ya está pagado, el link `pay` desaparece; el cliente no intenta pagar dos veces.
- **Evolución**: cambiar URLs internamente no rompe clientes que siguen links.

Estilos comunes de HATEOAS:

| Estilo | Cómo |
|---|---|
| HAL | `_links` y `_embedded` |
| JSON:API | `relationships` con `links` |
| Siren | `actions`, `entities` |
| Collection+JSON | `links`, `queries` |
| Custom | `links: [...]` |

Colección con links de navegación y paginación:
```json
{
  "data": [ { "id": 1, "_links": { "self": { "href": "/users/1" } } } ],
  "_links": {
    "self": { "href": "/users?limit=20&offset=0" },
    "next": { "href": "/users?limit=20&offset=20" }
  }
}
```

En la práctica, HATEOAS completo es raro; muchas APIs "REST" solo son CRUD sobre HTTP. Pero incluir al menos `self`, `next`/`prev` y los links de transiciones de estado mejora mucho la usabilidad.

## Conceptos clave

- **Modelado de recursos**: identificar sustantivos del dominio y mapear a URIs.
- **Naming**: plurales, kebab-case, consistencia camel/snake en JSON.
- **Referencia vs embebido**: id por defecto, `?expand=` para embebido bajo demanda.
- **Sub-recursos**: anidar cuando hay pertenencia fuerte; aplanar si >2 niveles.
- **Paginación offset vs cursor**: offset simple pero O(N); cursor estable y O(1).
- **Filtrado/orden**: query params; `sort=-name` para desc.
- **Versionado**: path (`/v1`) visible y cacheable; `Accept` para URIs limpias.
- **Content negotiation**: `Accept`/`Content-Type` acuerdan la representación.
- **HATEOAS**: links hypermedia que hacen la API navegable y desacoplada.

## Errores comunes

- **Modelar acciones como recursos CRUD** (`/checkouts` con GET/PUT) en vez de un `POST` que dispara la transición.
- **Anidar en exceso** generando URLs frágiles de 5+ segmentos.
- **Devolver un array pelón** en colecciones: impide añadir metadatos sin romper clientes.
- **Mezclar camelCase y snake_case** en la misma API.
- **Paginación offset en tablas enormes**: se vuelve lenta; usar cursor.
- **No incluir `next`/`hasMore`** en paginación: el cliente no sabe si seguir.
- **Filtros sin validación**: permitir `?sort=` arbitrario abre inyección en SQL `ORDER BY`.
- **Cambiar campos sin versionar**: romper clientes en silencio.
- **URLs limpias vía `Accept` sin documentar** el media type: nadie lo descubre.
- **Olvidar HATEOAS por completo**: la API funciona pero el cliente acopla todas las URLs.
