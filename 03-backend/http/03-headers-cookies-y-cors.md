# 03 — Headers, Cookies y CORS

> Headers en profundidad (general/request/response/entity), content negotiation, cookies y sus atributos, CORS y el preflight OPTIONS, y la maquinaria de caché HTTP (ETag, If-None-Match, Last-Modified, 304).

## Objetivos

- [ ] Clasificar headers en generales, de petición, de respuesta y de entidad.
- [ ] Entender la **content negotiation** con `Accept`, `Accept-Encoding`, `Content-Type`.
- [ ] Dominar las **cookies**: `Set-Cookie`, atributos (`HttpOnly`, `Secure`, `SameSite`, `Path`, `Domain`, `Expires`, `Max-Age`).
- [ ] Explicar **CORS** y el flujo **preflight** con `OPTIONS`.
- [ ] Dominar la **caché HTTP**: `Cache-Control`, `max-age`, `no-cache`, `no-store`, `public`, `private`, `ETag`, `If-None-Match`, `Last-Modified`, `If-Modified-Since`, `304 Not Modified`.

## Headers en profundidad

Un **header** es una línea `Nombre: valor` que viaja entre cliente y servidor aportando metadatos. Se clasifican por su alcance:

### General headers

Aparecen tanto en peticiones como en respuestas y no se refieren al contenido (body) en sí.

| Header | Descripción | Ejemplo |
|---|---|---|
| `Cache-Control` | Directivas de caché | `Cache-Control: no-cache` |
| `Connection` | Control de la conexión TCP | `Connection: keep-alive` |
| `Date` | Fecha/hora del mensaje | `Date: Fri, 22 Aug 2026 10:00:00 GMT` |
| `Transfer-Encoding` | Forma de transferir el body | `Transfer-Encoding: chunked` |
| `Trailer` | Headers que viven tras un body chunked | `Trailer: Expires` |

### Request headers

Solo en peticiones. Describen al cliente y lo que quiere.

| Header | Descripción | Ejemplo |
|---|---|---|
| `Host` | Dominio destino (obligatorio en HTTP/1.1) | `Host: api.tienda.com` |
| `User-Agent` | Identifica al cliente | `User-Agent: Mozilla/5.0...` |
| `Accept` | Tipos MIME aceptados | `Accept: application/json` |
| `Accept-Language` | Idiomas preferidos | `Accept-Language: es-ES, en;q=0.8` |
| `Accept-Encoding` | Compresiones soportadas | `Accept-Encoding: gzip, br` |
| `Authorization` | Credenciales | `Authorization: Bearer eyJ...` |
| `Cookie` | Cookies almacenadas | `Cookie: session=abc123` |
| `Origin` | Origen del cliente (para CORS) | `Origin: https://app.tienda.com` |
| `Referer` | URL de la que proviene | `Referer: https://app.tienda.com/home` |
| `If-None-Match` | ETag del caché del cliente | `If-None-Match: "v3"` |
| `If-Modified-Since` | Fecha del caché del cliente | `If-Modified-Since: Wed, 21 Oct 2025 07:28:00 GMT` |

### Response headers

Solo en respuestas. Describen el resultado y al servidor.

| Header | Descripción | Ejemplo |
|---|---|---|
| `Server` | Software del servidor | `Server: nginx/1.25` |
| `Location` | URI del recurso creado o redirección | `Location: /v1/products/42` |
| `Set-Cookie` | Enviar cookie al cliente | `Set-Cookie: session=abc; HttpOnly` |
| `ETag` | Versión/hash del recurso | `ETag: "v3"` |
| `Last-Modified` | Fecha de modificación | `Last-Modified: Wed, 21 Oct 2025 07:28:00 GMT` |
| `Vary` | Headers que diversifican la caché | `Vary: Accept-Encoding` |
| `WWW-Authenticate` | Esquema de auth requerido | `WWW-Authenticate: Bearer realm="api"` |
| `Allow` | Métodos permitidos | `Allow: GET, POST` |
| `Retry-After` | Cuándo reintentar (429/503) | `Retry-After: 60` |

### Entity headers

Describen el **body** del mensaje (en request o response).

| Header | Descripción | Ejemplo |
|---|---|---|
| `Content-Type` | Tipo MIME del body | `Content-Type: application/json` |
| `Content-Length` | Tamaño en bytes | `Content-Length: 46` |
| `Content-Encoding` | Compresión del body | `Content-Encoding: gzip` |
| `Content-Language` | Idioma del contenido | `Content-Language: es-ES` |
| `Content-Range` | Rango parcial | `Content-Range: bytes 0-1023/2048` |

