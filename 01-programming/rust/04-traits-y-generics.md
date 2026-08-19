# 04 — Traits y generics

## Objetivos

- [ ] Definir un `trait` con métodos y usarlo con `impl Trait for Tipo`.
- [ ] Implementar métodos con comportamiento por defecto y sobrescribirlos cuando haga falta.
- [ ] Usar `&impl Trait` y parámetros genéricos con bounds (`T: Trait`) en funciones.
- [ ] Derivar e implementar `Display`, `Debug`, `Clone`, `Copy`, `PartialEq`, `Eq` y `PartialOrd`.
- [ ] Convertir entre tipos con `From` / `Into`.
- [ ] Usar trait objects (`&dyn Trait`, `Box<dyn Trait>`) y diferenciarlos de `impl Trait`.
- [ ] Escribir funciones, structs y enums genéricos con `<T>`, incluyendo varios type parameters.
- [ ] Escribir bounds compuestos con `+` y la cláusula `where`.
- [ ] Escribir closures con `||`, entender qué capturan y su trait (`Fn`, `FnMut`, `FnOnce`).
- [ ] Recorrer colecciones con `iter`, `iter_mut` e `into_iter` y transformarlas con `map`, `filter`, `fold`, `collect`, `sum` y `count`.
- [ ] Implementar tu propio iterador implementando la trait `Iterator`.
- [ ] Identificar y corregir errores frecuentes (E0277, E0308, E0599, E0433, E0507, E0621...).

## Apuntes

Con los **traits** describimos *qué puede hacer* un tipo, y con los **generics** escribimos código una sola vez para que funcione con *muchos* tipos. Juntos permiten construir APIs cómodas y seguras como las de `std`.

### Traits

#### Definir un trait

Un `trait` declara métodos que un tipo debe implementar: comparte comportamiento entre tipos distintos sin herencia. El trait es el **contrato**; cada tipo lo cumple a su manera.

```rust
trait Sonido {
    fn hacer_sonido(&self);
}

struct Perro;
struct Gato;

impl Sonido for Perro {
    fn hacer_sonido(&self) { println!("Guau"); }
}
impl Sonido for Gato {
    fn hacer_sonido(&self) { println!("Miau"); }
}

fn main() {
    Perro.hacer_sonido();
    Gato.hacer_sonido();
}
```

La firma no tiene cuerpo obligatorio; `&self` es el receptor (también existen `&mut self` y `self`); y `Perro` y `Gato` son tipos ajenos que solo comparten el trait.

#### Implementar un trait

Se escribe `impl NombreTrait for NombreTipo`. Un mismo trait se implementa para muchos tipos, y un tipo puede implementar muchos traits.

```rust
trait Area {
    fn area(&self) -> f64;
}

struct Rectangulo { ancho: f64, alto: f64 }

impl Area for Rectangulo {
    fn area(&self) -> f64 {
        self.ancho * self.alto
    }
}

fn main() {
    let r = Rectangulo { ancho: 3.0, alto: 4.0 };
    println!("Rectángulo: {:.2}", r.area());
}
```

Cada `impl` adapta la misma idea («¿cuánto ocupa?») al tipo: eso es **polimorfismo**. 

> **Regla de los huérfanos**: solo puedes implementar un trait sobre un tipo si el trait **o** el tipo se definió en tu crate. `impl Display for Vec<i32>` es imposible (ambos son de `std`), para evitar conflictos entre crates.

#### Métodos con implementación por defecto

Un trait puede dar un **cuerpo por defecto** a algunos métodos; el tipo los hereda o los sobrescribe.

```rust
trait Saludo {
    fn nombre(&self) -> String;

    fn saludar(&self) -> String {
        format!("Hola, {}!", self.nombre())
    }
}

struct Persona { nombre: String }

impl Saludo for Persona {
    fn nombre(&self) -> String {
        self.nombre.clone()
    }
}

fn main() {
    let p = Persona { nombre: String::from("Ana") };
    println!("{}", p.saludar());
}
```

