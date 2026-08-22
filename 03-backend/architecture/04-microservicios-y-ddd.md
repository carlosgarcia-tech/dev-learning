# 04 — Microservicios y DDD

> Del monolito a los sistemas distribuidos. Qué son los microservicios, cuándo (no) usarlos, y cómo modelarlos con Domain-Driven Design: bounded contexts, aggregates, eventos de dominio y comunicación asíncrona. Patrones distribuidos: API Gateway, Service Discovery, Saga, Circuit Breaker, CQRS y Event Sourcing.

## Objetivos

- [ ] Definir microservicio y diferenciar monolito vs microservicios.
- [ ] Decidir cuándo (no) usar microservicios.
- [ ] Dominar DDD: bounded contexts, entities, value objects, aggregates, repositories, domain events, application services, ubiquitous language.
- [ ] Comparar formas de comunicación entre microservicios: REST, gRPC, async messaging, event-driven.
- [ ] Explicar API Gateway y Service Discovery.
- [ ] Implementar Saga (choreography y orchestration) para transacciones distribuidas.
- [ ] Aplicar Circuit Breaker para resiliencia.
- [ ] Entender CQRS y Event Sourcing en contexto distribuido.

## Microservicios

Un **microservicio** es un servicio pequeño, autónomo, que:

- Implementa una **capacidad de negocio** concreta (no una capa técnica).
- Es **propiedad de un equipo** y se despliega de forma independiente.
- **Tiene su propia base de datos** (no comparte tablas con otros servicios).
- Se comunica con los demás **por red** (síncrona o asíncrona).
- Está diseñado para **reemplazarse**, no para crecer eternamente.

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│ Usuarios│   │Productos│   │ Pedidos │   │  Pagos  │
│   DB    │   │   DB    │   │   DB    │   │   DB    │
└────┬────┘   └────┬────┘   └────┬────┘   └────┬────┘
     │             │             │             │
     └─────────────┴─────────────┴─────────────┘
              red (REST / eventos / gRPC)
```

> **No** significa "1 servicio por endpoint REST". Un microservicio expone varios endpoints coherentes que pertenecen al mismo contexto de negocio.

### Monolito vs Microservicios

| | Monolito | Microservicios |
|---|---|---|
| Despliegue | 1 binario | N servicios independientes |
| Base de datos | Compartida | 1 por servicio |
| Escalado | Toda la app | Por servicio (solo el que lo necesita) |
| Equipos | 1 equipo, código compartido | Equipos autónomos |
| Comunicación | Llamadas a función (en proceso) | Red (latencia, fallos) |
| Consistencia | Transacciones ACID locales | Saga, consistencia eventual |
| Complejidad operativa | Baja | Alta (observabilidad, CI/CD) |
| Tiempo al mercado inicial | Rápido | Lento (hay que partirlo bien) |
| Stack | Único | Heterogéneo (cada servicio elige) |

### Cuándo usar microservicios (y cuándo no)

**Usa microservicios cuando:**
- El dominio es grande y se divide naturalmente en bounded contexts.
- Hay varios equipos que necesitan iterar y desplegar de forma independiente.
- Necesitas escalar partes del sistema de forma muy distinta.
- Toleras la complejidad operativa y tienes CI/CD + observabilidad maduros.

**NO uses microservicios cuando:**
- Es un MVP o un dominio que aún no entiendes bien.
- Hay un solo equipo pequeño.
- No tienes automatización de despliegue ni observabilidad.
- La lógica es un CRUD simple sin sub-dominios claros.

> **Regla de oro:** empieza por un monolito modular bien estructurado. Extrae microservicios solo cuando el dolor lo justifique. "Comienza en monolito, extrae a microservicios."

```
   Monolito modular ──(dolor por escala/equipos)──> Microservicios
   (bajo coste, rápido)                              (alto coste, autonomía)
