# 01 — Fundamentos de Arquitectura de Software

> La base de todo. Qué es la arquitectura, cómo se diferencia del diseño, los estilos clásicos, el acoplamiento y la cohesión, la separación de intereses y los principios SOLID. Sin esto, todo lo demás son palabras.

## Objetivos

- [ ] Definir arquitectura de software y distinguirla del diseño detallado.
- [ ] Explicar la diferencia entre estilo arquitectónico y patrón.
- [ ] Describir los estilos: monolito, cliente-servidor, capas, microservicios.
- [ ] Medir el acoplamiento y la cohesión de un módulo.
- [ ] Aplicar el principio de separación de intereses (separation of concerns).
- [ ] Enunciar y aplicar los 5 principios SOLID (SRP, OCP, LSP, ISP, DIP).
- [ ] Reconocer la arquitectura en capas (presentación, negocio, datos).
- [ ] Explicar la arquitectura hexagonal (puertos y adaptadores).

## Qué es la arquitectura de software

La **arquitectura de software** es el conjunto de decisiones estructurales de alto nivel que definen un sistema: cómo se divide en componentes, cómo se relacionan, qué responsabilidades tiene cada uno y qué restricciones gobiernan su evolución. Esas decisiones son costosas de cambiar después, por eso se toman temprano.

> La arquitectura es las decisiones que quieres postergar tomar el mayor tiempo posible. — *Robert C. Martin*

Tres pilares clásicos (atributos de calidad, ISO/IEC 25010):

1. **Estructura:** componentes, conectores y sus relaciones.
2. **Comportamiento:** cómo interactúan para cumplir los requisitos funcionales.
3. **Atributos de calidad:** rendimiento, disponibilidad, seguridad, mantenibilidad, escalabilidad.

### Arquitectura vs Diseño

| | Arquitectura | Diseño |
|---|---|---|
| **Alcance** | Sistema completo, subsistemas | Clase, módulo, función |
| **Coste de cambio** | Alto (afecta a muchos) | Bajo-medio (local) |
| **Cuándo** | Temprano, fundacional | Continuo, iterativo |
| **Pregunta** | ¿Cómo divido el sistema? | ¿Cómo implemento este módulo? |
| **Ejemplo** | "Microservicios con API Gateway" | "Usar el patrón Strategy aquí" |

La frontera es difusa, pero la regla útil es: **si cambiarlo obliga a tocar muchos componentes y a redesplegar varios servicios, es arquitectura**.

## Estilos arquitectónicos

Un **estilo arquitectónico** es una plantilla de organización: un vocabulario de componentes y conectores con restricciones sobre cómo combinarlos. No es un patrón concreto (que resuelve un problema específico), sino una forma general de estructurar.

### Monolito

Todo el sistema en una sola unidad desplegable. Una base de datos, un proceso, un binario.

```
┌─────────────────────────────────────┐
│            MONOLITO                  │
│  ┌─────────┐ ┌─────────┐ ┌────────┐  │
│  │  Web UI │ │  Admin  │ │  API   │  │
│  └────┬────┘ └────┬────┘ └───┬────┘  │
│       └──────────┬┴──────────┘       │
│         ┌────────▼────────┐         │
│         │  Lógica negocio │         │
│         └────────┬────────┘         │
│         ┌────────▼────────┐         │
│         │   Base de datos  │         │
│         └─────────────────┘         │
└─────────────────────────────────────┘
```

- **Pros:** simple de desarrollar, depurar y desplegar; comunicación en proceso (rápida); transacciones ACID fáciles.
- **Contras:** escala mal; un bug puede tirar todo; equipos grandes chocan; pila tecnológica única.
- **Cuándo:** MVP, equipos pequeños, dominio estable, baja escala.

### Cliente-servidor

Dos partes: el cliente pide, el servidor responde. Base de la web, RPC y muchas APIs.

```
┌─────────┐    request     ┌─────────┐
│ Cliente │ ─────────────> │ Servidor│
│ browser │ <───────────── │   API   │
└─────────┘    response    └─────────┘
```

- **Pros:** separa responsabilidades; el servidor se puede escalar independientemente; clientes múltiples.
- **Contras:** el servidor es cuello de botella; requiere red; el cliente debe gestionar estado UI.

### Capas (layered)

Los componentes se organizan en capas horizontales; cada capa solo habla con la inmediatamente inferior.

