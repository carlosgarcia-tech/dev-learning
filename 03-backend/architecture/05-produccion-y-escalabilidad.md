# 05 — Producción y Escalabilidad

> El sistema en producción. Escalabilidad vertical y horizontal, mensajería asíncrona, colas y workers, arquitectura event-driven, event sourcing, CQRS en producción, balanceo de carga, caché distribuida, bases de datos distribuidas, observabilidad, resiliencia y la metodología 12-factor app.

## Objetivos

- [ ] Distinguir escalabilidad vertical y horizontal y por qué stateless es clave.
- [ ] Explicar mensajería asíncrona con RabbitMQ, Kafka y Redis.
- [ ] Implementar patrones de colas y workers.
- [ ] Describir arquitectura event-driven y event sourcing en producción.
- [ ] Aplicar CQRS con vistas de lectura optimizadas.
- [ ] Distribuir carga con load balancers (round-robin, least connections).
- [ ] Usar caché distribuida (Redis) con estrategias de invalidación.
- [ ] Explicar sharding, replicación y read replicas en bases de datos.
- [ ] Implementar observabilidad: logs, métricas y tracing.
- [ ] Aplicar patrones de resiliencia: circuit breaker, retry, timeout, bulkhead.
- [ ] Conocer los 12 factores de la 12-factor app.

## Escalabilidad

Capacidad de un sistema de manejar más carga (usuarios, datos, peticiones) sin degradar el rendimiento.

### Vertical vs Horizontal

```
ESCALADO VERTICAL (scale up)        ESCALADO HORIZONTAL (scale out)
   ┌─────────┐                       ┌─────────┐ ┌─────────┐ ┌─────────┐
   │ Server  │                       │ Server  │ │ Server  │ │ Server  │
   │  64CPU  │                       │  4CPU   │ │  4CPU   │ │  4CPU   │
   │ 512GB   │                       │  16GB   │ │  16GB   │ │  16GB   │
   └─────────┘                       └─────────┘ └─────────┘ └─────────┘
   (una máquina más grande)          (más máquinas pequeñas)
```

| | Vertical | Horizontal |
|---|---|---|
| Cómo | Mejor hardware (más CPU/RAM) | Más instancias |
| Límite | Hardware físico | Prácticamente ilimitado |
| Estado | Funciona con estado | Requiere **stateless** |
| Complejidad | Baja | Media (distribución de carga) |
| Coste | Crece rápido | Mejor relación coste/rendimiento |
| Disponibilidad | 1 punto de fallo | Tolerante a fallos |

### Stateless (sin estado)

Condición imprescindible para escalar horizontalmente. Un servidor **stateless** no guarda estado entre peticiones: cualquier instancia puede atender cualquier petición.

```
STATEFUL (malo para escalar)        STATELESS (bueno para escalar)
┌──────────┐                        ┌──────────┐
│ Server A │                        │ LB       │
│ sesión   │ ← sesión de usuario 1   └──┬─┬─┬──┘
│  aquí    │                           ▼ ▼ ▼
└──────────┘                        ┌──A─B─C──┐
   si A cae, se pierde la sesión    │ stateless│
   (debes volver a A siempre)       └──────────┘
                                    cualquier instancia sirve
```

**Regla:** el estado vive en almacenamiento compartido (Redis, BD), no en la memoria del servidor. Las sesiones van a Redis, no al proceso.

## Mensajería asíncrona

El emisor envía un mensaje y **no espera** la respuesta. Un broker intermedio lo entrega al consumidor cuando pueda. Desacopla emisor y receptor en **tiempo** y **espacio**.

```
Productor ──publica──> [ Broker ] ──entrega──> Consumidor
  (inmediato)          (cola/topic)             (cuando pueda)
```

### RabbitMQ

Broker de mensajes con modelo **cola** (AMQP). Mensajes persistentes, routing sofisticado (exchanges, bindings), acknowledge manual.

```
Productor ──> [Exchange] ──binding──> [Queue] ──> Consumidor
   (publica a exchange)    (cola)         (consume)
```

