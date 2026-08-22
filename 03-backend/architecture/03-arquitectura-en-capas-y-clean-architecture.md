# 03 — Arquitectura en Capas y Clean Architecture

> De las 3 capas clásicas a las arquitecturas que aislan el dominio. Capas, hexagonal, Clean Architecture, Dependency Rule, Dependency Injection, Onion. El objetivo siempre es el mismo: proteger el dominio de los detalles.

## Objetivos

- [ ] Dominar la arquitectura en capas controller-service-repository.
- [ ] Explicar la arquitectura hexagonal (ports and adapters) y su diferencia con capas simples.
- [ ] Describir las capas de Clean Architecture (entities, use cases, interface adapters, frameworks).
- [ ] Aplicar la **Dependency Rule**: las dependencias apuntan siempre hacia dentro.
- [ ] Implementar Dependency Injection (constructor, setter, interface).
- [ ] Explicar la inversión de dependencias (DIP) como motor de Clean Architecture.
- [ ] Separar dominio de infraestructura.
- [ ] Conocer la arquitectura Onion como variante de Clean.

## Arquitectura en capas (controller-service-repository)

La arquitectura más extendida en backend. Organiza el código en capas horizontales con responsabilidades distintas:

```
┌──────────────────────────────────────────────────────┐
│  Presentación (Controllers)                          │
│  ─ parsea HTTP, valida formato, devuelve HTTP/JSON  │
├──────────────────────────────────────────────────────┤
│  Negocio (Services / Use Cases)                     │
│  ─ reglas de negocio, orquesta repositorios          │
│  ─ NO sabe de HTTP ni de SQL                         │
├──────────────────────────────────────────────────────┤
│  Datos (Repositories)                                │
│  ─ abstrae persistencia, traduce objetos↔filas       │
├──────────────────────────────────────────────────────┤
│  Infraestructura (BD, frameworks)                    │
│  ─ drivers, ORM, connection pool                     │
└──────────────────────────────────────────────────────┘
        ▲ dependencias hacia abajo
```

### Controller → Service → Repository

```
HTTP POST /users {name,email}
   │
   ▼
┌──────────────┐  createUser(dto)   ┌──────────────┐  save(user)   ┌──────────────┐
│ UserController│ ─────────────────>│ UserService  │ ─────────────>│ UserRepository│
│  (present.)  │<─────────────────│  (negocio)    │<─────────────│   (datos)    │
└──────────────┘   UserDTO          └──────────────┘   User        └──────────────┘
```

```javascript
// repository.js (datos)
class UserRepository {
  constructor(db) { this.db = db; }
  async save(user) {
    await this.db.query('INSERT INTO users (id, name, email) VALUES (?, ?, ?)',
      [user.id, user.name, user.email]);
    return user;
  }
  async findById(id) { /* SELECT ... */ }
}

// service.js (negocio)
class UserService {
  constructor(repo) { this.repo = repo; }   // inyección
  async createUser(name, email) {
    if (!email.includes('@')) throw new Error('email inválido');
    const user = { id: crypto.randomUUID(), name, email };
    await this.repo.save(user);
    return user;
  }
}

// controller.js (presentación)
class UserController {
  constructor(service) { this.service = service; }   // inyección
  async postUser(req, res) {
    try {
      const user = await this.service.createUser(req.body.name, req.body.email);
      res.status(201).json(user);
    } catch (e) {
      res.status(400).json({ error: e.message });
    }
  }
}

// composición (la capa más externa conoce todo)
const repo = new UserRepository(db);
const service = new UserService(repo);
const controller = new UserController(service);
```

### Reglas de oro de las capas

1. **Solo hacia abajo:** una capa solo conoce a la inmediatamente inferior.
2. **El service no sabe de HTTP:** no ve `req`, `res`, ni status codes. Si lo hace, contamina el dominio.
3. **El controller no sabe de SQL:** no hace consultas. Solo orquesta y traduce.
4. **El repository devuelve objetos de dominio**, no filas crudas.
5. **Inyección de dependencias:** los componentes reciben sus dependencias desde fuera (constructor).

### Antipatrón: capa pasamanos (anemic)

Si el service solo hace `return this.repo.save(user)` sin ninguna regla, es un pasamanos: la capa de negocio está vacía. El dominio está anémico y todo el peso recae en la BD.

```
Controller ──> Service.save(user) ──> Repo.save(user)
                 (sin lógica)            (INSERT)
   ←─────── user ──────── user ──────
```

