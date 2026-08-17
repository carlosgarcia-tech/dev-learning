# 02 — Ownership y borrowing

## Objetivos

- [ ] Entender qué es el *ownership* y por qué Rust lo impone.
- [ ] Explicar las reglas del ownership: un valor solo tiene un dueño a la vez.
- [ ] Distinguir `Copy` (enteros, bools, char) de los tipos que se mueven (`String`, `Vec`).
- [ ] Prestar valores con referencias inmutables `&` y mutables `&mut`.
- [ ] Conocer la regla de que no puede haber un `&mut` y un `&` simultáneos.
- [ ] Usar slices `&str`, `&[T]` para prestar partes de datos.

## Apuntes

### ¿Qué es el ownership?

Cada valor en Rust tiene un **dueño** (owner). Solo puede haber un dueño a la vez; cuando el dueño sale de su ámbito, el valor se libera automáticamente. Esto garantiza seguridad de memoria sin recolector de basura.

```rust
{
    let s = String::from("hola");
    // s es dueño del String
} // aquí s sale del ámbito y la memoria se libera
```

### Movimiento

Cuando asignas un valor a otra variable o lo pasas a una función, el valor **se mueve**: el dueño original ya no puede usarlo.

```rust
let s1 = String::from("hola");
let s2 = s1; // s1 se mueve a s2
// println!("{}", s1); // ERROR: s1 ya no es válido
println!("{}", s2);
```

Los tipos con `Copy` (números, `bool`, `char`, tuplas de esos tipos) **no se mueven**, se copian:

```rust
let x = 5;
let y = x;     // copia, no movimiento
println!("{} {}", x, y); // ambos válidos
```

### Referencias y borrowing

Una **referencia** `&` presta el valor sin tomar posesión. El que la recibe es el *borrower*.

- Referencia inmutable `&T`: puedes leer pero no modificar.
- Referencia mutable `&mut T`: puedes modificar, pero solo si eres el único prestatario activo.

```rust
fn longitud(s: &String) -> usize {
    s.len() // leemos, no modificamos
}

fn saludar(s: &mut String) {
    s.push_str(" hola");
}

fn main() {
    let mut texto = String::from("mundo");
    println!("{}", longitud(&texto));
    saludar(&mut texto);
    println!("{}", texto);
}
```

### Reglas del borrowing

1. Puedes tener **muchas** referencias inmutables `&` a la vez.
2. Puedes tener **una sola** referencia mutable `&mut`.
3. No puedes mezclar un `&mut` con un `&` que apunte al mismo valor.

El compilador impone estas reglas para evitar carreras de datos y usar-después-de-liberar.

```rust
let mut v = 10;
let r1 = &v;      // ok
let r2 = &v;      // ok: varias inmutables
// let r3 = &mut v; // ERROR: ya hay referencias inmutables vivas
println!("{} {}", r1, r2);
```

### Slices

Un **slice** presta una parte contigua de una colección sin copiarla. Los de strings son `&str`; los de arrays/vectores son `&[T]`.

```rust
fn main() {
    let palabra = String::from("hola mundo");
    let saludo = &palabra[0..4];
    println!("{}", saludo); // "hola"

    let numeros = [10, 20, 30, 40, 50];
    let parte = &numeros[1..4];
    println!("{:?}", parte); // [20, 30, 40]
}
```

Los slices llevan implícitamente el tamaño, por eso los tipos se escriben `&str` y `&[T]` (con `T` el tipo de elemento).

### Funciones y devolución de ownership

Puedes devolver la propiedad de vuelta para que el valor no se pierda:

```rust
fn tomar_y_devolver(s: String) -> String {
    s // se devuelve la propiedad
}

fn main() {
    let s = String::from("texto");
    let s = tomar_y_devolver(s); // la propiedad vuelve a main
    println!("{}", s);
}
```

## Ejemplos de código

```rust
fn main() {
    let mut lista = vec![1, 2, 3, 4, 5];
    agregar_dos(&mut lista);

    let primeros = &lista[..3];
    println!("Primeros: {:?}", primeros);

    let suma: i32 = lista.iter().sum();
    println!("Suma: {}", suma);
}

fn agregar_dos(v: &mut Vec<i32>) {
    v.push(6);
    v.push(7);
}
```

```rust
// Primer palabra de una frase con slices
fn primera_palabra(s: &str) -> &str {
    match s.find(' ') {
        Some(pos) => &s[..pos],
        None => s,
    }
}

fn main() {
    let frase = String::from("hola mundo rust");
    println!("{}", primera_palabra(&frase)); // "hola"
}
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)

## Errores comunes

- **Usar un valor después de moverlo** → `error[E0382]: borrow of moved value`. Solución: pasa una referencia `&` en vez del valor.
- **Reasignar por una referencia** → intentar `s = ...` con `&String`. Usa `&mut String` para modificar.
- **Tener `&mut` y `&` a la vez** → `error[E0502]: cannot borrow ... as mutable`. Espera a que terminen las referencias inmutables.
- **Devolver una referencia a un valor local** → `error[E0106]: missing lifetime specifier`. El valor local se libera al salir de la función.
- **Confundir `String` con `&str`** → `String` es owned y modificable; `&str` es prestado e inmutable. Para compartir datos, usa `&str`.
- **Slices con índices de bytes erróneos** → cortar un `&str` por la mitad de un carácter UTF-8 paniquea. Usa `chars()` o `find` cuando haya texto acentuado.

## Recursos

- [The Rust Book — Ownership](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html)
- [Rust By Example — ownership](https://doc.rust-lang.org/rust-by-example/scope/move.html)
- [Rust By Example — borrowing](https://doc.rust-lang.org/rust-by-example/scope/borrow.html)
- [The Rust Book — The Slice Type](https://doc.rust-lang.org/book/ch04-03-slices.html)