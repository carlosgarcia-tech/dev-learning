# Ejercicio 04 — API gateway

- **Nivel:** 5/5
- **Tema:** API Gateway y cross-cutting concerns
- **Tiempo estimado:** 30 min

## Enunciado

Diseña la configuración de un **API gateway** que enruta peticiones a dos microservicios: `products-service` y `orders-service`. Escribe en `respuesta.json` un objeto que describa:

- `routes`: lista de rutas, cada una con `path` (prefijo), `service` (upstream) y `methods` (lista).
- `crossCutting`: lista de responsabilidades transversales que el gateway aplica (auth, rate limiting, cors, logging, etc.).
- `defaults`: defaults globales (rate limit por minuto, timeout en segundos).

## Requisitos

- [ ] `respuesta.json` tiene `routes`, `crossCutting` y `defaults`
- [ ] `routes` incluye al menos 2 rutas: una a `products-service` y otra a `orders-service`
- [ ] Cada ruta tiene `path`, `service` y `methods` (array)
- [ ] `crossCutting` incluye `auth`, `rateLimiting`, `cors` y `logging`
- [ ] `defaults` tiene `rateLimitPerMinute` y `timeoutSeconds`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El gateway centraliza concerns transversales para que los microservicios sean simples.
- Routing: `/products/*` → products-service, `/orders/*` → orders-service.
- Auth: el gateway valida el JWT antes de reenviar; los servicios confían en las cabeceras inyectadas.
- Rate limiting, CORS, logging y timeouts se configuran en el gateway.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````json
{
  "routes": [
    { "path": "/products", "service": "products-service", "methods": ["GET", "POST", "PUT", "PATCH", "DELETE"] },
    { "path": "/orders", "service": "orders-service", "methods": ["GET", "POST", "PUT", "PATCH", "DELETE"] }
  ],
  "crossCutting": ["auth", "rateLimiting", "cors", "logging", "caching", "compression"],
  "defaults": {
    "rateLimitPerMinute": 1000,
    "timeoutSeconds": 30
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
