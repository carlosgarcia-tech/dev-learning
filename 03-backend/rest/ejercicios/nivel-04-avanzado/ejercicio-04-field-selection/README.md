# Ejercicio 04 — Field selection

- **Nivel:** 4/5
- **Tema:** Selección de campos con `?fields=`
- **Tiempo estimado:** 20 min

## Enunciado

Implementa la respuesta de `GET /products/prod_001?fields=name,price` que devuelve **solo** los campos solicitados. La respuesta debe:

- Devolver status **200**.
- `body` contiene **solo** `id`, `name` y `price` (el `id` siempre se incluye).
- No debe incluir otros campos como `stock`, `category`, etc.

## Requisitos

- [ ] El status es **200**
- [ ] `body` tiene `id`, `name`, `price`
- [ ] `body` NO tiene `stock`, `category`, `createdAt` (solo los pedidos + id)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Field selection reduce el payload (ideal para móviles): `?fields=name,price`.
- El `id` se incluye siempre (identidad del recurso).
- Implementación: parseas `fields`, proyectas solo esos campos en la serialización.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": { "id": "prod_001", "name": "Teclado mecánico", "price": 89.90 }
}
````

El recurso completo tendría `stock`, `category`, `createdAt`, etc., pero con `?fields=name,price` se proyectan solo `id`, `name` y `price`.

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