Señal de alarma: si pudieras quitar el service y que controller llamara directamente al repo sin perder nada, **el dominio no existe**.

## Arquitectura hexagonal (Ports and Adapters)

Propuesta por Alistair Cockburn (2005). Lleva el DIP al extremo: el **núcleo de la aplicación** no conoce nada del exterior. Todo entra y sale por **puertos** (interfaces), conectados al mundo mediante **adaptadores**.

```
              ADAPTADORES DRIVING (entrada)
              ┌──────────┐  ┌──────────┐
   HTTP ─────▶│ HTTPCtrl │─▶│          │
   CLI  ─────▶│ CLIAdap  │─▶│ PUERTO   │
   gRPC ─────▶│ gRPCAdap │─▶│ DRIVING  │
              └──────────┘  │          │
                            │  NÚCLEO  │
                            │  (app +  │
                            │  dominio)│
                            │          │
              ┌──────────┐  │ PUERTO   │
   MySQL ◀────│ MySQLRepo│◀─│ DRIVEN   │
   Redis ◀────│ RedisRep │◀─│          │
   APIext ◀────│ APIAdap  │◀─│          │
              └──────────┘
              ADAPTADORES DRIVEN (salida)
```

### Puertos

- **Driving (de entrada):** qué puede hacerse con la aplicación. Interfaces que implementan los **casos de uso**. Ej: `CreateUserPort`, `GetUserPort`.
- **Driven (de salida):** qué necesita la aplicación del exterior. Interfaces que implementan los **adaptadores**. Ej: `UserRepositoryPort`, `MailPort`.

### Adaptadores

- **Driving:** traducen el mundo exterior (HTTP, CLI, gRPC) al puerto driving. Un controlador HTTP es un adaptador driving.
- **Driven:** implementan el puerto driven. `MySQLUserRepository` es un adaptador driven que implementa `UserRepositoryPort`.

### Ejemplo completo

```python
# ===== NÚCLEO (sin dependencias externas) =====
from abc import ABC, abstractmethod

# Puerto driven: lo que la app necesita del exterior
class UserRepository(ABC):
    @abstractmethod
    def save(self, user): ...
    @abstractmethod
    def find_by_email(self, email): ...

class Mailer(ABC):
    @abstractmethod
    def send_welcome(self, email): ...

# Entidad de dominio
class User:
    def __init__(self, email):
        if "@" not in email: raise ValueError("email inválido")
        self.email = email

# Caso de uso (implementa el puerto driving)
class CreateUserUseCase:
    def __init__(self, repo: UserRepository, mailer: Mailer):
        self.repo = repo
        self.mailer = mailer

    def execute(self, email):
        if self.repo.find_by_email(email):
            raise ValueError("ya existe")
        user = User(email)
        self.repo.save(user)
        self.mailer.send_welcome(email)
        return user

# ===== ADAPTADORES (conocen el exterior, implementan puertos) =====
class MySQLUserRepository(UserRepository):
    def __init__(self, conn): self.conn = conn
    def save(self, user):
        self.conn.execute("INSERT INTO users ...", (user.email,))
    def find_by_email(self, email):
        row = self.conn.execute("SELECT ...", (email,)).fetchone()
        return row and {"email": row[0]}

class SmtpMailer(Mailer):
    def send_welcome(self, email): print(f"enviando mail a {email}")

# ===== COMPOSICIÓN (el único punto que conoce todo) =====
use_case = CreateUserUseCase(MySQLUserRepository(conn), SmtpMailer())
```

### Diferencia con capas simples

| | Capas simples | Hexagonal |
|---|---|---|
| Dependencias | Presentación → Negocio → Datos | Todo hacia el núcleo |
| ¿Dominio conoce BD? | A veces (vía ORM) | Nunca |
| Tests | Necesitas BD o mock pesado | InMemory adapters, puros |
| Cambiar SQL por Mongo | Reescribir repos | Cambiar adaptador driven |
| Entradas (HTTP/CLI/gRPC) | Una por app | Múltiples adapters driving |

## Clean Architecture

Propuesta por Robert C. Martin ("Uncle Bob"). Generaliza hexagonal en **4 capas concéntricas**, cada una más abstracta hacia dentro.

