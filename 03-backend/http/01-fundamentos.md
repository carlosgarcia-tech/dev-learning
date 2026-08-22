# 01 — Fundamentos de HTTP

> El protocolo que mueve la web. Cómo se construyen peticiones y respuestas, qué significan los métodos, los códigos de estado, los headers y cómo ha evolucionado el protocolo de HTTP/1.0 a HTTP/3.

## Objetivos

- [ ] Entender qué es HTTP y el modelo cliente-servidor sin estado.
- [ ] Descomponer una URL en esquema, host, puerto, path, query y fragment.
- [ ] Leer y escribir una petición HTTP en texto plano (request line + headers + body).
- [ ] Leer y escribir una respuesta HTTP en texto plano (status line + headers + body).
- [ ] Conocer los métodos HTTP y su intención.
- [ ] Clasificar códigos de estado por familia (1xx–5xx).
- [ ] Identificar los headers más usados.
- [ ] Diferenciar HTTP/1.0, HTTP/1.1, HTTP/2 y HTTP/3.
- [ ] Reconocer MIME types comunes.

## Qué es HTTP

**HTTP** (HyperText Transfer Protocol) es un protocolo de la capa de aplicación diseñado para transferir documentos hipermedia (originalmente HTML, hoy cualquier JSON, imágenes, vídeo, archivos). Fue creado por Tim Berners-Lee en 1989-1991 para la World Wide Web.

Características clave:

- **Texto plano (en HTTP/1.x):** los mensajes son legibles por humanos. Una petición es solo líneas de texto terminadas en `\r\n`.
- **Cliente-servidor:** el cliente (browser, `curl`, tu código) pide; el servidor responde. El servidor no inicia la comunicación (salvo WebSocket/SSE).
- **Sin estado (stateless):** cada petición es independiente. El servidor no recuerda la anterior por defecto; las **cookies** y las **sesiones** simulan estado.
- **Extensible:** todo va en headers. Añadir un header nuevo no rompe el protocolo.
- **Transporte:** normalmente sobre **TCP** (HTTP/1.x, HTTP/2) o **UDP** (HTTP/3 sobre QUIC).

### Modelo cliente-servidor

```
┌─────────┐   petición HTTP (request)    ┌─────────┐
│ Cliente │ ───────────────────────────> │ Servidor│
│ browser │                              │  (API)  │
│  curl   │ <─────────────────────────── │         │
└─────────┘   respuesta HTTP (response) └─────────┘
```

- El **cliente** construye la petición: método, ruta, headers y (opcionalmente) body.
- El **servidor** la procesa y devuelve una respuesta: versión, status, headers y (opcionalmente) body.
- Entre medias puede haber **proxies**, **gateways**, **CDN** y **load balancers**, pero el contrato cliente-servidor se mantiene.

## La URL

Una **URL** (Uniform Resource Locator) identifica un recurso y cómo llegar a él.

```
  https://api.tienda.com:443/v1/products?limit=10&sort=desc#resumen
  \___/   \____________/ \_/ \_________/ \____________/ \______/
  esquema     host       puerto   path       query        fragment
```

| Parte | Ejemplo | Descripción |
|---|---|---|
| **esquema** (scheme) | `https` | Protocolo. `http`, `https`, `ws`, `wss`, `ftp`... |
| **host** | `api.tienda.com` | Dominio o IP del servidor |
| **puerto** (port) | `443` | Opcional. `80`→http, `443`→https por defecto |
| **path** (ruta) | `/v1/products` | Identifica el recurso en el servidor |
| **query** | `limit=10&sort=desc` | Parámetros para el servidor. Empieza en `?`, pares `k=v` separados por `&` |
| **fragment** | `#resumen` | Solo lo usa el cliente (navega dentro del documento). **No se envía al servidor** |

> **Truco:** el `fragment` (`#...`) nunca llega al servidor. Si necesitas ese dato en el backend, va en el `query`, no en el fragment.

Ejemplos:

```
http://localhost:3000/users/42
https://api.github.com/repos/carlos/ejemplo/issues?state=open
ftp://files.ejemplo.com/datos.csv
```

## Petición HTTP (request)

Una petición HTTP/1.1 en texto plano tiene esta forma:

```
POST /v1/products HTTP/1.1
Host: api.tienda.com
Content-Type: application/json
Content-Length: 46
Accept: application/json

{"name": "Teclado", "price": 49.99}
```

Tres partes:

1. **Request line:** `MÉTODO /ruta HTTP/versión`
2. **Headers:** `Nombre: valor` (uno por línea). Separados del body por **una línea en blanco**.
3. **Body (cuerpo):** opcional. El tamaño lo indica `Content-Length` (o `Transfer-Encoding: chunked`).

### Partes de una petición

| Parte | Ejemplo | Notas |
|---|---|---|
| Método | `POST` | La acción a realizar |
| Path | `/v1/products` | Ruta del recurso |
| Versión | `HTTP/1.1` | Versión del protocolo |
| Headers | `Host`, `Content-Type`... | Metadatos |
| Body | `{"name": "Teclado"}` | Datos a enviar. Vacío en GET |