- **Modelo:** cola, 1 mensaje → 1 consumidor (work queue) o fan-out.
- **Garantías:** persistencia, ack/nack, dead-letter queues.
- **Cuándo:** tareas de trabajo, RPC asíncrono, nivelado de picos.

```python
# Pika (Python) - enviar a una cola
import pika
conn = pika.BlockingConnection(pika.ConnectionParameters("localhost"))
ch = conn.channel()
ch.queue_declare(queue="emails")
ch.basic_publish(exchange="", routing_key="emails", body="Hola",
                 properties=pika.BasicProperties(delivery_mode=2))  # persistente
conn.close()
```

### Kafka

Plataforma de **event streaming** distribuida. No es una cola, es un **log** append-only, particionado y replicado. Los mensajes se retienen (días, para siempre).

```
Topic "pedidos" (particionado)
┌─────────────────────────────────────────┐
│ Partición 0:  [m1][m2][m3][m4]          │  ← offset monótono
│ Partición 1:  [m5][m6][m7]             │
│ Partición 2:  [m8][m9][m10][m11][m12]   │
└─────────────────────────────────────────┘
   consumidores leen por offset; retención configurable
```

- **Modelo:** log particionado; consumidores mantienen su **offset**.
- **Rendimiento:** millones de eventos/segundo.
- **Retención:** mensajes se guardan aunque ya se consumieran (replay).
- **Cuándo:** event sourcing, pipelines de datos, streaming, alta throughput.

### Redis (Pub/Sub, Streams)

Redis puede usarse como broker ligero (pub/sub) o con Streams (cola persistente).

```
PUBLISH canal "hola"   →  [Redis]  →  SUBSCRIBE canal
```

- **Pub/Sub:** sin persistencia (si no hay suscriptor, se pierde). Rápido, efímero.
- **Streams:** persistente, con consumer groups. Ligero pero no tan robusto como Kafka/RabbitMQ.
- **Cuándo:** notificaciones en tiempo real, sistemas pequeños donde ya tienes Redis.

### Comparativa brokers

| | RabbitMQ | Kafka | Redis Streams |
|---|---|---|---|
| Modelo | Cola AMQP | Log particionado | Log en memoria |
| Retención | Hasta consumir | Configurable (días) | Limitada por memoria |
| Throughput | Miles/s | Millones/s | Miles/s |
| Routing | Rico (exchanges) | Particiones | Simple |
| Caso | Tareas, RPC async | Streaming, event sourcing | Notificaciones, ligero |

## Colas y workers

Patrón productor-consumidor: las peticiones costosas se **encolan** y **workers** las procesan en segundo plano.

```
  Cliente ──POST /upload──> API ──encola job──> [Cola] ──> Worker
   (responde 202 inmediato)                      (procesa: 5min)
                                                              │
   Cliente ──GET /jobs/123─> API <──estado── store <──────────┘
```

```python
# API: encola y responde ya
@app.post("/upload")
def upload(file):
    job_id = str(uuid.uuid4())
    cola.push({"job_id": job_id, "file": file})
    return jsonify({"job_id": job_id, "status": "pending"}), 202  # Accepted

# Worker: consume y procesa
def worker():
    while True:
        job = cola.pop()
        procesar_video(job["file"])   # lento
        store.set(job["job_id"], "done")
```

**Ventajas:** el usuario no espera; nivelado de carga (la cola absorbe picos); reintentos; prioridades.

## Event-driven architecture

Arquitectura donde los **eventos** son el mecanismo principal de comunicación entre servicios. Un evento = "algo que pasó" (`PedidoCreado`, `PagoConfirmado`).

```
  Pedidos ──publica PedidoCreado──> [Bus de eventos]
                                        │
                ┌───────────────────────┼───────────────────────┐
                ▼                       ▼                       ▼
            Inventario                Envíos                   CRM
            (reserva stock)         (prepara envío)        (registra cliente)
```

- El emisor **no conoce** a los receptores; pub/sub.
- Cada receptor reacciona de forma independiente y se puede añadir sin tocar al emisor.
- La consistencia es **eventual**: el stock se reserva "al rato", no en la misma transacción.

