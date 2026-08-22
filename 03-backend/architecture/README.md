# Arquitectura de Software

> Guía de estudio + ejercicios por niveles. Arquitectura de 0 a experto: fundamentos, patrones de diseño, arquitectura en capas y Clean Architecture, microservicios y DDD, producción y escalabilidad.

## Guías

| Guía | Qué cubre |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Qué es arquitectura de software, arquitectura vs diseño, estilos (monolito, cliente-servidor, capas, microservicios), patrones vs estilos, acoplamiento y cohesión, separación de intereses, principios SOLID, arquitectura en capas, arquitectura hexagonal |
| [02 — Patrones de Diseño](02-patrones-de-diseno.md) | Patrones creacionales (Singleton, Factory, Builder, Prototype, Abstract Factory), estructurales (Adapter, Decorator, Facade, Proxy, Composite, Bridge), de comportamiento (Observer, Strategy, Command, Iterator, State, Template Method, Chain of Responsibility), patrones de backend (Repository, Unit of Work, CQRS, Mediator) |
| [03 — Capas y Clean Architecture](03-arquitectura-en-capas-y-clean-architecture.md) | Arquitectura en capas (controller-service-repository), hexagonal (ports-adapters), Clean Architecture, Dependency Rule, Dependency Injection, inversión de dependencias, dominio vs infraestructura, Onion Architecture |
| [04 — Microservicios y DDD](04-microservicios-y-ddd.md) | Microservicios, monolito vs microservicios, DDD (bounded contexts, entities, value objects, aggregates, repositories, domain events, application services, ubiquitous language), comunicación (REST, gRPC, async), API Gateway, Service Discovery, Saga, Circuit Breaker, CQRS, Event Sourcing |
| [05 — Producción y Escalabilidad](05-produccion-y-escalabilidad.md) | Escalabilidad vertical/horizontal, mensajería asíncrona (RabbitMQ, Kafka, Redis), colas y workers, event-driven, event sourcing, CQRS en producción, load balancing, cache distribuida, sharding, observabilidad, resiliencia, 12-factor app |

## Ejercicios

Ver [ejercicios/](ejercicios/)

| Nivel | Qué cubre | Estado |
|---|---|---|
| [nivel-01-fundamentos](ejercicios/nivel-01-fundamentos/) | Identificar capas, separar responsabilidades (SRP), Factory, Singleton, Open/Closed | ⬜ |
| [nivel-02-basico](ejercicios/nivel-02-basico/) | Repository pattern, Strategy, Observer, arquitectura en capas, Dependency Injection | ⬜ |
| [nivel-03-intermedio](ejercicios/nivel-03-intermedio/) | Clean Architecture, hexagonal ports-adapters, Builder, Decorator, Command | ⬜ |
| [nivel-04-avanzado](ejercicios/nivel-04-avanzado/) | Diseñar microservicio, DDD bounded context, CQRS, Circuit Breaker, API Gateway | ⬜ |
| [nivel-05-experto](ejercicios/nivel-05-experto/) | Event-driven, event sourcing, Saga, escalabilidad horizontal, sistema 12-factor | ⬜ |
| [proyectos](ejercicios/proyectos/) | Arquitectura de microservicios completa para e-commerce | ⬜ |
