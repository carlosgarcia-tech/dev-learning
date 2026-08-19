# Ejercicio 03 — Enums y match

- **Nivel:** 2/5
- **Tema:** `enum`, `match`, patrones
- **Tiempo estimado:** 20 min

## Enunciado

Crea un programa `enums.rs` que:

1. Defina un `enum Mensaje` con los casos: `Salir`, `Mover { x: i32, y: i32 }`, `Escribir(String)` y `CambiarColor(u8, u8, u8)`.
2. Implemente una función `procesar(m: Mensaje)` que imprima:
   - `Salir` → `"Adiós"`.
   - `Mover` → `"Moviendo a (x, y)"`.
   - `Escribir` → `"Escribiendo: texto"`.
   - `CambiarColor` → `"Color RGB: r, g, b"`.
3. En `main`, procese los cuatro mensajes.
4. Añada un `match` sobre una tupla `(i32, i32)` que distinga el origen `(0, 0)`, el eje X `(0, y)`, el eje Y `(x, 0)` y el resto.

Salida esperada (ejemplo):

```
Adiós
Moviendo a (3, -2)
Escribiendo: hola
Color RGB: 255, 0, 0
Origen
Eje X, y = 5
Eje Y, x = 7
Posición (2, 3)
```

## Requisitos

- [ ] El `enum` tiene los 4 casos con los datos asociados pedidos.
- [ ] `procesar` es exhaustiva (cubre todos los casos).
- [ ] El `match` de la tupla tiene casos con patrones y comodín.
- [ ] Ejecutarlo localmente con `rustc enums.rs && ./enums` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Enum con datos: `Escribir(String)` y `Mover { x: i32, y: i32 }`.
- `match` sobre el enum: `Mensaje::Mover { x, y } => println!("Moviendo a ({}, {})", x, y)`.
- Patrones de tupla: `(0, 0)`, `(0, y)`, `(x, 0)`, `(x, y)`.
- El comodín `_` cubre lo que no quieras nombrar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
enum Mensaje {
    Salir,
    Mover { x: i32, y: i32 },
    Escribir(String),
    CambiarColor(u8, u8, u8),
}

fn describir(m: &Mensaje) -> String {
    match m {
        Mensaje::Salir => String::from("Adiós"),
        Mensaje::Mover { x, y } => format!("Moviendo a ({}, {})", x, y),
        Mensaje::Escribir(texto) => format!("Escribiendo: {}", texto),
        Mensaje::CambiarColor(r, g, b) => format!("Color RGB: {}, {}, {}", r, g, b),
    }
}

fn clasificar(pos: (i32, i32)) -> String {
    match pos {
        (0, 0) => String::from("Origen"),
        (0, y) => format!("Eje X, y = {}", y),
        (x, 0) => format!("Eje Y, x = {}", x),
        (x, y) => format!("Posición ({}, {})", x, y),
    }
}

fn procesar(m: Mensaje) {
    println!("{}", describir(&m));
}

fn main() {
    procesar(Mensaje::Salir);
    procesar(Mensaje::Mover { x: 3, y: -2 });
    procesar(Mensaje::Escribir(String::from("hola")));
    procesar(Mensaje::CambiarColor(255, 0, 0));

    let posiciones = [(0, 0), (0, 5), (7, 0), (2, 3)];
    for pos in posiciones {
        println!("{}", clasificar(pos));
    }
}
````

</details>