### Características

- **Desacoplamiento máximo:** añadir un consumidor nuevo no cambia al productor.
- **Extensibilidad:** un nuevo servicio se suscribe al evento y reacciona.
- **Resiliencia:** si un consumidor cae, los eventos se acumulan y los procesa al volver.
- **Replay:** puedes reprocesar eventos (Kafka retiene).
- **Contras:** flujo difícil de seguir (necesitas tracing); consistencia eventual; idempotencia obligatoria.

## Event Sourcing en producción

Guardar la **secuencia de eventos** en vez del estado actual. El estado se reconstruye aplicando los eventos.

```
  Event Store (append-only)
  ┌──────┬───────────────────────┬───────────────┐
  │ seq  │ evento                │ datos         │
  ├──────┼───────────────────────┼───────────────┤
  │ 1    │ CuentaCreada          │ {saldo:0}     │
  │ 2    │ Depositado            │ {cantidad:30} │
  │ 3    │ Retirado              │ {cantidad:10} │
  │ 4    │ Depositado            │ {cantidad:30} │
  └──────┴───────────────────────┴───────────────┘
  Estado actual = aplicar 1+2+3+4 = saldo 50
```

```python
class CuentaAggregate:
    def __init__(self): self.saldo = 0; self.cambios = []
    def depositar(self, cantidad):
        if cantidad <= 0: raise ValueError
        self._apply(Depositado(cantidad))
    def _apply(self, e): self._reducir(e); self.cambios.append(e)
    def _reducir(self, e):
        if isinstance(e, Depositado): self.saldo += e.cantidad
        elif isinstance(e, Retirado): self.saldo -= e.cantidad

# Reconstruir desde el store
eventos = event_store.load("cuenta-123")
cuenta = CuentaAggregate()
for e in eventos: cuenta._reducir(e)
# cuenta.saldo == estado actual
```

### Snapshots

Reconstruir desde el evento 1 cada vez es lento. Un **snapshot** guarda el estado en un punto; al arrancar cargas el snapshot + eventos posteriores.

```
  eventos:  [e1][e2]...[e5000]  [e5001]...[e9000]
                                  ▲
  snapshot@5000: {saldo: 1200}  ──┘ cargar desde aquí + eventos >5000
```

### Ventajas y peligros

- **+ Auditoría total:** tienes el historial completo.
- **+ Nuevas vistas:** proyectas eventos a tablas nuevas sin migrar.
- **+ Time travel:** estado en cualquier momento.
- **− Versión de eventos:** un campo cambia; necesitas upcasters.
- **− Almacenamiento crece:** necesitas compactación/snapshots.
- **− Consistencia eventual:** las vistas proyectadas pueden ir retrasadas.

## CQRS en producción

Separa escritura (Commands) de lectura (Queries) con modelos distintos. En producción, la vista de lectura suele ser una **tabla denormalizada** sincronizada desde el modelo de escritura vía eventos.

```
      WRITE (Command)                READ (Query)
  ┌──────────────────┐          ┌──────────────────────┐
  │ CrearPedidoCmd   │          │ pedidos_view         │
  │ → valida         │          │ (denormalizada,      │
  │ → guarda Pedido  │──evento──>│  JOIN ya hecho)      │
  │ → publica evento │  async   │ → respuesta rápida   │
  └──────────────────┘          └──────────────────────┘
   (normalizado, consistente)   (optimizada para leer)
```

```python
# Write side: command handler
class CrearPedidoHandler:
    def handle(self, cmd):
        pedido = Pedido(items=cmd.items)
        repo.save(pedido)              # write model
        bus.publish(PedidoCreado(pedido.id, pedido.total))

# Read side: projector que escucha eventos y actualiza vista
class PedidoProjector:
    def on_pedido_creado(self, e):
        read_db.execute(
            "INSERT INTO pedidos_view (id, total, cliente) VALUES (?,?,?)",
            (e.pedido_id, e.total, e.cliente_id))

# Query: lee directo de la vista denormalizada
class PedidoQuery:
    def resumen(self, id):
        return read_db.query("SELECT * FROM pedidos_view WHERE id=?", (id,))
```

