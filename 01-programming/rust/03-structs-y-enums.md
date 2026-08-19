# 03 — Structs y enums

## Objetivos

- [ ] Definir `struct` clásicos (campos con nombre) y construir instancias.
- [ ] Crear tuple structs (`struct Color(u8, u8, u8)`) y unit structs (`struct Unidad;`).
- [ ] Acceder a los campos, usar la actualización con `..` y destructurar con `let`.
- [ ] Implementar métodos en `impl` distinguiendo `&self`, `&mut self` y `self`.
- [ ] Crear constructores con funciones asociadas (`Persona::new`) y diferenciarlas de los métodos.
- [ ] Implementar `Display` a mano y usar `#[derive(Debug)]` con `{:?}` y `{:#?}`.
- [ ] Derivar `Clone` y `Copy`, y razonar cuándo un struct puede ser `Copy`.
- [ ] Definir enums unit y enums con datos asociados (tuplas y structs).
- [ ] Escribir `match` exhaustivos con comodín `_`, guardas (`if`) y binding `@`.
- [ ] Manejar `Option<T>` con `match`, `if let` y `while let`.
- [ ] Anidar structs dentro de enums (y viceversa).
- [ ] Comparar structs y enums con `PartialEq`, `Eq`, `PartialOrd` y `Ord`.
- [ ] Identificar y corregir errores frecuentes (E0063, E0004, E0277, E0308, E0382...).

## Apuntes

### Definición y creación de structs

Un **struct** agrupa datos relacionados bajo un tipo con nombre propio. Hay **tres formas** de definirlo:

| Forma | Sintaxis | Cuándo usarla |
|---|---|---|
| Clásico (campos con nombre) | `struct A { x: u32, y: u32 }` | La más común; los campos se leen solos. |
| Tuple struct | `struct B(u32, u32)` | Envolver valores sin nombre; típico para "newtypes". |
| Unit struct | `struct C;` | Sin campos; marcador de tipo o variante de enum. |

#### Struct clásico

```rust
struct Persona {
    nombre: String,
    edad: u8,
    activo: bool,
}

fn main() {
    let ana = Persona {
        nombre: String::from("Ana"),
        edad: 30,
        activo: true,
    };
    println!("{} tiene {} años", ana.nombre, ana.edad);
}
```

Al construir hay dos atajos. La **inicialización abreviada** evita repetir `campo: valor` si ya existen variables con el mismo nombre:

```rust
fn main() {
    let nombre = String::from("Luis");
    let edad = 25;
    let luis = Persona { nombre, edad, activo: false };
    println!("{}", luis.nombre);
}
```

La **actualización de struct** (`..`) copia los campos restantes de otra instancia:

```rust
fn main() {
    let p1 = Persona { nombre: String::from("Ana"), edad: 30, activo: true };
    let p2 = Persona { nombre: String::from("Luis"), ..p1 };
    // p2.edad = 30, p2.activo = true; solo cambia el nombre
    println!("{} - {} años", p2.nombre, p2.edad);
}
```

**Cuidado**: si el campo viene de un tipo no `Copy` (como `String`), `..p1` lo **mueve**; `p1.nombre` queda inservible. La **destructuración** extrae los campos en variables con el mismo nombre:

```rust
fn main() {
    let p1 = Persona { nombre: String::from("Ana"), edad: 30, activo: true };
    let Persona { nombre, edad, .. } = p1;
    println!("{} tiene {} años", nombre, edad);
}
```

#### Tuple structs

Campos sin nombre, accesibles por posición con `.0`, `.1`, `.2`...:

```rust
struct Color(u8, u8, u8);

fn main() {
    let rojo = Color(255, 0, 0);
    println!("R={} G={} B={}", rojo.0, rojo.1, rojo.2);
}
```

Su uso más valioso es el patrón **newtype**: envolver un primitivo para darle significado y separar tipos que antes se confundían:

```rust
struct Euros(i32);
struct Articulos(i32);

fn cobrar(precio: Euros, cantidad: Articulos) -> i32 {
    precio.0 * cantidad.0
}

fn main() {
    println!("Total: {}", cobrar(Euros(5), Articulos(3)));
}
```

`Euros` y `Articulos` son tipos distintos: el compilador impide pasarlos cruzados.

#### Unit structs

