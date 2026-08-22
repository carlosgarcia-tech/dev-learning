# Ejercicio 05 — Manejo de errores 404/400

- **Nivel:** 2/5
- **Tema:** Respuestas de error RESTful
- **Tiempo estimado:** 15 min

## Enunciado

Implementa dos respuestas de error para la API de productos:

1. `respuesta_404.json`: `GET /products/prod_999` cuando el producto no existe.
2. `respuesta_400.json`: `POST /products` con un body que **no es JSON válido** (JSON mal formado).

Ambas deben usar bodies de error RESTful (RFC 7807) con `type`, `title`, `status`, `detail`.

## Requisitos

- [ ] `respuesta_404.json`: status **404**, body con `type`, `title`, `status`, `detail`
- [ ] `respuesta_400.json`: status **400**, body con `type`, `title`, `status`, `detail`
- [ ] Ambos usan `Content-Type: application/problem+json`
- [ ] El `detail` del 404 menciona el id no encontrado
- [ ] El `detail` del 400 menciona JSON mal formado
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- 404 = recurso no existe; 400 = petición mal formada (JSON inválido, sintaxis).
- RFC 7807 usa `application/problem+json` y los campos `type`, `title`, `status`, `detail`.
- El `detail` debe ser específico de la instancia, no genérico.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

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

`respuesta_400.json`:
````json
{
  "status": 400,
  "headers": { "Content-Type": "application/problem+json" },
  "body": {
    "type": "https://docs.api.example/errors/bad-request",
    "title": "Bad Request",
    "status": 400,
    "detail": "El cuerpo de la petición no es JSON válido"
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
