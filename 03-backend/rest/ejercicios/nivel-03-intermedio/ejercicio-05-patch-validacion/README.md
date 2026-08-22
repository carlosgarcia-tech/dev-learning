# Ejercicio 05 — PATCH con validación

- **Nivel:** 3/5
- **Tema:** Validación parcial en PATCH
- **Tiempo estimado:** 20 min

## Enunciado

Implementa la respuesta de `PATCH /products/prod_001` con un body que tiene errores de validación:

```json
{ "price": -10, "stock": -3, "category": "no-existe" }
```

La respuesta debe:

- Devolver status **422**.
- `Content-Type: application/problem+json`.
- Un array `errors` que reporte los 3 campos inválidos (`price`, `stock`, `category`).

## Requisitos

- [ ] El status es **422**
- [ ] `body.errors` es un array con al menos 3 errores
- [ ] Se reportan `price`, `stock` y `category`
- [ ] Cada error tiene `field`, `code` y `message`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- PATCH valida solo los campos enviados (no exige todos los requeridos como PUT).
- Reporta todos los errores de validación a la vez.
- `category` inválido es un error de enum (`invalid_enum`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````json
{
  "status": 422,
  "headers": { "Content-Type": "application/problem+json" },
  "body": {
    "type": "https://docs.api.example/errors/validation",
    "title": "Validation Failed",
    "status": 422,
    "detail": "Uno o más campos son inválidos",
    "errors": [
      { "field": "price", "code": "min_value", "message": "price debe ser >= 0" },
      { "field": "stock", "code": "min_value", "message": "stock debe ser >= 0" },
      { "field": "category", "code": "invalid_enum", "message": "category no es un valor permitido" }
    ]
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
