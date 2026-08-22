# Proyecto Final — Diseño y documentación de una API REST completa

> Proyecto integrador: diseñar la API REST de un **e-commerce** con OpenAPI/Swagger, autenticación JWT, rate limiting, paginación por cursor, webhooks, versionado y documentación.

- **Nivel:** Integrador (5/5)
- **Tiempo estimado:** 4-8 horas
- **Stack de ejemplo:** cualquier lenguaje (Node/Express, Python/FastAPI, Go, etc.); el entregable es el **diseño** y la **documentación**.

## Contexto

Vas a diseñar la API REST de una tienda online (**e-commerce**) que gestiona:

- **Productos**: catálogo con precio, stock, categoría y reviews.
- **Categorías**: clasificación de productos.
- **Usuarios**: clientes y admins, con roles.
- **Carrito**: carrito de compra por usuario, con items.
- **Pedidos** (orders): checkout desde el carrito, con estados (`pending`, `paid`, `shipped`, `delivered`, `cancelled`).
- **Pagos** (payments): procesamiento de pagos de pedidos, con idempotencia.

El proyecto cubre el ciclo completo: modelado de recursos, CRUD, seguridad (JWT + roles + rate limiting), paginación, webhooks (notificar `order.paid` y `order.shipped`), versionado y documentación OpenAPI.

## Requisitos

- [ ] `openapi.yaml` con la spec completa de la API (todos los recursos y endpoints)
- [ ] Autenticación JWT: endpoints públicos vs protegidos; refresh token
- [ ] Autorización por roles: `admin` y `customer`
- [ ] Rate limiting documentado con cabeceras `X-RateLimit-*`
- [ ] Paginación por **cursor** en los listados grandes (`/products`, `/orders`)
- [ ] Webhooks para eventos `order.paid` y `order.shipped` (registro + firma HMAC)
- [ ] Versionado: `/v1` con al menos un endpoint marcado como **deprecado** hacia `/v2`
- [ ] Manejo de errores RESTful (RFC 7807) consistente en toda la API
- [ ] Al menos una operación asíncrona con `202 Accepted` + polling (ej. generar reporte)
- [ ] Idempotency-Key en el endpoint de pago
- [ ] Soft delete en productos y pedidos
- [ ] Los tests pasan: `bash test.sh`

## Modelo de datos

```
Usuario (users)         Producto (products)        Categoría (categories)
─────────────           ────────────────           ──────────────────────
id                      id                          id
email                   name                        name
role: admin|customer    price (unitPrice en v2)     slug
                        stock
                        categoryId                  Carrito (carts)
                        createdAt                   ─────────────
                        updatedAt (deletedAt)        id
                                                     userId
Pedidos (orders)                                     items: [ CartItem ]
─────────────
id                                          CartItem
userId                                      ─────────
status: pending|paid|shipped|delivered      productId
total                                        quantity
createdAt                                   price (snapshot)
updatedAt                                   
paymentId

Pagos (payments)
─────────────
id
orderId
amount
status: completed|failed
idempotencyKey
```

## Endpoints mínimos

| Recurso | Endpoints |
|---|---|
| Auth | `POST /auth/login`, `POST /auth/refresh` |
| Products | CRUD completo + `GET /products?cursor=...` + `GET /products/{id}/reviews` |
| Categories | CRUD (admin) + `GET /categories` (público) |
| Users | `POST /users` (registro), `GET /users/me`, `PATCH /users/{id}` (admin o self) |
| Carts | `GET /carts/me`, `POST /carts/items`, `PATCH /carts/items/{id}`, `DELETE /carts/items/{id}` |
| Orders | `POST /orders` (checkout), `GET /orders`, `GET /orders/{id}`, `POST /orders/{id}/cancel` |
| Payments | `POST /payments` (con `Idempotency-Key`), `GET /payments/{id}` |
| Webhooks | `POST /webhooks` (registro), `GET /webhooks/{id}/deliveries` |
| Reports | `POST /reports` (202 + job), `GET /jobs/{id}` (polling) |

## Fases sugeridas

| Fase | Qué haces | Entregable |
|---|---|---|
| 1. Modelo | Identificar recursos, relaciones y sub-recursos | Diagrama de recursos |
| 2. URIs | Diseñar todas las rutas RESTful | Lista de endpoints |
| 3. Seguridad | Definir auth JWT, roles y rate limiting | Sección de security en OpenAPI |
| 4. OpenAPI | Escribir `openapi.yaml` con paths y schemas | `openapi.yaml` |
| 5. Errores | Definir el formato de error RFC 7807 | Schema `Error` + respuestas |
| 6. Paginación | Cursor en `/products` y `/orders` | Parámetros y schemas |
| 7. Webhooks | Registro de webhook y formato de evento | `POST /webhooks` + evento |
| 8. Async | `POST /reports` con 202 y job | Job status |
| 9. Versionado | Marcar un endpoint `/v1` como deprecado hacia `/v2` | Cabeceras Deprecation/Sunset/Link |
| 10. Tests | `bash test.sh` valida el `openapi.yaml` y los archivos starter | `OK Tests pasaron` |

## Criterios de aceptación

- ✅ El `openapi.yaml` declara `openapi: 3.0.3` y los `servers`.
- ✅ Todos los recursos del modelo tienen sus endpoints en la spec.
- ✅ Auth JWT está definida con `securitySchemes` (Bearer) y `security` por endpoint.
- ✅ Roles diferencian endpoints de admin (`/categories` POST/DELETE) de públicos (`/products` GET).
- ✅ Rate limiting documentado con cabeceras `X-RateLimit-*` y respuesta 429.
- ✅ Paginación por cursor en `/products` y `/orders` (`nextCursor`, `hasMore`).
- ✅ Webhooks con firma `X-Webhook-Signature` e `eventId` para idempotencia.
- ✅ `POST /payments` con cabecera `Idempotency-Key` y respuesta de conflicto 409.
- ✅ `POST /reports` devuelve 202 con `Location` a un job; `GET /jobs/{id}` devuelve estado.
- ✅ Un endpoint `/v1` marcado como deprecado con `Deprecation`, `Sunset` y `Link rel="successor-version"`.
- ✅ Errores usan `application/problem+json` con `type`, `title`, `status`, `detail`.
- ✅ `bash test.sh` imprime `OK Tests pasaron`.

## Rúbrica

| Criterio | Peso |
|---|---|
| Modelado y URIs | 15% |
| OpenAPI completo y válido | 25% |
| Seguridad (JWT, roles, rate limiting) | 15% |
| Paginación, webhooks, async, idempotencia | 20% |
| Versionado y errores | 10% |
| Documentación y tests | 15% |

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `openapi.yaml` | Spec OpenAPI 3.0 starter con la estructura base a completar |
| `ejemplos/producto.json` | Ejemplo de recurso producto (v1 y v2) |
| `ejemplos/webhook-event.json` | Ejemplo de payload de evento webhook firmado |
| `ejemplos/async-job.json` | Ejemplo de estado de job asíncrono |
| `test.sh` | Valida que `openapi.yaml` es válido y contiene los elementos mínimos |

## Cómo ejecutar

```bash
cd 03-backend/rest/ejercicios/proyectos/proyecto-final
bash test.sh
```

> El `test.sh` valida el `openapi.yaml` con `python3` (usa PyYAML si está disponible; si no, hace validación estructural sobre el texto). Comprueba que la spec declara los recursos y mecanismos mínimos: paths de productos/pedidos/pagos/webhooks, securitySchemes Bearer, schemas de error y de job asíncrono.