Con `curl -v` puedes ver la petición cruda:

```bash
curl -v -X POST https://api.tienda.com/v1/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Teclado","price":49.99}'
```

## Respuesta HTTP (response)

La respuesta del servidor:

```
HTTP/1.1 201 Created
Content-Type: application/json
Content-Length: 62
Location: /v1/products/99

{"id": 99, "name": "Teclado", "price": 49.99, "createdAt": "2026-08-22"}
```

Tres partes:

1. **Status line:** `HTTP/versión código reason-phrase`
2. **Headers**
3. **Body** (opcional)

| Parte | Ejemplo | Notas |
|---|---|---|
| Versión | `HTTP/1.1` | Coincide con la de la petición |
| Status code | `201` | Código numérico de 3 dígitos |
| Reason phrase | `Created` | Texto descriptivo (no lo usan los programas, solo humanos) |
| Headers | `Content-Type`, `Location`... | Metadatos |
| Body | `{"id": 99, ...}` | Representación del recurso |

## Métodos HTTP

| Método | Intención | Safe | Idempotente | Body en request |
|---|---|---|---|---|
| `GET` | Leer/obtener un recurso | Sí | Sí | No (no debería) |
| `POST` | Crear un recurso / disparar acción | No | No | Sí (normalmente) |
| `PUT` | Reemplazar por completo un recurso | No | Sí | Sí |
| `PATCH` | Modificar parcialmente un recurso | No | Sí (debería) | Sí |
| `DELETE` | Borrar un recurso | No | Sí | Opcional |
| `HEAD` | Como GET pero sin body | Sí | Sí | No |
| `OPTIONS` | Describir opciones de comunicación | Sí | Sí | No |

> **Safe** = no modifica datos del servidor (solo lectura). **Idempotente** = repetir la misma petición N veces produce el mismo resultado que una sola.

## Códigos de estado

Código de 3 dígitos. El primer dígito indica la familia:

| Familia | Significado | Ejemplos |
|---|---|---|
| **1xx** | Informativo | `100 Continue`, `101 Switching Protocols` |
| **2xx** | Éxito | `200 OK`, `201 Created`, `204 No Content` |
| **3xx** | Redirección | `301 Moved Permanently`, `304 Not Modified` |
| **4xx** | Error del cliente | `400 Bad Request`, `404 Not Found`, `401 Unauthorized` |
| **5xx** | Error del servidor | `500 Internal Server Error`, `503 Service Unavailable` |

> **Regla mnemotécnica:** 4xx = “tú la liaste”, 5xx = “yo (servidor) la lié”.

## Headers principales

| Header | Lado | Qué hace |
|---|---|---|
| `Host` | Request | Dominio del servidor. **Obligatorio en HTTP/1.1** (virtual hosting) |
| `Content-Type` | Ambos | Tipo MIME del body (`application/json`, `text/html`) |
| `Content-Length` | Ambos | Tamaño del body en bytes |
| `Accept` | Request | Tipos que el cliente acepta (`application/json`) |
| `Authorization` | Request | Credenciales (`Bearer eyJ...`, `Basic dXNlcjpwYXNz`) |
| `Cookie` | Request | Cookies que el cliente envía al servidor |
| `Set-Cookie` | Response | El servidor pide al cliente guardar una cookie |
| `User-Agent` | Request | Identifica al cliente (browser, librería) |
| `Location` | Response | URL del recurso creado/destino de redirección |

## Versiones de HTTP

| Versión | Año | Transporte | Características clave |
|---|---|---|---|
| **HTTP/1.0** | 1996 | TCP | Una conexión por petición. Se abre y se cierra TCP cada vez |
| **HTTP/1.1** | 1997 | TCP | **Keep-alive** (conexión reutilizable), **pipelining**, `Host` obligatorio, chunked transfer |
| **HTTP/2** | 2015 | TCP (sobre TLS en la práctica) | **Multiplexing** (varias peticiones en una conexión), **header compression (HPACK)**, binario, server push |
| **HTTP/3** | 2022 | **UDP + QUIC** | Sin head-of-line blocking, conexión más rápida (0-RTT), independencia de streams |

### HTTP/1.0 vs HTTP/1.1 (keep-alive)

En HTTP/1.0 cada petición abría una conexión TCP nueva (costoso: handshake TCP + TLS). HTTP/1.1 introdujo `Connection: keep-alive` para reutilizar la conexión:

```
GET /a HTTP/1.1
Host: ej.com
Connection: keep-alive

(otra petición por la misma conexión)
GET /b HTTP/1.1
Host: ej.com
```

### HTTP/2