## Content negotiation

El cliente y el servidor negocian el formato, idioma y compresión del contenido mediante headers. Es el principio de **una misma URL, varias representaciones**.

### `Accept` (formato)

El cliente lista los MIME types que acepta, con prioridad `q` (0–1):

```
Accept: application/json, text/xml;q=0.9, */*;q=0.1
```

El servidor responde con el elegido:

```
Content-Type: application/json
```

Si no puede servir ninguno: `406 Not Acceptable`.

### `Accept-Encoding` (compresión)

```
Accept-Encoding: gzip, deflate, br
```

El servidor comprime el body y lo indica:

```
Content-Encoding: gzip
```

### `Accept-Language` (idioma)

```
Accept-Language: es-ES, es;q=0.9, en;q=0.8
```

```
Content-Language: es-ES
```

### Ejemplo completo

```http
GET /products HTTP/1.1
Host: api.tienda.com
Accept: application/json
Accept-Language: es-ES
Accept-Encoding: gzip
```

```http
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Language: es-ES
Content-Encoding: gzip
Vary: Accept, Accept-Language, Accept-Encoding
```

> **`Vary`** avisa a los caches de que la respuesta depende de esos headers: dos clientes con distinto `Accept` no deben compartir la misma respuesta cacheada.

## Cookies

Las **cookies** son pares clave-valor que el servidor pide al cliente almacenar y reenviar en cada petición posterior al mismo dominio. Como HTTP es sin estado, las cookies aportan **estado** del lado del cliente.

### Ciclo de vida

1. El servidor envía `Set-Cookie` en la respuesta.
2. El browser la guarda.
3. En las siguientes peticiones al mismo dominio, el cliente envía `Cookie`.

```http
HTTP/1.1 200 OK
Set-Cookie: session=abc123; HttpOnly; Secure; SameSite=Lax; Path=/; Max-Age=3600
```

```http
GET /profile HTTP/1.1
Host: api.tienda.com
Cookie: session=abc123
```

### Atributos de `Set-Cookie`

| Atributo | Qué hace | Ejemplo |
|---|---|---|
| `HttpOnly` | La cookie NO es accesible vía `document.cookie` (JS). Mitiga XSS | `HttpOnly` |
| `Secure` | Solo se envía por HTTPS | `Secure` |
| `SameSite` | Controla envío en peticiones cross-site | `SameSite=Lax` |
| `Path` | URLs donde se envía | `Path=/account` |
| `Domain` | Dominio (y subdominios) donde se envía | `Domain=.tienda.com` |
| `Expires` | Fecha absoluta de caducidad | `Expires=Wed, 21 Oct 2026 07:28:00 GMT` |
| `Max-Age` | Segundos hasta caducar (relativo) | `Max-Age=3600` |

### `SameSite`

| Valor | Comportamiento |
|---|---|
| `Strict` | No se envía en navegación cross-site (ni siquiera al seguir un link) |
| `Lax` | Se envía en navegación top-level GET (links), pero no en POST cross-site. **Por defecto** en browsers modernos |
| `None` | Se envía siempre, pero **exige `Secure`** |

> **Seguridad:** las cookies de sesión deben llevar siempre `HttpOnly` (contra XSS) y `Secure` (contra sniffing). `SameSite=Lax` o `Strict` mitiga CSRF.

### Borrar una cookie

Se envía de nuevo con `Max-Age=0` o `Expires` en el pasado:

```
Set-Cookie: session=; Max-Age=0; Path=/
```

## CORS

**CORS** (Cross-Origin Resource Sharing) es el mecanismo que permite a un navegador ejecutar JS que hace peticiones a un **origen distinto** al de la página. El **origen** es `esquema://host:puerto`.

Sin CORS, el **Same-Origin Policy** del browser bloquearía la respuesta. CORS permite al servidor declarar qué orígenes pueden leer sus respuestas.

### Simple request

Una petición “simple” (GET/HEAD/POST con ciertos headers y `Content-Type` limitado) no necesita preflight. El browser envía directamente `Origin` y comprueba la respuesta:

```http
GET /products HTTP/1.1
Host: api.tienda.com
Origin: https://app.tienda.com
```

```http
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://app.tienda.com
```

