# 02 — Patrones de Diseño

> Soluciones probadas a problemas recurrentes. Los patrones de GoF (creacionales, estructurales, de comportamiento) y los patrones de backend modernos (Repository, Unit of Work, CQRS, Mediator). No son recetas mágicas, sino vocabulario de diseño.

## Objetivos

- [ ] Entender qué es un patrón de diseño y cuándo aplicarlo.
- [ ] Dominar los patrones creacionales: Singleton, Factory, Builder, Prototype, Abstract Factory.
- [ ] Dominar los patrones estructurales: Adapter, Decorator, Facade, Proxy, Composite, Bridge.
- [ ] Dominar los patrones de comportamiento: Observer, Strategy, Command, Iterator, State, Template Method, Chain of Responsibility.
- [ ] Aplicar patrones de backend: Repository, Unit of Work, CQRS, Mediator.
- [ ] Reconocer cuándo un patrón **no** es necesario (over-engineering).

## Qué es un patrón de diseño

Un **patrón de diseño** es una solución recurrente y probada a un problema común de diseño. No es código, sino una plantilla: describe el problema, la solución y las consecuencias. Los 23 patrones clásicos (Gamma, Helm, Johnson, Vlissides — "Gang of Four", GoF) se dividen en tres familias:

| Familia | Qué crea/compone | Pregunta que responde |
|---|---|---|
| **Creacionales** | Objetos | ¿Cómo construyo objetos flexiblemente? |
| **Estructurales** | Composiciones | ¿Cómo combino objetos en estructuras mayores? |
| **De comportamiento** | Interacciones | ¿Cómo se comunican y reparten responsabilidades? |

> Aviso: los patrones **no** son un objetivo. Si aplicas un patrón donde no hay problema real, añades complejidad. Aplica el patrón cuando el problema **aparezca varias veces** y el patrón lo resuelva de forma natural.

## Patrones creacionales

### Singleton

Garantiza que una clase tenga **una sola instancia** y proporciona un punto de acceso global.

```
┌─────────────────────┐
│   Singleton         │
│  ─────────────      │
│  - instancia: Self  │◀─── getInstance() devuelve siempre
│  + getInstance()    │     la MISMA instancia
└─────────────────────┘
```

```python
class Config:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance.valores = {}
        return cls._instance

c1 = Config(); c2 = Config()
print(c1 is c2)  # True, misma instancia
```

- **Cuándo:** configuración global, pool de conexiones, logger.
- **Cuidado:** es una **variable global disfrazada**. Introduce acoplamiento oculto y dificulta los tests (estado compartido). Úsalo con medida.

### Factory Method

Define una interfaz para crear un objeto, pero deja que las subclases decidan **qué clase instanciar**.

```
Creador ──create()──> Producto (interfaz)
   △                       △
CreadorConcretoA       ProductoA
CreadorConcretoB       ProductoB
```

```python
from abc import ABC, abstractmethod

class Notificacion(ABC):
    @abstractmethod
    def enviar(self, mensaje): ...

class EmailNotificacion(Notificacion):
    def enviar(self, mensaje): print(f"Email: {mensaje}")

class SMSNotificacion(Notificacion):
    def enviar(self, mensaje): print(f"SMS: {mensaje}")

class NotificacionFactory:
    @staticmethod
    def crear(tipo: str) -> Notificacion:
        if tipo == "email": return EmailNotificacion()
        if tipo == "sms":   return SMSNotificacion()
        raise ValueError(f"Tipo desconocido: {tipo}")

n = NotificacionFactory.crear("email")
n.enviar("Hola")  # Email: Hola
```

- **Cuándo:** el código no sabe de antemano qué clase concreta debe crear; quieres desacoplar la creación del uso.

### Builder

Separa la construcción de un objeto complejo de su representación, permitiendo crear distintas variantes paso a paso.

```
Director ─construct()─> Builder ─build()─> Producto
```

```python
class QueryBuilder:
    def __init__(self):
        self._select = "*"; self._from = ""; self._where = []; self._limit = None
    def select(self, cols): self._select = cols; return self
    def from_(self, tabla): self._from = tabla; return self
    def where(self, cond): self._where.append(cond); return self
    def limit(self, n): self._limit = n; return self
    def build(self):
        sql = f"SELECT {self._select} FROM {self._from}"
        if self._where: sql += " WHERE " + " AND ".join(self._where)
        if self._limit: sql += f" LIMIT {self._limit}"
        return sql

q = (QueryBuilder()
        .select("id, name")
        .from_("users")
        .where("age > 18")
        .where("active = 1")
        .limit(10)
        .build())
# SELECT id, name FROM users WHERE age > 18 AND active = 1 LIMIT 10
```

