# System Design

> Conceptos de diseño de sistemas distribuidos: escalabilidad, caching, balanceo de carga, particionado, teorema CAP, microservicios y colas de mensajes.

## Índice

1. [Escalabilidad](#escalabilidad)
2. [Caching](#caching)
3. [Load Balancing](#load-balancing)
4. [Sharding y Partitioning](#sharding-y-partitioning)
5. [Replicación](#replicación)
6. [Teorema CAP](#teorema-cap)
7. [Microservicios](#microservicios)
8. [Message Queues](#message-queues)
9. [Patrones de diseño distribuido](#patrones-de-diseño-distribuido)
10. [Resumen](#resumen)

---

## Escalabilidad

La **escalabilidad** es la capacidad de un sistema para manejar más carga añadiendo recursos.

### Escalado vertical vs horizontal

| Tipo | Qué hace | Límites | Coste |
|------|----------|---------|-------|
| Vertical (scale up) | Mejorar una máquina (más CPU, RAM) | Límite físico de hardware | Alto, servidor grande |
| Horizontal (scale out) | Añadir más máquinas | Casi sin límite teórico | Bajo, máquinas básicas |

```
Vertical:   [Servidor pequeño] --> [Servidor GRANDE]

Horizontal: [Servidor] --> [Servidor] + [Servidor] + [Servidor]
                                   \
                                  [Load Balancer]
```

### Escalabilidad vs rendimiento

- **Rendimiento:** cuán rápido responde el sistema (latencia, throughput).
- **Escalabilidad:** cómo se comporta el rendimiento al añadir carga o recursos.

Un sistema escalable puede mantener la latencia aunque aumenten los usuarios; un sistema rápido pero no escalable se degrada al crecer.

### Métricas clave

| Métrica | Significado |
|---------|-------------|
| Latencia (p50, p95, p99) | Tiempo de respuesta |
| Throughput | Peticiones por segundo |
| Disponibilidad | % de tiempo operativo (99.9%, 99.99%) |
| Concurrencia | Peticiones simultáneas |
| Saturación | Uso de recursos (CPU, disco, red) |

### Ley de Little

`L = λ · W`: el número de peticiones en el sistema (L) es igual a la tasa de llegada (λ) por el tiempo de respuesta (W). Útil para estimar cuántos servidores hacen falta.

### Cuellos de botella comunes

- **Base de datos:** consultas lentas, bloqueos.
- **Red:** llamadas síncronas encadenadas.
- **CPU:** algoritmos costosos.
- **I/O disco:** E/S no optimizada.
- **Memoria:** presión de GC, swapping.

---

## Caching

El **caching** guarda resultados costosos en un almacenamiento rápido para servirlos sin recalcularlos ni ir al origen. Es una de las formas más eficaces de reducir latencia y carga.

### Niveles de caché

```
[Cliente] -> [CDN] -> [Load Balancer] -> [App: caché en memoria] -> [Redis/Memcached] -> [BD]
```

| Nivel | Dónde | Ejemplo |
|-------|-------|---------|
| Cliente | Navegador / app | HTTP cache-control |
| CDN | Borde de la red | Cloudflare, CloudFront |
| App (en memoria) | Proceso de la app | LRU en memoria, dicts |
| Caché distribuida | Servidor aparte | Redis, Memcached |
| BD | Caché interna | page cache de PostgreSQL |

### Estrategias de lectura

| Estrategia | Cómo funciona |
|-----------|---------------|
| Cache-aside | La app lee la caché; si falla, lee la BD y la llena |
| Read-through | La caché se encarga de cargar del origen si hay fallo |
| Write-through | Toda escritura va a caché y a BD a la vez |
| Write-behind (write-back) | Se escribe en caché y se persiste en BD más tarde (async) |
| Write-around | Se escribe directo a BD; la caché se llena al leer |

### Políticas de expulsión

| Política | Descripción |
|----------|-------------|
| LRU | Least Recently Used: expulsa el menos usado recientemente |
| LFU | Least Frequently Used: el menos accedido |
| FIFO | El primero en entrar sale primero |
| TTL | Tiempo de vida: expira tras un tiempo |
| Random | Aleatorio |

### Problemas comunes

#### Cache stampede (thundering herd)

Cuando una clave popular expira, miles de peticiones golpean la BD a la vez. Soluciones:

- **Locking:** el primero en no encontrar la clave adquiere un lock; el resto espera.
- **Early refresh:** refrescar antes de que expire (TTL con jitter).
- **Stale-while-revalidate:** servir valor viejo mientras se refresca en segundo plano.

#### Inconsistencia

La caché y la BD pueden desincronizarse. Estrategias:

- **Invalidar** la caché al escribir en la BD.
- Usar TTL como red de seguridad.
- Eventos de actualización (pub/sub).

### Ejemplo: cache-aside con Redis (Python)

```python
import redis, json
r = redis.Redis()

def get_user(user_id):
    key = f"user:{user_id}"
    cached = r.get(key)
    if cached:
        return json.loads(cached)
    user = db.fetch_user(user_id)        # costoso
    r.setex(key, 300, json.dumps(user))  # TTL 5 min
    return user
```

---

## Load Balancing

El **load balancing** reparte el tráfico entre múltiples servidores para usarlos al máximo, aumentar la disponibilidad y evitar sobrecargas.

```
                    +---> Servidor 1
  Clientes --> LB --+---> Servidor 2
                    +---> Servidor 3
```

### Capas

- **L4 (transporte):** reparte por IP y puerto, sin inspeccionar el contenido. Rápido. Ej: HAProxy tcp, AWS NLB, IPVS.
- **L7 (aplicación):** inspecciona HTTP: URL, cookies, cabeceras. Flexible. Ej: nginx, HAProxy http, AWS ALB, Traefik.

### Algoritmos

| Algoritmo | Descripción |
|-----------|-------------|
| Round Robin | Distribuye en orden cíclico |
| Weighted Round Robin | Según capacidad de cada servidor |
| Least Connections | Al servidor con menos conexiones activas |
| IP Hash | El mismo cliente siempre al mismo servidor (sesión) |
| Least Response Time | El que responde más rápido |
| Random | Aleatorio |

### Health checks

El LB comprueba periódicamente la salud de cada backend (ej: `GET /health`). Si falla, se retira del pool; si se recupera, se reincorpora.

### Sticky sessions

El mismo cliente se enruta siempre al mismo backend (útil para sesiones en memoria) usando una cookie o hash de IP. Inconveniente: dificulta el balanceo justo y la recuperación ante fallos.

### Alta disponibilidad del propio LB

Un solo LB es un punto único de fallo (SPOF). Para HA se usan dos LB con **VRRP** (IP virtual flotante) o servicios gestionados (AWS ALB, Cloudflare, GCP LB).

---

## Sharding y Partitioning

**Particionar** divide una tabla o conjunto de datos en partes más pequeñas para gestionarlas mejor. **Sharding** reparte esos datos entre múltiples máquinas.

### Vertical partitioning

Dividir por **columnas**: poner columnas frecuentes juntas y las raras en otra tabla/partición. No reparte por máquinas necesariamente.

### Horizontal partitioning / Sharding

Dividir por **filas**: cada partición (shard) contiene un subconjunto de filas y puede estar en una máquina distinta.

```
Usuarios:
  shard 0: ids 0-9999     (maquina A)
  shard 1: ids 10000-19999 (maquina B)
  shard 2: ids 20000-29999 (maquina C)
```

### Claves de partición (shard key)

La elección de la **shard key** es crítica:

- Debe distribuir los datos de forma uniforme (evitar hotspots).
- Debe permitir responder consultas comunes sin tocar todos los shards.

### Estrategias

| Estrategia | Descripción | Pros / Contras |
|------------|-------------|----------------|
| Range-based | Por rango de la clave (0-1000, 1001-2000) | Consultas por rango fáciles; riesgo de hotspots |
| Hash-based | Hash de la clave % n shards | Distribución uniforme; consultas por rango difíciles |
| Directory | Un servicio mapea clave → shard | Flexible; el directorio es un SPOF |
| Geo-based | Por región geográfica | Baja latencia local; riesgo de desequilibrio |

### Problemas del sharding

- **Joins跨shard** complejos y costosos.
- **Transacciones distribuidas** difíciles (consistencia).
- **Reparticionado** (resharding) costoso: mover datos al añadir shards.
- **Hotspots:** una clave muy popular satura un shard.

---

## Replicación

La **replicación** mantiene copias de los datos en varios nodos para disponibilidad y rendimiento de lectura.

### Modelos

| Modelo | Descripción |
|--------|-------------|
| Primary-replica (master-slave) | Un nodo primario recibe escrituras; réplicas sirven lecturas |
| Multi-primary (multi-master) | Varios nodos aceptan escrituras; requiere resolución de conflictos |
| Quorum-based | Escritura/lectura requiere confirmación de mayoría (Raft, Paxos) |

### Replicación síncrona vs asíncrona

- **Síncrona:** el primario espera a que las réplicas confirmen antes de responder. Consistencia fuerte, mayor latencia.
- **Asíncrona:** el primario responde en cuanto escribe localmente. Rápido, pero las réplicas pueden ir retrasadas (lag).

```
Primary: WRITE -> [log] --replicar--> Replica 1
                          --replicar--> Replica 2
```

### Read replicas

Sirven para escalar lecturas. Ojo con la consistencia: una lectura de una réplica puede devolver datos antiguos si la replicación va retrasada. Útil para informes o lecturas no críticas.

---

## Teorema CAP

El **teorema CAP** dice que un sistema distribuido puede garantizar a lo sumo **dos de tres** propiedades:

| Propiedad | Significado |
|-----------|-------------|
| **C**onsistency | Todas las lecturas ven la escritura más reciente |
| **A**vailability | Cada petición recibe respuesta (no error) |
| **P**artition tolerance | El sistema sigue funcionando si se pierden mensajes entre nodos |

```
            C
           / \
          /   \
         /     \
        /-------\
       /    P    \
      A --------- 
```

### En la práctica

En una red real, las particiones de red **siempre** pueden ocurrir, así que hay que tolerarlas (P). La elección real es entre:

- **CP:** consistencia fuerte; si hay partición, se rechazan escrituras para evitar inconsistencias (ej: HBase, Spanner, Zookeeper).
- **AP:** disponibilidad; se sigue sirviendo aunque los datos puedan divergir, y se reconcilia después (ej: Cassandra, DynamoDB, CouchDB).

### Modelos de consistencia

| Modelo | Descripción |
|--------|-------------|
| Strong | Lectura siempre devuelve la última escritura |
| Eventual | Si no hay nuevas escrituras, todas las réplicas terminan convergiendo |
| Causal | Preserva orden causal entre operaciones |
| Read-your-writes | Un cliente siempre ve sus propias escrituras |
| Monotonic reads | Las lecturas de un cliente no retroceden en el tiempo |

### Teorema PACELC

Extiende CAP: si no hay partición (E), hay que elegir entre latencia (L) y consistencia (C). Por ejemplo, Cassandra es AP + EL (prioriza latencia), mientras que BigTable es CP + EC.

---

## Microservicios

La **arquitectura de microservicios** divide una aplicación en servicios pequeños e independientes, cada uno con una responsabilidad y su propio despliegue.

### Monolito vs microservicios

| Aspecto | Monolito | Microservicios |
|---------|----------|-----------------|
| Despliegue | Una sola unidad | Cada servicio por separado |
| Escalado | Todo el sistema | Solo lo que se necesita |
| Tecnología | Una pila | Cada servicio puede usar su stack |
| Acoplamiento | Alto | Bajo |
| Complejidad operativa | Baja | Alta (red, observabilidad) |
| Latencia interna | Llamadas a función | Llamadas por red |

### Características

- Cada servicio tiene su **propio almacén de datos** (database per service).
- Se comunican por **API** (HTTP/gRPC) o **eventos** (message broker).
- Despliegue y escalado independientes.
- Equipos autónomos por servicio.

### Ejemplo de descomposición

```
[ Tienda online ]
  ├── servicio-usuarios   (PostgreSQL)
  ├── servicio-catalogo   (MongoDB)
  ├── servicio-carrito    (Redis)
  ├── servicio-pedidos    (PostgreSQL)
  ├── servicio-pagos      (API externa)
  └── servicio-notificaciones (SMTP/Push)
```

### Cuándo usar microservicios

- Equipo grande con varios squads.
- Partes del sistema con requisitos de escala muy distintos.
- Necesidad de desplegar y evolucionar componentes por separado.

### Desventajas y retos

- Complejidad de **red** y fallos parciales.
- **Consistencia** distribuida (transacciones distribuidas, saga).
- **Observabilidad**: necesitas trazas distribuidas (OpenTelemetry, Jaeger).
- **Despliegue** y orquestación (Kubernetes).
- Latencia entre servicios.

### Patrones asociados

- **API Gateway:** punto de entrada único que enruta a los servicios.
- **Service discovery:** los servicios se encuentran dinámicamente (Consul, K8s DNS).
- **Circuit breaker:** si un servicio falla repetidamente, se deja de llamar por un tiempo.
- **Saga:** coordinación de transacciones distribuidas como secuencia de eventos.
- **BFF (Backend for Frontend):** un backend por tipo de cliente (web, móvil).

---

## Message Queues

Las **colas de mensajes** permiten la comunicación **asíncrona** entre servicios: un productor publica un mensaje y los consumidores lo procesan más tarde.

```
[Productor] -> [Cola/Broker] -> [Consumidor 1]
                           ---> [Consumidor 2]
```

### Patrones

| Patrón | Descripción | Ejemplos |
|--------|-------------|----------|
| Cola (queue) | Un mensaje lo consume un único consumidor | RabbitMQ, SQS |
| Pub/Sub | Un mensaje llega a todos los suscriptores | Kafka, NATS |
| Cola de trabajo (work queue) | Varios workers se reparten tareas | Celery + RabbitMQ |
| Request/Reply | Petición y respuesta asíncrona | RPC sobre broker |

### RabbitMQ

Broker clásico orientado a colas y enrutamiento flexible.

- Modela intercambios (exchanges) que enrutan mensajes a colas según reglas.
- Soporta ack/nack para entrega fiable.
- Ideal para tareas y workflows.

### Apache Kafka

Plataforma de streaming distribuido. No es una cola tradicional sino un **log** particionado y replicado.

- Los mensajes se guardan en **topics** particionados durante un tiempo configurable.
- Los consumidores mantienen su propio offset de lectura.
- Pensado para altísimo throughput y retención duradera.

```
Topic "pedidos" (3 particiones):
  P0: [msg1, msg4, msg7]
  P1: [msg2, msg5]
  P2: [msg3, msg6]
```

### Casos de uso

- Procesamiento asíncrono (enviar email, generar PDF).
- Desacoplar productores y consumidores (soportar picos de carga).
- Event-driven architecture.
- Streaming de datos y pipelines ETL.
- Replicación de datos entre servicios (CDC).

### Beneficios

- **Desacoplamiento:** productor y consumidor no se conocen.
- **Resiliencia:** si el consumidor cae, los mensajes se encolan.
- **Escalado:** añadir consumidores para repartir la carga.
- **Picos:** absorber aumentos bruscos de tráfico.

### Garantías de entrega

| Garantía | Descripción |
|----------|-------------|
| At-most-once | Puede perderse algún mensaje |
| At-least-once | Nunca se pierde, pero puede duplicarse (idempotencia necesaria) |
| Exactly-once | La más compleja; requiere transaccionalidad del broker |

---

## Patrones de diseño distribuido

### Circuit Breaker

Si un servicio falla repetidamente, se abre el circuito y se deja de llamar durante un tiempo, devolviendo un error rápido o un fallback. Tras un periodo, entra en half-open para probar si se ha recuperado.

```
Closed (normal) --errores--> Open (rechaza rápido)
                              |  (timer)
                              v
                          Half-Open (prueba)
                              |
                   ok -> Closed   / fail -> Open
```

### Saga

Coordina una transacción distribuida como una secuencia de transacciones locales, cada una con una **acción compensatoria** de deshacer si algo falla.

```
Pedido -> Reservar stock -> Cobrar -> Enviar
  <- compensa                <- compensa (si falla)
```

### Idempotencia

Una operación es idempotente si ejecutarla varias veces produce el mismo efecto que una vez. Esencial en sistemas distribuidos porque los mensajes pueden duplicarse. Estrategia: usar un id único por operación y guardarlo para detectar repeticiones.

### CQRS

**Command Query Responsibility Segregation:** separa el modelo de escritura (commands) del de lectura (queries). Permite optimizar cada lado independientemente y escalar lecturas.

### Event Sourcing

En lugar de almacenar el estado actual, se guarda la **secuencia de eventos** que llevaron a ese estado. El estado se reconstruye aplicando los eventos. Facilita auditoría y reconstrucción, pero añade complejidad.

### Strangler Fig

Migrar un monolito gradualmente: se van desviando partes a nuevos microservicios detrás de un facade, hasta que el monolito "se asfixia" y desaparece.

### Bulkhead

Aislar recursos por servicio o tenant para que un fallo en uno no arrastre al resto (ej: pools de conexiones separados).

### Rate limiting

Limitar el número de peticiones por cliente o por unidad de tiempo para proteger el sistema. Algoritmos: token bucket, leaky bucket, fixed window, sliding window.

---

## Resumen

- **Escalabilidad vertical** sube una máquina; **horizontal** añade máquinas.
- El **caching** es la forma más barata de reducir latencia y carga; cuidado con la consistencia y el stampede.
- El **load balancing** reparte tráfico y aumenta disponibilidad; hay L4 (rápido) y L7 (flexible).
- **Sharding** reparte datos entre máquinas; la **shard key** lo es todo.
- La **replicación** da disponibilidad y lecturas, pero introduce consistencia eventual.
- El **teorema CAP** obliga a elegir entre consistencia y disponibilidad durante particiones.
- Los **microservicios** desacoplan y escalan, pero añaden complejidad operativa.
- Las **colas de mensajes** permiten asincronía y desacoplamiento entre servicios.
- Patrones como **circuit breaker, saga, idempotencia y rate limiting** resuelven problemas típicos de sistemas distribuidos.

> Volver al [índice de conceptos](../07-concepts/)
