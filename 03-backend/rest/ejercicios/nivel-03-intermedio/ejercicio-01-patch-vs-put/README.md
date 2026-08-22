# Ejercicio 01 — PATCH parcial vs PUT total

- **Nivel:** 3/5
- **Tema:** Diferencia entre PATCH y PUT
- **Tiempo estimado:** 20 min

## Enunciado

Dado este producto existente:

```json
{ "id": "prod_001", "name": "Teclado mecánico", "price": 89.90, "stock": 15, "active": true }
```

Implementa dos respuestas para la misma petición parcial `{ "price": 99.90 }`:

1. `respuesta_patch.json`: `PATCH /products/prod_001` — modifica **solo** `price`; el resto se conserva.
2. `respuesta_put.json`: `PUT /products/prod_001` — como PUT reemplaza todo, los campos no enviados se consideran ausentes/reseteados (aquí asumimos validación que exige `name` y `price`, así que PUT con solo `price` da **422** porque falta `name`).

## Requisitos

- [ ] `respuesta_patch.json`: status **200**, `body.price` = 99.90, `body.name` se conserva
- [ ] `respuesta_put.json`: status **422** (faltan campos requeridos para reemplazo total)
- [ ] El body del 422 indica que falta `name`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- PATCH modifica solo lo enviado; el resto del recurso se conserva.
- PUT exige todos los campos requeridos (reemplazo total); si falta alguno, 422.
- PUT es idempotente; PATCH no lo es por definición.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta_patch.json`:
````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": {
    "id": "prod_001",
    "name": "Teclado mecánico",
    "price": 99.90,
    "stock": 15,
    "active": true,
    "updatedAt": "2024-01-16T08:00:00Z"
  }
}
````

`respuesta_put.json`:
````json
{
  "status": 422,
  "headers": { "Content-Type": "application/problem+json" },
  "body": {
    "type": "https://docs.api.example/errors/validation",
    "title": "Validation Failed",
    "status": 422,
    "detail": "PUT requiere todos los campos requeridos",
    "errors": [
      { "field": "name", "code": "required", "message": "name es obligatorio en PUT" }
    ]
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