- **Cuándo:** objetos con muchos parámetros opcionales, constructor con 8 argumentos, o representaciones múltiples del mismo proceso de construcción.

### Prototype

Crea nuevos objetos **clonando** una instancia existente, en vez de construir desde cero.

```javascript
const prototipo = {
  tipo: "documento",
  contenido: [],
  clonar() { return structuredClone(this); } // copia profunda
};
const copia = prototipo.clonar();
copia.contenido.push("nueva página");
console.log(prototipo.contenido.length); // 0, no se afecta
```

- **Cuándo:** crear objetos es costoso (carga pesada de datos) o quieres copias independientes de un estado prefijado.

### Abstract Factory

Crea **familias** de objetos relacionados sin especificar sus clases concretas.

```python
class GUIFactory(ABC):
    @abstractmethod def crear_boton(self): ...
    @abstractmethod def crear_input(self): ...

class WindowsFactory(GUIFactory):
    def crear_boton(self): return WindowsBoton()
    def crear_input(self): return WindowsInput()

class MacFactory(GUIFactory):
    def crear_boton(self): return MacBoton()
    def crear_input(self): return MacInput()
```

- **Cuándo:** necesitas una familia completa y coherente (todos los widgets de un mismo tema) y quieres cambiar la familia entera sin tocar el código cliente.

### Tabla creacionales

| Patrón | Crea | Cuándo |
|---|---|---|
| Singleton | 1 instancia | Config, logger, pool |
| Factory Method | 1 producto | Desacoplar creación del uso |
| Builder | Objeto complejo paso a paso | Muchos parámetros opcionales |
| Prototype | Clon de un objeto | Creación costosa |
| Abstract Factory | Familia de productos | Temas/variantes coherentes |

## Patrones estructurales

### Adapter

Convierte la interfaz de una clase en otra interfaz que el cliente espera. Permite que clases incompatibles colaboren.

```
Cliente ──usa──> InterfazObjetivo
                    △
                 Adapter ──adapta──> Adaptee (clase existente incompatible)
```

```python
class PagoLegacy:  # interfaz antigua e incompatibles
    def haz_pago(self, cantidad_centavos): print(f"Pagando {cantidad_centavos} centavos")

class PagoInterfaz(ABC):  # lo que espera el cliente
    @abstractmethod
    def pagar(self, euros: float): ...

class PagoAdapter(PagoInterfaz):  # puente
    def __init__(self, legacy): self.legacy = legacy
    def pagar(self, euros):
        self.legacy.haz_pago(int(euros * 100))  # convierte euros→centavos

cliente = PagoAdapter(PagoLegacy())
cliente.pagar(9.99)  # Pagando 999 centavos
```

- **Cuándo:** integrar una librería externa o legacy cuya interfaz no controlas.

### Decorator

Añade comportamiento a un objeto **dinámicamente**, sin modificar su clase ni usar herencia. Es una alternativa flexible a la herencia múltiple.

```
Componente ◁── DecoradorBase ◁── DecoradorConcretoA
                        △       DecoradorConcretoB
                        │       (envuelven a otro Componente)
```

```python
class Cafe:  # componente base
    def coste(self): return 2
    def desc(self): return "Café"

class CafeDecorator:
    def __init__(self, cafe): self.cafe = cafe
    def coste(self): return self.cafe.coste()
    def desc(self): return self.cafe.desc()

class Leche(CafeDecorator):
    def coste(self): return self.cafe.coste() + 0.5
    def desc(self): return self.cafe.desc() + " + Leche"

class Azucar(CafeDecorator):
    def coste(self): return self.cafe.coste() + 0.2
    def desc(self): return self.cafe.desc() + " + Azúcar"

c = Azucar(Leche(Cafe()))  # composición de decoradores
print(c.desc(), c.coste())  # Café + Leche + Azúcar 2.7
```

- **Cuándo:** añadir responsabilidades opcionales y combinables (logs, caché, validación, cifrado) sin herencia explosiva.

### Facade

Proporciona una interfaz simplificada a un conjunto complejo de subsistemas.

```
Cliente ──> Fachada ─┬─> SubsistemaA
                    ├─> SubsistemaB
                    └─> SubsistemaC
```

