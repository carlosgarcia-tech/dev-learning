# Ejercicio 01 — Rate limiting

- **Nivel:** 4/5
- **Tema:** Limitación de peticiones (429)
- **Tiempo estimado:** 20 min

## Enunciado

Implementa la respuesta cuando un cliente supera el rate limit (100 peticiones/minuto). La petición `GET /products` ha superado el límite.

La respuesta debe:

- Devolver status **429 Too Many Requests**.
- Cabecera `Retry-After` (segundos a esperar).
- Cabeceras `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`.
- Un body de error con `code: "rate_limit_exceeded"`.

## Requisitos

- [ ] El status es **429**
- [ ] `headers.Retry-After` es un entero > 0
- [ ] `headers.X-RateLimit-Limit` = 100
- [ ] `headers.X-RateLimit-Remaining` = 0
- [ ] `body.code` es `"rate_limit_exceeded"`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- 429 indica que el cliente hace demasiadas peticiones.
- `Retry-After` dice cuántos segundos esperar antes de reintentar.
- Las cabeceras `X-RateLimit-*` deben ir en **todas** las respuestas (no solo en 429) para que el cliente se autorregule.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````json
{
  "status": 429,
  "headers": {
    "Content-Type": "application/problem+json",
    "Retry-After": 60,
    "X-RateLimit-Limit": 100,
    "X-RateLimit-Remaining": 0,
    "X-RateLimit-Reset": 1700000060
  },
  "body": {
    "type": "https://docs.api.example/errors/rate-limit",
    "title": "Too Many Requests",
    "status": 429,
    "code": "rate_limit_exceeded",
    "detail": "Has superado el límite de 100 peticiones por minuto",
    "message": "Demasiadas peticiones, reintenta en 60s"
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