Es el patrón de `std`: `Display` exige `fmt` y regala `to_string()`; `Iterator` exige `next` y regala `map`, `filter`, `sum`, etc. Escribe lo obligatorio y heredas el resto.

#### Traits como parámetros (impl Trait, generics con bounds)

Para aceptar **cualquier** tipo que implemente un trait hay dos sintaxis equivalentes:

```rust
trait Mascota {
    fn nombre(&self) -> &str;
}

struct Perro;
impl Mascota for Perro {
    fn nombre(&self) -> &str { "Rex" }
}

fn presentar(a: &impl Mascota) {
    println!("Mascota: {}", a.nombre());
}

fn presentar_generico<T: Mascota>(a: &T) {
    println!("Mascota: {}", a.nombre());
}

fn main() {
    presentar(&Perro);
    presentar_generico(&Perro);
}
```

Ambas generan la misma **monomorfización** (una copia de la función por tipo usado). La segunda es imprescindible si dos parámetros deben ser **el mismo** tipo: con dos `&impl PartialEq` independientes, `a` y `b` podrían ser de tipos distintos y `a == b` no compilaría.

| Sintaxis | Cuándo preferirla |
|---|---|
| `fn f(a: &impl Trait)` | Firmas cortas; el tipo anónimo se entiende por contexto. |
| `fn f<T: Trait>(a: &T)` | Cuando el mismo tipo `T` aparece en varios parámetros o en el retorno. |

### Traits estándar útiles

| Trait | Para qué sirve | Sintaxis | ¿Derivable? |
|---|---|---|---|
| `Debug` | Formateo de depuración | `{:?}` | Sí |
| `Display` | Formateo para humanos | `{}` | No (manual) |
| `Clone` | Copia profunda explícita | `.clone()` | Sí |
| `Copy` | Copia implícita por bits | asignación | Sí |
| `PartialEq` | Igualdad `==` | `a == b` | Sí |
| `Eq` | Igualdad total | `a == b` | Sí |
| `PartialOrd` | Comparación `< > <= >=` | `a < b` | Sí |
| `From` / `Into` | Conversión entre tipos | `T::from(x)`, `x.into()` | Parcial |

#### Display y Debug

`Debug` es el formato de máquina (derivable, se imprime con `{:?}` o `{:#?}`); `Display` es el formato humano (manual, con `{}`):

```rust
use std::fmt::{self, Display, Formatter};

#[derive(Debug)]
struct Punto { x: i32, y: i32 }

impl Display for Punto {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

fn main() {
    let p = Punto { x: 3, y: 4 };
    println!("{}", p);    // (3, 4)
    println!("{:?}", p);  // Punto { x: 3, y: 4 }
}
```

`Debug` es lo que usan `assert_eq!` y `.unwrap()` para mostrar valores al fallar.

#### Clone y Copy

`Clone` hace una **copia profunda explícita** con `.clone()` (cualquier tipo). `Copy` es un marcador: el tipo se copia por bits **implícitamente** al moverlo. Todo `Copy` debe ser `Clone`.

```rust
#[derive(Debug, Clone, Copy)]
struct Punto { x: i32, y: i32 }

fn main() {
    let p = Punto { x: 1, y: 2 };
    let q = p;          // Copy: copia implícita, `p` sigue vivo
    let r = p.clone();  // Clone: copia explícita
    println!("{:?} {:?} {:?}", p, q, r);
}
```

Los primitivos son `Copy`; `String` y `Vec` no. Un struct solo es `Copy` si **todos** sus campos lo son (`#[derive(Copy)]` con un `String` dentro falla, E0204).

#### PartialEq, Eq

`PartialEq` define `==` y `!=`. `Eq` añade la equivalencia total (reflexiva: `x == x` siempre); por eso `f64` (con `NaN`) solo puede ser `PartialEq`.

