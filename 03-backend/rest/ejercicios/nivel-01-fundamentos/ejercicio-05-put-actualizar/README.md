# Ejercicio 05 — PUT actualizar

- **Nivel:** 1/5
- **Tema:** Reemplazo completo de recurso con PUT
- **Tiempo estimado:** 15 min

## Enunciado

Implementa la respuesta de `PUT /products/prod_001` para reemplazar por completo un producto. La petición envía el recurso entero:

```json
{ "name": "Teclado mecánico RGB", "price": 109.90, "stock": 20, "category": "perifericos" }
```

La respuesta debe:

- Devolver status **200 OK**.
- Devolver el recurso actualizado en el `body` con `updatedAt` renovado (posterior al `createdAt`).
- `id` y `createdAt` se conservan; `updatedAt` cambia.

## Requisitos

- [ ] El status es **200**
- [ ] `body.id` se conserva (`prod_001`)
- [ ] `body.createdAt` se conserva
- [ ] `body.updatedAt` es posterior a `createdAt`
- [ ] Los campos enviados se actualizan en el body
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- PUT reemplaza el recurso completo y es **idempotente**: repetir la misma petición deja el mismo estado.
- `id` y `createdAt` no cambian en una actualización.
- `updatedAt` debe ser >= `createdAt` (la regeneración se ve en que es posterior).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": {
    "id": "prod_001",
    "name": "Teclado mecánico RGB",
    "price": 109.90,
    "stock": 20,
    "category": "perifericos",
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-16T08:00:00Z"
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
