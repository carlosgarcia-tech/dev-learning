# Ejercicio 04 — Patrones avanzados

- **Nivel:** 3/5
- **Tema:** guards, rangos, destructuración, `if let`, `while let`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un programa `patrones.rs` que:

1. Defina un `enum Color { Rgb(u8, u8, u8), Hex(String) }`.
2. Implemente `describir(c: Color) -> String` con un `match` que use un **guard** (`if r > 200` para "Rojo intenso").
3. En `main`:
   - Use un `match` sobre un `i32` con **rangos** (`1..=5`, `6..=10`, `_`).
   - Use `if let` para extraer un `Option<i32>`.
   - Use `while let` para agotar un `VecDeque` (o una pila manual con `Vec` + `pop`).
   - Destructure una tupla de 3 elementos.

Salida esperada (ejemplo):

```
Rgb (255, 0, 0) -> Rojo intenso
Rgb (10, 10, 10) -> Rgb (10, 10, 10)
Hex ff0000
Número 4 está en 1..=5
Número 8 está en 6..=10
if let: 42
while let: 3, 2, 1,
Tupla: Ana, 30, 1.65
```

## Requisitos

- [ ] `describir` usa al menos un guard `if` en un patrón.
- [ ] El `match` numérico usa rangos `..=`.
- [ ] Usar `if let` y `while let`.
- [ ] Destructurar una tupla.
- [ ] Ejecutarlo localmente con `rustc patrones.rs && ./patrones` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Guard: `Color::Rgb(r, _, _) if r > 200 => ...`.
- Rangos: `1..=5 => ...` dentro de `match`.
- `if let Some(n) = opcion { ... }`.
- `while let Some(x) = pila.pop() { ... }` agota la pila.
- Destructurar: `let (a, b, c) = tupla;`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
enum Color {
    Rgb(u8, u8, u8),
    Hex(String),
}

fn describir(c: Color) -> String {
    match c {
        Color::Rgb(r, g, b) if r > 200 => format!("Rojo intenso ({}, {}, {})", r, g, b),
        Color::Rgb(r, g, b) => format!("Rgb ({}, {}, {})", r, g, b),
        Color::Hex(h) => format!("Hex #{}", h),
    }
}

fn clasificar_numero(n: i32) -> &'static str {
    match n {
        1..=5 => "está en 1..=5",
        6..=10 => "está en 6..=10",
        _ => "fuera de rango",
    }
}

fn main() {
    println!("{}", describir(Color::Rgb(255, 0, 0)));
    println!("{}", describir(Color::Rgb(10, 10, 10)));
    println!("{}", describir(Color::Hex(String::from("ff0000"))));

    for n in [4, 8] {
        println!("Número {} {}", n, clasificar_numero(n));
    }

    let opcion: Option<i32> = Some(42);
    if let Some(valor) = opcion {
        println!("if let: {}", valor);
    }

    let mut pila = vec![1, 2, 3];
    print!("while let: ");
    while let Some(x) = pila.pop() {
        print!("{}, ", x);
    }
    println!();

    let persona = ("Ana", 30, 1.65);
    let (nombre, edad, altura) = persona;
    println!("Tupla: {}, {}, {}", nombre, edad, altura);
}
````

</details>