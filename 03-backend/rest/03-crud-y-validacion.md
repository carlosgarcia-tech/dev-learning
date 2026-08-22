# Guía 03 — CRUD y Validación

> CRUD completo, validación de entrada, manejo de errores RESTful, idempotencia, PATCH parcial vs PUT total, soft delete vs hard delete y timestamps.

## Objetivos

- [ ] Implementar un CRUD completo sobre un recurso (Create, Read, Update, Delete)
- [ ] Validar entrada: campos requeridos, tipos, rangos, formatos
- [ ] Devolver errores RESTful coherentes con `code`, `message`, `details`
- [ ] Entender y aplicar idempotencia en PUT
- [ ] Diferenciar PATCH parcial y PUT total
- [ ] Decidir entre soft delete y hard delete
- [ ] Gestionar timestamps (`createdAt`, `updatedAt`, `deletedAt`)

## CRUD completo

CRUD = Create, Read, Update, Delete. En REST se mapea a métodos HTTP:

| Operación | Método | URI | Status |
|---|---|---|---|
| Create | POST | `/products` | 201 |
| Read (lista) | GET | `/products` | 200 |
| Read (uno) | GET | `/products/{id}` | 200 / 404 |
| Update (total) | PUT | `/products/{id}` | 200 / 204 |
| Update (parcial) | PATCH | `/products/{id}` | 200 / 204 |
| Delete | DELETE | `/products/{id}` | 204 / 200 |

### Create — POST a la colección

Petición:
```http
POST /products HTTP/1.1
Content-Type: application/json

{
  "name": "Teclado mecánico",
  "price": 89.90,
  "stock": 15,
  "category": "perifericos"
}
```

Respuesta:
```http
HTTP/1.1 201 Created
Location: /products/prod_001
Content-Type: application/json

{
  "id": "prod_001",
  "name": "Teclado mecánico",
  "price": 89.90,
  "stock": 15,
  "category": "perifericos",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

Notas:
- El **servidor** asigna el `id` y los timestamps; el cliente no debe mandarlos (o se ignoran).
- La cabecera `Location` indica la URI del nuevo recurso.
- Si el recurso ya existe (duplicado), 409 Conflict.

### Read — GET lista y GET item

Lista con paginación y metadatos:
```http
GET /products?limit=2 HTTP/1.1
```
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "data": [
    { "id": "prod_001", "name": "Teclado mecánico", "price": 89.90 },
    { "id": "prod_002", "name": "Ratón", "price": 19.90 }
  ],
  "pagination": { "limit": 2, "offset": 0, "total": 42, "next": "/products?limit=2&offset=2" }
}
```

Item por id:
```http
GET /products/prod_001 HTTP/1.1
```
```http
HTTP/1.1 200 OK
{ "id": "prod_001", "name": "Teclado mecánico", "price": 89.90 }
```

No encontrado:
```http
HTTP/1.1 404 Not Found
Content-Type: application/problem+json

{
  "type": "https://docs.api.example/errors/not-found",
  "title": "Not Found",
  "status": 404,
  "detail": "Producto prod_999 no existe"
}
```

### Update — PUT vs PATCH

**PUT** reemplaza el recurso completo. Si un campo no viene, se considera que se borra/ignora. Es idempotente: repetir la misma petición deja el recurso en el mismo estado.

```http
PUT /products/prod_001 HTTP/1.1
Content-Type: application/json

{
  "name": "Teclado mecánico RGB",
  "price": 99.90,
  "stock": 20,
  "category": "perifericos"
}
```
```http
HTTP/1.1 200 OK
{ "id": "prod_001", "name": "Teclado mecánico RGB", "price": 99.90, "stock": 20, "category": "perifericos", "updatedAt": "2024-01-15T11:00:00Z" }
```

**PATCH** modifica solo los campos enviados; el resto se conserva. No es idempotente por definición (si envías `{"stock":15}` dos veces, el resultado es el mismo, pero si envías `{"stockIncrement": 1}` no).

```http
PATCH /products/prod_001 HTTP/1.1
Content-Type: application/json

{ "price": 109.90 }
```
```http
HTTP/1.1 200 OK
{ "id": "prod_001", "name": "Teclado mecánico RGB", "price": 109.90, "stock": 20, "category": "perifericos" }
```

### Delete — DELETE

```http
DELETE /products/prod_001 HTTP/1.1
```
```http
HTTP/1.1 204 No Content
```

O con cuerpo (si devuelves el recurso borrado):
```http
HTTP/1.1 200 OK
{ "id": "prod_001", "deleted": true, "deletedAt": "2024-01-15T12:00:00Z" }
```

DELETE es idempotente: borrar un recurso ya borrado sigue dando 204 (o 404 según convención). Lo importante: repetir no causa error 5xx.

## Validación de entrada

La validación protege la integridad de los datos y da feedback claro al cliente. Se valida en **tres capas**:

1. **Sintaxis**: el JSON es válido, el `Content-Type` es correcto.
2. **Esquema**: campos requeridos, tipos, formatos.
3. **Reglas de negocio**: el email no existe ya, el stock no es negativo, etc.

Tipos de validación:

| Tipo | Ejemplo | Error típico |
|---|---|---|
| Requerido | `name` obligatorio | 422 |
| Tipo | `price` es número | 422 |
| Rango | `price >= 0`, `stock <= 10000` | 422 |
| Formato | `email` válido, `sku` regex `^[A-Z]{3}-\d+$` | 422 |
| Longitud | `name` entre 2 y 100 chars | 422 |
| Enum | `category` en `["perifericos","pantallas"]` | 422 |
| Referencia | `categoryId` existe | 422 / 409 |
| Unicidad | `email` único | 409 |

Ejemplo de payload inválido y su error:

Petición:
```http
POST /products HTTP/1.1
Content-Type: application/json

{ "name": "", "price": -5, "email_categoria": "no-existe" }
```

Respuesta:
```http
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/problem+json

{
  "type": "https://docs.api.example/errors/validation",
  "title": "Validation Failed",
  "status": 422,
  "errors": [
    { "field": "name", "code": "min_length", "message": "name debe tener al menos 2 caracteres" },
    { "field": "price", "code": "min_value", "message": "price debe ser >= 0" },
    { "field": "category", "code": "invalid_enum", "message": "category debe ser 'perifericos' o 'pantallas'" }
  ]
}
```

Reglas:
- Validar **siempre** en el servidor, aunque el cliente también valide. El cliente es no confiable.
- Devolver **todos** los errores posibles de una vez, no uno por petición.
- Usar códigos de error estables (`min_length`, `invalid_email`) para que el cliente pueda traducirlos.
- Distinguir **400** (JSON mal formado, sintaxis) de **422** (semántica inválida).

## Manejo de errores RESTful

Un buen error RESTful es **consistente, predecible y accionable**. Estructura recomendada (siguiendo RFC 7807 Problem Details):

```json
{
  "type": "https://docs.api.example/errors/validation",
  "title": "Validation Failed",
  "status": 422,
  "detail": "Uno o más campos son inválidos",
  "instance": "/products",
  "errors": [
    { "field": "price", "code": "min_value", "message": "price debe ser >= 0" }
  ]
}
```

| Campo | Significado |
|---|---|
| `type` | URI de doc del error (estable, público) |
| `title` | Resumen humano corto |
| `status` | Código HTTP (redundante pero útil) |
| `detail` | Descripción específica de esta instancia |
| `instance` | URI/trace de esta ocurrencia |
| `errors` | Lista detallada de errores de validación (extensión) |

Tabla de errores típicos:

| Situación | Status | code |
|---|---|---|
| JSON mal formado | 400 | `bad_request` |
| Falta auth | 401 | `unauthorized` |
| Sin permiso | 403 | `forbidden` |
| Recurso no existe | 404 | `not_found` |
| Método no permitido | 405 | `method_not_allowed` |
| Conflicto (duplicado) | 409 | `conflict` |
| Validación | 422 | `validation_failed` |
| Rate limit | 429 | `rate_limit_exceeded` |
| Error interno | 500 | `internal_error` |

Buenas prácticas:
- **Nunca** devuelvas 200 con un error dentro.
- Usa **Content-Type `application/problem+json`** para errores (RFC 7807).
- Incluye un **trace id** para correlacionar logs.
- No filtres stack traces ni detalles internos al cliente.
- Usa códigos estables (`code`) además del mensaje humano.

## Idempotencia en PUT

**Idempotente**: ejecutar la misma petición N veces deja el sistema en el mismo estado que ejecutarla 1 vez.

| Método | Idempotente |
|---|---|
| GET | ✅ |
| PUT | ✅ |
| DELETE | ✅ |
| POST | ❌ |
| PATCH | ❌ (depende del formato) |

PUT es idempotente porque **reemplaza** el recurso entero: `PUT /users/1 {name:"Ana"}` dos veces deja el usuario con `name:"Ana"`, sin duplicados.

POST no es idempotente: `POST /users {name:"Ana"}` dos veces crea **dos** usuarios.

### Idempotency Keys

Para hacer POST idempotente (evitar duplicados por reintentos de red), se usa una **idempotency key** que el cliente envía en una cabecera:

```http
POST /payments HTTP/1.1
Idempotency-Key: 7c8f3a2e-...
Content-Type: application/json

{ "orderId": "ord_123", "amount": 99.90 }
```

El servidor:
1. Recibe la key, la almacena con el resultado.
2. Si llega la **misma key** otra vez, devuelve el resultado cacheado en vez de procesar de nuevo.
3. Si llega la misma key con **otro body**, error 409/422 (conflicto).

Esto resuelve el problema de "el cliente reintentó porque no le llegó la respuesta, pero el servidor ya procesó el pago". Es esencial en pagos, emails, transferencias.