**Cuándo:** sistemas con R/W asimétricos (ej. 99% lecturas), listados con joins caros, búsqueda全文. **No** en un CRUD simple.

## Distribución de carga (Load Balancing)

Un **load balancer** reparte tráfico entre varias instancias para evitar que una sola se sature y para alta disponibilidad.

```
           Cliente
             │
             ▼
      ┌──────────────┐
      │ Load Balancer│
      └──┬───┬───┬───┘
         │   │   │
      ┌──▼┐┌──▼┐┌──▼┐
      │S1 ││S2 ││S3 │   (instancias stateless)
      └───┘└───┘└───┘
```

### Algoritmos de balanceo

| Algoritmo | Cómo reparte | Cuándo |
|---|---|---|
| **Round-robin** | S1→S2→S3→S1... | Instancias iguales |
| **Least connections** | Al que menos conexiones tenga | Peticiones de duración variable |
| **IP hash** | Misma IP → misma instancia | Sticky sessions (con stateful) |
| **Random** | Aleatorio | Simple, distribuye bien con muchas |
| **Weighted** | Proporcional a un peso | Instancias de distinto tamaño |

```
Round-robin:              Least connections:
req1 → S1                 S1: 2 conns
req2 → S2                 S2: 5 conns  ← no, tiene más
req3 → S3                 S3: 1 conn   ← sí, el de menos
req4 → S1
```

### Health checks

El LB sondea cada instancia (`GET /health`). Si no responde o devuelve error, lo saca de la rotación (**drain**).

```
S1 ──GET /health──> 200 OK → sigue en rotación
S2 ──GET /health──> 500    → marcado down, no recibe tráfico
```

## Cache distribuida (Redis)

La caché guarda resultados frecuentes para evitar golpear la BD. En arquitecturas con múltiples instancias, la caché debe ser **compartida** (Redis), no en memoria de cada proceso.

```
Cliente ──> API ──> ¿en Redis? ──sí──> devolver cacheado
                          │
                          no
                          ▼
                        BD ──> escribir en Redis (TTL) ──> devolver
```

### Estrategias de caché

| Estrategia | Cómo | Cuándo |
|---|---|---|
| **Cache-aside** | App lee cache; si miss, lee BD y llena cache | Default general |
| **Write-through** | Escribe en cache Y BD a la vez | Lecturas críticas |
| **Write-behind** | Escribe en cache; async a BD | Alta escritura |
| **TTL** | Caduca tras X segundos | Datos que cambian poco |

### Invalidación

El problema más difícil. ¿Cuándo invalidar?

```python
# Cache-aside con invalidación en escritura
def get_user(id):
    cached = redis.get(f"user:{id}")
    if cached: return json.loads(cached)
    user = db.find(id)
    redis.setex(f"user:{id}", 300, json.dumps(user))  # TTL 5min
    return user

def update_user(id, data):
    db.update(id, data)
    redis.delete(f"user:{id}")   # invalida en escritura
```

**Peligros:** cache stampede (varias peticiones miss a la vez), datos obsoletos (stale), thundering herd. Soluciones: lock, jitter en TTL.

### Patrones avanzados

- **Pub/Sub para invalidación:** al actualizar, publicas `invalidate:user:123`; todas las instancias borran su copia.
- **Cache warming:** precalentar la caché al desplegar para no empezar frío.

## Bases de datos en arquitecturas distribuidas

### Sharding (particionado horizontal)

Divide una tabla enorme en **shards** (trozos) repartidos por una **shard key**. Cada servidor guarda un subconjunto de filas.

```
Tabla "users" con 100M filas, shard por user_id % 3:

  Shard 0 (user_id % 3 == 0)    Shard 1 (% 3 == 1)    Shard 2 (% 3 == 2)
  ┌─────────────────┐           ┌─────────────────┐   ┌─────────────────┐
  │ user_id | name │           │ user_id | name │   │ user_id | name │
  │ 3       | Ana  │           │ 1       | Bob  │   │ 2       | Cy   │
  │ 6       | Dan  │           │ 4       | Eve  │   │ 5       | Fae  │
  └─────────────────┘           └─────────────────┘   └─────────────────┘
```

