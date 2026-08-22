# Ejercicio 06 — Bulk operations

- **Nivel:** 4/5
- **Tema:** Operaciones masivas con resultados parciales
- **Tiempo estimado:** 25 min

## Enunciado

Implementa la respuesta de `POST /products/bulk` que crea varios productos a la vez. La petición envía:

```json
{
  "products": [
    { "name": "Teclado", "price": 89.90 },
    { "name": "", "price": -5 },
    { "name": "Monitor", "price": 199.90 }
  ]
}
```

La respuesta debe:

- Devolver status **200** (operación masiva completada, con resultados parciales).
- `body.results` con un resultado por cada item (`index`, `status`, y `id` o `error`).
- `body.summary` con `created` y `failed` (contadores).
- El segundo item falla por validación; los otros dos se crean.

## Requisitos

- [ ] El status es **200**
- [ ] `body.results` es un array con 3 elementos (uno por item)
- [ ] Cada resultado tiene `index` (0, 1, 2) y `status` (`created` o `error`)
- [ ] El item con `index: 1` tiene `status: "error"`
- [ ] Los items con `index: 0` y `index: 2` tienen `status: "created"` y un `id`
- [ ] `body.summary.created` = 2 y `body.summary.failed` = 1
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Bulk permite procesar varios recursos en una petición (menos round-trips).
- Resultados **parciales**: cada item con su propio estado (no todo falla porque uno falle).
- `index` permite al cliente correlacionar el resultado con el item enviado.
- Establece un límite máximo de items por petición para evitar abusos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": {
    "results": [
      { "index": 0, "status": "created", "id": "prod_010" },
      { "index": 1, "status": "error", "error": { "code": "validation_failed", "message": "name vacío y price negativo" } },
      { "index": 2, "status": "created", "id": "prod_011" }
    ],
    "summary": { "created": 2, "failed": 1 }
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
