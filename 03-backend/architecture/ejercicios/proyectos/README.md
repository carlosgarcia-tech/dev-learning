# Proyecto Final — Arquitectura de microservicios completa (e-commerce)

> Proyecto integrador del tema **Arquitectura**. Diseñar e implementar una arquitectura de microservicios para un e-commerce con API Gateway, servicios (usuarios, productos, pedidos, pagos), comunicación asíncrona con eventos, CQRS, resiliencia con Circuit Breaker, caché distribuida y observabilidad.

## Contexto

Construyes el backend de **TiendaNube**, un e-commerce en auge. El monolito inicial ya no escala: los equipos de Productos y Pedidos se estorban, los despliegues son de toda la app y los picos de Black Friday tiran el sistema. Tu misión es migrar a una arquitectura de microservicios.

El proyecto se entrega en el directorio `ecommerce/` con los starters de cada servicio y un diseño documentado.

## Requisitos de arquitectura

1. **API Gateway** — punto único de entrada: auth, routing, rate limiting.
2. **4 microservicios** con bounded contexts y BD propia cada uno:
   - `usuarios-service` — registro, login, perfil.
   - `productos-service` — catálogo, stock.
   - `pedidos-service` — crear/gestionar pedidos (aggregate root DDD).
   - `pagos-service` — cobrar, reembolsar.
3. **Comunicación asíncrona** vía event bus (RabbitMQ/Kafka simulado en memoria).
4. **CQRS** en pedidos: modelo de escritura (comandos) + read model (vista denormalizada).
5. **Resiliencia** con Circuit Breaker en llamadas síncronas entre servicios.
6. **Caché distribuida** (Redis simulado) para catálogo de productos.
7. **Observabilidad**: logs estructurados, métricas y tracing con `trace_id` propagado.
8. **Saga** coreografiada para `CrearPedido` (pedidos → inventario → pagos) con compensaciones.

## Fases

### Fase 1 — Diseño (documentación)
- Diagrama de la arquitectura completa (`diagrama.txt`).
- Tabla de bounded contexts y qué servicio los cubre.
- Contrato de eventos publicados/consumidos por cada servicio.
- Elección de BD por servicio y por qué.

### Fase 2 — API Gateway y servicios base
- Implementar el `ApiGateway` con auth y routing.
- Implementar `usuarios-service` y `productos-service` (CRUD + eventos).
- Cache para el catálogo de productos.

### Fase 3 — Pedidos con DDD y CQRS
- `pedidos-service` con aggregate root `Pedido` (invariantes).
- CQRS: command handler (crear pedido) + read model (vista de pedidos por cliente).
- Publica `PedidoCreado`.

### Fase 4 — Comunicación asíncrona y Saga
- `EventBus` en memoria compartido.
- `pagos-service` reacciona a `PedidoCreado` → cobra → publica `PagoConfirmado`/`PagoFallido`.
- `productos-service` reacciona a `PedidoCreado` → reserva stock.
- Saga coreografiada: si `PagoFallido`, liberar stock y cancelar pedido.

### Fase 5 — Resiliencia y observabilidad
- Circuit Breaker alrededor de las llamadas síncronas (si las hay).
- Logs estructurados JSON con `trace_id`.
- Métricas: requests por servicio, latencia, errores.
- Tracing: propagación de `trace_id` en toda la cadena.

## Criterios de aceptación

- [ ] El `ApiGateway` enruta a los 4 servicios y rechaza sin token (401).
- [ ] Cada servicio tiene su propia "BD" (Map/dict separado; no se comparte).
- [ ] `pedidos-service` implementa el aggregate `Pedido` con invariantes (no confirmar vacío).
- [ ] CQRS: el read model de pedidos es distinto del write model y se actualiza por eventos.
- [ ] La saga `CrearPedido` publica eventos y, ante fallo de pago, compensa (libera stock + cancela).
- [ ] Circuit Breaker abre tras N fallos y falla rápido.
- [ ] La caché de productos responde sin tocar la "BD" tras el primer miss.
- [ ] Los logs son JSON estructurado con `trace_id` y se propagan entre servicios.
- [ ] `test.sh` valida el flujo completo de extremo a extremo.
- [ ] `diagrama.txt` muestra la arquitectura final.
- [ ] `estructura.json` describe los servicios y sus eventos.

## Estructura de archivos

```
ecommerce/
├── README.md                 (este documento, copia del proyecto)
├── diagrama.txt              (arquitectura completa ASCII)
├── estructura.json           (servicios, BDs, eventos)
├── bus.js                    (EventBus en memoria compartido)
├── gateway/
│   └── gateway.js            (ApiGateway con auth + routing)
├── usuarios/
│   └── service.js            (usuarios-service)
├── productos/
│   └── service.js            (productos-service + cache)
├── pedidos/
│   ├── aggregate.js          (Pedido aggregate root DDD)
│   ├── commands.js           (command handler CQRS write)
│   ├── queries.js            (query handler CQRS read)
│   └── projector.js          (sincroniza read model)
├── pagos/
│   └── service.js            (pagos-service, reacciona a eventos)
├── shared/
│   ├── circuit-breaker.js    (Circuit Breaker reutilizable)
│   ├── logger.js             (logger estructurado con trace_id)
│   └── metrics.js            (métricas counters/histograms)
└── test.sh                   (validación end-to-end)
```

> Los archivos starter ya están creados como referencia. Tu tarea es completar el flujo end-to-end y hacer pasar `test.sh`.

## Cómo ejecutar

```bash
cd 03-backend/architecture/ejercicios/proyectos/ecommerce
bash test.sh
```

## Pistas generales

- Empieza por el diseño (Fase 1); sin contrato de eventos, la coreografía se vuelve caos.
- El `EventBus` en memoria es suficiente para el ejercicio; en producción sería RabbitMQ/Kafka.
- El `trace_id` se genera en el gateway y se propaga en cada evento y llamada.
- La caché de productos invalida en `ProductoActualizado` (pub/sub de invalidación).
- La saga no tiene orquestador; cada servicio reacciona y compensa de forma autónoma.