Un struct sin campos; se instancia sin llaves ni paréntesis. No ocupa memoria y sirve de marcador de tipo o para implementar comportamiento con `impl`:

```rust
struct Unidad;

fn main() {
    let u = Unidad;
}
```

### Métodos con impl

Un `impl` da comportamiento al struct. La diferencia entre los tres receptores:

| Receptor | Qué hace | Ejemplo |
|---|---|---|
| `fn m(&self)` | Presta inmutable; solo lectura | `area()`, `describir()` |
| `fn m(&mut self)` | Presta mutable; puede cambiar campos | `escalar()`, `depositar()` |
| `fn m(self)` | Consume el struct; ya no puedes usarlo | "transforma esto en otra cosa" |

#### Métodos que toman &self

```rust
struct Rectangulo { ancho: u32, alto: u32 }

impl Rectangulo {
    fn area(&self) -> u32 {
        self.ancho * self.alto
    }
}

fn main() {
    let r = Rectangulo { ancho: 4, alto: 3 };
    println!("Área: {}", r.area()); // 12
}
```

No hace falta `let mut`: no se modifica nada.

#### Métodos que mutan &mut self

```rust
impl Rectangulo {
    fn escalar(&mut self, factor: u32) {
        self.ancho *= factor;
        self.alto *= factor;
    }
}

fn main() {
    let mut r = Rectangulo { ancho: 4, alto: 3 };
    println!("Antes: {}", r.area()); // 12
    r.escalar(2);
    println!("Después: {}", r.area()); // 48
}
```

Si `r` no fuera `mut`, obtendrías `error[E0596]`.

#### Métodos que consumen self

Con `self` (sin `&`) el método se **lleva** el valor; el original deja de existir. Útil para transformaciones:

```rust
struct Rectangulo { ancho: u32, alto: u32 }
struct Cuadrado { lado: u32 }

impl Rectangulo {
    fn a_cuadrado(self) -> Cuadrado {
        Cuadrado { lado: self.ancho.min(self.alto) }
    }
}

fn main() {
    let r = Rectangulo { ancho: 10, alto: 4 };
    let c = r.a_cuadrado();
    println!("Lado: {}", c.lado);
    // println!("{}", r.ancho); // error[E0382]: r fue movido
}
```

#### Funciones asociadas (new, constructores)

Van en el `impl` pero **sin** `self`. Se invocan con `Tipo::nombre(...)`, no con la sintaxis de punto. Por convención el constructor principal se llama `new`:

```rust
impl Persona {
    fn new(nombre: &str, edad: u8) -> Persona {
        Persona { nombre: nombre.to_string(), edad }
    }

    fn cumpleanios(&mut self) {
        self.edad += 1;
    }
}

fn main() {
    let mut ana = Persona::new("Ana", 30);
    ana.cumpleanios();
    println!("Ahora tiene {} años", ana.edad);
}
```

Dentro del `impl` puedes usar `Self` (mayúscula) en vez del nombre del tipo. `new` no es mágico: es solo una convención.

### El trait Display y {:?}

Hay dos formas de imprimir valores:

| Trait | Sintaxis | ¿Se deriva? | Uso |
|---|---|---|---|
| `Display` | `{}` | No | Salida para el usuario final |
| `Debug` | `{:?}` / `{:#?}` | Sí, con `#[derive(Debug)]` | Depuración; contenido crudo |

Los primitivos y contenedores estándar ya los implementan. Tus structs propios, no. Para `Debug` basta la anotación:

```rust
#[derive(Debug)]
struct Persona { nombre: String, edad: u8 }

fn main() {
    let ana = Persona { nombre: String::from("Ana"), edad: 30 };
    println!("{:?}", ana);   // Persona { nombre: "Ana", edad: 30 }
    println!("{:#?}", ana);  // formato multilínea
}
```

Para `Display` hay que implementarlo a mano:

```rust
use std::fmt;

struct Persona { nombre: String, edad: u8 }

impl fmt::Display for Persona {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{} ({} años)", self.nombre, self.edad)
    }
}

fn main() {
    println!("{}", Persona { nombre: String::from("Ana"), edad: 30 });
}
```

La firma `fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result` es obligatoria; dentro se usa `write!(f, ...)` como si fuera `println!`. Si usas `{}` con un struct sin `Display`, el compilador responde con `error[E0277]`:

```rust
// NO COMPILA — error[E0277]: `Persona` doesn't implement `std::fmt::Display`
#[derive(Debug)]
struct Persona { nombre: String }

fn main() {
    let p = Persona { nombre: String::from("Ana") };
    println!("{}", p);
}
```

Solución: implementar `Display` (salida definitiva) o usar `{:?}` (depuración). Al implementarlo a mano es fácil toparse con dos errores clásicos: escribir `to_string` en vez de `fmt` (`error[E0407]`) u olvidar definir `fn fmt` (`error[E0046]`); ambos se desarrollan en "Errores comunes".

### El trait Clone y Copy en structs

**`Clone`** duplica el valor **en profundidad** con `.clone()`. Se deriva si todos los campos son `Clone` (casi siempre):

```rust
#[derive(Debug, Clone)]
struct Persona { nombre: String, edad: u8 }

fn main() {
    let p1 = Persona { nombre: String::from("Ana"), edad: 30 };
    let p2 = p1.clone(); // copia profunda: String duplicada
    println!("{:?} y {:?}", p1, p2); // p1 sigue viva
}
```

**`Copy`** copia **bit a bit** de forma implícita en la asignación (`let b = a;`). Solo puede ser `Copy` si **todos** sus campos lo son (números, `bool`, `char`, referencias...). Un `String` NO es `Copy`, así que un struct con `String` jamás podrá derivarlo:

```rust
// NO COMPILA — error[E0200]: the trait `Copy` may not be implemented for this type
#[derive(Debug, Clone, Copy)]
struct Persona { nombre: String } // String no es Copy -> E0200
```

Un struct solo numérico sí:

```rust
#[derive(Debug, Clone, Copy, PartialEq)]
struct Punto { x: i32, y: i32 }

fn main() {
    let a = Punto { x: 1, y: 2 };
    let b = a;         // Copy: copia, no mueve
    let c = a.clone(); // también disponible
    println!("{:?} — {:?} — {:?}", a, b, c);
}
```

| | `Clone` | `Copy` |
|---|---|---|
| Duplicado con | `.clone()` explícito | Asignación/paso implícito |
| Coste | Puede ser profundo | Siempre barato |
| Impedimento | Un campo no-`Clone` | Un campo no-`Copy` o con `Drop` |
| Relación | — | `Copy` *implica* `Clone` (derivar ambos) |

Regla práctica: si es una "bolsa de números", deriva `Clone, Copy`. Si contiene `String`/`Vec`, solo `Clone`.

### Enum

Un **enum** modela alternativas: el valor es **uno de varios casos** (variantes). Rust obliga a tratarlos todos, lo que elimina los "valores inválidos".

#### Enums con datos asociados

Cada variante puede llevar una tupla, un struct anónimo o nada:

```rust
enum Mensaje {
    Texto(String),
    Numerico(i32),
    Mover { x: i32, y: i32 },
    Salir,
}

fn main() {
    let m1 = Mensaje::Texto(String::from("hola"));
    let m2 = Mensaje::Numerico(42);
    let m3 = Mensaje::Mover { x: 5, y: -3 };
    let m4 = Mensaje::Salir;
}
```

Para leer los datos se usa `match` **exhaustivo** (o un comodín `_`):

```rust
fn procesar(m: Mensaje) {
    match m {
        Mensaje::Texto(t) => println!("Texto: {}", t),
        Mensaje::Numerico(n) => println!("Número: {}", n),
        Mensaje::Mover { x, y } => println!("Mover a ({}, {})", x, y),
        Mensaje::Salir => println!("Saliendo"),
    }
}

fn main() {
    procesar(Mensaje::Texto(String::from("hola")));
    procesar(Mensaje::Numerico(42));
    procesar(Mensaje::Mover { x: 5, y: -3 });
    procesar(Mensaje::Salir);
}
```

Si falta una variante: `error[E0004]`. Al añadir variantes nuevas, el compilador te lleva a todos los sitios que deben tratarla.

#### Enums unit

Variantes sin datos:

```rust
enum Estado {
    Activo,
    Pausado,
    Terminado,
}

impl Estado {
    fn etiqueta(&self) -> &'static str {
        match self {
            Estado::Activo => "en marcha",
            Estado::Pausado => "pausado",
            Estado::Terminado => "terminado",
        }
    }

    fn transicion(&mut self) {
        *self = match self {
            Estado::Activo => Estado::Pausado,
            Estado::Pausado => Estado::Terminado,
            Estado::Terminado => Estado::Terminado,
        };
    }
}

fn main() {
    let mut e = Estado::Activo;
    println!("{}", e.etiqueta()); // en marcha
    e.transicion();
    println!("{}", e.etiqueta()); // pausado
}
```

Patrón habitual de **máquina de estados**: el enum guarda el estado y un método `&mut self` calcula la transición con `*self = match ...`.

### match en profundidad

#### Patrones de enums

Los patrones pueden ligar varios datos, ignorar con `_` o `..`, casar literales y combinar alternativas con `|`:

```rust
fn clasificar(e: Estado) -> &'static str {
    match e {
        Estado::Activo => "Corriendo",
        Estado::Pausado | Estado::Terminado => "Detenido",
        _ => "Desconocido",
    }
}

fn main() {
    let m = Mensaje::Mover { x: 5, y: -3 };
    match m {
        Mensaje::Mover { y, .. } => println!("Me interesa la y: {}", y),
        _ => {}
    }
}
```

#### @ (binding)

`@` **liga el valor completo a un nombre** mientras lo casas con un patrón. Clásico con rangos:

```rust
enum Nivel { Estandar, Premium }

fn puntos(nivel: Nivel, puntos: u32) -> u32 {
    match (nivel, puntos) {
        (Nivel::Premium, p @ 0..=100) => p * 2,
        (Nivel::Premium, p) => p * 3,
        (Nivel::Estandar, p) => p,
    }
}

fn main() {
    println!("{}", puntos(Nivel::Premium, 50));   // 100
    println!("{}", puntos(Nivel::Premium, 200));  // 600
    println!("{}", puntos(Nivel::Estandar, 50));  // 50
}
```

`p @ 0..=100` casa valores entre 0 y 100 **y** los guarda en `p`.

#### Guardas (if en match)

Una **guarda** añade una condición extra tras el patrón; si es falsa, se sigue probando:

```rust
fn clasificar(n: i32) -> &'static str {
    match n {
        x if x % 2 == 0 => "par",
        x if x < 0 => "negativo e impar",
        _ => "positivo e impar",
    }
}

fn main() {
    for n in [-3, 4, 7] {
        println!("{} -> {}", n, clasificar(n));
    }
}
```

También deciden sobre datos del enum, como `Mensaje::Numerico(n) if *n > 100 => "Número muy grande"`.

#### match sobre Option

`Option<T>` es el enum de "hay valor o no". `match` es la forma segura y explícita de leerlo:

```rust
fn mitad(n: i32) -> Option<i32> {
    if n % 2 == 0 { Some(n / 2) } else { None }
}

fn main() {
    match mitad(10) {
        Some(v) => println!("La mitad es {}", v),
        None => println!("No es divisible entre 2"),
    }
}
```

`match` obliga a contemplar `None`, eliminando de raíz los "null pointer exceptions".

### if let

Cuando solo interesa **un caso**, `if let` condensa el `match`. El `else` corre cuando NO casa:

```rust
fn main() {
    let opt = Some(5);

    if let Some(v) = opt {
        println!("Encontré {}", v);
    } else {
        println!("No había nada");
    }

    let m = Mensaje::Numerico(42);
    if let Mensaje::Numerico(n) = m {
        println!("Era numérico: {}", n);
    }
}
```

Si necesitas tratar todos los casos, usa `match`; si te importa uno solo, `if let`.

### while let

Mientras el patrón case se ejecuta el cuerpo; en cuanto no case, termina. Clásico con pilas:

```rust
fn main() {
    let mut stack = vec![1, 2, 3];

    while let Some(top) = stack.pop() {
        println!("Sacando {}", top);
    }
    // 3, 2, 1 (pop devuelve None al vaciarse)
}
```

### Enums con structs anidados

Structs y enums se combinan libremente. Una figura puede ser un círculo o un rectángulo, y ambos usan un struct `Punto`:

```rust
struct Punto { x: i32, y: i32 }

enum Figura {
    Circulo { centro: Punto, radio: f64 },
    Rectangulo { esquina: Punto, ancho: f64, alto: f64 },
}

impl Figura {
    fn contiene(&self, p: &Punto) -> bool {
        match self {
            Figura::Circulo { centro, radio } => {
                let dx = (p.x - centro.x) as f64;
                let dy = (p.y - centro.y) as f64;
                (dx * dx + dy * dy) <= radio * radio
            }
            Figura::Rectangulo { esquina, ancho, alto } => {
                p.x >= esquina.x
                    && p.y >= esquina.y
                    && (p.x as f64) <= esquina.x as f64 + ancho
                    && (p.y as f64) <= esquina.y as f64 + alto
            }
        }
    }
}

fn main() {
    let circulo = Figura::Circulo { centro: Punto { x: 0, y: 0 }, radio: 5.0 };
    let rect = Figura::Rectangulo { esquina: Punto { x: 0, y: 0 }, ancho: 4.0, alto: 3.0 };
    let dentro = Punto { x: 3, y: 4 };
    println!("(3,4) en círculo: {}", circulo.contiene(&dentro)); // true
    println!("(3,4) en rect:   {}", rect.contiene(&dentro));    // true
}
```

El `match` extrae el struct anidado (`centro`, `esquina`) y accede a sus campos. También al revés: un struct puede llevar un enum como campo, y un enum puede tener una variante que sea un struct.

### Comparación de structs: PartialEq, Eq, PartialOrd

Los operadores `==`, `<`, etc. **no funcionan por arte de magia**: el tipo debe implementar los traits. Para tus tipos los derivas:

| Trait | Operadores | Exige | Uso |
|---|---|---|---|
| `PartialEq` | `==`, `!=` | — | Igualdad; base de `assert_eq!` |
| `Eq` | — | `PartialEq` | Igualdad total; para `HashMap`/`HashSet` |
| `PartialOrd` | `<`, `<=`, `>`, `>=` | `PartialEq` | Orden con posibles incomparables |
| `Ord` | `sort`, `min`, `max` | `PartialOrd` + `Eq` | Orden total; para `BTreeSet`/`BTreeMap` |

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
struct Version { mayor: u8, menor: u8, patch: u8 }

fn main() {
    let v1 = Version { mayor: 1, menor: 4, patch: 0 };
    let v2 = Version { mayor: 1, menor: 10, patch: 2 };

    println!("v1 == v1: {}", v1 == v1);
    println!("v1 < v2:  {}", v1 < v2); // orden lexicográfico por campos

    let mut versiones = vec![v2, v1];
    versiones.sort(); // requiere Ord
    println!("Ordenadas: {:?}", versiones);
}
```

El orden derivado es **lexicográfico**: compara campo a campo; por eso `1.4.0 < 1.10.2`. **¿Y si comparas sin `PartialEq`?** `error[E0369]`:

```rust
// NO COMPILA — error[E0369]: binary operation `==` cannot be applied to type `Punto`
#[derive(Debug)]
struct Punto { x: i32, y: i32 }

fn main() {
    let a = Punto { x: 1, y: 2 };
    let b = Punto { x: 1, y: 2 };
    if a == b { println!("iguales"); }
}
```

Solución: `#[derive(PartialEq)]` (más `Debug` para que `assert_eq!` imprima al fallar). Matices: **no derives `Eq` ni `Ord` con campos `f64`/`f32`** (`NaN == NaN` es falso), y los enums también se comparan por variante y datos.

## Ejemplos de código

### Ejemplo 1 — Biblioteca de figuras

```rust
use std::f64::consts::PI;

struct Punto { x: i32, y: i32 }

enum Figura {
    Circulo { centro: Punto, radio: f64 },
    Rectangulo { esquina: Punto, ancho: f64, alto: f64 },
}

impl Figura {
    fn area(&self) -> f64 {
        match self {
            Figura::Circulo { radio, .. } => PI * radio * radio,
            Figura::Rectangulo { ancho, alto, .. } => ancho * alto,
        }
    }
}

fn main() {
    let figuras = vec![
        Figura::Circulo { centro: Punto { x: 0, y: 0 }, radio: 2.0 },
        Figura::Rectangulo { esquina: Punto { x: 0, y: 0 }, ancho: 3.0, alto: 4.0 },
    ];

    let mut total = 0.0;
    for f in &figuras {
        total += f.area();
    }
    println!("Área total: {:.2}", total); // 12.57 + 12.00 = 24.57
}
```

### Ejemplo 2 — Cuenta bancaria con enum de operaciones