```
┌──────────────────────────────┐
│  Presentación (UI / API)     │  capa N
├──────────────────────────────┤
│  Negocio (lógica de dominio) │  capa N-1
├──────────────────────────────┤
│  Datos (acceso a BD)         │  capa N-2
├──────────────────────────────┤
│  Infraestructura (BD, red)   │  capa base
└──────────────────────────────┘
        ▲ solo hacia abajo
```

- **Pros:** separación de intereses clara; testable por capas; fácil de entender.
- **Contras:** puede volverse rígida; muchas capas añaden latencia; acoplamiento vertical si se salta capas.
- **Regla:** una capa solo conoce a la inmediatamente inferior. Si `Presentación` llama a `Datos` directamente, está rota.

### Microservicios

El sistema se divide en servicios pequeños, autónomos, cada uno con su propia base de datos, desplegados independientemente y comunicados por red.

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│ Usuarios│   │ Productos│   │ Pedidos │   │  Pagos  │
│   BD    │   │   BD     │   │   BD    │   │   BD    │
└────┬────┘   └────┬────┘   └────┬────┘   └────┬────┘
     │             │             │             │
     └─────────────┴─────────────┴─────────────┘
                       (red / eventos)
```

- **Pros:** escalado independiente; equipos autónomos; aislamiento de fallos; despliegues independientes.
- **Contras:** complejidad distribuida (red, consistencia, observabilidad); latencia; datos distribuidos; operación costosa.

> Se profundiza en [04-microservicios-y-ddd.md](04-microservicios-y-ddd.md).

## Patrones vs estilos

| Concepto | Alcance | Ejemplo |
|---|---|---|
| **Estilo arquitectónico** | Forma global de organizar | Microservicios, capas |
| **Patrón arquitectónico** | Solución recurrente a un subproblema | API Gateway, BFF, CQRS |
| **Patrón de diseño** | Solución a nivel de clase/módulo | Singleton, Strategy |
| **Idioma** | Truco de un lenguaje | `Array.map` en JS |

Un estilo es la **forma del edificio**; un patrón es la **distribución de una habitación**; un patrón de diseño es **cómo se abre una puerta**.

## Acoplamiento y cohesión

Dos métricas fundamentales para evaluar cualquier diseño.

### Acoplamiento (coupling)

Grado en que un módulo **depende de otro**. Queremos **bajo acoplamiento**: cambiar un módulo no rompe los demás.

```
ALTO acoplamiento (malo)           BAJO acoplamiento (bueno)

  A ──> B ──> C                       A ─┐
  │    │    │                          B ├─> interfaz común
  └────┴────┘                          C ─┘
  (todo conoce a todo)              (dependen de abstracciones)
```

Señales de alto acoplamiento:
- Importas clases concretas en vez de interfaces.
- Cambiar la BD implica tocar los controladores.
- Para testear A, necesitas instanciar B, C y D.

### Cohesión (cohesion)

Grado en que los elementos de un módulo **pertenecen juntos** y trabajan hacia un mismo fin. Queremos **alta cohesión**: un módulo hace una sola cosa bien.

```
BAJA cohesión (malo)               ALTA cohesión (bueno)

  ┌─────────────────┐                ┌──────┐  ┌──────┐
  │ GestorTodo      │                │Auth  │  │Mail  │
  │ - login()       │                │      │  │      │
  │ - enviarMail()  │                └──────┘  └──────┘
  │ - exportarPDF() │
  │ - calcularNomina│
  └─────────────────┘
  (clase "saco" que hace de todo)
```

### La regla de oro

> **Bajo acoplamiento + alta cohesión.**

Cada módulo debe hacer **una cosa** (cohesión) y comunicarse con los demás mediante **abstracciones** (bajo acoplamiento). Esto maximiza la mantenibilidad y la testabilidad.

## Separación de intereses (Separation of Concerns)

Principio de que un sistema se divide en piezas tales que **cada una aborda un interés distinto**. Un "interés" es una responsabilidad o eje de cambio.

Ejemplo clásico: no mezcles HTML con SQL. La presentación no debe saber cómo se persisten los datos, y la persistencia no debe saber cómo se renderiza la UI.

```javascript
// ❌ Mezcla de intereses: UI + acceso a datos en una función
function mostrarUsuario(id) {
  const db = require('db');
  const user = db.query(`SELECT * FROM users WHERE id=${id}`); // SQL en la UI
  console.log(`<h1>${user.name}</h1>`);                        // HTML en la lógica
}

