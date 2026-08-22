# Guía 05 — Producción y Buenas Prácticas

> Documentación (OpenAPI/Swagger), versionado y migración, backwards compatibility, deprecation, rate limiting en producción, caching, idempotency keys, webhooks, bulk operations, async operations (202), API gateway, microservicios y REST, testing, monitoreo y logging.

## Objetivos

- [ ] Documentar una API con OpenAPI/Swagger
- [ ] Versionar y migrar APIs manteniendo backwards compatibility
- [ ] Deprecar endpoints sin romper clientes
- [ ] Aplicar caching con ETag, Cache-Control y CDN
- [ ] Usar idempotency keys para reintentos seguros
- [ ] Implementar webhooks para notificaciones push
- [ ] Hacer bulk operations y operaciones asíncronas (202 + polling)
- [ ] Entender el rol del API gateway en microservicios
- [ ] Testear y monitorear una API REST

## Documentación de API (OpenAPI/Swagger)

Una API sin documentación es inutilizable. **OpenAPI** (antes Swagger) es el estándar: un fichero YAML/JSON que describe endpoints, métodos, parámetros, request/response, status codes y schemas. Sirve para generar docs interactivas, SDKs y tests.

Estructura de un `openapi.yaml`:

```yaml
openapi: 3.0.3
info:
  title: API de Productos
  version: 1.0.0
  description: API REST para gestionar productos de e-commerce.
servers:
  - url: https://api.example.com/v1
paths:
  /products:
    get:
      summary: Listar productos
      parameters:
        - name: limit
          in: query
          schema: { type: integer, default: 20, minimum: 1, maximum: 100 }
        - name: offset
          in: query
          schema: { type: integer, default: 0 }
      responses:
        '200':
          description: Lista de productos
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ProductList'
        '429':
          $ref: '#/components/responses/RateLimited'
    post:
      summary: Crear producto
      requestBody:
        required: true
        content:
          application/json:
            schema: { $ref: '#/components/schemas/ProductCreate' }
      responses:
        '201':
          description: Creado
          headers:
            Location: { schema: { type: string } }
        '422':
          $ref: '#/components/responses/ValidationError'
  /products/{id}:
    get:
      summary: Obtener producto por id
      parameters:
        - name: id
          in: path
          required: true
          schema: { type: string }
      responses:
        '200': { description: Producto }
        '404': { $ref: '#/components/responses/NotFound' }
components:
  schemas:
    Product:
      type: object
      properties:
        id: { type: string, example: prod_001 }
        name: { type: string, example: Teclado mecánico }
        price: { type: number, minimum: 0, example: 89.90 }
        createdAt: { type: string, format: date-time }
      required: [id, name, price]
    ProductList:
      type: object
      properties:
        data: { type: array, items: { $ref: '#/components/schemas/Product' } }
        pagination:
          type: object
          properties:
            limit: { type: integer }
            offset: { type: integer }
            total: { type: integer }
    ProductCreate:
      type: object
      properties:
        name: { type: string, minLength: 2, maxLength: 100 }
        price: { type: number, minimum: 0 }
      required: [name, price]
  responses:
    NotFound:
      description: Recurso no encontrado
      content:
        application/problem+json:
          schema: { $ref: '#/components/schemas/Error' }
    ValidationError:
      description: Error de validación
      content:
        application/problem+json:
          schema: { $ref: '#/components/schemas/Error' }
    RateLimited:
      description: Rate limit superado
      headers:
        Retry-After: { schema: { type: integer } }
  schemas:
    Error:
      type: object
      properties:
        type: { type: string }
        title: { type: string }
        status: { type: integer }
        detail: { type: string }
```

Herramientas:
- **Swagger UI / Redoc / Elements**: generan docs interactivas HTML desde el YAML.
- **Generadores de SDK**: producen clientes para JS, Python, Go, etc.
- **Validadores**: comprueban que el servidor cumple la spec (contract testing).
- **Postman / Insomnia**: importan la spec y montan colecciones.

