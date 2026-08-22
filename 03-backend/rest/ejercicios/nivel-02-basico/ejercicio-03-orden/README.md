# Ejercicio 03 — Orden

- **Nivel:** 2/5
- **Tema:** Orden de resultados con `sort`
- **Tiempo estimado:** 15 min

## Enunciado

Implementa la respuesta de `GET /products?sort=-price` (orden descendente por precio). La respuesta debe:

- Devolver status **200**.
- `body.data` con los productos ordenados por `price` **descendente** (de mayor a menor).
- Cada producto incluye `price` para verificar el orden.

## Requisitos

- [ ] El status es **200**
- [ ] `body.data` tiene al menos 3 elementos
- [ ] Los productos están ordenados por `price` descendente (cada `price` >= al siguiente)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El prefijo `-` en `sort` indica descendente: `?sort=-price` = de mayor a menor.
- Valida el orden comparando cada elemento con el siguiente: `data[i].price >= data[i+1].price`.
- Para múltiples campos: `?sort=-price,name` (primero precio desc, luego nombre asc).

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
      { "id": "prod_001", "name": "Teclado mecánico", "price": 89.90 },
      { "id": "prod_004", "name": "Webcam", "price": 45.50 },
      { "id": "prod_002", "name": "Ratón", "price": 19.90 }
    ],
    "pagination": { "limit": 20, "offset": 0, "total": 4 }
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