```rust
#[derive(Debug, PartialEq)]
struct Color { r: u8, g: u8, b: u8 }

fn main() {
    let a = Color { r: 255, g: 0, b: 0 };
    let b = Color { r: 255, g: 0, b: 0 };
    let c = Color { r: 0, g: 0, b: 255 };
    println!("a == b: {}, a == c: {}, a != c: {}", a == b, a == c, a != c);
}
```

Derivar `PartialEq` habilita `Vec::contains` y `assert_eq!`. `Eq` se exige como clave de `HashSet`/`HashMap` (junto con `Hash`).

#### From / Into

`From` y `Into` son **el mismo trait visto desde dos lados**: si implementas `From<A> for B`, obtienes gratis `Into<B> for A`.

```rust
struct Temperatura { celsius: f64 }

impl From<f64> for Temperatura {
    fn from(celsius: f64) -> Self { Temperatura { celsius } }
}

fn main() {
    let t1: Temperatura = 21.5.into();
    let t2 = Temperatura::from(18.0);
    println!("{} y {}", t1.celsius, t2.celsius);
}
```

Ya los usas: `String::from("hola")` es `From<&str> for String`. Con `.into()` suele hacer falta anotar el destino.

### Trait objects

#### &dyn Trait y Box<dyn Trait>

Un **trait object** guarda un valor de tamaño desconocido detrás de un puntero (`&dyn Trait` o `Box<dyn Trait>`) y decide el tipo concreto **en tiempo de ejecución** mediante una *vtable*. A diferencia de los generics, permite **colecciones heterogéneas**; con `Box<dyn Trait>` el valor vive **en el heap**, por lo que una función puede devolverlo:

```rust
trait Sonido {
    fn hacer_sonido(&self) -> String;
}

struct Perro;
struct Gato;

impl Sonido for Perro {
    fn hacer_sonido(&self) -> String { String::from("Guau") }
}
impl Sonido for Gato {
    fn hacer_sonido(&self) -> String { String::from("Miau") }
}

fn caja_sonido() -> Box<dyn Sonido> { Box::new(Perro) }

fn coro(animales: &[&dyn Sonido]) {
    for a in animales {
        println!("{}", a.hacer_sonido());
    }
}

fn main() {
    let animales: Vec<&dyn Sonido> = vec![&Perro, &Gato];
    coro(&animales);
    println!("{}", caja_sonido().hacer_sonido());
}
```

#### Diferencia con impl Trait

| | `impl Trait` / `<T: Trait>` | `&dyn Trait` |
|---|---|---|
| Tipo concreto | En **compilación** (monomorfización) | En **ejecución** (vtable) |
| Rendimiento | Máximo, sin indirección | Una indirección por llamada |
| Código generado | Una copia por tipo usado | Una sola función |
| Colección de tipos distintos | No | Sí |
| Requisito | Ninguno | El trait debe ser *object-safe* |

Regla práctica: usa generics si puedes; `dyn` solo cuando necesites heterogeneidad.

### Generics

#### Funciones genéricas

Una función genérica declara el tipo con `<T>` y funciona con cualquier tipo que cumpla el bound. Sin bound solo puedes hacer lo válido para *todos* los tipos; para `>` o `+` debes declararlo.

```rust
fn mayor<T: PartialOrd>(a: T, b: T) -> T {
    if a > b { a } else { b }
}

fn main() {
    println!("{} {} {}", mayor(3, 7), mayor(3.5, 2.1), mayor("a", "b"));
}
```

`mayor` se instancia una vez por tipo usado. `T: PartialOrd` es el **trait bound**: "cualquier `T` comparable con `>`".

#### Structs genéricos