```python
class CPU: def ejecutar(self): print("CPU ejecutando")
class Memoria: def cargar(self): print("Memoria cargando")
class Disco: def leer(self): print("Disco leyendo")

class ComputadoraFacade:  # simplifica el arranque
    def __init__(self):
        self.cpu = CPU(); self.mem = Memoria(); self.disco = Disco()
    def arrancar(self):
        self.disco.leer(); self.mem.cargar(); self.cpu.ejecutar()

pc = ComputadoraFacade()
pc.arrancar()  # 3 líneas ocultas tras 1 llamada
```

- **Cuándo:** un subsistema es complejo y los clientes solo necesitan un caso de uso común.

### Proxy

Un objeto que **controla el acceso** a otro objeto, añadiendo un intermediario (lazy loading, control de acceso, caché, remoto).

```
Cliente ──> Proxy ──> SujetoReal (mismo interfaz)
```

```python
class Imagen:
    def mostrar(self): raise NotImplementedError

class ImagenReal(Imagen):
    def __init__(self, archivo):
        print(f"Cargando {archivo} desde disco...")  # costoso
        self.archivo = archivo
    def mostrar(self): print(f"Mostrando {self.archivo}")

class ImagenProxy(Imagen):
    def __init__(self, archivo): self.archivo = archivo; self.real = None
    def mostrar(self):
        if self.real is None: self.real = ImagenReal(self.archivo)  # lazy
        self.real.mostrar()

p = ImagenProxy("foto.png")  # no carga nada aún
print("--- imagen creada ---")
p.mostrar()  # ahora sí carga y muestra
```

- **Cuándo:** acceso diferido, control de permisos, caché o acceso remoto.

### Composite

Compone objetos en estructuras de árbol y trata a individuos y composiciones de forma uniforme.

```javascript
class Componente {
  precio() { return 0; }
}
class Producto extends Componente {
  constructor(p) { super(); this._p = p; }
  precio() { return this._p; }
}
class Caja extends Componente {
  constructor() { super(); this._hijos = []; }
  add(c) { this._hijos.push(c); return this; }
  precio() { return this._hijos.reduce((s, c) => s + c.precio(), 0); }
}

const pedido = new Caja();
pedido.add(new Producto(10)).add(new Producto(5));
const regalo = new Caja().add(new Producto(3));
pedido.add(regalo);
console.log(pedido.precio()); // 18, mismo método para caja y producto
```

- **Cuándo:** estructura jerárquica (menús, directorios, pedidos con sub-paquetes) donde el cliente no debe distinguir hoja de contenedor.

### Bridge

Separa una abstracción de su implementación para que ambas varíen independientemente.

```
Abstraccion ──usa──> Implementador (interfaz)
   △                      △
AbstraccionRefinada    ImplA, ImplB
```

```python
class Renderer(ABC):  # implementador
    @abstractmethod
    def render(self, texto): ...

class HTMLRenderer(Renderer):
    def render(self, texto): return f"<b>{texto}</b>"

class PlainTextRenderer(Renderer):
    def render(self, texto): return texto.upper()

class Mensaje:  # abstracción
    def __init__(self, renderer: Renderer): self.renderer = renderer
    def mostrar(self, t): return self.renderer.render(t)

m = Mensaje(HTMLRenderer())
print(m.mostrar("hola"))  # <b>hola</b>
m.renderer = PlainTextRenderer()
print(m.mostrar("hola"))  # HOLA
```

- **Cuándo:** una abstracción tiene varias implementaciones ortogonales (ej. forma × renderer; dispositivo × plataforma).

### Tabla estructurales

| Patrón | Qué hace | Cuándo |
|---|---|---|
| Adapter | Adapta interfaz | Integrar código legacy/externo |
| Decorator | Envuelve y añade | Comportamientos combinables |
| Facade | Simplifica subsistema | Interfaz simple sobre complejidad |
| Proxy | Controla acceso | Lazy, caché, permisos |
| Composite | Árbol uniforme | Jerarquías hoja+contenedor |
| Bridge | Separa 2 dimensiones | Variaciones ortogonales |

## Patrones de comportamiento

### Observer

Define una dependencia uno-a-muchos: cuando un objeto cambia de estado, **todos sus observadores son notificados** automáticamente.

```
Sujeto ──notify()──> ObservadorA
                   > ObservadorB
                   > ObservadorC
```