Si el header falta o no coincide con el origen, el browser bloquea la lectura aunque la petición sí haya llegado al servidor.

### Preflight (OPTIONS)

Si la petición **no es simple** (usa métodos como PUT/DELETE, o headers custom como `Authorization`, o `Content-Type: application/json`), el browser envía primero un **preflight** con `OPTIONS`:

```http
OPTIONS /products HTTP/1.1
Host: api.tienda.com
Origin: https://app.tienda.com
Access-Control-Request-Method: DELETE
Access-Control-Request-Headers: Authorization, Content-Type
```

El servidor responde declarando lo permitido:

```http
HTTP/1.1 204 No Content
Access-Control-Allow-Origin: https://app.tienda.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Authorization, Content-Type
Access-Control-Max-Age: 600
```

Si el preflight aprueba, el browser envía la petición real. Si no, la bloquea.

### Headers CORS

| Header | Lado | Qué hace |
|---|---|---|
| `Origin` | Request | Origen de la página que hace la petición |
| `Access-Control-Request-Method` | Request (preflight) | Método que se quiere usar |
| `Access-Control-Request-Headers` | Request (preflight) | Headers custom que se quieren enviar |
| `Access-Control-Allow-Origin` | Response | Origen permitido (o `*`) |
| `Access-Control-Allow-Methods` | Response | Métodos permitidos |
| `Access-Control-Allow-Headers` | Response | Headers permitidos en la petición real |
| `Access-Control-Allow-Credentials` | Response | Permite cookies/Authorization cross-site |
| `Access-Control-Max-Age` | Response | Cuánto cachear el preflight (segundos) |

### CORS con credenciales

Si el cliente envía cookies o `Authorization` cross-site, el servidor debe:

- Responder `Access-Control-Allow-Credentials: true`.
- **No** usar `Access-Control-Allow-Origin: *`; debe ser el origen concreto.

```http
Access-Control-Allow-Origin: https://app.tienda.com
Access-Control-Allow-Credentials: true
```

Y el cliente debe configurar `fetch` con `credentials: 'include'`.

> **Peligro:** `Access-Control-Allow-Origin: *` con `Access-Control-Allow-Credentials: true` está prohibido por el estándar. El browser lo rechaza.

## Caché HTTP

La caché HTTP evita re-descargar datos que no han cambiado, reduciendo latencia y tráfico. Intervienen el browser, proxies y CDNs.

### `Cache-Control` (directivas)

| Directiva | Significado |
|---|---|
| `max-age=N` | El recurso es fresco durante N segundos |
| `s-maxage=N` | Como `max-age` pero para caches compartidas (CDN/proxy) |
| `no-cache` | **Se puede cachear pero hay que revalidar** antes de usar |
| `no-store` | **No cachear nada** (ni en disco ni en memoria) |
| `public` | Cachable por caches compartidas |
| `private` | Cachable solo por el browser del usuario (no CDN) |
| `immutable` | El recurso nunca cambia mientras es fresco (evita revalidación) |
| `must-revalidate` | Si expira, debe revalidarse (no usar la copia stale) |
| `stale-while-revalidate=N` | Sirve copia vieja mientras revalida en paralelo |

### `no-cache` vs `no-store`

- **`no-cache`**: el navegador guarda la copia, pero **antes de usarla** debe preguntar al servidor si sigue siendo válida (revalidación).
- **`no-store`**: no se guarda absolutamente nada. Más estricto.

### Validación con `ETag` / `If-None-Match`

Un **ETag** es una versión/hash del recurso. El servidor lo envía:

```http
HTTP/1.1 200 OK
ETag: "v3"
Cache-Control: max-age=60
```

Cuando caduca `max-age`, el cliente revalida enviando su ETag:

```http
GET /products/42 HTTP/1.1
If-None-Match: "v3"
```

Si el recurso **no cambió**, el servidor responde **304 Not Modified** sin body:

```http
HTTP/1.1 304 Not Modified
ETag: "v3"
Cache-Control: max-age=60
```

El cliente reutiliza su copia cacheada. Si cambió:

```http
HTTP/1.1 200 OK
ETag: "v4"
Cache-Control: max-age=60

{"id":42,"name":"Monitor","price":229}
```

### Validación con `Last-Modified` / `If-Modified-Since`

Alternativa basada en fechas:

```http
HTTP/1.1 200 OK
Last-Modified: Wed, 21 Oct 2025 07:28:00 GMT
Cache-Control: max-age=60
```