Buenas prácticas:
- La spec es **código**: vive en el repo, se revisa en PR, se versiona con la API.
- Documenta **ejemplos** de request y response.
- Describe **todos** los status codes, incluidos los de error.
- Usa `$ref` para reutilizar schemas.
- Mantén docs sincronizadas con la implementación (o genéralas desde el código).

## Versionado y migración

El versionado permite cambiar la API sin romper clientes (ver guía 02). En producción hay que gestionar el **ciclo de vida** de las versiones.

Estrategias:
1. **Nueva versión (major)**: para cambios breaking, lanza `/v2` en paralelo a `/v1`.
2. **Deprecación**: marca `/v1` como obsoleta, sigue funcionando.
3. **Migración**: comunica a los clientes el cambio, da tiempo, ejemplos y guías.
4. **Sunset**: anuncia fecha de apagado y finalmente retira `/v1`.

Cabeceras de deprecación:
```
Deprecation: true
Sunset: Wed, 31 Dec 2025 23:59:59 GMT
Link: <https://docs.example.com/migration-v2>; rel="deprecation"
```

## Backwards compatibility

Un cambio es **backwards compatible** si los clientes existentes siguen funcionando sin cambios.

| Cambio | ¿Compatible? |
|---|---|
| Añadir campo opcional en respuesta | ✅ |
| Añadir endpoint nuevo | ✅ |
| Añadir valor a un enum (cliente tolerante) | ✅ |
| Añadir query param opcional con default | ✅ |
| Eliminar campo de respuesta | ❌ |
| Cambiar tipo de un campo | ❌ |
| Hacer obligatorio un campo opcional | ❌ |
| Cambiar semántica de un campo | ❌ |
| Cambiar status code de un caso | ❌ |
| Cambiar URL | ❌ |

Regla de oro: **additive changes only** (solo añadir, nunca quitar ni cambiar significados). Cuando necesites romper, sube de versión.

## Deprecation

Marcar algo como "obsoleto, no usar, será retirado":

- **Documentación**: marca con `[DEPRECATED]` y la fecha de sunset.
- **Cabeceras**: `Deprecation: true`, `Sunset`.
- **Logs**: cuenta cuántos clientes siguen usando el endpoint deprecado.
- **Comunicación**: email a integradores, changelog, banner en docs.

Ciclo típico:
1. Lanzas `/v2` con el cambio.
2. Deprecas `/v1` (sigue funcionando, avisa en cabeceras).
3. Migras clientes activos.
4. Anuncias sunset (fecha concreta).
5. Apagas `/v1` en la fecha anunciada.

## Rate limiting en producción

En producción, el rate limiting debe ser:
- **Por identidad** (usuario o API key), no solo por IP.
- **Diferenciado** por endpoint: lectura alto, escritura bajo; endpoints caros con límite aparte.
- **Visible**: cabeceras `X-RateLimit-*` siempre (incluso cuando no se excede).
- **Con `Retry-After`** al devolver 429.
- **Configurable** por plan (free/Pro/Enterprise).
- **Persistido** en Redis/memoria distribuida para que todos los nodos compartan el conteo.