```python
class Sujeto:
    def __init__(self): self._obs = []
    def suscribir(self, o): self._obs.append(o)
    def notificar(self, evento):
        for o in self._obs: o.update(evento)

class Logger:
    def update(self, e): print(f"[LOG] {e}")
class Mailer:
    def update(self, e): print(f"[MAIL] enviado por {e}")

s = Sujeto()
s.suscribir(Logger()); s.suscribir(Mailer())
s.notificar("usuario_creado")
# [LOG] usuario_creado
# [MAIL] enviado por usuario_creado
```

- **Cuándo:** sistemas de eventos, reactivo, pub/sub, broadcast de cambios de estado.

### Strategy

Define una familia de algoritmos, los encapsula y los hace intercambiables en tiempo de ejecución.

```
Contexto ──usa──> Estrategia (interfaz)
                    △
              EstrategiaA, EstrategiaB
```

```python
class Descuento(ABC):
    @abstractmethod
    def aplicar(self, base): ...

class SinDescuento(Descuento):
    def aplicar(self, base): return base
class DescuentoBlackFriday(Descuento):
    def aplicar(self, base): return base * 0.5

class Carrito:
    def __init__(self, descuento: Descuento): self.desc = descuento; self.total = 0
    def set_descuento(self, d): self.desc = d
    def checkout(self): return self.desc.aplicar(self.total)

c = Carrito(SinDescuento()); c.total = 100
print(c.checkout())  # 100
c.set_descuento(DescuentoBlackFriday())
print(c.checkout())  # 50
```

- **Cuándo:** múltiples variantes de un mismo algoritmo; elimina cascadas de `if`.

### Command

Encapsula una petición como un objeto, permitiendo parametrizar, encolar, registrar y deshacer.

```python
class Comando(ABC):
    @abstractmethod
    def ejecutar(self): ...
    @abstractmethod
    def deshacer(self): ...

class Luz:
    def encender(self): print("💡 on")
    def apagar(self): print("💡 off")

class EncenderLuz(Comando):
    def __init__(self, luz): self.luz = luz
    def ejecutar(self): self.luz.encender()
    def deshacer(self): self.luz.apagar()

class ControlRemoto:
    def __init__(self): self.historial = []
    def pulsar(self, cmd): cmd.ejecutar(); self.historial.append(cmd)
    def undo(self):
        if self.historial: self.historial.pop().deshacer()

ctrl = ControlRemoto()
ctrl.pulsar(EncenderLuz(Luz()))  # 💡 on
ctrl.undo()                       # 💡 off
```

- **Cuándo:** undo/redo, colas de tareas, macros, despacho de acciones (Redux usa Command).

### Iterator

Proporciona acceso secuencial a los elementos de un agregado sin exponer su representación interna.

```javascript
class Lista {
  constructor() { this._items = []; }
  add(x) { this._items.push(x); }
  [Symbol.iterator]() {
    let i = 0; const items = this._items;
    return { next() {
      return i < items.length
        ? { value: items[i++], done: false }
        : { value: undefined, done: true };
    }};
  }
}
const l = new Lista(); l.add(1); l.add(2); l.add(3);
for (const x of l) console.log(x); // 1 2 3
```

- **Cuándo:** recorrer colecciones (arrays, árboles, grafos) uniformemente sin exponer internals.

### State

Permite que un objeto altere su comportamiento cuando su estado interno cambia. Es como si el objeto cambiara de clase.

```python
class Documento:
    def __init__(self):
        self.estado = Borrador()  # estado inicial
    def publicar(self): self.estado.publicar(self)

class Borrador:
    def publicar(self, doc): print("→ En revisión"); doc.estado = EnRevision()
class EnRevision:
    def publicar(self, doc): print("→ Publicado"); doc.estado = Publicado()
class Publicado:
    def publicar(self, doc): print("Ya está publicado")

d = Documento()
d.publicar()  # → En revisión
d.publicar()  # → Publicado
d.publicar()  # Ya está publicado
```

- **Cuándo:** máquinas de estados, flujos de aprobación, estados de pedido.

### Template Method

Define el esqueleto de un algoritmo en la clase base y deja que las subclases redefinan pasos concretos.

