# Ejercicios — HTTP

Cada ejercicio tiene enunciado, requisitos, pistas y solución (plegables). Los `test.sh` validan con `python3` y, cuando corres, levantan un servidor de prueba con `python3` y lo consultan con `curl`.

| Nivel | Qué cubre | Estado |
|---|---|---|
| [nivel-01-fundamentos](nivel-01-fundamentos/) | GET con curl, métodos HTTP, códigos 200/404, Content-Type, estructura de URL, body en POST | ⬜ |
| [nivel-02-basico](nivel-02-basico/) | Query params, POST con JSON, PUT, DELETE, códigos 201/204, Accept y content negotiation | ⬜ |
| [nivel-03-intermedio](nivel-03-intermedio/) | Cookies, CORS preflight, caché con ETag/304, redirecciones 301/302, auth Basic, Last-Modified | ⬜ |
| [nivel-04-avanzado](nivel-04-avanzado/) | JWT decode/verify, OAuth flow, headers de seguridad, rate limiting, HTTPS/TLS, Bearer y scopes | ⬜ |
| [nivel-05-experto](nivel-05-experto/) | WebSocket, SSE con python3, REST vs GraphQL vs gRPC, HTTP/2 multiplexing, API REST completa, GraphQL sobre HTTP | ⬜ |
| [proyectos](proyectos/) | Servidor HTTP desde cero en Node.js | ⬜ |

## Cómo usar los ejercicios

1. Entra a la carpeta del ejercicio.
2. Lee el `README.md` con el enunciado y requisitos.
3. Examina `peticiones.http` (peticiones HTTP de ejemplo) y `expected.json` (la salida esperada).
4. Ejecuta `bash test.sh` para validar.

```bash
cd 03-backend/http/ejercicios/nivel-01-fundamentos/ejercicio-01-peticion-get-curl
bash test.sh
```

> Los `test.sh` requieren `python3`. Algunos además levantan un servidor de prueba (`server.sh`) y lo consultan con `curl`. Los scripts matan el servidor al terminar.

## Requisitos de entorno

- `python3` (obligatorio).
- `curl` (para los ejercicios que consultan un servidor).
- `bash` 4+.

Comprueba que los tienes:

```bash
python3 --version
curl --version
bash --version | head -1
```