```rust
#[derive(Debug, Clone, PartialEq)]
struct Caja<T> {
    contenido: T,
}

impl<T> Caja<T> {
    fn nuevo(contenido: T) -> Caja<T> { Caja { contenido } }
}

// Este método solo existe si T se puede comparar
impl<T: PartialOrd> Caja<T> {
    fn es_mayor_que(&self, otra: &Caja<T>) -> bool {
        self.contenido > otra.contenido
    }
}

fn main() {
    let a = Caja::nuevo(5);
    let b = Caja::nuevo(3);
    println!("a > b: {} | a == b: {}", a.es_mayor_que(&b), a == b);
}
```

`Caja<i32>` y `Caja<String>` son **tipos distintos** y `T` se infiere del argumento de `nuevo`. Si llamas a `es_mayor_que` sobre un `Caja<String>`, el compilador lo impide: el método no existe para ese tipo.

#### Enums genéricos

Los enums admiten parámetros de tipo — de hecho `Option<T>` y `Result<T, E>` lo son. Puedes definir los tuyos:

```rust
enum Resultado<T, E> {
    Exito(T),
    Falla(E),
}

fn procesar(valor: i32) -> Resultado<i32, String> {
    if valor >= 0 { Resultado::Exito(valor * 2) }
    else { Resultado::Falla(String::from("no acepto negativos")) }
}

fn main() {
    match procesar(4) {
        Resultado::Exito(x) => println!("Exito: {}", x),
        Resultado::Falla(m) => println!("Falla: {}", m),
    }
}
```

Cada variante puede usar los parámetros del enum (`T` en `Exito`, `E` en `Falla`) y se eligen los tipos concretos en el punto de uso.

#### Múltiples type parameters

```rust
struct Par<A, B> {
    primero: A,
    segundo: B,
}

fn invertir<A, B>(par: Par<A, B>) -> Par<B, A> {
    Par { primero: par.segundo, segundo: par.primero }
}

fn main() {
    let invertido = invertir(Par { primero: 1, segundo: "dos" });
    println!("{} - {}", invertido.primero, invertido.segundo);
}
```

Los parámetros se separan con comas y el compilador deduce `A` y `B` en el punto de uso.

### Bounds y where

#### Trait bounds simples

Un **bound** es la restricción `T: Trait` en la declaración del parámetro. El compilador solo permite en el cuerpo lo que el bound garantiza:

```rust
use std::fmt::Display;

fn mostrar<T: Display>(valor: T) {
    println!("{}", valor);
}

fn main() {
    mostrar(42);
    mostrar("hola");
    // mostrar(vec![1, 2]); // E0277: Vec<i32> no implementa Display
}
```

#### Cláusula where

Cuando la firma acumula bounds largos, la cláusula `where` al final mejora la legibilidad. Es **exactamente igual** que ponerlos en línea:

```rust
use std::fmt::Display;

fn mayor_y_mostrar<T>(a: T, b: T) -> T
where
    T: PartialOrd + Display,
{
    let m = if a > b { a } else { b };
    println!("El mayor es {}", m);
    m
}

fn main() {
    mayor_y_mostrar(3, 9);
}
```

#### Múltiples bounds (T: A + B)

Con `+` pides varios traits a la vez y el cuerpo usa los métodos de todos (lo viste en `mayor_y_mostrar` con `T: PartialOrd + Display`). También es combinable con `where` y con `impl Trait`.

### Closures

#### Sintaxis y captura

Un **closure** es una función anónima que *captura* variables del entorno. Se escribe `|parámetros| cuerpo`; si el cuerpo es una expresión, esa es su devolución.

```rust
fn main() {
    let sumar = |a: i32, b: i32| a + b;
    println!("{}", sumar(2, 3));

    let incremento = 10;
    let sumar_incremento = |a: i32| a + incremento; // captura `incremento`
    println!("{}", sumar_incremento(5));
}
```

`sumar` no captura nada; `sumar_incremento` captura `incremento` por referencia porque solo lo lee. Los closures capturan de la forma **más débil** posible:

| Lo que el cuerpo hace | Captura |
|---|---|
| Solo lee la variable | Por referencia `&` |
| Modifica la variable | Por referencia mutable `&mut` |
| Mueve la variable (la consume) | Por valor (movida) |

#### Fn, FnMut, FnOnce

Cada closure implementa automáticamente estos traits, que definen *cómo* y *cuántas veces* se puede llamar:

| Trait | Qué puede hacer | Cuántas veces | Captura |
|---|---|---|---|
| `Fn` | Solo leer el entorno | Muchas | `&` |
| `FnMut` | Modificar el entorno | Muchas | `&mut` |
| `FnOnce` | Consumir el entorno | Una sola | por valor |

La jerarquía es transitiva: todo `Fn` es `FnMut` y `FnOnce`; todo `FnMut` es `FnOnce`.

```rust
fn main() {
    let mensaje = String::from("Hola");
    let lee = || println!("{}", mensaje); // Fn: solo lee
    lee();
    lee();

    let mut contador = 0;
    let mut modifica = || contador += 1; // FnMut: modifica el entorno
    modifica();
    modifica();
    println!("contador = {}", contador);

    let texto = String::from("adiós");
    let consume = || drop(texto); // FnOnce: consume lo capturado
    consume();
    // consume(); // E0382: `texto` ya fue movido
}
```

Nota que `let mut modifica = || ...` necesita `mut`: el closure guarda el estado mutado dentro de sí mismo.

#### move closures

Con `move` obligas al closure a **tomar posesión** (mover) de lo capturado en vez de prestarlo. Es necesario cuando el closure va a vivir más que su entorno o correrá en otro hilo:

```rust
fn main() {
    let dato = String::from("soy un dato");
    let mover = move || println!("{}", dato);
    mover();

    // println!("{}", dato); // E0382: `dato` fue movido al closure
}
```

Sin `move`, `mover` capturaría `&dato` y el `println!` seguiría funcionando. Es imprescindible con `std::thread::spawn`, porque el hilo nuevo no puede prestar del stack del hilo original.

#### Closures como parámetros

Para pasar un closure a una función usas generics con `Fn`/`FnMut`/`FnOnce` como bound, eligiendo según cuántas veces lo vayas a llamar:

```rust
fn aplicar_dos<F>(f: F, valor: i32) -> i32
where
    F: Fn(i32) -> i32,
{
    f(f(valor))
}

fn ejecutar_una_vez<F>(f: F) -> i32
where
    F: FnOnce() -> i32,
{
    f()
}

fn main() {
    let doble = |x: i32| x * 2;
    println!("{} {}", aplicar_dos(doble, 5), ejecutar_una_vez(|| 3 * 10));
}
```

Por eso `Iterator::map`, `Iterator::filter`, `Option::unwrap_or_else` y `thread::spawn` aceptan closures: están escritos con estos bounds.

### Iterators

#### La trait Iterator

Un **iterator** es un tipo con `next()` que devuelve `Option<Item>`: `Some(elemento)` mientras queden elementos y `None` al final. Todo lo demás (`map`, `filter`, ...) está implementado encima de `next`.

```rust
fn main() {
    let numeros = vec![1, 2, 3];
    let mut it = numeros.iter();
    println!("{:?}", it.next()); // Some(1)
    println!("{:?}", it.next()); // Some(2)
    println!("{:?}", it.next()); // Some(3)
    println!("{:?}", it.next()); // None
}
```

Tres formas de obtener un iterador, según **quién es dueño** de los elementos:

| Método | Devuelve | ¿Consume la colección? |
|---|---|---|
| `iter()` | `&T` | No |
| `iter_mut()` | `&mut T` | No |
| `into_iter()` | `T` | Sí |

```rust
fn main() {
    let mut numeros = vec![1, 2, 3];

    for n in numeros.iter() {
        print!("{} ", n); // &i32
    }
    println!();

    for n in numeros.iter_mut() {
        *n *= 10; // &mut i32
    }
    println!("{:?}", numeros);

    for n in numeros.into_iter() {
        print!("{} ", n); // i32 por valor, consume el vector
    }
    println!();
}
```