// ✅ Intereses separados
class UserRepository {
  findById(id) { /* solo datos */ }
}
class UserView {
  render(user) { /* solo presentación */ }
}
class UserService {
  constructor(repo, view) { this.repo = repo; this.view = view; }
  show(id) {
    const user = this.repo.findById(id);
    this.view.render(user);
  }
}
```

Cada interés cambia por razones distintas y a ritmos distintos. Separarlos permite que evolucionen sin arrastrarse unos a otros.

## Principios SOLID

Cinco principios de diseño orientado a objetos que promueven sistemas mantenibles y flexibles. Son la base de buena parte de la arquitectura moderna.

### S — Single Responsibility Principle (SRP)

> Una clase debe tener **una sola razón para cambiar**.

No significa "un método por clase", sino "un actor o interés que la hace cambiar". Si una clase cambia cuando el equipo de contabilidad cambia las reglas **y** cuando el equipo de UI cambia el formato, tiene dos responsabilidades.

```python
# ❌ Dos razones para cambiar: persistencia + cálculo
class Factura:
    def total(self): ...
    def guardar_en_bd(self): ...   # responsabilidad de persistencia
    def to_xml(self): ...          # responsabilidad de serialización

# ✅ Una razón cada una
class Factura:           # dominio
    def total(self): ...
class FacturaRepository: # persistencia
    def guardar(self, f): ...
class FacturaSerializer: # serialización
    def to_xml(self, f): ...
```

### O — Open/Closed Principle (OCP)

> Una entidad debe estar **abierta a extensión** pero **cerrada a modificación**.

Añadir funcionalidad no debe requerir tocar código existente (y arriesgar romperlo). Se logra con polimorfismo, composición o abstracciones.

```javascript
// ❌ Para añadir un descuento nuevo, hay que tocar esta función
function precioFinal(tipo, base) {
  if (tipo === 'normal') return base;
  if (tipo === 'vip') return base * 0.8;
  // cada descuento nuevo = otro if aquí
}

// ✅ Abierto a extensión: añades una clase, sin tocar las existentes
class Descuento {
  aplicar(base) { return base; }
}
class DescuentoVIP extends Descuento {
  aplicar(base) { return base * 0.8; }
}
function precioFinal(descuento, base) {
  return descuento.aplicar(base); // no cambia al añadir descuentos
}
```

### L — Liskov Substitution Principle (LSP)

> Los subtipos deben ser **sustituibles** por sus tipos base sin romper el programa.

Si `B` es subtipo de `A`, cualquier código que use `A` debe funcionar con `B` sin sorpresas. El subtipo no puede fortalecer precondiciones ni debilitar postcondiciones.

```python
# ❌ Rompe LSP: el cuadrado hereda rectángulo pero viola invariantes
class Rectangulo:
    def __init__(self): self.ancho = 0; self.alto = 0
    def set_ancho(self, w): self.ancho = w
    def set_alto(self, h): self.alto = h
    def area(self): return self.ancho * self.alto

class Cuadrado(Rectangulo):
    def set_ancho(self, w): self.ancho = self.alto = w   # ¡rompe el contrato!
    def set_alto(self, h): self.ancho = self.alto = h

def usar(r: Rectangulo):
    r.set_ancho(5); r.set_alto(10)
    assert r.area() == 50   # falla con Cuadrado → LSP roto

# ✅ No heredar fuerzas incompatibles; modela por separado o usa interfaz común
```

### I — Interface Segregation Principle (ISP)

> Ningún cliente debe verse obligado a depender de métodos que no usa.

Interfaces pequeñas y específicas mejor que una "gordís". Si una clase implementa una interfaz pero deja métodos vacíos o lanzando excepciones, la interfaz es demasiado grande.

```typescript
// ❌ Interfaz gorda: el servidor de impresión no necesita escanear
interface Multifuncion {
  imprimir(doc: string): void;
  escanear(): string;
  enviarFax(doc: string): void;
}
class ImpresoraSimple implements Multifuncion {
  imprimir(doc) { /* ok */ }
  escanear() { throw new Error('no soportado'); }   // obligada a implementarlo
  enviarFax(doc) { throw new Error('no soportado'); }
}

// ✅ Interfaces segregadas
interface Imprimible { imprimir(doc: string): void; }
interface Escaneable { escanear(): string; }
interface Faxeable { enviarFax(doc: string): void; }

