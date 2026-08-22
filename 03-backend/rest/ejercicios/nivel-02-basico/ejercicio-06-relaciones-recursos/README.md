# Ejercicio 06 — Relaciones entre recursos

- **Nivel:** 2/5
- **Tema:** Relaciones: referencias vs embebido
- **Tiempo estimado:** 20 min

## Enunciado

Implementa la respuesta de `GET /orders/ord_456` que incluye una **referencia por id** al usuario y, bajo demanda con `?expand=user`, una versión **embebida**.

- `respuesta.json`: respuesta por defecto con `userId` como referencia (sin el objeto completo).
- `respuesta_expand.json`: respuesta con `?expand=user` que incluye el objeto `user` embebido.

## Requisitos

- [ ] `respuesta.json`: `body.userId` es un string (referencia), sin objeto `user` completo
- [ ] `respuesta_expand.json`: `body.user` es un objeto con `id` y `name`
- [ ] Ambos devuelven status 200 y `Content-Type: application/json`
- [ ] Ambos conservan los campos del pedido (`id`, `total`, `status`)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Por defecto, referencia por id: `"userId": "usr_123"`. El cliente hace otra petición si necesita el detalle.
- Con `?expand=user`, embebes el objeto: `"user": { "id": "usr_123", "name": "Ana" }`.
- Embebido reduce peticiones (mejor para móvil); referencia mantiene respuestas ligeras.

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
    "id": "ord_456",
    "userId": "usr_123",
    "total": 99.90,
    "status": "paid"
  }
}
````

`respuesta_expand.json`:
````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": {
    "id": "ord_456",
    "userId": "usr_123",
    "user": { "id": "usr_123", "name": "Ana García" },
    "total": 99.90,
    "status": "paid"
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