Recuerda que `for x in coleccion` es azúcar para `coleccion.into_iter()`.

#### Métodos adaptadores: map, filter, fold

Los **adaptadores** devuelven otro iterator **perezoso** (no hacen nada hasta que un consumidor los recorre), por eso se encadenan:

```rust
fn main() {
    let numeros = vec![1, 2, 3, 4, 5, 6];

    let cuadrados: Vec<i32> = numeros.iter().map(|n| n * n).collect();
    let pares: Vec<i32> = numeros.iter().filter(|&&n| n % 2 == 0).copied().collect();
    let acumulado: i32 = numeros.iter().fold(0, |acc, n| acc + n);
    println!("{:?} {:?} {}", cuadrados, pares, acumulado);
}
```

En `filter`, como `iter()` produce `&i32`, el closure recibe `&&i32` y el patrón típico es `|&&n| ...` (o usa `.copied()`). `fold` es el "todopoderoso": acumulador inicial + closure `|acc, elemento| nuevo_acc`.

#### Consumidores: collect, sum, count

Los **consumidores** recorren el iterator hasta agotarlo y devuelven un valor final:

```rust
fn main() {
    let numeros = vec![1, 2, 3, 4, 5, 6];

    let suma: i32 = numeros.iter().sum();
    let cantidad = numeros.iter().count();
    let coleccion: Vec<i32> = numeros.iter().map(|n| n * 10).collect();
    println!("{} {} {:?}", suma, cantidad, coleccion);
}
```

| Consumidor | Devuelve | Ejemplo |
|---|---|---|
| `collect()` | Cualquier colección (`Vec`, `String`...) | `v.iter().map(...).collect()` |
| `sum()` | Suma de elementos | `let s: i32 = v.iter().sum();` |
| `count()` | Número de elementos | `v.iter().count()` |
| `fold()` | Reducción con acumulador | `v.iter().fold(0, \|acc, n\| acc + n)` |

#### Iteradores propios

Implementas `Iterator` definiendo el tipo asociado `Item` y el método `next`; con eso obtienes gratis `map`, `filter`, `sum`, etc.:

```rust
struct Contador {
    actual: u32,
    limite: u32,
}

impl Contador {
    fn nuevo(limite: u32) -> Contador {
        Contador { actual: 0, limite }
    }
}

impl Iterator for Contador {
    type Item = u32;

    fn next(&mut self) -> Option<u32> {
        if self.actual >= self.limite {
            None
        } else {
            self.actual += 1;
            Some(self.actual)
        }
    }
}

fn main() {
    let total: u32 = Contador::nuevo(5).sum();
    let multiplos: Vec<u32> = Contador::nuevo(5).map(|n| n * 3).collect();
    println!("{} {:?}", total, multiplos);
}
```

El invariante: `next` debe devolver `None` **para siempre** después del final; los adaptadores de `std` confían en eso.

### Combinación de traits y generics

En la práctica todo se mezcla: bounds compuestos, closures y genéricos en la misma función.

```rust
use std::fmt::Debug;

trait Describible {
    fn describir(&self) -> String;
}

#[derive(Debug)]
struct Punto { x: i32, y: i32 }

impl Describible for Punto {
    fn describir(&self) -> String { format!("Punto({}, {})", self.x, self.y) }
}

fn imprimir<T: Debug + Describible>(valor: &T) {
    println!("{:?} -> {}", valor, valor.describir());
}

fn main() {
    imprimir(&Punto { x: 3, y: 4 });
    println!("{}", (|n: i32| n * 2)(21));
}
```

Datos + regla de transformación pasada como closure es la base de `map`, `filter` y `sort_by`.

## Ejemplos de código

### Ejemplo 1 — Zoológico con trait objects

