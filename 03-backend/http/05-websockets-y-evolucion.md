# 05 — WebSockets y Evolución

> WebSockets, Server-Sent Events (SSE), polling vs SSE vs WebSocket, GraphQL sobre HTTP, gRPC y Protocol Buffers, HTTP/2 (multiplexing, server push, HPACK), HTTP/3 y QUIC, y comparativa REST vs GraphQL vs gRPC.

## Objetivos

- [ ] Entender **WebSockets**: upgrade handshake, frames, ping/pong, close.
- [ ] Entender **Server-Sent Events (SSE)** y cuándo usarlos.
- [ ] Comparar **polling, long polling, SSE y WebSocket**.
- [ ] Explicar **GraphQL sobre HTTP** (una sola ruta, query/mutation, errores).
- [ ] Explicar **gRPC** y **Protocol Buffers**.
- [ ] Entender **HTTP/2**: multiplexing, server push, compresión de headers (HPACK).
- [ ] Entender **HTTP/3** y **QUIC**.
- [ ] Comparar **REST vs GraphQL vs gRPC**.

## WebSockets

**WebSocket** es un protocolo que proporciona **comunicación bidireccional, full-duplex, persistente** sobre una sola conexión TCP. A diferencia de HTTP (petición→respuesta), WebSocket permite que servidor y cliente se envíen mensajes en cualquier momento.

### Upgrade handshake

WebSocket **nace sobre HTTP**: la primera petición es un GET normal con headers especiales que piden “upgrade”. Si el servidor acepta, la conexión TCP deja de ser HTTP y pasa a ser WebSocket.

```http
GET /chat HTTP/1.1
Host: chat.ejemplo.com
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Sec-WebSocket-Version: 13
```

El servidor responde con **101 Switching Protocols**:

```http
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
```

A partir de aquí, la conexión es WebSocket: cualquier parte puede enviar frames en cualquier momento.

> El `Sec-WebSocket-Accept` se calcula concatenando el `Sec-WebSocket-Key` con un GUID fijo y aplicando SHA-1 + Base64. Confirma que el servidor entiende WebSocket.

### Frames

Una vez upgradeada la conexión, los datos viajan en **frames** binarios. No son texto HTTP.

| Opcode | Tipo de frame |
|---|---|
| `0x0` | Continuación (frame fragmentado) |
| `0x1` | Texto (UTF-8) |
| `0x2` | Binario |
| `0x8` | Cierre (close) |
| `0x9` | Ping |
| `0xA` | Pong |

### Ping / Pong

Para mantener viva la conexión y detectar caídas, una parte envía un **ping** (`0x9`) y la otra responde con **pong** (`0xA`). Si no llega el pong, se considera que la conexión murió.

### Close

Para cerrar limpiamente, se envía un frame **close** (`0x8`) con un código de estado (ej. `1000` = cierre normal, `1001` = se va, `1011` = error del servidor).

### Ejemplo conceptual (Node.js)

```js
import { WebSocketServer } from "ws";

const wss = new WebSocketServer({ port: 8080 });
wss.on("connection", (ws) => {
  ws.send("Bienvenido al chat");
  ws.on("message", (msg) => {
    wss.clients.forEach((c) => c.send(msg.toString())); // broadcast
  });
});
```

### Cuándo usar WebSockets

- Chat en tiempo real.
- Juegos multijugador.
- Dashboards con actualizaciones instantáneas.
- Colaboración en vivo (editores, pizarras).
- Streaming de datos de baja latencia.

> **No abuses:** WebSockets rompen la infraestructura HTTP (cachés, proxies, balanceo). Úsalos solo cuando el servidor deba empujar datos con baja latencia.

## Server-Sent Events (SSE)

**SSE** es un mecanismo **unidireccional servidor→cliente** sobre HTTP. El servidor mantiene una conexión abierta y envía eventos en formato texto. El cliente solo escucha.

```http
GET /events HTTP/1.1
Host: api.ejemplo.com
Accept: text/event-stream
```

```http
HTTP/1.1 200 OK
Content-Type: text/event-stream
Cache-Control: no-cache
Connection: keep-alive

data: {"msg":"hola"}

data: {"msg":"adiós"}

```

Formato de los eventos:

```
event: mensaje
id: 42
data: {"texto":"hola"}

```

- Cada evento se separa con **dos saltos de línea** (`\n\n`).
- El campo `id` permite al cliente reanudar enviando `Last-Event-ID`.
- El browser auto-reconecta si la conexión cae.

### SSE en el browser

```js
const es = new EventSource("/events");
es.onmessage = (e) => console.log(e.data);
es.addEventListener("mensaje", (e) => console.log(e.data));
```

### SSE con Python (servidor mínimo)

```python
from http.server import BaseHTTPRequestHandler, HTTPServer
import time, json

class SSEHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/events":
            self.send_response(404); self.end_headers(); return
        self.send_response(200)
        self.send_header("Content-Type", "text/event-stream")
        self.send_header("Cache-Control", "no-cache")
        self.send_header("Connection", "keep-alive")
        self.end_headers()
        i = 0
        try:
            while True:
                i += 1
                msg = json.dumps({"count": i, "time": int(time.time())})
                self.wfile.write(f"data: {msg}\n\n".encode())
                self.wfile.flush()
                time.sleep(1)
        except BrokenPipeError:
            pass

HTTPServer(("localhost", 8080), SSEHandler).serve_forever()
```

### Cuándo usar SSE

- Notificaciones push simples (servidor→cliente).
- Feeds en vivo (noticias, deportes).
- Logs en streaming.
- Progreso de tareas largas (build, import).

## Polling vs long polling vs SSE vs WebSocket

| | Polling | Long polling | SSE | WebSocket |
|---|---|---|---|---|
| Dirección | Cliente pide | Cliente pide, servidor responde cuando hay dato | Servidor→cliente | Bidireccional |
| Latencia | Alta (se pregunta cada N s) | Media | Baja | Muy baja |
| Complejidad | Muy simple | Simple | Media | Media-alta |
| Protocolo | HTTP | HTTP | HTTP | WS (sobre HTTP) |
| Reutiliza infra HTTP | Sí | Sí | Sí | Parcial (proxies) |
| Escala | Mal (muchas peticiones) | Regular | Bien | Bien |

### Polling

El cliente pregunta periódicamente:

```js
setInterval(() => fetch("/updates"), 5000); // cada 5s
```

- Simple pero genera mucho tráfico inútil y latencia alta.

### Long polling

El cliente hace una petición y el servidor **la mantiene abierta** hasta que hay algo que enviar (o timeout):

```http
GET /updates?wait=30 HTTP/1.1
```

El servidor responde cuando hay un evento o a los 30s. El cliente re-pide enseguida. Mejor que el polling simple pero sigue siendo costoso.

### Decisión

- **Notificaciones servidor→cliente** → SSE (simple, sobre HTTP).
- **Bidireccional tiempo real** (chat, juego) → WebSocket.
- **Casual, sin datos push** → polling (más simple).

## GraphQL sobre HTTP

**GraphQL** es un **lenguaje de consulta** para APIs. Sustituye los muchos endpoints REST por **uno solo** (`/graphql`) al que se envía una query en JSON.

### Petición

```http
POST /graphql HTTP/1.1
Host: api.ejemplo.com
Content-Type: application/json

{
  "query": "{ user(id: 42) { name email posts { title } } }"
}
```

### Respuesta

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "data": {
    "user": {
      "name": "Ana",
      "email": "ana@ejemplo.com",
      "posts": [{"title": "Hola"}]
    }
  }
}
```

### Errores GraphQL

GraphQL devuelve **200 OK incluso con errores**, agrupándolos en `errors`:

```json
{
  "data": null,
  "errors": [{"message": "Usuario no encontrado", "path": ["user"]}]
}
```

### Mutaciones

Para escribir datos se usan **mutations**:

```http
POST /graphql
{
  "query": "mutation { createPost(title:\"Hola\",body:\"...\"){ id title } }"
}
```

### Características

- **Un endpoint** para todo.
- El cliente pide **exactamente** los campos que necesita (evita over-fetching/under-fetching).
- **Tipado fuerte** y schema autodescriptivo.
- Normalmente sobre POST; se puede usar GET con la query en el query string (para caché HTTP).

## gRPC y Protocol Buffers

**gRPC** es un framework RPC (Remote Procedure Call) de Google. Usa **HTTP/2** como transporte y **Protocol Buffers (Protobuf)** como formato de serialización binaria.

### Protocol Buffers

Definición del servicio en un archivo `.proto`:

```proto
syntax = "proto3";

