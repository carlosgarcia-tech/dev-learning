# Ejercicio 06 — Sub-recursos anidados

- **Nivel:** 3/5
- **Tema:** Sub-recursos y rutas anidadas
- **Tiempo estimado:** 20 min

## Enunciado

Implementa la respuesta de `GET /users/usr_123/orders` que lista los pedidos de un usuario concreto. La respuesta debe:

- Devolver status **200**.
- `body.data` con los pedidos, cada uno con `id`, `status`, `total`.
- Todos los pedidos pertenecen al usuario `usr_123`.

Además, en `respuesta_sub_item.json`, implementa `GET /users/usr_123/orders/ord_456` (un pedido concreto de ese usuario).

## Requisitos

- [ ] `respuesta.json`: status 200, `body.data` es un array no vacío
- [ ] Cada pedido de `body.data` tiene `id`, `status`, `total`
- [ ] `respuesta_sub_item.json`: status 200, `body.id` = `ord_456`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Sub-recursos: cuando hay pertenencia fuerte (el pedido "es de" un usuario), anida bajo el padre.
- `/users/{userId}/orders` lista; `/users/{userId}/orders/{orderId}` un item concreto.
- No anides en exceso: si el pedido tiene identidad propia global, también se puede acceder plano con `/orders/{id}`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json`:
````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": {
    "data": [
      { "id": "ord_456", "status": "paid", "total": 99.90 },
      { "id": "ord_457", "status": "pending", "total": 45.50 }
    ],
    "pagination": { "limit": 20, "offset": 0, "total": 2 }
  }
}
````

`respuesta_sub_item.json`:
````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": { "id": "ord_456", "userId": "usr_123", "status": "paid", "total": 99.90 }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
