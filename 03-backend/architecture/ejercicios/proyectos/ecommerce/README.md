# ecommerce — Microservicios TiendaNube (proyecto integrador)

> Implementación de referencia de una arquitectura de microservicios para e-commerce con API Gateway, 4 servicios, comunicación asíncrona, CQRS, Saga, Circuit Breaker, caché y observabilidad.

Ver el enunciado completo en [../README.md](../README.md).

## Archivos

| Archivo | Rol |
|---|---|
| `bus.js` | EventBus en memoria + contrato de eventos |
| `gateway/gateway.js` | API Gateway (auth, routing, trace_id, circuit breaker) |
| `usuarios/service.js` | usuarios-service (BD propia) |
| `productos/service.js` | productos-service (BD propia + caché) |
| `pedidos/aggregate.js` | Aggregate root Pedido (DDD, invariantes) |
| `pedidos/commands.js` | CQRS write model (command handler + reacciones saga) |
| `pedidos/queries.js` | CQRS read model (query handler) |
| `pedidos/projector.js` | Sincroniza read model desde eventos |
| `pagos/service.js` | pagos-service (reacciona a PedidoCreado) |
| `shared/circuit-breaker.js` | Circuit Breaker reutilizable |
| `shared/logger.js` | Logger estructurado JSON con trace_id |
| `shared/metrics.js` | Counters y histograms |

## Cómo ejecutar

```bash
bash test.sh
```

El test valida el flujo end-to-end: crear producto, crear pedido (que dispara la saga), verificar que el pago se confirma y el pedido queda pagado, y el caso de fallo de pago (compensación: stock liberado, pedido cancelado).