```

## Domain-Driven Design (DDD)

Metodología de Eric Evans (2003) para modelar software complejo **alineado con el negocio**. El núcleo: que el código refleje el modelo del dominio, expresado en un **lenguaje ubicuo** compartido por expertos y desarrolladores.

DDD tiene dos fases:

1. **Strategic Design (estratégico):** divide el dominio en bounded contexts y define su relación.
2. **Tactical Design (táctico):** bloques de construcción dentro de un bounded context: entities, value objects, aggregates, etc.

### Ubiquitous Language (lenguaje ubicuo)

El vocabulario común entre negocio y código. Si el experto dice "Cliente Premium", en código hay una clase `ClientePremium`, no `User` con un flag `is_special`. El código **habla** el lenguaje del negocio.

```
Negocio: "Un cliente premium puede canjear puntos por descuentos"
Código:  class ClientePremium { canjearPuntos(puntos): Descuento }
   (mismas palabras, mismo significado)
```

### Bounded Context (contexto delimitado)

Un **bounded context** es un límite explícito dentro del cual un modelo y su lenguaje son consistentes. Fuera de ese límite, las palabras pueden significar otra cosa.

```
  Contexto "Ventas"            Contexto "Envíos"         Contexto "Facturación"
  ┌──────────────┐            ┌──────────────┐         ┌──────────────┐
  │ Producto     │            │ Producto     │         │ Producto     │
  │ (precio,     │            │ (peso,       │         │ (código      │
  │  stock)      │            │  dimensiones)│         │  fiscal)     │
  └──────────────┘            └──────────────┘         └──────────────┘
  "Producto" significa        "Producto" significa     "Producto" significa
  algo distinto en cada contexto. No compartir modelo entre contextos.
```

Un "Producto" en Ventas (precio, stock) no es el mismo concepto que en Envíos (peso, dimensiones). **Cada contexto tiene su modelo propio.** Un microservicio ≈ un bounded context.

### Bloques tácticos de DDD

#### Entity (Entidad)

Objeto definido por su **identidad** (no por sus atributos). Dos usuarios con los mismos datos pero distinto ID son distintos.

```python
class User:
    def __init__(self, id, email):
        self.id = id          # identidad
        self.email = email    # atributos mutables
    def __eq__(self, other):
        return isinstance(other, User) and self.id == other.id
```

#### Value Object (Objeto Valor)

Objeto definido por sus **valores**, sin identidad. Inmutable. Dos `Email("a@b.com")` son el mismo valor.

```python
@dataclass(frozen=True)  # inmutable
class Email:
    valor: str
    def __post_init__(self):
        if "@" not in self.valor: raise ValueError("email inválido")

e1 = Email("a@b.com"); e2 = Email("a@b.com")
e1 == e2  # True, mismo valor → mismo concepto
```

#### Aggregate (Agregado)

Un **cluster de entidades y value objects** tratado como una unidad de consistencia. Tiene una **aggregate root** (raíz) que es la única puerta de entrada: fuera del agregado solo se referencia la raíz.

```
  AGREGADO "Pedido"
  ┌───────────────────────────────────────┐
  │  Pedido (root) ◀── única entrada      │
  │   ├── línea1 (LineItem, entidad)      │
  │   ├── línea2 (LineItem)              │
  │   └── DireccionEnvio (value object)   │
  └───────────────────────────────────────┘
  (las reglas de invariantes del Pedido se garantizan
   solo si se accede por la root)
```

```python
class Pedido:  # aggregate root
    def __init__(self, id):
        self.id = id
        self.lineas = []
        self.estado = "borrador"
    def add_linea(self, producto, cantidad, precio):
        if self.estado != "borrador": raise Error("pedido cerrado")
        self.lineas.append(Linea(producto, cantidad, precio))
    def confirmar(self):
        if not self.lineas: raise Error("pedido vacío")
        self.estado = "confirmado"
```

**Invariante:** "un pedido confirmado no puede tener 0 líneas". Esa regla se garantiza solo si todo acceso pasa por `Pedido`. No añadas líneas modificando `pedido.lineas` directamente.

#### Repository (Repositorio)

Abstrae la persistencia de un **agregado** completo (no de entidades sueltas). Ofrece una vista "como colección en memoria".

```python
class PedidoRepository(ABC):
    @abstractmethod
    def save(self, pedido: Pedido): ...
    @abstractmethod
    def find_by_id(self, id) -> Pedido: ...

