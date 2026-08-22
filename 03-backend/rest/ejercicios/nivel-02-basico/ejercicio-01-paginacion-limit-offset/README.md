# Ejercicio 01 — Paginación con limit/offset

- **Nivel:** 2/5
- **Tema:** Paginación offset clásica
- **Tiempo estimado:** 15 min

## Enunciado

Implementa la respuesta de `GET /products?limit=2&offset=2` sobre un total de 5 productos. La respuesta debe:

- Devolver status **200**.
- `body.data` con los productos correspondientes a esa página (2 elementos).
- `body.pagination` con `limit`, `offset`, `total` y `next` (URL de la página siguiente si la hay).

## Requisitos

- [ ] El status es **200**
- [ ] `body.data` tiene exactamente 2 elementos
- [ ] `pagination.limit` = 2 y `pagination.offset` = 2
- [ ] `pagination.total` = 5
- [ ] `pagination.next` es una URL que apunta a `offset=4` (o `null`/ausente si no hay más)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Con `limit=2, offset=2` sobre 5 elementos, devuelves los productos #3 y #4 (índices 2 y 3).
- `next` apunta a la siguiente página: `offset + limit = 4`.
- Si `offset + limit >= total`, no hay `next` (o es `null`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": {
    "data": [
      { "id": "prod_003", "name": "Monitor", "price": 199.90 },
      { "id": "prod_004", "name": "Webcam", "price": 45.50 }
    ],
    "pagination": {
      "limit": 2,
      "offset": 2,
      "total": 5,
      "next": "/products?limit=2&offset=4"
    }
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
