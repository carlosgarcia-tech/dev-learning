# Ejercicio 04 — POST crear recurso

- **Nivel:** 1/5
- **Tema:** Creación de recursos con POST
- **Tiempo estimado:** 15 min

## Enunciado

Implementa la respuesta de `POST /products` para crear un producto. La petición envía:

```json
{ "name": "Webcam HD", "price": 45.50, "stock": 10, "category": "perifericos" }
```

La respuesta debe:

- Devolver status **201 Created**.
- Incluir la cabecera `Location` con la URI del nuevo recurso.
- Devolver el recurso creado en el `body`, con el `id` asignado por el servidor y `createdAt`/`updatedAt`.

## Requisitos

- [ ] El status es **201**
- [ ] `headers.Location` contiene la URI del nuevo recurso (`/products/<id>`)
- [ ] `headers.Content-Type` es `application/json`
- [ ] `body.id` está asignado por el servidor (no por el cliente)
- [ ] `body` incluye `createdAt` y `updatedAt` en ISO 8601 UTC
- [ ] Los campos enviados (`name`, `price`, `stock`, `category`) están en el body
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- 201 indica "creado". La cabecera `Location` es obligatoria en REST para que el cliente sepa dónde quedó el recurso.
- El servidor asigna el `id` (y los timestamps); el cliente no debe enviarlos.
- `createdAt` y `updatedAt` coinciden al crear.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/json",
    "Location": "/products/prod_010"
  },
  "body": {
    "id": "prod_010",
    "name": "Webcam HD",
    "price": 45.50,
    "stock": 10,
    "category": "perifericos",
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-15T10:30:00Z"
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
