# Ejercicio 06 — Microservicios REST

- **Nivel:** 5/5
- **Tema:** Comunicación entre microservicios con REST
- **Tiempo estimado:** 35 min

## Enunciado

Un microservicio de **Orders** necesita, al crear un pedido, verificar el stock consultando al microservicio de **Products**. Escribe en `respuesta.json` un diseño de esta interacción con:

1. `flujo`: lista de pasos de la interacción entre `orders-service` y `products-service` (cada paso con `actor`, `accion`, `endpoint`).
2. `resiliencia`: lista de estrategias para tolerancia a fallos (circuit breaker, timeout, retry, fallback).
3. `contrato`: el contrato REST entre ambos (qué espera el `orders-service` del `products-service`): `endpoint`, `method`, `response` con campos.

## Requisitos

- [ ] `respuesta.json` tiene `flujo`, `resiliencia` y `contrato`
- [ ] `flujo` es un array con al menos 3 pasos; cada paso tiene `actor`, `accion`, `endpoint`
- [ ] `resiliencia` incluye `circuit-breaker`, `timeout` y `retry`
- [ ] `contrato` tiene `endpoint`, `method` y `response`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Service-to-service REST: el `orders-service` hace `GET /products/{id}` al `products-service` para verificar stock.
- Resiliencia: circuit breaker (para no saturar un servicio caído), timeout (no esperar indefinidamente), retry (con backoff para fallos transitorios), fallback (respuesta degradada).
- El contrato define qué campos espera el consumidor del proveedor.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````json
{
  "flujo": [
    { "actor": "cliente", "accion": "crear pedido", "endpoint": "POST /orders" },
    { "actor": "orders-service", "accion": "verificar stock del producto", "endpoint": "GET /products/{id}" },
    { "actor": "products-service", "accion": "responder con producto y stock", "endpoint": "GET /products/{id}" },
    { "actor": "orders-service", "accion": "crear el pedido si hay stock", "endpoint": "POST /orders" }
  ],
  "resiliencia": ["circuit-breaker", "timeout", "retry", "fallback", "bulkhead"],
  "contrato": {
    "endpoint": "/products/{id}",
    "method": "GET",
    "response": { "id": "string", "name": "string", "stock": "integer", "price": "number" }
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