- **Binario** (no texto plano): frames.
- **Multiplexing:** varias peticiones/respuestas en paralelo sobre **una** conexión TCP, sin bloquearse entre sí.
- **HPACK:** compresión de headers (los headers repetidos como `Cookie` se envían una sola vez).
- **Server push** (obsoleto en la práctica): el servidor podía enviar recursos antes de que se pidieran.

### HTTP/3 y QUIC

- Sobre **UDP**, no TCP. El protocolo **QUIC** implementa fiabilidad y encriptación (TLS 1.3 integrado) sobre UDP.
- **Sin head-of-line blocking**: si se pierde un paquete, solo se para ese stream, no toda la conexión.
- **0-RTT:** conexiones resumidas sin handshake completo.

## MIME types

Un **MIME type** (Media Type) describe el formato de un recurso: `tipo/subtipo`.

| MIME type | Significado |
|---|---|
| `text/html` | Documento HTML |
| `text/plain` | Texto plano |
| `application/json` | JSON (APIs modernas) |
| `application/xml` | XML |
| `application/x-www-form-urlencoded` | Datos de formulario HTML |
| `multipart/form-data` | Subida de archivos |
| `image/png`, `image/jpeg`, `image/webp` | Imágenes |
| `application/octet-stream` | Binario genérico (descargas) |

El header `Content-Type` lo indica:

```
Content-Type: application/json; charset=utf-8
```

## Tabla de referencia rápida

### Métodos

| Método | Uso típico | ¿Crea? | ¿Modifica? | ¿Borra? |
|---|---|---|---|---|
| GET | Listar/obtener | No | No | No |
| POST | Crear | Sí | No | No |
| PUT | Reemplazar | Sí (si no existe) | Sí | No |
| PATCH | Modificar parcial | No | Sí | No |
| DELETE | Borrar | No | No | Sí |

### Códigos más comunes

| Código | Nombre | Cuándo |
|---|---|---|
| 200 | OK | Petición exitosa |
| 201 | Created | Recurso creado (POST/PUT) |
| 204 | No Content | Éxito sin body (DELETE, PUT) |
| 301 | Moved Permanently | Redirección permanente |
| 304 | Not Modified | Caché válida, no reenviar body |
| 400 | Bad Request | Sintaxis incorrecta |
| 401 | Unauthorized | Falta auth |
| 403 | Forbidden | Auth ok, pero sin permiso |
| 404 | Not Found | Recurso no existe |
| 500 | Internal Server Error | Error del servidor |

## Ejemplo completo con curl

Petición GET:

```bash
curl -v https://api.tienda.com/v1/products/99
```

Petición y respuesta crudas (lo que viaja por el cable):

```http
GET /v1/products/99 HTTP/1.1
Host: api.tienda.com
Accept: application/json
User-Agent: curl/8.0
```

```http
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 78

{"id": 99, "name": "Teclado", "price": 49.99, "createdAt": "2026-08-22"}
```

POST con JSON:

```bash
curl -v -X POST https://api.tienda.com/v1/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Ratón","price":19.99}'
```

## Conceptos clave

- **HTTP es sin estado:** cada petición es independiente. Las cookies/sessiones aportan estado por encima del protocolo.
- **El método expresa la intención:** GET lee, POST crea, PUT reemplaza, PATCH modifica, DELETE borra.
- **El código de estado comunica el resultado:** 2xx éxito, 4xx tu culpa, 5xx culpa del servidor.
- **Los headers son metadatos:** todo lo que no es método/ruta/body va en headers.
- **`Host` es obligatorio en HTTP/1.1:** permite alojar varios dominios en la misma IP.
- **El fragment de la URL no viaja al servidor.**
- **HTTP/2 y HTTP/3 resuelven el rendimiento:** multiplexing, compresión de headers, QUIC sobre UDP.

## Errores comunes

- **Poner body en un GET.** Aunque técnicamente es posible, rompe caches, proxies y la semántica. Usa POST si necesitas enviar body.
- **Confundir 401 y 403.** `401` = “no sé quién eres” (falta auth). `403` = “sé quién eres, pero no puedes”.
- **Usar `200 OK` para un recurso creado.** Lo correcto es `201 Created` con `Location`.
- **Olvidar `Content-Type` en un POST/PUT.** Sin él, el servidor no sabe cómo parsear el body.
- **Devolvolver `200` con un cuerpo de error.** Si algo falla, el código debe reflejarlo (4xx/5xx), no un 200 con `{"error": ...}`.
- **Pensar que `Content-Length` es opcional.** Si el servidor lo omite, el cliente no sabe dónde acaba el body (salvo chunked).
- **Mezclar `GET` con副作用.** Un GET que modifica datos rompe la idempotencia y la caché.
- **Confundir path y query.** El path identifica el recurso (`/products/99`); el query filtra/modifica (`?include=category`).
- **Olvidar el `Host` header** al probar a mano con `nc`/`telnet`.

## Siguiente

Continúa con [02 — Métodos y Códigos](02-metodos-y-codigos.md) para profundizar en la semántica de cada método y código de estado.