```
                  ┌─────────────────────────────────────────────┐
                  │  Frameworks & Drivers                       │
                  │  (Web, BD, frameworks, UI)                  │
                  │   ┌─────────────────────────────────────┐   │
                  │   │  Interface Adapters                 │   │
                  │   │  (Controllers, Presenters, Gateways)│   │
                  │   │   ┌─────────────────────────────┐   │   │
                  │   │   │  Use Cases                  │   │   │
                  │   │   │  (casos de uso, interactors) │   │   │
                  │   │   │   ┌─────────────────────┐    │   │   │
                  │   │   │   │  Entities           │    │   │   │
                  │   │   │   │  (modelo de dominio)│   │   │   │
                  │   │   │   └─────────────────────┘    │   │   │
                  │   │   └─────────────────────────────┘   │   │
                  │   └─────────────────────────────────────┘   │
                  └─────────────────────────────────────────────┘
            ──────────────────────────────────────────────────────
            DEPENDENCY RULE: las flechas SIEMPRE apuntan hacia dentro
            (de Frameworks → ... → Entities)
```

### Las 4 capas

| Capa | Qué contiene | Sabe de |
|---|---|---|
| **Entities** | Reglas de negocio empresariales, entidades, value objects | Nada externo |
| **Use Cases** | Reglas de negocio de la aplicación, casos de uso | Entities |
| **Interface Adapters** | Controllers, presenters, gateways, mappers | Use Cases |
| **Frameworks & Drivers** | Web, DB, frameworks, dispositivos externos | Interface Adapters |

### Entities vs Use Cases

- **Entities** son reglas que sobrevivirían aunque no hubiera software (reglas de la empresa): `Pedido.calcularTotal()`, `Usuario.esMayorDeEdad()`.
- **Use Cases** son reglas específicas de la aplicación: `CrearPedidoUseCase`, `CancelarPedidoUseCase`. Orquestan entidades y aplican casos concretos.

> Si cambias de framework web, las entities no se tocan. Si cambias de BD, los use cases no se tocan. Esa es la promesa.

### Ejemplo: CrearPedido

```python
# ===== ENTITIES (lo más interno, puro dominio) =====
class Pedido:
    def __init__(self, id, items):
        self.id = id
        self.items = items  # lista de {producto, precio, cantidad}
    def total(self):
        return sum(i["precio"] * i["cantidad"] for i in self.items)

# ===== USE CASES =====
class CrearPedidoUseCase:
    def __init__(self, repo, notificador):
        self.repo = repo          # interfaz (puerto driven)
        self.notificador = notificador
    def execute(self, items):
        pedido = Pedido(id=gen_id(), items=items)
        if pedido.total() <= 0: raise ValueError("pedido vacío")
        self.repo.save(pedido)
        self.notificador.pedido_creado(pedido)
        return pedido.id

# ===== INTERFACE ADAPTERS =====
class PedidoController:
    def __init__(self, use_case): self.uc = use_case
    def post(self, req):
        try:
            pid = self.uc.execute(req["items"])
            return (201, {"id": pid})
        except ValueError as e:
            return (400, {"error": str(e)})

# ===== FRAMEWORKS & DRIVERS =====
class SQLPedidoRepository:   # implementa el puerto del use case
    def save(self, pedido): ...  # INSERT INTO pedidos ...
class RabbitNotifier:
    def pedido_creado(self, pedido): ...  # publica evento
```

## La Dependency Rule

> **Las dependencias de código fuente solo pueden apuntar hacia dentro.**

Cada círculo puede no saber nada del código de un círculo más externo. En particular:

- **Entities** no importan nada externo.
- **Use Cases** importan entities; no importan controllers ni BD.
- **Interface Adapters** importan use cases; no importan frameworks.
- **Frameworks** importan interface adapters (y estos a los interiores).

```
       Frameworks ──> Adapters ──> Use Cases ──> Entities
         (SQL, HTTP)  (Ctrl)        (UC)          (Dom)
              ▲ la flecha apunta hacia DENTRO
```

**Consecuencia:** el código interno (lo valioso, el dominio) no conoce los detalles (framework, BD). Los detalles son plugins intercambiables. Esto es la **formalización del DIP** aplicado a la arquitectura completa.

### ¿Cómo se cumple si el use case necesita guardar?

El use case declara una interfaz (`PedidoRepository`) y la usa. La capa externa (`SQLPedidoRepository`) **implementa** esa interfaz. La dependencia de compilación va del SQL al use case (hacia dentro), aunque en tiempo de ejecución el use case llame al repositorio.

```
        PedidoRepository  (interfaz, definida en use cases)
              △ implements
        SQLPedidoRepository (frameworks & drivers)
              │
              │  dependencia de código fuente:
              │  SQLRepo ──> interfaz (hacia dentro) ✓
```