# El repo guarda el AGREGADO completo (Pedido + sus líneas) atómicamente.
```

#### Domain Event (Evento de dominio)

Algo significativo que **ocurrió** en el dominio. Se publica tras un cambio de estado y otros contextos reaccionan. Nombrado en pasado: `PedidoCreado`, `PagoConfirmado`.

```python
@dataclass
class PedidoCreado:
    pedido_id: str
    cliente_id: str
    total: float
    ocurrido_en: datetime

class Pedido:  # agregado publica eventos
    def confirmar(self):
        ...
        self.eventos.append(PedidoCreado(self.id, self.cliente_id, self.total))
```

Los eventos permiten desacoplar contextos: Pedidos publica `PedidoCreado`, Inventario y Envíos reaccionan sin que Pedidos los conozca.

#### Application Service (Servicio de aplicación)

Orquesta casos de uso: recibe un comando, carga el agregado del repositorio, invoca un método de dominio, persiste y publica eventos. **No contiene lógica de negocio**, solo coordinación.

```python
class ConfirmarPedidoService:
    def __init__(self, repo: PedidoRepository, bus: EventBus):
        self.repo = repo; self.bus = bus
    def execute(self, cmd: ConfirmarPedidoCommand):
        pedido = self.repo.find_by_id(cmd.pedido_id)
        pedido.confirmar()                       # lógica de dominio
        self.repo.save(pedido)
        for e in pedido.eventos:
            self.bus.publish(e)                  # publica eventos
```

### Tabla táctica DDD

| Bloque | Identidad | Mutabilidad | Ejemplo |
|---|---|---|---|
| Entity | Sí (ID) | Mutable | `User`, `Pedido` |
| Value Object | No (por valor) | Inmutable | `Email`, `Dinero` |
| Aggregate | Root con ID | Coordinado | `Pedido` + `Linea`s |
| Repository | — | — | `PedidoRepository` |
| Domain Event | — | Inmutable | `PedidoCreado` |
| Application Service | — | — | `ConfirmarPedidoService` |

## Comunicación entre microservicios

Cada forma tiene trade-offs de acoplamiento, latencia y resiliencia.

| | REST/HTTP | gRPC | Async messaging | Event-driven |
|---|---|---|---|---|
| Estilo | Request-response | Request-response | Cola (1→1) | Pub/sub (1→N) |
| Formato | JSON | Protobuf | JSON/Avro | JSON/Avro |
| Acoplamiento | Medio | Medio | Bajo | Muy bajo |
| Latencia | Media | Baja | Asíncrona | Asíncrona |
| Sincronicidad | Síncrono | Síncrono | Asíncrono | Asíncrono |
| Ejemplo | `GET /users/1` | `rpc.GetUser(id)` | RabbitMQ queue | Kafka topic |

### REST

Síncrono sobre HTTP/JSON. Simple, ubicuo, legible. Buen default para APIs externas.

```http
GET /users/123 HTTP/1.1
Host: api.tienda.com
Accept: application/json
```

- **Pro:** estándar, fácil de depurar, caching HTTP.
- **Contra:** acoplamiento temporal (el servidor debe estar up); JSON es verboso; sin schema estricto.

### gRPC

RPC binario sobre HTTP/2 con Protobuf. Tipado fuerte, muy rápido, streaming bidireccional. Ideal para comunicación interna servicio-a-servicio.

```protobuf
service UserService {
  rpc GetUser (UserRequest) returns (UserResponse);
}
message UserRequest { string id = 1; }
message UserResponse { string id = 1; string email = 2; }
```

- **Pro:** 5-10× más rápido que REST; schema estricto; streaming.
- **Contra:** menos legible; no browser-friendly sin grpc-web.

### Async messaging (colas)

El emisor envía un mensaje a una cola y **no espera**. El receptor lo consume cuando pueda. Desacopla temporalmente emisor y receptor.

```
Servicio A ──send(msg)──> [ Cola ] ──consume──> Servicio B
   (no espera)                                   (cuando pueda)