Implementación: almacenar `(key, request_hash, response)` con TTL (típicamente 24-48h) en Redis o BD. La key debe ser un UUID generado por el cliente.

## PATCH parcial vs PUT total

| Aspecto | PUT | PATCH |
|---|---|---|
| Semántica | Reemplazar recurso completo | Modificar campos enviados |
| Campos no enviados | Se borran / ignoran | Se conservan |
| Idempotente | Sí | No (por defecto) |
| Validación | Todos los campos requeridos | Solo los enviados |
| Uso típico | Editar un formulario completo | Toggle de un campo, quick edit |

Ejemplo: recurso actual:
```json
{ "id": 1, "name": "Ana", "email": "ana@x.com", "active": true }
```

PUT con menos campos (los otros se resetean):
```http
PUT /users/1
{ "name": "Ana García" }
```
→ `{ "id": 1, "name": "Ana García", "email": null, "active": false }` (según implementación; o 422 si `email` es requerido).

PATCH solo cambia lo enviado:
```http
PATCH /users/1
{ "email": "ana.nueva@x.com" }
```
→ `{ "id": 1, "name": "Ana", "email": "ana.nueva@x.com", "active": true }`.

**Formatos de PATCH** (RFC 6902 JSON Patch):
```json
[
  { "op": "replace", "path": "/email", "value": "nueva@x.com" },
  { "op": "remove", "path": "/active" }
]
```

O el más simple JSON Merge Patch (RFC 7396): un objeto con los campos a cambiar; `null` significa borrar.

## Soft delete vs hard delete

### Hard delete

```http
DELETE /products/prod_001
→ 204
```
El recurso se **borra físicamente** de la BD. No se puede recuperar.

- Ventaja: datos limpios, GDds, sin basura.
- Inconveniente: no se puede deshacer; rompe integridad referencial si hay FKs; pérdida de histórico.

### Soft delete

El recurso se **marca como borrado** sin eliminarlo:
```json
{ "id": "prod_001", "deletedAt": "2024-01-15T12:00:00Z", "deleted": true }
```

Las consultas por defecto excluyen los borrados (`WHERE deletedAt IS NULL`). Para verlos: `?include=deleted` o `GET /products/trash`.

- Ventaja: recuperable, auditoría, integridad referencial, no rompe reportes.
- Inconveniente: la BD crece; hay que filtrar siempre; índices deben incluir la condición.

### Cuál elegir

| Caso | Recomendado |
|---|---|
| Datos regulados (GDPR, derecho al olvido) | Hard delete (o anonimizar) |
| Pedidos, facturas, usuarios | Soft delete (auditoría) |
| Datos efímeros (caché, sesiones) | Hard delete |
| Datos con integridad referencial fuerte | Soft delete |

## Timestamps

Registra el ciclo de vida del recurso con timestamps:

| Campo | Cuándo se setea |
|---|---|
| `createdAt` | Al crear el recurso |
| `updatedAt` | En cada modificación (PUT/PATCH) |
| `deletedAt` | Al hacer soft delete |

```json
{
  "id": "prod_001",
  "name": "Teclado",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-20T09:15:00Z",
  "deletedAt": null
}
```

Reglas:
- **ISO 8601 UTC** con `Z` (`2024-01-15T10:30:00Z`).
- Seteados por el **servidor**, nunca por el cliente.
- `deletedAt: null` indica "no borrado".
- Para auditoría fina, una tabla de eventos/versiones aparte (`audit_log`).

## Conceptos clave

- **CRUD**: Create (POST), Read (GET), Update (PUT/PATCH), Delete (DELETE).
- **Validación en 3 capas**: sintaxis → esquema → negocio.
- **Error body**: `type`, `title`, `status`, `detail`, `errors`; RFC 7807.
- **Idempotencia**: PUT y DELETE sí; POST no. Se corrige con **idempotency keys**.
- **PUT total vs PATCH parcial**: PUT reemplaza, PATCH modifica.
- **Soft delete**: marcar `deletedAt`; **hard delete**: borrar físicamente.
- **Timestamps**: `createdAt`, `updatedAt`, `deletedAt` en ISO 8601 UTC.

## Errores comunes

- **Permitir que el cliente setee** `id`, `createdAt` o `updatedAt`.
- **Devolver 200 en errores** o usar un body de error distinto por endpoint.
- **Validar solo en el cliente**: el servidor es la única barrera fiable.
- **Devolver errores uno a uno** en vez de todos los fallos de validación de golpe.
- **Tratar PUT como PATCH** (no resetear campos) rompiendo la idempotencia esperada.
- **No gestionar reintentos** en POST críticos (pagos) → pagos duplicados.
- **Hacer hard delete** de pedidos/facturas y perder auditoría.
- **Olvidar `deletedAt` en filtros**: los recursos "borrados" aparecen en listados.
- **Timestamps en formato local** o sin zona horaria: bugs de timezone.
- **Reutilizar el id de un recurso borrado**: confunde y rompe caches/referencias.