## Dependency Injection (DI)

La DI es la técnica que materializa el DIP. Consiste en que un componente **reciba** sus dependencias desde fuera, en vez de crearlas (`new`) o buscarlas.

### Sin DI (acoplado)

```python
class OrderService:
    def __init__(self):
        self.repo = MySQLPedidoRepository()   # acoplado: crea y conoce MySQL
        self.mailer = SmtpMailer()             # acoplado: conoce SMTP
```

### Con DI (desacoplado)

```python
class OrderService:
    def __init__(self, repo, mailer):   # recibe abstracciones
        self.repo = repo
        self.mailer = mailer
```

### Tipos de inyección

**1. Constructor (la más común y recomendada):**

```python
class Service:
    def __init__(self, repo: Repository):  # inmutable y visible
        self.repo = repo
```

**2. Setter:**

```python
class Service:
    def set_repo(self, repo): self.repo = repo  # mutable, flexible
```

**3. Interface (contenedor DI):**

```python
# Un contenedor resuelve las dependencias por ti
container = Container()
container.register(Repository, MySQLRepository)
container.register(Service, lambda c: Service(c.get(Repository)))
service = container.get(Service)  # el contenedor inyecta todo
```

### Ejemplos en frameworks

- **Spring (Java):** `@Autowired`, `@Component`.
- **NestJS (Node):** `@Injectable()`, inyección por constructor.
- **.NET:** `services.AddTransient<IRepo, SqlRepo>()`.

### Beneficios

- **Testable:** en tests inyectas dobles (mocks, fakes, in-memory).
- **Desacoplado:** cambiar MySQL por Postgres es cambiar la inyección.
- **Single Responsibility:** la clase no crea sus dependencias; solo las usa.
- **Ciclo de vida controlado:** el contenedor gestiona singletons, scopes, transients.

## Inversión de dependencias (DIP)

La pieza central. El principio dice:

1. Los módulos de alto nivel no deben depender de los de bajo nivel. Ambos deben depender de **abstracciones**.
2. Las abstracciones no deben depender de los detalles. Los detalles deben depender de las abstracciones.

```
SIN DIP (malo)                  CON DIP (bueno)

Alto nivel ──> Bajo nivel        Alto nivel ──> Abstracción ◁── Bajo nivel
(Service)      (MySQLRepo)        (Service)      (IRepo)       (MySQLRepo)
                                  la flecha de dependencia se INVIERTE
```

```python
# SIN DIP
class UserService:
    def __init__(self):
        self.repo = MySQLUserRepository()  # depende de concreto

# CON DIP
class UserService:
    def __init__(self, repo: UserRepository):  # depende de abstracción
        self.repo = repo
class MySQLUserRepository(UserRepository):     # el concreto depende de la abstracción
    ...
```

El efecto: `UserService` ya no sabe que existe MySQL. Puedes inyectar `InMemoryUserRepository` en tests. La **flecha de dependencia** se invirtió: antes el service dependía del repo concreto; ahora ambos dependen de la interfaz.

> Clean Architecture y hexagonal son, en el fondo, **el DIP aplicado sistemáticamente a toda la arquitectura**.

## Separación de dominio e infraestructura

La división más útil en la práctica: **dominio** (lo que resuelve el problema) vs **infraestructura** (todo lo demás que lo soporta).

```
DOMINIO (core, puro)                  INFRAESTRUCTURA (detalles)
┌──────────────────────────┐         ┌──────────────────────────┐
│ Entidades (Pedido, User)│         │ Frameworks web (Express) │
│ Value Objects (Email)   │         │ Bases de datos (MySQL)   │
│ Reglas de negocio        │         │ ORMs (Prisma, Hibernate)   │
│ Casos de uso             │         │ Mensajería (RabbitMQ)     │
│ Interfaces (puertos)     │         │ Cache (Redis)             │
└──────────────────────────┘         │ Librerías externas         │
   (no importa el framework)         │ HTTP, gRPC, CLI            │
                                     └──────────────────────────┘
                                         (intercambiable, "plugin")
```

### Regla práctica

Pregúntate: **si mañana cambiamos de Express a Fastify, ¿se toca el dominio?** Si sí, el dominio no está aislado.

