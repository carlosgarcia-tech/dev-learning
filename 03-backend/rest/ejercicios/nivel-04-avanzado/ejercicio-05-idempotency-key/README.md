# Ejercicio 05 — Idempotency key

- **Nivel:** 4/5
- **Tema:** Idempotencia en POST con `Idempotency-Key`
- **Tiempo estimado:** 25 min

## Enunciado

Un cliente hace `POST /payments` con la cabecera `Idempotency-Key: 7c8f3a2e-...` para procesar un pago. Implementa:

1. `respuesta_primera.json`: la **primera** petición con esa key (procesa el pago, devuelve 201).
2. `respuesta_reintento.json`: el **reintento** con la **misma** key y el mismo body (el servidor devuelve el resultado cacheado, no reprocesa).

## Requisitos

- [ ] `respuesta_primera.json`: status **201**, body con `id` y `status: "completed"`
- [ ] `respuesta_reintento.json`: status **201** (mismo resultado), mismo `id` que la primera
- [ ] `respuesta_conflicto.json`: si llega la misma key con **otro** body, status **409** (conflicto)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Idempotency-Key permite reintentos seguros: el servidor cachea el resultado por key.
- Misma key + mismo body → devuelve el resultado cacheado (no duplica el pago).
- Misma key + body distinto → conflicto (409), porque la key ya está asociada a otra operación.
- Las keys deben ser UUIDs generados por el cliente, con TTL de 24-48h.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta_primera.json`:
````json
{
  "status": 201,
  "headers": { "Content-Type": "application/json" },
  "body": { "id": "pay_001", "orderId": "ord_456", "amount": 99.90, "status": "completed" }
}
````

`respuesta_reintento.json` (misma key, mismo body → resultado cacheado):
````json
{
  "status": 201,
  "headers": { "Content-Type": "application/json" },
  "body": { "id": "pay_001", "orderId": "ord_456", "amount": 99.90, "status": "completed" }
}
````

`respuesta_conflicto.json` (misma key, body distinto → 409):
````json
{
  "status": 409,
  "headers": { "Content-Type": "application/problem+json" },
  "body": {
    "type": "https://docs.api.example/errors/idempotency-conflict",
    "title": "Conflict",
    "status": 409,
    "detail": "Idempotency-Key ya usada con un body distinto"
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