Ejemplo de cabeceras en cada respuesta:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 942
X-RateLimit-Reset: 1700000060
```

## Caching (ETag, Cache-Control, CDN)

El caching reduce latencia, carga del servidor y tráfico. Hay dos niveles:

### 1. Caching del cliente y proxies (HTTP caching)

Cabeceras:
```
Cache-Control: public, max-age=60
ETag: "abc123"
Last-Modified: Wed, 15 Jan 2024 10:30:00 GMT
```

- `Cache-Control: max-age=N`: cacheable durante N segundos.
- `Cache-Control: private`: solo el navegador del usuario puede cachear (no proxies compartidos).
- `Cache-Control: no-store`: no cachear nunca (datos sensibles).
- `ETag`: hash/version del recurso. El cliente envía `If-None-Match: "abc123"` y el servidor responde `304 Not Modified` si no cambió (sin body).
- `Last-Modified` / `If-Modified-Since`: igual pero con fecha.

**Conditional requests**:
```http
GET /products/prod_001
If-None-Match: "abc123"
```
```http
HTTP/1.1 304 Not Modified
ETag: "abc123"
```

Esto ahorra ancho de banda y CPU. Ideal para GET de recursos que cambian poco.

### 2. Caching en CDN

Una **CDN** (Cloudflare, Fastly, CloudFront) cachea respuestas en el borde, cerca del usuario. Para que la CDN cachee:

```
Cache-Control: public, max-age=300, s-maxage=600
```

- `s-maxage`: TTL para la CDN (distinto del navegador).
- `Surrogate-Control`: cabecera para la CDN.

**Nunca cachear** respuestas autenticadas/personalizadas sin una clave de cache que incluya al usuario (o `private`).

**Invalidación**: al modificar un recurso (PUT/DELETE), invalida su caché (`purge` en CDN, actualizar ETag).

## Idempotency keys

(Ver guía 03.) En producción son imprescindibles en:
- **Pagos**: evitar cobros duplicados por reintentos.
- **Emails**: no enviar dos veces.
- **Transferencias**: no mover dinero dos veces.

Flujo:
```
POST /payments
Idempotency-Key: 7c8f3a2e-...
{ "orderId": "ord_123", "amount": 99.90 }

→ (procesa, guarda resultado con la key)

POST /payments
Idempotency-Key: 7c8f3a2e-...   (mismo body, reintento)
→ (devuelve el resultado cacheado, no reprocesa)
```

Implementación:
- TTL de 24-48h en Redis.
- Guarda `(key, request_hash, status, response_body)`.
- Si llega misma key con body distinto → 409 Conflict (client error).
- Si llega misma key con mismo body mientras procesa → 409 o espera.

## Webhooks

Un **webhook** es un callback HTTP: el cliente registra una URL y el servidor le hace un `POST` cuando ocurre un evento. Invierte el modelo: en vez de que el cliente **pulse** (polling), el servidor **empuja** (push).

Registro:
```http
POST /webhooks
{ "url": "https://client.example.com/hooks", "events": ["order.paid", "order.shipped"] }
→ 201 { "id": "wh_1", "secret": "whsec_..." }
```

Evento disparado por el servidor:
```http
POST https://client.example.com/hooks
X-Webhook-Event: order.paid
X-Webhook-Signature: sha256=...
Content-Type: application/json

{ "id": "evt_001", "type": "order.paid", "data": { "orderId": "ord_456", "amount": 99.90 } }
```

Buenas prácticas:
- **Firma**: firma el body con HMAC-SHA256 y el `secret` para que el cliente verifique autenticidad.
- **Reintentos**: si el cliente responde != 2xx, reintenta con backoff exponencial (1m, 5m, 30m, 2h, 24h).
- **Idempotencia**: incluye un `eventId` para que el cliente ignore duplicados.
- **Timeout corto** (5-10s) y no bloquees el flujo principal: envía el webhook asíncrono.
- **Cola**: mete los eventos en una cola (Kafka, SQS, Redis) antes de enviar.
- **Logs y reintentos visibles** para el cliente en un dashboard.

## Bulk operations

Operaciones masivas: crear/actualizar/borrar varios recursos en una sola petición.

```http
POST /products/bulk
Content-Type: application/json

{
  "products": [
    { "name": "Teclado", "price": 89.90 },
    { "name": "Ratón", "price": 19.90 },
    { "name": "Monitor", "price": 199.90 }
  ]
}
```

Respuesta:
```http
HTTP/1.1 200 OK
{
  "results": [
    { "index": 0, "status": "created", "id": "prod_001" },
    { "index": 1, "status": "error", "error": { "code": "validation_failed", "message": "price debe ser >= 0" } },
    { "index": 2, "status": "created", "id": "prod_003" }
  ],
  "summary": { "created": 2, "failed": 1 }
}
```

Reglas:
- **Límite** de items por petición (ej. 100) para evitar abusos.
- **Resultados parciales**: cada item con su propio estado (no todo falla porque uno falle).
- **Atomicidad opcional**: si se quiere todo o nada, un flag `?atomic=true`.
- **Bulk idempotency**: idempotency key a nivel de operación completa.

## Async operations (202 Accepted + polling)

Operaciones largas (generar reporte, procesar video, importar CSV) no pueden bloquear la petición HTTP. Se devuelve **202 Accepted** con una URI de estado, y el cliente **poll** (consulta periódica).

```http
POST /reports
{ "type": "monthly_sales", "month": "2024-01" }
```
```http
HTTP/1.1 202 Accepted
Location: /jobs/job_abc123
Content-Type: application/json

