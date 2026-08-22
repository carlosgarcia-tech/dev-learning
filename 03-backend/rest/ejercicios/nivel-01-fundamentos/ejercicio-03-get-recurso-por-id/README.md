# Ejercicio 03 — GET recurso por id

- **Nivel:** 1/5
- **Tema:** Lectura de un recurso individual
- **Tiempo estimado:** 10 min

## Enunciado

Implementa la respuesta de `GET /products/prod_001`. La respuesta debe:

- Devolver status **200 OK** con `Content-Type: application/json`.
- El `body` es un objeto con `id`, `name`, `price`, `stock` y `createdAt` (ISO 8601 UTC).
- El `id` del cuerpo debe coincidir con el solicitado (`prod_001`).

Además, indica en `respuesta_404.json` qué responderías si el producto no existe (status y body de error RESTful).

## Requisitos

- [ ] El status es **200**
- [ ] `headers.Content-Type` es `application/json`
- [ ] `body.id` coincide con `prod_001`
- [ ] `body` tiene `name`, `price` (numérico), `stock` (entero), `createdAt` (ISO 8601 con `Z`)
- [ ] El error 404 usa un body con `type`, `title`, `status` y `detail`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El id del path y el del body deben ser iguales.
- `createdAt` en ISO 8601 UTC termina en `Z`: `"2024-01-15T10:30:00Z"`.
- El error 404 sigue RFC 7807: `type` (URI de doc), `title`, `status`, `detail`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json`:
````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": {
    "id": "prod_001",
    "name": "Teclado mecánico",
    "price": 89.90,
    "stock": 15,
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
````

`respuesta_404.json`:
````json
{
  "status": 404,
  "headers": { "Content-Type": "application/problem+json" },
  "body": {
    "type": "https://docs.api.example/errors/not-found",
    "title": "Not Found",
    "status": 404,
    "detail": "Producto prod_999 no existe"
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