class ImpresoraSimple implements Imprimible {
  imprimir(doc) { /* ok, y nada más */ }
}
```

### D — Dependency Inversion Principle (DIP)

> Los módulos de alto nivel no deben depender de los de bajo nivel. **Ambos deben depender de abstracciones.**

La regla más importante para arquitecturas desacopladas. El dominio (lo valioso) no debe depender de la BD o el framework (detalles). Se invierte la dependencia con interfaces.

```javascript
// ❌ El servicio de alto nivel depende de la BD concreta de bajo nivel
const MySQL = require('./mysql');
class UserService {
  constructor() { this.db = new MySQL(); }   // acoplado a MySQL
}

// ✅ Ambos dependen de la abstracción
class UserService {
  constructor(db /* : interface UserRepository */) { this.db = db; }
}
// La BD concreta implementa la interfaz; el servicio no la conoce
const service = new UserService(new MySQLUserRepository());
const serviceTest = new UserService(new InMemoryUserRepository()); // testable
```

> DIP es el motor de Clean Architecture y hexagonal. Se ve en profundidad en [03-arquitectura-en-capas-y-clean-architecture.md](03-arquitectura-en-capas-y-clean-architecture.md).

### Tabla resumen SOLID

| Letra | Nombre | Idea clave | Olor que detecta |
|---|---|---|---|
| **S** | Single Responsibility | Una razón para cambiar | Clase "Dios" que hace de todo |
| **O** | Open/Closed | Extender sin modificar | Cascadas de `if` por tipo |
| **L** | Liskov Substitution | Subtipos sustituibles | `throw not implemented` en hijas |
| **I** | Interface Segregation | Interfaces pequeñas | Interfaces gordas con métodos no usados |
| **D** | Dependency Inversion | Depender de abstracciones | `new Concreto()` dentro de la lógica |

## Arquitectura en capas

El estilo más común en backend. Tres capas canónicas:

```
┌───────────────────────────────────────────┐
│ Capa de Presentación                      │
│ Controllers, routers, HTTP handlers        │
│ ─ recibe requests, valida, devuelve HTTP  │
├───────────────────────────────────────────┤
│ Capa de Negocio (dominio)                 │
│ Servicios, casos de uso, reglas de negocio│
│ ─ orquesta, aplica reglas, no sabe de HTTP │
├───────────────────────────────────────────┤
│ Capa de Datos                              │
│ Repositories, DAOs, modelos de persistencia│
│ ─ guarda/lee, no sabe de reglas de negocio │
└───────────────────────────────────────────┘
```

Flujo de una petición:

```
HTTP POST /users
  → [Controller] valida y llama a service.createUser(dto)
    → [Service] aplica reglas, llama a repo.save(user)
      → [Repository] INSERT en BD
    ← [Service] devuelve el usuario creado
  ← [Controller] responde 201 + JSON
```

```javascript
// Ejemplo en capas (Node.js)
// --- Repository (datos) ---
class UserRepository {
  async save(user) { /* INSERT ... */ }
  async findById(id) { /* SELECT ... */ }
}
// --- Service (negocio) ---
class UserService {
  constructor(repo) { this.repo = repo; }
  async createUser(name, email) {
    if (!email.includes('@')) throw new Error('email inválido');
    const user = { id: crypto.randomUUID(), name, email };
    await this.repo.save(user);
    return user;
  }
}
// --- Controller (presentación) ---
class UserController {
  constructor(service) { this.service = service; }
  async postUser(req, res) {
    try {
      const user = await this.service.createUser(req.body.name, req.body.email);
      res.status(201).json(user);
    } catch (e) {
      res.status(400).json({ error: e.message });
    }
  }
}
```

**Peligro de las capas:** convertirlas en "pasamanos" donde el service solo llama al repo sin lógica. Eso es síntoma de que el dominio está vacío (anemic domain model).

## Arquitectura hexagonal (Ports and Adapters)

Propuesta por Alistair Cockburn. Aísla el **núcleo de la aplicación** (lógica de negocio) detrás de **puertos** (interfaces) y conecta el mundo exterior mediante **adaptadores**.

```
                    ┌──────────────────────────────────┐
   HTTP adapter ──▶ │  PUERTO  (driving)               │
   CLI adapter  ──▶ │  ┌────────────────────────────┐  │
                    │  │   NÚCLEO DE APLICACIÓN      │  │
                    │  │   (casos de uso + dominio) │  │
                    │  │   sin saber nada del exterior│  │
                    │  └────────────────────────────┘  │
                    │  PUERTO  (driven)                │
                    │     ▲            ▲                │
   MySQL adapter ──│─────┘            │                │
   Redis adapter  ──│──────────────────┘               │
                    └──────────────────────────────────┘