Revalidación:

```http
GET /products/42 HTTP/1.1
If-Modified-Since: Wed, 21 Oct 2025 07:28:00 GMT
```

Si no modificó: `304 Not Modified`. ETag es preferible (más preciso).

### Flujo completo de caché

```
1ª petición:  GET /p  → 200 OK + ETag + max-age=60
                               │
            (60s de frescura)  │  el cliente usa la copia cacheada
                               │
2ª petición (tras 60s): GET /p + If-None-Match:"v3"
                               │
              ┌────────────────┴────────────────┐
              ▼                                  ▼
   sin cambios: 304                  con cambios: 200 + nuevo ETag
   (usa copia cacheada)              (descarga nuevo body)
```

### Ejemplo con curl

```bash
# Guarda la caché en caché.txt y la usa en la 2ª petición
curl -v -c cache.txt -b cache.txt \
  -H 'Cache-Control: max-age=0' \
  https://api.tienda.com/products/42
```

## Tabla de referencia rápida

### Atributos de cookies

| Atributo | Seguridad | Notas |
|---|---|---|
| `HttpOnly` | Anti-XSS | Impide acceso desde JS |
| `Secure` | Anti-sniffing | Solo HTTPS |
| `SameSite=Strict` | Anti-CSRF | No envía cross-site |
| `SameSite=Lax` | Anti-CSRF parcial | Default en browsers |
| `SameSite=None` | — | Requiere `Secure` |
| `Max-Age` / `Expires` | Caducidad | Preferible `Max-Age` |

### Directivas de `Cache-Control`

| Directiva | ¿Cachea? | ¿Revalida? |
|---|---|---|
| `max-age=N` | Sí, N s | Tras N s |
| `no-cache` | Sí | Siempre antes de usar |
| `no-store` | No | — |
| `public` | Caches compartidas | Según `max-age` |
| `private` | Solo browser | Según `max-age` |

## Conceptos clave

- **Los headers son metadatos:** general, request, response y entity.
- **Content negotiation:** una URL, varias representaciones (`Accept`, `Accept-Language`, `Accept-Encoding`).
- **`Vary`** evita servir una respuesta cacheada de un cliente a otro con distinto `Accept`.
- **Cookies aportan estado a un protocolo sin estado.** Se reenvían en cada petición al dominio.
- **`HttpOnly` + `Secure` + `SameSite`** es el mínimo de seguridad para cookies de sesión.
- **CORS lo aplica el navegador, no el servidor.** El servidor declara permisos; el browser los hace cumplir.
- **Preflight (`OPTIONS`) ocurre** cuando la petición no es “simple” (PUT/DELETE, headers custom, JSON).
- **`Access-Control-Allow-Origin: *` no es compatible con credenciales.**
- **`no-cache` no prohíbe cachear:** pide revalidar. `no-store` sí prohíbe.
- **ETag + If-None-Match + 304** es la revalidación preferida (precisión de hash vs fecha).

## Errores comunes

- **Olvidar `HttpOnly` en cookies de sesión**, dejándolas accesibles a ataques XSS.
- **Usar `SameSite=None` sin `Secure`.** El browser rechaza la cookie.
- **Pensar que CORS protege el servidor.** CORS protege al **browser** de leer respuestas cross-site; el servidor recibe la petición igual.
- **Responder `Access-Control-Allow-Origin: *` con credenciales.** El browser bloquea la respuesta.
- **Confundir `no-cache` con `no-store`.** `no-cache` cachea y revalida; `no-store` no guarda nada.
- **Olvidar `Vary: Accept-Encoding`.** Sin él, una CDN puede servir gzip a un cliente que no lo soporta.
- **Devolver 200 en vez de 304** cuando el ETag coincide. Se desperdicia ancho de banda.
- **Usar `Last-Modified` cuando la precisión de segundos no basta.** ETag resuelve cambios sub-segundo.
- **No cachear el preflight CORS** (`Access-Control-Max-Age`). Sin él, cada petición cuesta un extra de OPTIONS.
- **Poner `Cache-Control: public` en respuestas con datos de usuario.** Un proxy podría servirlas a otro usuario.

## Siguiente

Continúa con [04 — Autenticación y Seguridad](04-autenticacion-y-seguridad.md) para ver auth HTTP, JWT, OAuth 2.0, HTTPS/TLS y headers de seguridad.
