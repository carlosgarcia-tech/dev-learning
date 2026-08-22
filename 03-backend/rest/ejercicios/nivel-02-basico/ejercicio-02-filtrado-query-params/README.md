# Ejercicio 02 — Filtrado por query params

- **Nivel:** 2/5
- **Tema:** Filtrado de colecciones con query params
- **Tiempo estimado:** 15 min

## Enunciado

Implementa la respuesta de `GET /products?category=perifericos&in_stock=true` que filtra productos por categoría y disponibilidad. La respuesta debe:

- Devolver status **200**.
- `body.data` contiene solo los productos que cumplen ambos filtros.
- Cada producto incluye `category` y `stock` (para verificar el filtro).

## Requisitos

- [ ] El status es **200**
- [ ] Todos los productos en `body.data` tienen `category == "perifericos"`
- [ ] Todos los productos en `body.data` tienen `stock > 0`
- [ ] `body.data` no está vacío
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los filtros por igualdad van directos: `?category=perifericos`.
- Para "en stock" puedes usar un booleano `in_stock=true` que el servidor traduce a `stock > 0`.
- Devuelve solo los que cumplen **todos** los filtros (AND).

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
      { "id": "prod_001", "name": "Teclado mecánico", "price": 89.90, "category": "perifericos", "stock": 15 },
      { "id": "prod_002", "name": "Ratón", "price": 19.90, "category": "perifericos", "stock": 30 }
    ],
    "pagination": { "limit": 20, "offset": 0, "total": 2 }
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
