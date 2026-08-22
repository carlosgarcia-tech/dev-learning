# Ejercicio 04 — Soft delete

- **Nivel:** 3/5
- **Tema:** Borrado lógico con `deletedAt`
- **Tiempo estimado:** 20 min

## Enunciado

Implementa el **soft delete** de un producto. La petición `DELETE /products/prod_001` no borra el recurso físicamente, sino que lo marca como borrado.

Implementa dos respuestas:

1. `respuesta_delete.json`: respuesta del `DELETE` (status 204 o 200 con confirmación).
2. `respuesta_get_despues.json`: respuesta de `GET /products/prod_001` **después** del soft delete. Como por defecto los productos borrados no aparecen, devuelve **404** con un body de error.

Además, indica en `respuesta_get_con_include.json` qué devolverías con `?include=deleted` (el producto con `deletedAt` seteado y `deleted: true`).

## Requisitos

- [ ] `respuesta_delete.json`: status 204 (sin body) o 200 (con confirmación y `deletedAt`)
- [ ] `respuesta_get_despues.json`: status **404** (el recurso borrado no se ve por defecto)
- [ ] `respuesta_get_con_include.json`: status 200, `body.deleted` = true y `body.deletedAt` no es null
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Soft delete: setea `deletedAt` (timestamp) y/o `deleted: true`; no elimina la fila.
- Las consultas por defecto filtran `WHERE deletedAt IS NULL`, así que el recurso "borrado" da 404.
- Con `?include=deleted` se ven también los borrados.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta_delete.json`:
````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": { "id": "prod_001", "deleted": true, "deletedAt": "2024-01-15T12:00:00Z" }
}
````

`respuesta_get_despues.json`:
````json
{
  "status": 404,
  "headers": { "Content-Type": "application/problem+json" },
  "body": { "type": "https://docs.api.example/errors/not-found", "title": "Not Found", "status": 404, "detail": "Producto prod_001 no existe" }
}
````

`respuesta_get_con_include.json`:
````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": {
    "id": "prod_001",
    "name": "Teclado mecánico",
    "price": 89.90,
    "deleted": true,
    "deletedAt": "2024-01-15T12:00:00Z"
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