```python
class Exportador:
    def exportar(self):  # template method (no se sobrescribe)
        datos = self.leer()
        contenido = self.formatear(datos)
        self.escribir(contenido)
    def leer(self): return ["fila1", "fila2"]
    def formatear(self, datos): raise NotImplementedError
    def escribir(self, c): print(f"Guardado: {c}")

class CSVExporter(Exportador):
    def formatear(self, datos): return ",".join(datos)
class JSONExporter(Exportador):
    def formatear(self, datos): import json; return json.dumps(datos)

CSVExporter().exportar()   # Guardado: fila1,fila2
JSONExporter().exportar()  # Guardado: ["fila1", "fila2"]
```

- **Cuándo:** un algoritmo tiene pasos fijos pero variaciones en algunos.

### Chain of Responsibility

Pasa una petición a lo largo de una cadena de manejadores hasta que uno la procesa.

```
req ──> ManejadorA ──> ManejadorB ──> ManejadorC ──> (fin)
        (si no puede)   (si no puede)
```

```python
class Manejador:
    def __init__(self): self.siguiente = None
    def set_next(self, h): self.siguiente = h; return h
    def manejar(self, req):
        if self.siguiente: return self.siguiente.manejar(req)
        return None

class Auth(Manejador):
    def manejar(self, req):
        if not req.get("token"): return "401 No autorizado"
        return super().manejar(req)
class Log(Manejador):
    def manejar(self, req):
        print(f"[log] {req.get('path')}"); return super().manejar(req)
class Negocio(Manejador):
    def manejar(self, req): return "200 OK"

auth = Auth(); log = Log(); biz = Negocio()
auth.set_next(log).set_next(biz)

print(auth.manejar({"path": "/x"}))            # 401 No autorizado
print(auth.manejar({"path": "/x", "token": 1}))# [log] /x \n 200 OK
```

- **Cuándo:** pipelines de middleware (Express, Django), filtros, logs, validaciones encadenadas.

### Tabla comportamiento

| Patrón | Qué hace | Cuándo |
|---|---|---|
| Observer | Notifica a N observers | Eventos, pub/sub, reactivo |
| Strategy | Intercambia algoritmos | Variantes de un cálculo |
| Command | Encapsula acción | Undo, colas, despacho |
| Iterator | Recorre colección | Acceso uniforme |
| State | Comportamiento por estado | Máquinas de estados |
| Template Method | Esqueleto fijo, pasos variables | Frameworks, algoritmos plantilla |
| Chain of Resp. | Pasa por cadena | Middleware, filtros |

## Patrones de backend

Más allá de GoF, hay patrones específicos de arquitectura de aplicaciones backend.

### Repository

Abstrae el acceso a datos detrás de una interfaz que se ve como una **colección en memoria**. El dominio habla de `save`, `findById`, `findByEmail`... y no sabe si hay SQL, Mongo o un archivo.

```
Dominio ──> Repositorio (interfaz) ◁── MySQLRepo, MongoRepo, InMemoryRepo
```

```python
class UserRepository(ABC):
    @abstractmethod
    def save(self, user): ...
    @abstractmethod
    def find_by_email(self, email): ...

class InMemoryUserRepository(UserRepository):
    def __init__(self): self.db = {}
    def save(self, user): self.db[user["email"]] = user; return user
    def find_by_email(self, email): return self.db.get(email)

class UserService:
    def __init__(self, repo: UserRepository): self.repo = repo
    def register(self, email):
        if self.repo.find_by_email(email): raise ValueError("ya existe")
        self.repo.save({"email": email})

# Producción: MySQLRepo. Tests: InMemoryRepo. El dominio no cambia.
svc = UserService(InMemoryUserRepository())
svc.register("a@b.com")
```

- **Cuándo:** siempre que tengas persistencia y quieras un dominio testeable y desacoplado de la BD.

### Unit of Work (UoW)

Coordina que varias operaciones de escritura se completen **atómicamente**: o todas se commitan o ninguna.

```python
class UnitOfWork:
    def __init__(self, session): self.session = session
    def __enter__(self):
        self.session.begin()
        return self
    def __enter__(self): return self
    def commit(self): self.session.commit()
    def rollback(self): self.session.rollback()
    def __exit__(self, exc_type, *_):
        if exc_type: self.rollback()
        else: self.commit()

# Uso: transferir dinero entre dos cuentas, atómico
with UnitOfWork(session) as uow:
    cuenta_origen.sacar(100)
    cuenta_destino.ingresar(100)
    # si cualquier paso falla → rollback de todo
```

- **Cuándo:** múltiples escrituras que deben ser consistentes (transferencias, pedidos + stock).

### CQRS (Command Query Responsibility Segregation)

