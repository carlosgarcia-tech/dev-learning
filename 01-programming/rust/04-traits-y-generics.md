# 04 — Traits y generics

## Objetivos

- [ ] Definir un `trait` con métodos y usarlo con `impl Trait for Tipo`.
- [ ] Usar `&impl Trait` y el parámetro genérico `T: Trait` en funciones.
- [ ] Definir structs y funciones genéricas con `<T>`.
- [ ] Usar traits estándar como `PartialOrd`, `Display`, `Clone` y `Debug`.
- [ ] Escribir closures con `||` y entender `Fn`, `FnMut` y `FnOnce`.
- [ ] Usar iterators con `map`, `filter`, `collect`, `sum`, `fold`.

## Apuntes

### Definir un trait

Un `trait` define un conjunto de métodos que un tipo debe implementar. Es la forma de compartir comportamiento entre tipos distintos.

```rust
trait Sonido {
    fn sonido(&self) -> String;
}

struct Perro;
struct Gato;

impl Sonido for Perro {
    fn sonido(&self) -> String {
        String::from("Guau")
    }
}

impl Sonido for Gato {
    fn sonido(&self) -> String {
        String::from("Miau")
    }
}

fn main() {
    let p = Perro;
    let g = Gato;
    println!("{}", p.sonido());
    println!("{}", g.sonido());
}
```

### `&impl Trait` y `T: Trait`

Para escribir funciones que acepten cualquier tipo que implemente un trait:

```rust
fn presentar(a: &impl Sonido) {
    println!("Suena: {}", a.sonido());
}

// Equivalente con genéricos
fn presentar_generico<T: Sonido>(a: &T) {
    println!("Suena: {}", a.sonido());
}
```

### Generics

Los genéricos permiten escribir código que funciona con varios tipos sin duplicarlo.

```rust
fn mayor<T: PartialOrd>(a: T, b: T) -> T {
    if a > b { a } else { b }
}

fn main() {
    println!("{}", mayor(3, 7));
    println!("{}", mayor(3.5, 2.1));
    println!("{}", mayor("a", "b"));
}
```

`PartialOrd` permite comparar con `>`; `Display` permite imprimir con `{}`.

### Structs genéricos

```rust
struct Caja<T> {
    contenido: T,
}

impl<T> Caja<T> {
    fn nuevo(contenido: T) -> Caja<T> {
        Caja { contenido }
    }

    fn obtener(&self) -> &T {
        &self.contenido
    }
}

fn main() {
    let caja_numero = Caja::nuevo(42);
    let caja_texto = Caja::nuevo(String::from("hola"));
    println!("{} - {}", caja_numero.obtener(), caja_texto.obtener());
}
```

### Traits estándar comunes

- `Debug` — imprime con `{:?}` (deriva automáticamente).
- `Clone` — clona el valor con `.clone()`.
- `PartialEq` — compara con `==`.
- `PartialOrd` — compara con `<`, `>`, etc.
- `Display` — imprime con `{}`.

Puedes derivar los automáticos:

```rust
#[derive(Debug, Clone, PartialEq)]
struct Producto {
    nombre: String,
    precio: f64,
}

fn main() {
    let a = Producto { nombre: String::from("Pan"), precio: 1.5 };
    let b = a.clone();
    println!("{:?} == {:?}: {}", a, b, a == b);
}
```

### Closures

Un closure es una función anónima que captura variables del entorno. Sintaxis: `|param| cuerpo`.

```rust
fn main() {
    let sumar = |a: i32, b: i32| a + b;
    println!("{}", sumar(2, 3));

    let incremento = 10;
    let sumar_incremento = |a: i32| a + incremento; // captura
    println!("{}", sumar_incremento(5));
}
```

Clasificación según lo que capturan:

- `Fn` — solo lee (llamada múltiple).
- `FnMut` — modifica lo capturado.
- `FnOnce` — consume lo capturado; solo se llama una vez.

```rust
fn main() {
    let mut contador = 0;
    let mut incrementar = || {
        contador += 1; // FnMut: modifica el entorno
    };
    incrementar();
    incrementar();
    println!("contador = {}", contador);
}
```

### Iterators

Un iterator permite recorrer y transformar colecciones de forma declarativa. Métodos clave:

- `map` — transforma cada elemento.
- `filter` — se queda con los que cumplen una condición.
- `collect` — reúne los resultados en una colección.
- `sum`, `fold` — reducen a un valor.
- `max`, `min` — extremos.

```rust
fn main() {
    let numeros = vec![1, 2, 3, 4, 5, 6];

    let pares: Vec<i32> = numeros.iter().filter(|&&n| n % 2 == 0).copied().collect();
    println!("Pares: {:?}", pares);

    let cuadrados: Vec<i32> = numeros.iter().map(|n| n * n).collect();
    println!("Cuadrados: {:?}", cuadrados);

    let suma: i32 = numeros.iter().sum();
    println!("Suma: {}", suma);

    let acumulado: i32 = numeros.iter().fold(0, |acc, n| acc + n);
    println!("Fold: {}", acumulado);
}
```

## Ejemplos de código

```rust
use std::fmt::Display;

trait Describible {
    fn describir(&self) -> String;
}

struct Punto { x: i32, y: i32 }

impl Describible for Punto {
    fn describir(&self) -> String {
        format!("Punto({}, {})", self.x, self.y)
    }
}

fn imprimir<T: Display + Describible>(valor: &T) {
    println!("{} -> {}", valor, valor.describir());
}

fn main() {
    let p = Punto { x: 3, y: 4 };
    imprimir(&p);
}
```

```rust
// Transformación de datos con closures e iterators
fn main() {
    let nombres = vec!["ana", "luis", "carmen"];
    let saludos: Vec<String> = nombres
        .iter()
        .map(|n| format!("Hola, {}!", n))
        .collect();
    println!("{:?}", saludos);

    let largos: Vec<&str> = nombres.iter().filter(|n| n.len() > 3).copied().collect();
    println!("Nombres largos: {:?}", largos);
}
```

## Ejercicios relacionados

- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)

## Errores comunes

- **`>` no funciona con cualquier tipo** → necesitas el bound `T: PartialOrd` (o `Ord`). No todo tipo es comparable.
- **`{}` no funciona con tu propio tipo** → implementa `Display` o usa `{:?}` con `Debug` (`#[derive(Debug)]`).
- **Olvidar `#[derive(Clone)]`** → `a.clone()` falla si el tipo no implementa `Clone`.
- **Closure que intenta modificar sin `mut`** → si el closure muta su entorno, decláralo `let mut closure = ...`.
- **`collect` no infiere el tipo de destino** → anota el tipo: `let v: Vec<i32> = ...collect();`.
- **`filter` con referencias** → `iter()` produce `&T`, así que el patrón suele ser `|&&x| ...` o usar `.copied()`.

## Recursos

- [The Rust Book — Traits](https://doc.rust-lang.org/book/ch10-02-traits.html)
- [The Rust Book — Generics](https://doc.rust-lang.org/book/ch10-01-syntax.html)
- [The Rust Book — Closures](https://doc.rust-lang.org/book/ch13-01-closures.html)
- [The Rust Book — Iterators](https://doc.rust-lang.org/book/ch13-02-iterators.html)
- [Rust By Example — traits](https://doc.rust-lang.org/rust-by-example/trait.html)