- **Ventaja:** escala escritura y almacenamiento.
- **Reto:** elegir bien la shard key; cross-shard queries son caras; redistribución difícil.

### Replicación (replication)

Copia los datos de un **primary** a uno o más **replicas**.

```
  Primary (escrituras) ──replica──> Replica 1 (lecturas)
                      ──replica──> Replica 2 (lecturas)
```

- **Síncrona:** el primary espera el ack de replicas antes de confirmar (consistente, lento).
- **Asíncrona:** el primary confirma y replica luego (rápido, eventualmente consistente).

### Read Replicas

Patrón común: las escrituras van al primary, las lecturas a réplicas. Escala lectura.

```
  App ──write──> Primary ──replicate──> Replica (read)
  App ──read──> Replica
```

**Caveat:** consistencia eventual; si lees justo después de escribir, la réplica puede no tenerlo aún. Patrón "read-your-writes" requiere enrutar tu propia escritura temporalmente al primary.

### Tabla resumen BD distribuida

| Técnica | Escala | Problema |
|---|---|---|
| Sharding | Escritura + almacenamiento | Shard key, queries cross-shard |
| Replicación | Lectura + disponibilidad | Lag, consistencia |
| Read replicas | Lectura | Read-your-writes |
| Denormalización | Lectura | Duplicación, invalidación |

## Observabilidad

Capacidad de entender el estado del sistema desde fuera. Tres pilares:

### 1. Logs

Eventos discretos con timestamp. Se centralizan (ELK, Loki) y se estructuran (JSON).

```json
{"ts":"2026-08-22T10:00:00Z","level":"info","service":"pedidos",
 "trace_id":"abc123","msg":"Pedido creado","pedido_id":"p-1"}
```

- **Regla:** log estructurado (JSON), con `trace_id`, nivel y contexto.
- **Niveles:** DEBUG (detalle), INFO (eventos), WARN (raro pero ok), ERROR (fallo).

### 2. Métricas

Valores agregados en el tiempo (counters, gauges, histograms). Se consultan en dashboards (Prometheus + Grafana).

```
# Prometheus
http_requests_total{method="POST",route="/orders",status="201"} 1234
http_request_duration_seconds_bucket{le="0.1"} 1100
active_connections 42
```

- **Counter:** solo sube (peticiones totales).
- **Gauge:** sube y baja (conexiones activas).
- **Histogram:** distribución (latencia de peticiones).

### 3. Tracing distribuido

Sigue una petición a través de múltiples servicios con un **trace_id**. Cada servicio añade **spans**.

```
trace_id: abc123
  span: POST /checkout (250ms)
    ├─ span: Pedidos.crear (30ms)
    ├─ span: Inventario.reservar (80ms)
    └─ span: Pagos.cobrar (140ms)
         └─ span: DB.insert pago (50ms)
```

- Permite ver **dónde** se va el tiempo y **qué servicio** falló.
- Estándares: OpenTelemetry, Jaeger, Zipkin.
- **Regla:** propaga `trace_id` en todas las llamadas (headers HTTP, metadata gRPC, atributos de mensaje).

### Tabla observabilidad

| Pilar | Qué responde | Herramientas |
|---|---|---|
| Logs | ¿Qué pasó en este evento? | ELK, Loki, CloudWatch |
| Métricas | ¿Cómo está el sistema en agregado? | Prometheus, Grafana |
| Tracing | ¿Dónde se fue el tiempo / qué falló? | Jaeger, Zipkin, OpenTelemetry |

## Patrones de resiliencia

Técnicas para que un sistema **siga funcionando** cuando las dependencias fallan.

### Circuit Breaker

(Ver detalle en [04-microservicios-y-ddd.md](04-microservicios-y-ddd.md).) Tras N fallos, deja de llamar y falla rápido.

