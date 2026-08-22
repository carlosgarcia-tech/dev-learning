# Ejercicio 02 — GET lista de recursos

- **Nivel:** 1/5
- **Tema:** Lectura de colecciones con GET
- **Tiempo estimado:** 10 min

## Enunciado

Implementa la respuesta de `GET /products` (lista de productos). La respuesta debe:

- Devolver status **200 OK**.
- Incluir `Content-Type: application/json`.
- Envolver los datos en un objeto `body.data` (un array), no devolver un array "pelón".
- Incluir metadatos de paginación en `body.pagination` con `limit`, `offset` y `total`.

Escribe la respuesta esperada en `respuesta.json` siguiendo el sobre:

```json
{ "status": 200, "headers": {...}, "body": { "data": [...], "pagination": {...} } }
```

## Requisitos

- [ ] El status es **200**
- [ ] `headers.Content-Type` es `application/json`
- [ ] `body.data` es un array con al menos 1 producto
- [ ] Cada producto tiene `id`, `name` y `price`
- [ ] `body.pagination` tiene `limit`, `offset` y `total` (números)
- [ ] No se devuelve un array pelón (está envuelto en `body.data`)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un array pelón `[...]` no permite añadir metadatos sin romper clientes; envuélvelo en `{ "data": [...], "pagination": {...} }`.
- `total` es el número total de recursos (no los de esta página).
- `limit` y `offset` reflejan los de la petición (defaults: 20 y 0).
- `price` es numérico, no string.

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
      { "id": "prod_001", "name": "Teclado mecánico", "price": 89.90 },
      { "id": "prod_002", "name": "Ratón", "price": 19.90 },
      { "id": "prod_003", "name": "Monitor", "price": 199.90 }
    ],
    "pagination": { "limit": 20, "offset": 0, "total": 3 }
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