service ProductService {
  rpc GetProduct (ProductRequest) returns (Product);
  rpc ListProducts (Empty) returns (ProductList);
}

message ProductRequest { int32 id = 1; }
message Product { int32 id = 1; string name = 2; double price = 3; }
message ProductList { repeated Product products = 1; }
```

Se compila a código en varios lenguajes (Go, Java, Python, Node...). El cliente llama a métodos como si fueran locales:

```python
stub = ProductServiceStub(channel)
product = stub.GetProduct(ProductRequest(id=42))
```

### Características de gRPC

- **Binario y compacto:** Protobuf serializa a menos bytes que JSON.
- **HTTP/2:** multiplexing, streams bidireccionales.
- **Tipado fuerte** con contrato `.proto` compartido.
- **Soporta streaming:** unidireccional server, bidireccional.
- **Ideal para microservicios** internos (latencia baja, alto rendimiento).

### gRPC vs REST

| | gRPC | REST |
|---|---|---|
| Formato | Protobuf (binario) | JSON (texto) |
| Transporte | HTTP/2 | HTTP/1.1 o HTTP/2 |
| Contrato | `.proto` estricto | Flexible (OpenAPI opcional) |
| Browser | Requiere gRPC-Web (proxy) | Nativo |
| Streaming | Sí, bidireccional | No nativo |
| Latencia | Muy baja | Media |

## HTTP/2

Publicado en 2015. Es **binario** (no texto plano) y multiplexa sobre una sola conexión TCP.

### Multiplexing

En HTTP/1.1, para pedir 3 recursos rápidamente había que abrir varias conexiones TCP (o pipelining limitado). HTTP/2 permite **varios streams paralelos** en una conexión: cada petición/respuesta es un stream numerado, sin bloquearse entre sí.

```
Una conexión TCP
├── stream 1: GET /index.html
├── stream 3: GET /style.css
└── stream 5: GET /script.js
```

### Header compression (HPACK)

Los headers HTTP son repetitivos (`Cookie`, `User-Agent`...). HTTP/2 comprime con **HPACK**: mantiene un diccionario de headers vistos y envía solo índices/deltas.

### Server push (obsoleto)

El servidor podía enviar recursos antes de que se pidieran (ej. manda el CSS junto con el HTML). En la práctica apenas se usaba bien y se removió de los browsers en 2022.

### Frames y streams

HTTP/2 estructura el tráfico en **frames** binarios. Cada frame pertenece a un **stream**. Hay frames de headers, data, settings, ping, etc.

## HTTP/3 y QUIC

**HTTP/3** (2022) cambia el transporte: en vez de TCP, usa **QUIC** sobre **UDP**.

### QUIC

- Protocolo de transporte sobre UDP con fiabilidad y **TLS 1.3 integrado**.
- **Sin head-of-line blocking:** si se pierde un paquete de un stream, solo se bloquea ese stream, no toda la conexión.
- **0-RTT:** conexiones resumidas pueden enviar datos en el primer paquete (sin handshake completo).
- **Migración de conexión:** si cambias de red (WiFi→4G), la conexión sobrevive porque se identifica por un connection ID, no por la IP.

### Por qué UDP

TCP acopla fiabilidad y orden a toda la conexión. QUIC implementa fiabilidad por stream sobre UDP, ganando flexibilidad. Esto elimina el head-of-line blocking de HTTP/2.

## Comparativa REST vs GraphQL vs gRPC

| | REST | GraphQL | gRPC |
|---|---|---|---|
| Modelo | Recursos y verbos HTTP | Query language | RPC |
| Formato | JSON | JSON | Protobuf (binario) |
| Transporte | HTTP/1.1 o HTTP/2 | HTTP (POST /graphql) | HTTP/2 |
| Endpoint | Muchos | Uno | Métodos del servicio |
| Tipado | Flexible (OpenAPI opcional) | Schema obligatorio | `.proto` estricto |
| Over-fetching | Común | Evitado | N/A |
| Streaming | No | Subscriptions (WS) | Nativo bidireccional |
| Browser | Excelente | Excelente | Necesita gRPC-Web |
| Caché HTTP | Nativo (ETag, Cache-Control) | Difícil (POST) | No |
| Caso de uso | APIs públicas | Datos complejos con muchas vistas | Microservicios internos |

### Cuándo elegir qué

- **REST:** API pública, browser, mobile, con caché HTTP estándar. El default.
- **GraphQL:** Cuando los clientes necesitan formas muy variadas de los datos (web vs móvil con campos distintos) o agregan muchos servicios.
- **gRPC:** Comunicación entre microservicios internos donde el rendimiento y el contrato estricto importan.

## Tabla de referencia rápida

### Tecnologías de tiempo real

| Tecnología | Dirección | Protocolo | Reconexión nativa |
|---|---|---|---|
| Polling | Cliente→servidor | HTTP | — |
| Long polling | Cliente→servidor (retenido) | HTTP | Manual |
| SSE | Servidor→cliente | HTTP | Sí (`Last-Event-ID`) |
| WebSocket | Bidireccional | WS sobre HTTP | Manual |

### Versiones HTTP

| Versión | Transporte | Clave |
|---|---|---|
| HTTP/1.0 | TCP | 1 conexión por petición |
| HTTP/1.1 | TCP | keep-alive, `Host` |
| HTTP/2 | TCP (TLS) | multiplexing, HPACK |
| HTTP/3 | UDP (QUIC) | sin HoL blocking, 0-RTT |

## Conceptos clave

- **WebSockets** ofrecen canal bidireccional full-duplex tras un upgrade HTTP (101 Switching Protocols).
- **SSE** es más simple para push servidor→cliente, reutiliza HTTP y reconecta solo.
- **Polling es simple pero ineficiente; SSE y WebSocket son las opciones serias para tiempo real.**
- **GraphQL** unifica todo en un endpoint POST; el cliente pide solo lo que necesita; los errores van con HTTP 200.
- **gRPC** usa Protobuf binario sobre HTTP/2, ideal para microservicios internos; no es nativo del browser.
- **HTTP/2 multiplexa streams** en una conexión y comprime headers con HPACK.
- **HTTP/3** sobre QUIC/UDP elimina el head-of-line blocking y permite 0-RTT.
- **REST cachea bien; GraphQL no (POST); gRPC no usa caché HTTP.**
- **La elección de arquitectura depende del contexto:** pública (REST), datos complejos (GraphQL), interno alto rendimiento (gRPC).

## Errores comunes

- **Usar WebSockets para todo.** Si solo necesitas push servidor→cliente, SSE es más simple y compatible con la infraestructura HTTP.
- **Olvidar ping/pong en WebSocket.** Sin keepalive, proxies cerrarán conexiones inactivas por timeout.
- **Pensar que SSE es bidireccional.** No lo es: el cliente solo escucha.
- **Tratar los errores de GraphQL como fallos HTTP.** GraphQL devuelve 200 con `errors`; revisa el body, no el status.
- **Usar GraphQL por moda** cuando REST + caché HTTP serviría mejor.
- **Intentar gRPC en el browser sin gRPC-Web.** No funciona nativamente.
- **Olvidar que HTTP/2 requiere TLS** en la práctica (todos los browsers lo exigen sobre HTTPS).
- **Pensar que HTTP/3 es “solo más rápido” siempre.** Sus ventajas destacan en conexiones inestables y mobile.
- **No versionar el `.proto`.** Cambios incompatibles rompen clientes gRPC sin warning.
- **Comparar latencias de REST vs gRPC** sin contar la serialización. Protobuf es más rápido, pero el cuello de botella suele ser la red o la BD.

## Cierre

Has completado el recorrido de HTTP: desde la petición en texto plano hasta HTTP/3 sobre QUIC, pasando por métodos, códigos, headers, cookies, CORS, caché, autenticación, JWT, OAuth, TLS y las arquitecturas modernas. El siguiente paso es practicar en los [ejercicios](ejercicios/) y construir el [servidor HTTP desde cero](ejercicios/proyectos/) en Node.js.
