# 01 — Fundamentos de Rust

## Objetivos

- [ ] Escribir un programa ejecutable con `fn main()`.
- [ ] Declarar variables con `let` y entender la inmutabilidad por defecto.
- [ ] Conocer los tipos numéricos, `bool`, `char`, `String` y `&str`.
- [ ] Usar operadores aritméticos, de comparación y lógicos.
- [ ] Escribir condicionales `if/else if/else` y `match`.
- [ ] Usar los bucles `loop`, `while` y `for`.
- [ ] Leer entrada del usuario con `std::io` y `std::env`.

## Apuntes

### La función `main`

Todo programa ejecutable empieza en `fn main()`. El código se compila con `cargo run` o `rustc archivo.rs`.

```rust
fn main() {
    println!("¡Hola, Rust!");
}
```

### Variables y mutabilidad

- `let` declara una variable **inmutable** por defecto. No se puede reasignar.
- `mut` la hace **mutable** (puede cambiar su valor).
- El tipo se infiere, pero puedes anotarlo: `let edad: u32 = 30;`.
- Las constantes se declaran con `const` y deben anotar tipo siempre.

```rust
let nombre = "Ana";          // inmutable
let mut contador = 0;        // mutable
contador += 1;               // ok
const GRAVEDAD: f64 = 9.81;  // constante

// let nombre = "Luis";      // ERROR: no se puede reasignar
```

### Tipos de datos

- **Enteros:** `i8`, `i16`, `i32`, `i64`, `i128` (con signo) y `u8`, `u16`, `u32`, `u64`, `u128` (sin signo). Por defecto se infiere `i32`.
- **Flotantes:** `f32` y `f64` (por defecto `f64`).
- **Booleanos:** `bool` (`true` / `false`).
- **Caracteres:** `char`, un solo carácter Unicode entre comillas simples: `'a'`.
- **Cadenas:** `String` (propia y modificable) y `&str` (rebanada de texto, inmutable).

```rust
let entero: i32 = 42;
let flotante: f64 = 3.14;
let verdadero: bool = true;
let letra: char = 'R';
let texto_owned: String = String::from("hola");
let texto_prestado: &str = "hola";
```

### Operadores

- **Aritméticos:** `+ - * / %`.
- **Comparación:** `== != > < >= <=`.
- **Lógicos:** `&& || !`.
- **Asignación:** `= += -= *= /=`.

```rust
println!("{}", 7 % 3);   // 1 (resto)
println!("{}", 2 * 10);  // 20
println!("{}", 5 == 5);  // true
println!("{}", 3 > 2 && 1 < 0); // false
```

### Condicionales

`if`, `else if`, `else` evalúan condiciones booleanas. En Rust **no hay** valores "falsy": la condición debe ser `bool`. Puedes usar `if` como expresión que devuelve un valor.

```rust
let nota = 85;
if nota >= 90 {
    println!("Excelente");
} else if nota >= 70 {
    println!("Aprobado");
} else {
    println!("Reprobado");
}

let resultado = if nota >= 60 { "aprueba" } else { "reprueba" };
println!("{}", resultado);
```

### `match`

`match` compara un valor contra patrones. Es exhaustivo: debes cubrir todas las posibilidades.

```rust
let dia = 3;
match dia {
    1 => println!("Lunes"),
    2 => println!("Martes"),
    3 => println!("Miércoles"),
    _ => println!("Otro día"),
}
```

### Bucles

- `loop` — repite para siempre hasta que encuentres `break`.
- `while` — repite mientras la condición sea verdadera.
- `for` — recorre rangos, vectores, etc. Es el más usado.
- `break` corta el bucle; `continue` salta a la siguiente iteración.

```rust
for i in 1..=3 {
    println!("{}", i); // 1, 2, 3
}

let mut n = 0;
while n < 3 {
    n += 1;
}

let mut valor = loop {
    break 42; // loop como expresión devuelve 42
};
```

### Entrada y salida

- `println!` imprime con salto de línea; `print!` sin él. Usa `{}` para mostrar valores.
- Leer del teclado requiere `std::io::stdin()`.
- Los argumentos del programa se obtienen con `std::env::args()`.

```rust
use std::io::{self, Write};

fn main() {
    print!("Dime tu nombre: ");
    io::stdout().flush().unwrap();

    let mut nombre = String::new();
    io::stdin().read_line(&mut nombre).unwrap();
    let nombre = nombre.trim();

    println!("Hola, {}!", nombre);
}
```

## Ejemplos de código

```rust
// Programa completo: saludo con nombre y edad
use std::io::{self, Write};

fn main() {
    print!("Nombre: ");
    io::stdout().flush().unwrap();
    let mut nombre = String::new();
    io::stdin().read_line(&mut nombre).unwrap();

    print!("Edad: ");
    io::stdout().flush().unwrap();
    let mut edad = String::new();
    io::stdin().read_line(&mut edad).unwrap();

    let edad: u32 = edad.trim().parse().expect("edad inválida");
    println!("Hola {}, el año que viene tendrás {} años.", nombre.trim(), edad + 1);
}
```

```rust
// Tabla de multiplicar
fn main() {
    let numero = 7;
    for i in 1..=10 {
        println!("{} x {} = {}", numero, i, numero * i);
    }
}
```

## Ejercicios relacionados

- [Ejercicios nivel 01 — Fundamentos](../ejercicios/nivel-01-fundamentos/)

## Errores comunes

- **Reasignar una variable sin `mut`** → `error[E0384]: cannot assign twice to immutable variable`. Solución: declara `let mut`.
- **Comparar `String` con `&str` mal** → a veces comparas referencias y no valores; usa `==` entre `&str` o `.trim()`.
- **Usar `&&` con valores no booleanos** → en Rust no existen valores "falsy"; `if 1 { }` no compila.
- **Leer entrada y olvidar el `\n`** → `read_line` incluye el salto de línea; usa `.trim()` antes de comparar o parsear.
- **Acceder a un índice fuera de rango** → `vec[10]` sobre un vector de 3 elementos lanza un *panic*. Prefiere `.get(10)`.
- **Parsear sin manejar el error** → `.parse::<u32>()` devuelve `Result`; usa `.expect(...)` o `match` para manejarlo.

## Recursos

- [The Rust Programming Language — libro oficial](https://doc.rust-lang.org/book/)
- [Rust By Example — variables](https://doc.rust-lang.org/rust-by-example/variable_bindings.html)
- [Rust Playground — probar en el navegador](https://play.rust-lang.org/)
- [rustup — instalación de Rust](https://rustup.rs/)
- [std::io — documentación](https://doc.rust-lang.org/std/io/index.html)