{ "jobId": "job_abc123", "status": "pending", "statusUrl": "/jobs/job_abc123" }
```

Polling del estado:
```http
GET /jobs/job_abc123
```
```http
HTTP/1.1 200 OK
{ "jobId": "job_abc123", "status": "running", "progress": 45 }
```

Cuando termina:
```http
HTTP/1.1 200 OK
{ "jobId": "job_abc123", "status": "completed", "result": { "reportUrl": "/reports/rpt_789" } }
```

Estados típicos: `pending` → `running` → `completed` | `failed`.

Alternativa al polling: **webhook** de callback que el servidor invoca al terminar. Combinación: devuelves 202 con `statusUrl` y opcionalmente registras un webhook.

## API gateway

Un **API gateway** es la entrada única a tus APIs/servicios. Recibe todas las peticiones y las enruta, aplicando cross-cutting concerns:

| Responsabilidad | Ejemplo |
|---|---|
| Routing | `/v1/products` → servicio Productos |
| Autenticación | valida JWT antes de llegar al servicio |
| Rate limiting | 429 antes de tocar el backend |
| CORS | añade cabeceras |
| Caching | cachea GETs |
| Transformación | cambia versión/ formato |
| Logging/métricas | centraliza trazas |
| Load balancing | reparte entre instancias |
| Agregación | une respuestas de varios servicios |
| Quota/billing | cuenta uso por cliente |

Productos: Kong, AWS API Gateway, NGINX, Tyk, Apigee, Traefik.

El gateway permite que los microservicios sean **simples** (solo lógica de negocio) y centraliza lo transversal.

## Microservicios y REST

En microservicios, cada servicio expone su propia API REST y se comunican entre ellos o con el cliente a través de HTTP. Patrones:

- **API Gateway perimetral**: el cliente habla solo con el gateway; este agrega/viene de varios servicios.
- **Service-to-service REST**: un servicio llama a otro por HTTP (simple, pero acoplamiento síncrono).
- **Aggregation/BFF** (Backend For Frontend): un servicio por tipo de cliente (web, móvil) que agrega datos de varios.
- **Saga**: coordinación de transacciones distribuidas vía eventos/compensaciones (no REST puro, pero las acciones se exponen como endpoints REST).

Pros de REST entre microservicios:
- Simple, estándar, buen tooling.
- Fácil de debuggear con curl.

Contras:
- **Síncrono**: si un servicio cae, falla la cadena. Mitigar con circuit breakers, timeouts, retries.
- **Acoplamiento temporal**: el cliente necesita al servidor levantado.
- Para alto rendimiento/bajo acoplamiento, mejor **async messaging** (Kafka, RabbitMQ) o **gRPC** entre servicios internos.

## Testing de APIs

Niveles de testing:

1. **Unitarios**: lógica de cada handler/controller en aislado (mocks de BD).
2. **Integración**: controller + BD real/efímera, sin red externa.
3. **Contract testing**: la API cumple la spec OpenAPI (Pact, Dredd, Schemathesis).
4. **E2E**: levantas todo el stack y lanzas peticiones HTTP reales.
5. **Load testing**: rendimiento bajo carga (k6, Locust, JMeter).
6. **Security testing**: fuzzing, escaneo OWASP (ZAP, Burp).

Ejemplo de test de contrato:
```yaml
# validar que GET /products/valid_id devuelve 200 con schema Product
GET /products/prod_001
assert: response.status == 200
assert: response.body matches ProductSchema
```

Estrategias:
- **Datos de test** reproducibles (seed, factories).
- **Estados deterministas**: usa BD efímera o transacciones con rollback.
- **Tests de los errores** también (404, 422, 429).
- **Mock de dependencias externas** (pagos, email) en tests.
- **CI**: todo pasa en cada PR.

## Monitoreo y logging

Una API en producción necesita observabilidad.

**Logs estructurados** (JSON):
```json
{ "timestamp": "2024-01-15T10:30:00Z", "level": "info", "method": "GET", "path": "/products/123", "status": 200, "duration_ms": 45, "requestId": "req_abc", "userId": "usr_1" }
```

- Un **requestId** por petición (cabecera `X-Request-Id`) propagado a todos los servicios.
- Logs en stdout, recolectados por la infra (ELK, Loki, Datadog).
- **No loguear** datos sensibles (tokens, contraseñas, PII).

**Métricas**:
- **RED**: Rate (peticiones/s), Errors (tasa de error), Duration (latencia).
- Por endpoint, por status code, percentiles p50/p95/p99.
- Herramientas: Prometheus + Grafana, Datadog, NewRelic.

**Tracing distribuido**:
- Un **trace** sigue una petición a través de múltiples servicios.
- OpenTelemetry, Jaeger, Zipkin.
- Cada servicio añade spans con el `traceId`.

**Alertas**:
- Tasa de error > X%.
- Latencia p95 > Y ms.
- 5xx espontáneos.
- Rate limit 429 alto (posible abuso o clientes rotos).

**Health checks**:
- `GET /health` → 200 si el servicio vive (liveness).
- `GET /ready` → 200 si está listo para recibir tráfico (BD conectada, etc.) (readiness).
- El orquestador (K8s) usa estos endpoints para reiniciar/quitar de servicio.

## Conceptos clave

- **OpenAPI**: spec que documenta, valida y genera SDKs de la API.
- **Backwards compatibility**: solo añadir, nunca quitar/cambiar significados.
- **Deprecation + Sunset**: ciclo de vida de versiones.
- **Caching**: `Cache-Control` + `ETag` + CDN (`s-maxage`); conditional requests `304`.
- **Idempotency keys**: reintentos seguros en POST.
- **Webhooks**: push de eventos con firma y reintentos.
- **Bulk ops**: múltiples items con resultados parciales.
- **Async**: `202 Accepted` + polling de `/jobs/{id}` o webhook.
- **API gateway**: entrada única con auth, rate limit, caching, routing.
- **Microservicios REST**: simples pero síncronos; circuit breakers y timeouts.
- **Testing**: unit, integration, contract, E2E, load, security.
- **Observabilidad**: logs estructurados + métricas RED + tracing + health.

## Errores comunes

- **Docs desactualizadas** respecto a la implementación.
- **Eliminar campos sin versionar**: rompe clientes en silencio.
- **No dar fecha de sunset** al deprecar: clientes pillados por sorpresa.
- **Cachear respuestas autenticadas** con `public`: filtra datos entre usuarios.
- **No usar ETag** en recursos pesados: latencia evitable.
- **Olvidar idempotency keys** en pagos: cobros duplicados.
- **Webhooks sin firma**: cualquiera puede falsear eventos.
- **Webhooks síncronos**: bloquear el flujo principal esperando al cliente.
- **Bulk sin límite**: payloads gigantes, DoS.
- **Operaciones largas síncronas**: timeouts en el cliente.
- **Sin API gateway**: cada servicio reimplementa auth, rate limit, logging.
- **Microservicios acoplados síncronamente sin circuit breaker**: cascadas de fallos.
- **Tests que no cubren errores** (solo el happy path).
- **Logs no estructurados** o sin `requestId`: imposible correlacionar.
- **No monitorizar p95/p99**: la media oculta colas lentas.
- **Sin health checks**: el orquestador no sabe cuándo reiniciar.