```
CLOSED ──fallos>umbral──> OPEN ──timeout──> HALF-OPEN ──éxito──> CLOSED
```

### Retry con backoff

Reintentar una operación que falló por algo transitorio (red), con espera creciente y **jitter** (aleatorización) para evitar sincronización.

```python
import time, random

def call_with_retry(fn, retries=3, base=0.1):
    for i in range(retries):
        try:
            return fn()
        except Exception:
            if i == retries - 1: raise
            delay = base * (2 ** i) + random.uniform(0, 0.1)  # jitter
            time.sleep(delay)
```

- **Backoff exponencial:** 0.1s, 0.2s, 0.4s...
- **Jitter:** +random(0,0.1s) para que no todos reintenten a la vez.
- **Ojo:** reintentar operaciones **no idempotentes** es peligroso (doble cobro). Idempotencia primero.

### Timeout

Límite de tiempo para una operación. Sin timeout, un servicio lento puede agotar todos tus hilos/conexiones.

```python
# Si la BD no responde en 2s, falla (mejor eso que colgar)
requests.get(url, timeout=2)
```

**Regla:** toda llamada externa tiene timeout. El timeout debe propagarse: si el controller tiene 5s, el servicio 4s y el repo 3s.

### Bulkhead

Aísla recursos por servicio/operación para que un fallo no consuma todos los recursos. Un "compartimento estanco" como en un barco.

```
Pool de hilos total: 100

  SIN bulkhead (malo)              CON bulkhead (bueno)
  ┌──────────────────────┐        ┌──────────┐┌──────────┐┌──────────┐
  │ 100 hilos compartidos │        │ Serv A   ││ Serv B   ││ Serv C   │
  │ si A se cuelga,      │        │ 30 hilos ││ 30 hilos ││ 40 hilos │
  │ consume los 100      │        │ (aislado)││(aislado) ││(aislado) │
  └──────────────────────┘        └──────────┘└──────────┘└──────────┘
                                   si A cae, B y C siguen
```

- Cada dependencia con su pool de conexiones/hilos propio.
- Un servicio lento no puede consumir el pool del resto.

### Tabla resiliencia

| Patrón | Protege de | Cómo |
|---|---|---|
| Circuit Breaker | Fallos en cascada | Deja de llamar a algo caído |
| Retry | Fallos transitorios | Reintenta con backoff+jitter |
| Timeout | Lentitud indefinida | Falla tras X segundos |
| Bulkhead | Agotamiento de recursos | Pools aislados por dependencia |

## 12-factor app

Metodología de Heroku (Adam Wiggins) para construir SaaS modernos. 12 reglas que hacen una app portable, escalable y apta para cloud.

| # | Factor | Qué dice | Violación típica |
|---|---|---|---|
| I | **Codebase** | 1 codebase trackeado, N despliegues | Múltiples repos para el mismo app |
| II | **Dependencies** | Declaradas y aisladas explícitamente | "En mi máquina funciona" |
| III | **Config** | Config en entorno, no en código | API keys en el código |
| IV | **Backing services** | Recursos externos como URLs | BD hardcodeada |
| V | **Build, release, run** | 3 fases separadas | Build y run mezclados |
| VI | **Processes** | Stateless, estado en backing | Sesión en memoria del proceso |
| VI | **Port binding** | La app escucha un puerto (es el servidor) | Necesitar Apache delante |
| VIII | **Concurrency** | Escala por procesos | Una sola instancia gigante |
| VIII | **Disposability** | Arranque rápido, parada limpia | Shutdown de 5 minutos |
| IX | **Logs** | Streams de eventos a stdout | Escribir a archivo local |
| X | **Admin processes** | Tareas como procesos 1-off | Cron en el servidor de prod |
| XI | **Dev/prod parity** | Entornos lo más similares posible | Dev en SQLite, prod en Postgres |

> Nota: los factores están numerados con números romanos; por el orden clásico, algunos puntos comparten numeración en esta tabla comprimida para resaltar el principio. La lista canónica es: I Codebase, II Dependencies, III Config, IV Backing services, V Build/release/run, VI Processes, VII Port binding, VIII Concurrency, IX Disposability, X Logs, XI Admin processes, XII Dev/prod parity.