Separa las operaciones de **escritura** (Commands) de las de **lectura** (Queries), con modelos distintos optimizados para cada caso.

```
        ESCRITURA (Command)               LECTURA (Query)
  ┌────────────────────────┐       ┌────────────────────────┐
  │ CreateUserCommand      │       │ UserByIdQuery          │
  │ ─ valida, muta estado  │       │ ─ optimizada para leer │
  │ ─ guarda en write DB   │       │ ─ lee de read DB/cache │
  └───────────┬────────────┘       └───────────▲────────────┘
              │                                 │
              └───── sync por eventos ──────────┘
```

```python
# Command: muta
class CreateUserHandler:
    def handle(self, cmd):
        # valida y guarda en el modelo de escritura
        user = User(name=cmd.name, email=cmd.email)
        self.repo.save(user)
        self.bus.publish(UserCreated(user.id, user.email))

# Query: solo lee, modelo optimizado (denormalizado)
class UserByIdQueryHandler:
    def handle(self, q):
        return self.read_db.get(q.user_id)  # vista denormalizada, rápida
```

- **Cuándo:** sistemas con mucha más lectura que escritura, o donde lectura y escritura escalan distinto. Aporta complejidad; no lo apliques a un CRUD simple.

### Mediator

Centraliza la comunicación entre objetos que no se conocen entre sí. En vez de que N objetos se hablen directamente (N² relaciones), hablan con un mediador.

```
  ColegaA \                   / ColegaC
           \                 /
            > Mediator <----<
           /                 \
  ColegaB /                   \ ColegaD
  (cada uno solo conoce al mediador)
```

```python
class ChatMediator:
    def __init__(self): self.users = []
    def registrar(self, u): self.users.append(u)
    def enviar(self, msg, origen):
        for u in self.users:
            if u is not origen: u.recibir(msg)

class Usuario:
    def __init__(self, nombre, mediator): self.nombre = nombre; self.med = mediator
    def enviar(self, msg): self.med.enviar(msg, self)
    def recibir(self, msg): print(f"{self.nombre} recibe: {msg}")

med = ChatMediator()
a = Usuario("Ana", med); b = Usuario("Bob", med)
med.registrar(a); med.registrar(b)
a.enviar("Hola")  # Bob recibe: Hola
```

- **Cuándo:** muchos componentes acoplados; colas de comandos en aplicaciones (MediatR en .NET, Command Bus).

### Tabla backend

| Patrón | Problema | Cuándo |
|---|---|---|
| Repository | Acoplar dominio a BD | Siempre con persistencia |
| Unit of Work | Atomicidad de varias escrituras | Transacciones multi-entidad |
| CQRS | Lectura ≠ escritura | R/W asimétricos, alta escala |
| Mediator | Comunicación N↔N | Desacoplar muchos componentes |

## Conceptos clave

- **Los patrones son vocabulario:** permiten discutir diseño con precisión ("usa un Decorator" dice mucho en una palabra).
- **No fuerces patrones:** si el problema no aparece repetido, el patrón es over-engineering. La regla es "regla de tres": si lo ves 3 veces, extrae.
- **Repository + UoW son la base del dominio desacoplado** y la piedra angular de Clean/Hexagonal.
- **CQRS y Mediator aportan complejidad:** los pagas solo cuando el sistema lo necesita (escala, asimetría R/W).
- **Strategy y Factory** son los más usados día a día; dominarlos da mucho por poco esfuerzo.
- **Decorator es la alternativa limpia a la herencia** para comportamientos combinables (logs, caché, validación).

## Errores comunes

- **Aplicar patrones por moda:** añadir Singleton a todo introduce estado global oculto y acoplamiento.
- **Factory con un solo producto:** una factoría con un único `case` que solo crea una clase no aporta nada.
- **Usar CQRS en un CRUD:** dobla el modelo de datos para nada. CQRS es para asimetría real de lectura/escritura.
- **Observer con fugas de memoria:** no te desuscribes y el sujeto retiene al observer (típico en JS/Node).
- **Decorator profundo:** anidar 10 decoradores hace el stack incomprensible y difícil de depurar.
- **Repository que filtra SQL al dominio:** si el dominio ve `WHERE` o `SELECT`, el repositorio no está abstrayendo.
- **Confundir Strategy con State:** Strategy elige el algoritmo desde fuera; State cambia su solo según el estado interno.
- **Olvidar deshacer en Command:** si implementas Command sin `undo`, pierdes la mitad del valor del patrón.