```rust
enum Operacion { Deposito(f64), Retiro(f64) }

struct Cuenta { titular: String, saldo: f64 }

impl Cuenta {
    fn nueva(titular: &str) -> Cuenta {
        Cuenta { titular: titular.to_string(), saldo: 0.0 }
    }

    fn aplicar(&mut self, op: Operacion) -> Result<f64, String> {
        match op {
            Operacion::Deposito(monto) => {
                self.saldo += monto;
                Ok(self.saldo)
            }
            Operacion::Retiro(monto) => {
                if monto <= self.saldo {
                    self.saldo -= monto;
                    Ok(self.saldo)
                } else {
                    Err(format!("Fondos insuficientes (saldo: {})", self.saldo))
                }
            }
        }
    }
}

fn main() {
    let mut cuenta = Cuenta::nueva("Ana");
    println!("{:?}", cuenta.aplicar(Operacion::Deposito(100.0))); // Ok(100.0)
    println!("{:?}", cuenta.aplicar(Operacion::Retiro(30.0)));    // Ok(70.0)
    println!("{:?}", cuenta.aplicar(Operacion::Retiro(200.0)));   // Err(...)
}
```

### Ejemplo 3 — Máquina de estados de un pedido

```rust
enum Pedido {
    Recibido,
    EnPreparacion,
    Enviado(String), // número de seguimiento
}

fn siguiente(p: &Pedido) -> Option<Pedido> {
    match p {
        Pedido::Recibido => Some(Pedido::EnPreparacion),
        Pedido::EnPreparacion => Some(Pedido::Enviado(String::from("SEG-123"))),
        Pedido::Enviado(_) => None,
    }
}

fn main() {
    let mut pedido = Pedido::Recibido;
    let mut pasos = 0;

    while let Some(nuevo) = siguiente(&pedido) {
        pedido = nuevo;
        pasos += 1;
    }
    println!("El pedido avanzó {} veces hasta terminar", pasos); // 2

    match &pedido {
        Pedido::Enviado(codigo) => println!("Enviado. Código: {}", codigo),
        _ => println!("Aún en camino"),
    }
}
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)

## Errores comunes

### E0063 — Faltan campos al construir un struct

```rust
// NO COMPILA — error[E0063]: missing field `edad` in initializer of `Persona`
struct Persona { nombre: String, edad: u8 }
fn main() {
    let p = Persona { nombre: String::from("Ana") }; // falta `edad`
}
```

**Solución**: inicializa todos los campos o usa `..` para copiar el resto. Si un campo es opcional, plantéate `Option<T>`.

### E0004 — match no exhaustivo

```rust
// NO COMPILA — error[E0004]: non-exhaustive patterns: `Mensaje::Numerico` not covered
enum Mensaje { Texto(String), Numerico(i32), Salir }
fn procesar(m: Mensaje) {
    match m {
        Mensaje::Texto(t) => println!("Texto: {}", t),
        Mensaje::Salir => println!("Saliendo"),
        // falta Mensaje::Numerico
    }
}
```

**Solución**: añade la rama que falta o cierra con `_ => {}`. El error te dice exactamente qué patrón falta.

### E0308 — Tipos que no coinciden (String vs &str)

```rust
// NO COMPILA — error[E0308]: mismatched types. expected `String`, found `&str`
struct Persona { nombre: String }
fn main() {
    let p = Persona { nombre: "Ana" }; // "Ana" es &str
}
```

**Solución**: convierte con `.to_string()` o `String::from("Ana")`. Regla: los structs guardan `String` (con dueño); los `&str` solo prestan.

### E0596 — Prestar como mutable algo que no es mut

```rust
// NO COMPILA — error[E0596]: cannot borrow `r` as mutable, as it is not declared as mutable
struct Rectangulo { ancho: u32, alto: u32 }
impl Rectangulo { fn escalar(&mut self, f: u32) { self.ancho *= f; } }
fn main() {
    let r = Rectangulo { ancho: 4, alto: 3 };
    r.escalar(2); // r no es mut
}
```

**Solución**: declara `let mut r`. Pareja: método `&mut self` ⟺ variable `let mut`.

### E0382 — Usar un valor después de moverlo

```rust
// NO COMPILA — error[E0382]: borrow of moved value: `ana`
struct Persona { nombre: String }
fn consumir(p: Persona) {}
fn main() {
    let ana = Persona { nombre: String::from("Ana") };
    consumir(ana);
    println!("{}", ana.nombre); // E0382: ana ya no existe
}
```

**Solución**: pásala por referencia (`&ana`), clónala, o reordena para consumir al final. Pasa igual con métodos que toman `self`.

### E0425 / E0412 — Typos en nombres

```rust
// NO COMPILA — error[E0425]: cannot find value `nomrbe` in this scope
struct Persona { nombre: String }
fn main() {
    let nomrbe = String::from("Ana"); // typo de variable
    let p = Persona { nombre: nomrbe }; // E0425
    // error[E0412]: cannot find type `Personna` in this scope (typo de tipo)
    // let p2 = Personna { nombre: String::from("Ana") };
}
```

**Solución**: revisa la ortografía de variables (E0425) y tipos (E0412). El compilador suele sugerir "a similar name exists: `nombre`"; con tipos, también ocurre al olvidar un `use`.

### E0277 — Usar `{}` sin implementar Display

```rust
// NO COMPILA — error[E0277]: `Persona` doesn't implement `std::fmt::Display`
#[derive(Debug)]
struct Persona { nombre: String }
fn main() {
    let p = Persona { nombre: String::from("Ana") };
    println!("{}", p); // E0277
}
```

**Solución**: implementa `Display` a mano, o usa `{:?}` si solo estás depurando. `Display` (manual) y `Debug` (derivable) son distintos.

### E0407 / E0046 — Implementar Display mal

```rust
// NO COMPILA — error[E0407]: method `to_string` is not a member of trait `std::fmt::Display`
use std::fmt;
struct Persona { nombre: String }
impl fmt::Display for Persona {
    fn to_string(&self) -> String { /* el obligatorio se llama `fmt` */ }
}
```

```rust
// NO COMPILA — error[E0046]: not all trait items implemented, missing: `fmt`
impl fmt::Display for Persona {
    // olvidamos definir fn fmt(&self, ...)
}
```

**Solución**: respeta la firma exacta `fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result` con `write!(f, ...)`, y completa todos los métodos requeridos por el trait.

### E0599 — Llamar a un método inexistente (por ejemplo, `.clone()`)

```rust
// NO COMPILA — error[E0599]: no method named `clone` found for struct `Persona`
struct Persona { nombre: String }
fn main() {
    let p1 = Persona { nombre: String::from("Ana") };
    let p2 = p1.clone(); // Persona no deriva Clone
}
```

**Solución**: añade `#[derive(Clone)]` (y todos los campos deben ser `Clone`). También aparece con nombres de método mal escritos.