```

- **Pro:** resiliencia (si B cae, el mensaje queda en cola); leveling de picos.
- **Contra:** complejidad; no hay respuesta directa; orden y deduplicación.
- **Brokers:** RabbitMQ, AWS SQS, Redis Streams.

### Event-driven

Extensión de async: el emisor publica un **evento** y N servicios reaccionan. El emisor no sabe quién escucha (máximo desacoplamiento).

```
Pedidos ──publica──> [ Topic "pedidos" ] ──> Inventario
                                   ────────> Envíos
                                   ────────> CRM
   (Pedidos no conoce a quién reacciona)
```

- **Pro:** máxima desacoplamiento; añadir reactivos sin tocar el emisor.
- **Contra:** flujo difícil de seguir; consistencia eventual; necesitas idempotencia.
- **Plataformas:** Kafka, NATS, EventBridge.

### Reglas de oro de la comunicación

- **Prefiere asíncrono** entre servicios internos: reduce acoplamiento temporal y mejora resiliencia.
- **Síncrono (REST/gRPC) para consultas que necesitan respuesta inmediata** o APIs externas.
- **Nunca compartas base de datos** entre servicios: comparte eventos o APIs.
- **Diseña para idempotencia**: el mismo evento puede llegar duplicado.

## API Gateway

Punto único de entrada que enruta, compone, autentica y transforma peticiones hacia los microservicios.

```
        Cliente (web, mobile)
              │
              ▼
      ┌───────────────┐
      │  API Gateway  │  ─ auth, rate limit, logging, agregación
      └───┬───┬───┬───┘
          │   │   │
       ┌──▼┐ ┌▼┐ ┌▼────┐
       │Usr│ │Pr│ │Pedid│   (servicios internos)
       └───┘ └─┘ └─────┘