### Ejemplos de aplicación

```bash
# III Config: config en entorno, no en código
DATABASE_URL=postgres://... redis_url=redis://... JWT_SECRET=... ./app
# VI Processes: stateless; la sesión va a Redis
session_store = Redis(redis_url)   # no un dict en memoria
# IX Logs: a stdout, no a archivo
print('{"level":"info","msg":"ready"}')   # el runtime los recolecta
# XI Dev/prod parity: mismo stack
docker-compose.yml   # dev
docker-compose.prod.yml  # prod (mismo base, distinta config)
```

## Tabla de referencia rápida

| Concepto | Una línea |
|---|---|
| Escalado vertical | Máquina más grande |
| Escalado horizontal | Más máquinas (stateless) |
| Stateless | Sin estado entre peticiones (escala horizontal) |
| RabbitMQ | Cola AMQP, tareas |
| Kafka | Log particionado, streaming |
| Cola + worker | Encolar tareas costosas |
| Event-driven | Comunicación por eventos pub/sub |
| Event sourcing | Guardar eventos, reconstruir estado |
| CQRS | Separar escritura (command) de lectura (query) |
| Load balancer | Reparte tráfico entre instancias |
| Round-robin | S1→S2→S3 cíclico |
| Least connections | Al que menos carga tenga |
| Cache distribuida | Redis compartido |
| Sharding | Particionar por clave |
| Read replica | Réplica de lectura del primary |
| Observabilidad | Logs + métricas + tracing |
| Circuit breaker | Fallar rápido ante dependencia caída |
| Bulkhead | Pools aislados por dependencia |
| 12-factor | 12 reglas para apps cloud |

## Conceptos clave

- **Stateless es la llave de la escalabilidad horizontal:** sin estado, cualquier instancia sirve; con estado, estás atado a ella.
- **Asíncrono desacopla:** colas y eventos permiten que el emisor no espere al receptor y nivelan picos.
- **Event-driven = máximo desacoplamiento:** añadir consumidores sin tocar al productor.
- **CQRS en producción necesita sincronizar la vista de lectura** (generalmente por eventos), no es magia gratuita.
- **Caché: la invalidación es lo difícil.** TTL, invalidación en escritura y pub/sub para coherencia.
- **Sharding escala escritura pero la shard key lo decide todo:** elegirla mal lo hace inutilizable.
- **Observabilidad = logs + métricas + tracing:** los tres, con `trace_id` común, o no puedes depurar producción.
- **Resiliencia se compone:** circuit breaker + retry + timeout + bulkhead se combinan para no caer en cascada.
- **12-factor app es el contrato cloud:** seguirla hace la app portable y escalable por defecto.

## Errores comunes

- **Estado en memoria del proceso:** sesiones en un dict; al escalar horizontalmente, peticiones a otra instancia se pierden.
- **Retry sin idempotencia:** reintentar un pago no idempotente → doble cobro. Siempre haz operaciones retryables idempotentes.
- **Caché sin TTL:** datos que nunca caducan y se vuelven obsoletos sin que nadie lo note.
- **Shard key mal elegida:** por `created_at` → el shard del día actual recibe todo el tráfico (hotspot).
- **Read replica con read-your-writes roto:** el usuario crea algo, lo lee y no aparece (la réplica va con lag).
- **Timeouts ausentes:** un servicio lento agota hilos y tira toda la app.
- **Bulkhead olvidado:** un solo pool compartido; una dependencia lenta lo consume entero.
- **Logs a archivo local:** en containers, se pierden; deben ir a stdout y ser recolectados.
- **Config en el código:** API keys, URLs en el repo; deben ir en variables de entorno.
- **Ignorar el lag de consistencia eventual:** asumir que tras `publish` el consumidor ya procesó; no, es asíncrono.
- **Circuit Breaker sin half-open:** si no tiene half-open, nunca se recupera aunque el servicio vuelva.