```

- **Puerto driving (de entrada):** define qué puede hacer la aplicación (ej. `CreateUserPort`). Lo implementa el caso de uso.
- **Adaptador driving:** HTTP, CLI, gRPC... traducen el mundo externo al puerto.
- **Puerto driven (de salida):** define qué necesita la aplicación del exterior (ej. `UserRepositoryPort`). Lo implementan los adaptadores.
- **Adaptador driven:** MySQL, Redis, API externa... implementan el puerto driven.

```python
# Puerto driven (lo que la app necesita del exterior)
from abc import ABC, abstractmethod

class UserRepository(ABC):
    @abstractmethod
    def save(self, user): ...
    @abstractmethod
    def find_by_id(self, id): ...

# Núcleo de aplicación (no conoce MySQL ni HTTP)
class CreateUserUseCase:
    def __init__(self, repo: UserRepository):  # depende de la abstracción
        self.repo = repo

    def execute(self, name, email):
        user = User(name=name, email=email)
        self.repo.save(user)
        return user

# Adaptador driven: implementa el puerto
class MySQLUserRepository(UserRepository):
    def save(self, user):
        # INSERT INTO users ...
        pass
    def find_by_id(self, id):
        # SELECT ...
        pass
```

**Ventaja:** el núcleo es puro, testeable sin levantar nada, y puedes cambiar MySQL por Postgres o por memoria en tests sin tocar el núcleo. Es la formalización del DIP aplicado a toda la arquitectura.

## Tabla de referencia rápida

| Concepto | Una línea |
|---|---|
| Arquitectura | Decisiones estructurales costosas de cambiar |
| Estilo | Plantilla de organización (capas, microservicios) |
| Patrón | Solución recurrente a un problema concreto |
| Acoplamiento | Cuánto depende un módulo de otro (bajo = bueno) |
| Cohesión | Cuánto pertenece junta la lógica de un módulo (alto = bueno) |
| SRP | Una razón para cambiar |
| OCP | Extender sin modificar |
| LSP | Subtipos sustituibles |
| ISP | Interfaces pequeñas |
| DIP | Depender de abstracciones |
| Capas | Presentación → negocio → datos |
| Hexagonal | Núcleo aislado, puertos y adaptadores |

## Conceptos clave

- **Arquitectura vs diseño:** la arquitectura son decisiones de alto costo de cambio tomadas temprano; el diseño es continuo y local.
- **Bajo acoplamiento + alta cohesión** es la métrica universal: si dudas, evalúa estas dos.
- **Separación de intereses:** cada módulo, un eje de cambio. Mezclar intereses arrastra cambios.
- **SOLID son principios, no leyes:** guían el diseño; aplicarlos a ciegas puede sobre-ingeniar.
- **DIP es la pieza central de la arquitectura moderna:** invertir dependencias permite aislar el dominio de la infraestructura (hexagonal, Clean).
- **El dominio es lo valioso:** la lógica de negocio debe poder vivir y testearse sin HTTP, ni BD, ni framework.

## Errores comunes

- **Confundir arquitectura con framework:** "usamos Spring, luego tenemos arquitectura" — no, el framework es un detalle.
- **Capas pasamanos:** el service solo delega al repo sin lógica; el dominio está vacío.
- **Acoplamiento a la BD en el controlador:** `req.db.query(...)` cruza capas y viola separación de intereses.
- **Romper LSP sin saberlo:** `Cuadrado extends Rectangulo` o `PatoDeGoma extends Pato` con métodos que lanzan excepciones.
- **Abusar de Singleton:** se usa como variable global disfrazada y acopla todo a una instancia.
- **Sobre-ingeniería prematura:** aplicar microservicios + DDD + CQRS a un MVP que tiene 3 usuarios.
- **Ignorar la regla de dependencias:** el dominio importa `mysql` o `express`; ya no es portable ni testeable solo.
- **Cohesión baja disfrazada de SRP:** partir una clase en 20 clases de un método cada una, pero todas mutuamente dependientes; ahora tienes baja cohesión **y** alto acoplamiento.