```rust
trait Animal {
    fn hablar(&self) -> String;
}

struct Perro;
struct Gato;

impl Animal for Perro {
    fn hablar(&self) -> String { String::from("Guau") }
}
impl Animal for Gato {
    fn hablar(&self) -> String { String::from("Miau") }
}

fn main() {
    let animales: Vec<Box<dyn Animal>> = vec![Box::new(Perro), Box::new(Gato)];
    for a in &animales {
        println!("{}", a.hablar());
    }
}
```

### Ejemplo 2 — Pipeline de datos con closures e iterators

```rust
fn pipeline<T, F>(datos: Vec<T>, transformacion: F) -> Vec<T>
where
    F: Fn(&T) -> T,
{
    datos.iter().map(transformacion).collect()
}

fn main() {
    let numeros = vec![1, 2, 3, 4, 5, 6];

    let duplicados = pipeline(numeros.clone(), |n| n * 2);
    let impares: Vec<i32> = duplicados.iter().filter(|&&n| n % 2 == 1).copied().collect();
    println!("{:?} {:?} {}", duplicados, impares, duplicados.iter().sum::<i32>());
}
```

### Ejemplo 3 — Productos: filtrar, mapear y sumar

```rust
#[derive(Debug, Clone, PartialEq)]
struct Producto {
    nombre: String,
    precio: f64,
}

fn main() {
    let productos = vec![
        Producto { nombre: String::from("Pan"), precio: 1.5 },
        Producto { nombre: String::from("Leche"), precio: 0.9 },
        Producto { nombre: String::from("Queso"), precio: 3.2 },
    ];

    let baratos: Vec<&Producto> = productos.iter().filter(|p| p.precio < 2.0).collect();
    println!("Baratos: {}", baratos.len());

    let total: f64 = productos.iter().map(|p| p.precio).sum();
    println!("Total: {:.2}", total);
}
```

## Ejercicios relacionados

- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)

Practica con los conceptos del capítulo: define al menos dos structs propios con `#[derive(Debug, Clone, PartialEq)]`, implementa un trait propio para ambos y escribe una función genérica con `where` que reciba un closure para transformar una lista con `map` y `filter`.

## Errores comunes

### E0277 — Usar `>` sin el bound `PartialOrd`

```rust
// NO COMPILA — error[E0277]: `T` doesn't implement `PartialOrd`
fn mayor<T>(a: T, b: T) -> T {
    if a > b { a } else { b } // el compilador no sabe comparar `T`
}
```

**Solución**: añade el bound `fn mayor<T: PartialOrd>(...)`. El error indica exactamente el trait que falta.

### E0277 — Usar `{}` sin implementar Display

```rust
// NO COMPILA — error[E0277]: `Producto` doesn't implement `std::fmt::Display`
struct Producto { nombre: String }
fn main() {
    let p = Producto { nombre: String::from("Pan") };
    println!("{}", p); // E0277
}
```

**Solución**: implementa `Display` a mano o usa `{:?}` con `#[derive(Debug)]`.

### E0308 — Mezclar `String` y `&str`

```rust
// NO COMPILA — error[E0308]: mismatched types. expected `String`, found `&str`
fn main() {
    let nombre: String = "Ana"; // "Ana" es &str
}
```

**Solución**: usa `String::from("Ana")` o `"Ana".to_string()`.

### E0599 — Llamar a un método que no existe (por ejemplo, `.clone()` sin derivar)

```rust
// NO COMPILA — error[E0599]: no method named `clone` found for struct `Producto`
struct Producto { nombre: String }
fn main() {
    let p1 = Producto { nombre: String::from("Pan") };
    let p2 = p1.clone(); // Producto no deriva Clone
}
```

**Solución**: añade `#[derive(Clone)]`. También aparece con typos: `.mapp` en vez de `.map`.

### E0433 — Módulo mal escrito o `use` inexistente