```javascript
// ❌ Dominio contaminado por infraestructura
class UserService {
  constructor() { this.app = express(); }   // conoce el framework
  async login(req, res) {                    // conoce HTTP
    const row = await db.query('SELECT...'); // conoce SQL
  }
}

// ✅ Dominio aislado
class UserService {
  constructor(repo, hasher) { this.repo = repo; this.hasher = hasher; }
  async login(email, password) {
    const user = await this.repo.findByEmail(email);
    if (!user || !this.hasher.verify(password, user.hash)) return null;
    return user;
  }
}
```

## Arquitectura Onion

Variante de Clean Architecture (Jeffrey Palermo). Similar estructura concéntrica, pero organiza por capas de Model/Service/DataService y pone interfaces en el centro.

```
                  ┌──────────────────────────────────────┐
                  │  UI / Web                            │
                  │   ┌──────────────────────────────┐   │
                  │   │  Infrastructure              │   │
                  │   │   ┌──────────────────────┐   │   │
                  │   │   │  Domain Services     │   │   │
                  │   │   │   ┌──────────────┐   │   │   │
                  │   │   │   │  Domain Model │   │   │   │
                  │   │   │   │  (entities + │   │   │   │
                  │   │   │   │   interfaces)  │   │   │   │
                  │   │   │   └──────────────┘   │   │   │
                  │   │   └──────────────────────┘   │   │
                  │   └──────────────────────────────┘   │
                  └──────────────────────────────────────┘
                  dependencias hacia dentro (igual que Clean)
```

- **Domain Model:** entidades + **interfaces** de repositorios (no implementaciones).
- **Domain Services:** lógica que involucra varias entidades.
- **Infrastructure:** implementaciones de las interfaces (repos concretos, logging, etc.).
- **UI:** controladores, views.

**Diferencia con Clean:** Onion mezcla "interfaces e implementaciones en capas adyacentes"; Clean pone todas las interfaces como fronteras. En la práctica, son intercambiables; ambas cumplen la Dependency Rule.

## Tabla comparativa de arquitecturas

| | Capas simples | Hexagonal | Clean | Onion |
|---|---|---|---|---|
| Estructura | Horizontal | Núcleo + adaptadores | Concéntrica (4) | Concéntrica (4) |
| Foco | Separar presentación/negocio/datos | Aislar núcleo de todo exterior | Regla de dependencia | Igual que Clean |
| Interfaces | Repos | Puertos driving/driven | Boundaries | Interfaces en centro |
| Flexibilidad entrada | 1 (HTTP) | Múltiples adapters | Múltiples | Múltiples |
| Complejidad | Baja | Media | Media-alta | Media-alta |
| Cuándo | CRUD, MVP | Apps con varias entradas | Lógica de negocio rica | Similar a Clean |

## Conceptos clave

- **La Dependency Rule es la regla universal:** dependencias hacia dentro, siempre. El dominio no conoce los detalles.
- **DIP es el motor:** invertir dependencias con interfaces es lo que permite aislar el dominio.
- **DI es la técnica:** recibir dependencias en el constructor desacopla y facilita tests.
- **Hexagonal, Clean y Onion son variantes** del mismo principio: aislar el dominio. La elección es más de gusto/equipo que de sustancia.
- **El dominio es lo que queda si quitas el framework:** si al borrar Express/MySQL todo se rompe, el dominio no estaba aislado.
- **El repository es el patrón clave** para desacoplar persistencia; es la frontera entre dominio e infraestructura.

## Errores comunes

- **Saltarse capas:** controller que hace `db.query` directamente; rompe la separación y acopla presentación a SQL.
- **Service pasamanos:** sin lógica, solo delega al repo; dominio anémico.
- **Dominio que importa el framework:** `import express` o `import mysql` dentro de un use case o entity.
- **VIOLACIÓN de la Dependency Rule:** un use case que importa un controller o un controller que importa la BD concreta (no la interfaz).
- **DI mal aplicada:** usar service locator (buscar dependencias) en vez de constructor injection; oculta dependencias y dificulta tests.
- **Mocking la BD en vez de abstraerla:** si necesitas mockear `mysql`, no tienes un repositorio; si mockeas `UserRepository`, sí.
- **Muchas capas para un CRUD:** Clean/Hexagonal en un CRUD simple es over-engineering; 3 capas bastan.
- **Pasar DTOs al dominio:** el dominio debe trabajar con entidades, no con estructuras de HTTP (`req.body`).
- **Olvidar el punto de composición:** nadie define dónde se cablean dependencias; el "main" o el contenedor DI es el único que conoce todo.
