# HTTP

> Guía de estudio + ejercicios por niveles. El protocolo HTTP de 0 a experto: peticiones, respuestas, métodos, códigos, headers, cookies, CORS, caché, autenticación, seguridad y evolución (HTTP/2, HTTP/3, WebSockets, SSE, gRPC).

## Guías

| Guía | Qué cubre |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Qué es HTTP, modelo cliente-servidor, URL, petición y respuesta HTTP, métodos, códigos de estado, headers principales, versiones HTTP/1.0·1.1·2·3, MIME types |
| [02 — Métodos y Códigos](02-metodos-y-codigos.md) | Métodos en detalle (safe/unsafe, idempotentes), semántica de cada método, códigos de estado en detalle, headers de petición y respuesta, PUT vs PATCH |
| [03 — Headers, Cookies y CORS](03-headers-cookies-y-cors.md) | Headers en profundidad, content negotiation, cookies y atributos, CORS y preflight, caché HTTP (ETag, If-None-Match, 304) |
| [04 — Autenticación y Seguridad](04-autenticacion-y-seguridad.md) | Auth HTTP (Basic/Bearer/Digest), sesiones vs tokens, JWT, OAuth 2.0, headers de seguridad, HTTPS y TLS, rate limiting |
| [05 — WebSockets y Evolución](05-websockets-y-evolucion.md) | WebSockets, SSE, polling vs SSE vs WebSocket, GraphQL sobre HTTP, gRPC y Protobuf, HTTP/2, HTTP/3 y QUIC, comparativa REST vs GraphQL vs gRPC |

## Ejercicios

Ver [ejercicios/](ejercicios/)

| Nivel | Qué cubre | Estado |
|---|---|---|
| [nivel-01-fundamentos](ejercicios/nivel-01-fundamentos/) | GET con curl, métodos HTTP, códigos 200/404, Content-Type, estructura de URL, body en POST | ⬜ |
| [nivel-02-basico](ejercicios/nivel-02-basico/) | Query params, POST con JSON, PUT, DELETE, códigos 201/204, Accept y content negotiation | ⬜ |
| [nivel-03-intermedio](ejercicios/nivel-03-intermedio/) | Cookies, CORS preflight, caché con ETag/304, redirecciones 301/302, auth Basic, Last-Modified | ⬜ |
| [nivel-04-avanzado](ejercicios/nivel-04-avanzado/) | JWT decode/verify, OAuth flow, headers de seguridad, rate limiting, HTTPS/TLS, Bearer y scopes | ⬜ |
| [nivel-05-experto](ejercicios/nivel-05-experto/) | WebSocket, SSE con python3, REST vs GraphQL vs gRPC, HTTP/2 multiplexing, API REST completa, GraphQL sobre HTTP | ⬜ |
| [proyectos](ejercicios/proyectos/) | Servidor HTTP desde cero en Node.js | ⬜ |
