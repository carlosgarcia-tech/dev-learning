# Ejercicio 02 — Webhooks

- **Nivel:** 5/5
- **Tema:** Notificaciones push con webhooks
- **Tiempo estimado:** 30 min

## Enunciado

Un cliente registró un webhook para el evento `order.paid`. Implementa:

1. `respuesta_registro.json`: respuesta del `POST /webhooks` que registra el webhook (status 201, body con `id`, `url`, `events`, `secret`).
2. `peticion_evento.json`: el **payload** que el servidor enviaría al cliente al dispararse el evento `order.paid`, con firma HMAC.
3. `respuesta_evento.json`: la respuesta esperada del cliente al recibir el evento (200 OK).

## Requisitos

- [ ] `respuesta_registro.json`: status 201, body con `id`, `url`, `events` (array), `secret`
- [ ] `peticion_evento.json`: body con `id` (eventId), `type: "order.paid"`, `data` (objeto), y cabecera `X-Webhook-Signature`
- [ ] `peticion_evento.json` incluye `X-Webhook-Event` con el tipo de evento
- [ ] `respuesta_evento.json`: status 200
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Registro: el servidor devuelve un `secret` para verificar la firma HMAC de los eventos posteriores.
- El evento lleva `eventId` para idempotencia (el cliente ignora duplicados).
- La firma `X-Webhook-Signature` es HMAC-SHA256 del body con el `secret`.
- El cliente debe responder 2xx; si no, el servidor reintenta con backoff.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta_registro.json`:
````json
{
  "status": 201,
  "headers": { "Content-Type": "application/json" },
  "body": {
    "id": "wh_001",
    "url": "https://client.example.com/hooks",
    "events": ["order.paid", "order.shipped"],
    "secret": "whsec_abc123def456"
  }
}
````

`peticion_evento.json` (lo que el servidor envía al cliente):
````json
{
  "method": "POST",
  "url": "https://client.example.com/hooks",
  "headers": {
    "Content-Type": "application/json",
    "X-Webhook-Event": "order.paid",
    "X-Webhook-Signature": "sha256=5f2b...",
    "X-Webhook-Id": "evt_001"
  },
  "body": {
    "id": "evt_001",
    "type": "order.paid",
    "createdAt": "2024-01-15T12:00:00Z",
    "data": { "orderId": "ord_456", "amount": 99.90, "currency": "EUR" }
  }
}
````

`respuesta_evento.json` (lo que el cliente responde):
````json
{ "status": 200, "headers": { "Content-Type": "application/json" }, "body": { "received": true } }
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