### E0507 — Mover un campo al devolverlo desde un método &self

```rust
// NO COMPILA — error[E0507]: cannot move out of `self.nombre` which is behind a shared reference
struct Persona { nombre: String }
impl Persona {
    fn dame_nombre(&self) -> String {
        self.nombre // solo tiene prestado &self
    }
}
```

**Solución**: devuelve una referencia (`-> &str` con `&self.nombre`), clona, o cambia a `self` si quieres consumir el struct.

## Recursos

- [The Rust Book — Capítulo 5: Using Structs to Structure Related Data](https://doc.rust-lang.org/book/ch05-00-structs.html)
- [The Rust Book — Capítulo 6: Enums and Pattern Matching](https://doc.rust-lang.org/book/ch06-00-enums.html)
- [The Rust Book — `if let`: Concise Control Flow](https://doc.rust-lang.org/book/ch06-03-if-let.html)
- [Rust By Example — Structs](https://doc.rust-lang.org/rust-by-example/custom_types/structs.html)
- [Rust By Example — Enums](https://doc.rust-lang.org/rust-by-example/custom_types/enum.html)
- [Rust By Example — Pattern matching](https://doc.rust-lang.org/rust-by-example/flow_control/match.html)
- [Rust By Example — `if let` y `while let`](https://doc.rust-lang.org/rust-by-example/flow_control/if_let.html)
- [std::fmt — documentación oficial](https://doc.rust-lang.org/std/fmt/)
- [std::option::Option — documentación oficial](https://doc.rust-lang.org/std/option/enum.Option.html)
- [Rustlings — ejercicios de structs y enums](https://github.com/rust-lang/rustlings)