```

Responsabilidades:
- **Routing:** `/users/*` → servicio usuarios, `/orders/*` → pedidos.
- **AuthN/AuthZ:** valida tokens antes de llegar a los servicios.
- **Rate limiting & throttling:** protege contra abuso.
- **Aggregation:** una petición del cliente puede componer respuestas de varios servicios.
- **Protocol translation:** REST externo ↔ gRPC interno.
- **Logging/métricas:** punto central de observabilidad.

**Variantes:** BFF (Backend for Frontend) — un gateway por tipo de cliente (web, mobile) con APIs a medida.

## Service Discovery

En sistemas dinámicos, las instancias aparecen y desaparecen (autoscaling, reinicios). El **service discovery** permite que un servicio encuentre dónde está otro sin IPs hardcodeadas.

```
  Servicio A necesita llamar a B
         │
         ▼
  ┌───────────────┐   registro   ┌───────────────┐
  │ Service       │ <─────────── │ Servicio B    │
  │  Discovery     │   (latido)   │ (instancia 1) │
  │  Registry      │ <─────────── │ (instancia 2) │
  └───────┬───────┘              └───────────────┘
          │ resuelve "B" → ["10.0.0.1:8080","10.0.0.2:8080"]
          ▼
  Servicio A llama a una de las instancias
```

- **Client-side:** el cliente pregunta al registro y elige instancia (load balancing propio). Ej: Consul + Ribbon.
- **Server-side:** un load balancer pregunta al registro y enruta. Ej: Kubernetes Service + kube-proxy.

## Saga pattern

Problema: una operación de negocio cruza varios servicios (ej. `crearPedido` toca Pedidos, Inventario, Pagos). No hay transacción ACID distribuida barata. **Saga** descompone la operación en una secuencia de transacciones locales, cada una con una **acción compensatoria** (deshacer).

```
  Saga "CrearPedido"
  ┌─────────────┐     ┌────────────────┐     ┌──────────────┐
  │ 1. Crear    │ ──> │ 2. Reservar    │ ──> │ 3. Cobrar    │
  │    pedido   │     │    inventario  │     │    pago      │
  └─────────────┘     └────────────────┘     └──────────────┘
        │ si falla 3:            ▲               │ falla
        ▼                        │               ▼
  ┌─────────────┐     ┌────────────────┐
  │ 1c. Cancelar│ <── │ 2c. Liberar    │ <── (compensaciones en orden inverso)
  │    pedido   │     │    inventario   │
  └─────────────┘     └────────────────┘
```

### Orquestación vs Coreografía

**Orquestación (orchestration):** un **orquestador** central llama a cada paso y decide compensaciones. Flujo explícito, fácil de seguir, pero el orquestador es un punto más.

```python
class CrearPedidoSaga:
    def execute(self, pedido):
        try:
            pedidos.crear(pedido)
            inventario.reservar(pedido.id, pedido.items)
            pagos.cobrar(pedido.id, pedido.total)
        except PagoFallido:
            inventario.liberar(pedido.id)   # compensar
            pedidos.cancelar(pedido.id)      # compensar
```

**Coreografía (choreography):** no hay orquestador. Cada servicio reacciona a eventos y publica los suyos. Más desacoplado, pero el flujo es implícito.

```
Pedidos publica PedidoCreado
   → Inventario escucha, reserva, publica InventarioReservado
      → Pagos escucha, cobra, publica PagoConfirmado O PagoFallido
         → si PagoFallido, Inventario libera y Pedidos cancela
```

| | Orquestación | Coreografía |
|---|---|---|
| Flujo | Explícito (orquestador) | Implícito (eventos) |
| Acoplamiento | Medio | Bajo |
| Complejidad | Centralizada | Distribuida |
| Seguimiento | Fácil | Difícil (tracing) |
| Cuándo | Sagas complejas | Reacciones simples |

## Circuit Breaker

Protege un servicio de llamadas a otro que está fallando. Tras N fallos consecutivos, "abre el circuito" y falla rápido sin llamar; periódicamente prueba si se recuperó.

```
  ESTADOS:
  CLOSED ──(errores > umbral)──> OPEN
     ▲                               │
     │                               │ (timeout)
     │                               ▼
     └──────────────── HALF-OPEN ◄───┘
  (deja pasar 1 petición de prueba)
```

- **Closed:** normal, las peticiones pasan. Se cuentan los fallos.
- **Open:** no se llama al servicio; se devuelve error/fallback inmediato.
- **Half-Open:** se permite 1 petición de prueba; si va bien → Closed, si falla → Open.

```python
import time

class CircuitBreaker:
    def __init__(self, umbral=3, reset_seg=30):
        self.fallos = 0; self.umbral = umbral
        self.reset_seg = reset_seg
        self.estado = "closed"; self.ultimo_fallo = 0
    def call(self, fn, *a):
        if self.estado == "open":
            if time.time() - self.ultimo_fallo > self.reset_seg:
                self.estado = "half_open"
            else:
                raise Exception("CircuitBreaker abierto")
        try:
            r = fn(*a)
            self.fallos = 0; self.estado = "closed"
            return r
        except Exception as e:
            self.fallos += 1; self.ultimo_fallo = time.time()
            if self.fallos >= self.umbral: self.estado = "open"
            raise
```

- **Cuándo:** llamadas síncronas a servicios externos que pueden caer.
- **Librerías:** Hystrix (Java), opossum (Node), resilience4j.

## CQRS y Event Sourcing

### CQRS en microservicios

Separa escritura (Commands) de lectura (Queries). En microservicios permite:

- Optimizar lectura con vistas denormalizadas.
- Escalar lectura y escritura independientemente.
- Usar eventos para sincronizar la vista de lectura desde el modelo de escritura.

```
  Cliente ──Command──> [Servicio Pedidos (write)] ──evento──> [Read Model (query)]
  Cliente ──Query────> [Read Model (query)]   (vista denormalizada, rápida)
```

### Event Sourcing

En vez de guardar el **estado actual**, guardas la **secuencia de eventos** que llevaron a ese estado. El estado se **reconstruye** replays de eventos.

```
  Estados tradicionales:       Event Sourcing:
  ┌──────────┐                 ID   Evento            Estado reconstruido
  │ saldo=50 │                 ──── ──────────────── ──────────────────
  └──────────┘                 #1   CuentaCreada     saldo=0
   (se pierde el historial)    #2   Depositado(30)   saldo=30
                               #3   Retirado(10)     saldo=20
                               #4   Depositado(30)   saldo=50
                               (guardas eventos; el estado se deriva)
```

```python
class CuentaBancaria:  # aggregate con event sourcing
    def __init__(self):
        self.saldo = 0
        self.cambios = []   # eventos nuevos
    # Comando
    def depositar(self, cantidad):
        if cantidad <= 0: raise ValueError
        self._apply(Depositado(cantidad))   # genera evento
    # Aplica evento (muta estado + lo guarda)
    def _apply(self, evento):
        self._reducir(evento)
        self.cambios.append(evento)
    def _reducir(self, evento):  # reductor: evento → estado
        if isinstance(evento, Depositado): self.saldo += evento.cantidad
        elif isinstance(evento, Retirado): self.saldo -= evento.cantidad
    # Reconstruir desde historial
    @classmethod
    def from_history(cls, eventos):
        c = cls()
        for e in eventos: c._reducir(e)
        return c
```

**Ventajas:** auditoría total; el estado es derivado; puedes crear nuevas vistas proyectando eventos. **Contras:** complejidad; snapshots; versionado de eventos; almacenamiento crece.

## Tabla de patrones distribuidos

| Patrón | Problema | Solución |
|---|---|---|
| API Gateway | Múltiples servicios, un cliente | Punto único de entrada que enruta/compon |
| Service Discovery | IPs dinámicas | Registro que resuelve nombres→instancias |
| Saga | Transacción distribuida | Secuencia de tx locales + compensaciones |
| Circuit Breaker | Cascada de fallos | Fallar rápido si el destino está caído |
| CQRS | R/W asimétricos | Separar modelo de escritura y lectura |
| Event Sourcing | Auditoría/derivar estado | Guardar eventos, reconstruir estado |

## Conceptos clave

- **Empieza en monolito, extrae microservicios** cuando el dolor lo justifique; no al revés.
- **1 microservicio ≈ 1 bounded context:** divide por capacidad de negocio, no por capa técnica.
- **Cada servicio, su propia BD** (database per service); compartir BD = monolito distribuido.
- **Ubiquitous language:** el código debe hablar el idioma del negocio; sinónimos entre negocio y código son deuda.
- **Aggregate root es la única puerta** al agregado; garantiza invariantes y consistencia.
- **Los eventos de dominio desacoplan contextos:** Pedidos no conoce Inventario; ambos hablan por eventos.
- **Prefiere asíncrono y event-driven** entre servicios para resiliencia y bajo acoplamiento.
- **Saga, no transacciones distribuidas:** la consistencia eventual es la norma; diseña compensaciones.
- **Circuit Breaker** evita que un servicio caído arrastre a los que lo llaman.

## Errores comunes

- **"Microservicios = 1 endpoint por servicio":** no; un servicio agrupa varias operaciones coherentes de un contexto.
- **Base de datos compartida:** 2 servicios consultan la misma tabla → acoplamiento de datos, no es microservicio.
- **Comunicación síncrona encadenada:** A→B→C→D; si D cae, toda la cadena falla. Usa asíncrono o circuit breaker.
- **Modelo anémico en DDD:** entidades sin comportamiento (solo getters/setters); la lógica vive en services, perdiendo el valor de DDD.
- **Aggregate demasiado grande:** un agregado "Pedido" que contiene Usuarios y Productos; viola el límite de consistencia.
- **Eventos que llevan estado completo en vez de delta:** `PedidoActualizado` con todo el pedido; rompe versionado y浪费 almacenamiento.
- **No diseñar compensaciones en Saga:** si falla un paso y no hay undo, el sistema queda inconsistente.
- **Olvidar idempotencia:** un evento procesado dos veces duplica efectos; los consumidores deben ser idempotentes.
- **Circuit Breaker sin fallback:** abrir el circuito sin devolver nada útil deja al usuario colgado.
- **Coreografía sin trazas:** sin distributed tracing, un bug en un flujo de eventos es imposible de rastrear.