```rust
// NO COMPILA — error[E0433]: failed to resolve: could not find `collection` in `std`
use std::collection::HashMap; // el módulo real es `std::collections` (plural)
fn main() {
    let mut m = HashMap::new();
    m.insert(1, "a");
}
```

**Solución**: corrige la ruta (`std::collections`) y revisa la ortografía del módulo.

### E0507 — Mover un campo fuera de una referencia

```rust
// NO COMPILA — error[E0507]: cannot move out of `self.nombre` which is behind a shared reference
struct Persona { nombre: String }
impl Persona {
    fn dame_nombre(&self) -> String {
        self.nombre // solo tenemos prestado `&self`
    }
}
```

**Solución**: devuelve `-> &str` con `&self.nombre`, clona (`self.nombre.clone()`) o toma `self` por valor.

### E0621 — Falta el lifetime explícito al devolver una referencia

```rust
// NO COMPILA — error[E0621]: explicit lifetime required in the type of `a`
struct A;
struct B<'a> {
    a: &'a A,
}
impl<'a> B<'a> {
    fn get(&self) -> &A {
        self.a // el &self del método no tiene por qué durar tanto como `'a`
    }
}
```

**Solución**: vincula el retorno al lifetime del struct: `fn get(&self) -> &'a A`.

### E0382 — Usar un valor después de que un closure `move` lo consuma

```rust
// NO COMPILA — error[E0382]: borrow of moved value: `dato`
fn main() {
    let dato = String::from("importante");
    let mover = move || {
        println!("{}", dato);
    };
    mover();
    println!("{}", dato); // `dato` fue movido dentro del closure
}
```

**Solución**: si el closure solo lee, quita el `move`; si debe poseer el dato, no uses la variable después.

### E0282 — `collect` sin anotar el tipo de destino

```rust
// NO COMPILA — error[E0282]: type annotations needed
fn main() {
    let nums = vec![1, 2, 3];
    let cuadrados = nums.iter().map(|n| n * n).collect(); // ¿Vec<i32>? ¿HashSet? ¿String?
}
```

**Solución**: anota el tipo (`let cuadrados: Vec<i32> = ...collect();`) o usa `collect::<Vec<i32>>()`.

### E0502 — Prestar inmutable y mutable a la vez (con iterators)

```rust
// NO COMPILA — error[E0502]: cannot borrow `numeros` as mutable because it is also borrowed as immutable
fn main() {
    let mut numeros = vec![1, 2, 3];
    let primero = &numeros[0]; // préstamo inmutable
    numeros.push(4);           // E0502: no se puede mutar mientras viva `primero`
    println!("{}", primero);
}
```

**Solución**: mueve el `push` antes de crear `primero`, o clona el valor.

## Recursos

- [The Rust Book — Capítulo 10: Generics, Traits, and Lifetimes](https://doc.rust-lang.org/book/ch10-00-generics.html)
- [The Rust Book — 10.1: Generic Data Types](https://doc.rust-lang.org/book/ch10-01-syntax.html)
- [The Rust Book — 10.2: Traits: Defining Shared Behavior](https://doc.rust-lang.org/book/ch10-02-traits.html)
- [The Rust Book — Capítulo 13: Functional Language Features](https://doc.rust-lang.org/book/ch13-00-functional-features.html)
- [The Rust Book — 13.1: Closures](https://doc.rust-lang.org/book/ch13-01-closures.html)
- [The Rust Book — 13.2: Processing a Series of Items with Iterators](https://doc.rust-lang.org/book/ch13-02-iterators.html)
- [Rust By Example — Traits](https://doc.rust-lang.org/rust-by-example/trait.html)
- [Rust By Example — Closures](https://doc.rust-lang.org/rust-by-example/fn/closures.html)
- [std::iter::Iterator — documentación oficial](https://doc.rust-lang.org/std/iter/trait.Iterator.html)
- [std::convert::From — documentación oficial](https://doc.rust-lang.org/std/convert/trait.From.html)