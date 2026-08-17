# Ejercicio 05 — Mini proyecto: calculadora con módulos

- **Nivel:** 5/5
- **Tema:** módulos, organización de código, programas interactivos
- **Tiempo estimado:** 45 min

## Enunciado

Crea un programa `calculadora.rs` que organice su código en módulos:

1. Módulo `mod aritmetica` con las funciones públicas `sumar`, `restar`, `multiplicar` y `dividir`. `dividir(a, b) -> Result<f64, String>` devuelve `Err` si `b == 0.0`.
2. Módulo `mod menu` que:
   - Usa `crate::aritmetica`.
   - Muestra un menú con opciones `1` Sumar, `2` Restar, `3` Multiplicar, `4` Dividir, `5` Salir.
   - Lee la opción y dos números con una función auxiliar privada `leer_numero(mensaje: &str) -> f64`.
   - Maneja el `Result` de `dividir` e imprime el error.
3. `main` llama a `menu::ejecutar()`.

Prueba: suma `2 + 3`, divide `10 / 0` (debe mostrar error) y luego `salir`.

## Requisitos

- [ ] El módulo `aritmetica` tiene 4 funciones `pub`.
- [ ] `dividir` devuelve `Result<f64, String>`.
- [ ] El módulo `menu` usa `crate::aritmetica` y tiene una función privada.
- [ ] El menú se repite hasta elegir `salir`.
- [ ] Ejecutarlo localmente con `cargo run` (o `rustc calculadora.rs && ./calculadora`) y probar las 5 opciones.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Módulos dentro del mismo archivo: `mod aritmetica { ... }`.
- Para leer números: `let mut linea = String::new(); io::stdin().read_line(&mut linea).unwrap(); linea.trim().parse::<f64>()`.
- `print!` + `io::stdout().flush().unwrap()` muestra el prompt sin salto de línea.
- `match opcion.trim() { "1" => ..., ... }`.
- En el caso de dividir: `match aritmetica::dividir(a, b) { Ok(r) => ..., Err(e) => ... }`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
use std::io::{self, Write};

mod aritmetica {
    pub fn sumar(a: f64, b: f64) -> f64 {
        a + b
    }

    pub fn restar(a: f64, b: f64) -> f64 {
        a - b
    }

    pub fn multiplicar(a: f64, b: f64) -> f64 {
        a * b
    }

    pub fn dividir(a: f64, b: f64) -> Result<f64, String> {
        if b == 0.0 {
            Err(String::from("división entre cero"))
        } else {
            Ok(a / b)
        }
    }
}

mod menu {
    use crate::aritmetica;
    use std::io::{self, Write};

    pub fn ejecutar() {
        loop {
            println!("=== Calculadora ===");
            println!("1. Sumar");
            println!("2. Restar");
            println!("3. Multiplicar");
            println!("4. Dividir");
            println!("5. Salir");
            print!("Elige una opción: ");
            io::stdout().flush().unwrap();

            let mut opcion = String::new();
            io::stdin().read_line(&mut opcion).unwrap();

            match opcion.trim() {
                "5" => {
                    println!("¡Hasta luego!");
                    break;
                }
                "1" | "2" | "3" | "4" => {
                    let a = leer_numero("Primer número: ");
                    let b = leer_numero("Segundo número: ");
                    let resultado = match opcion.trim() {
                        "1" => Ok(aritmetica::sumar(a, b)),
                        "2" => Ok(aritmetica::restar(a, b)),
                        "3" => Ok(aritmetica::multiplicar(a, b)),
                        _ => aritmetica::dividir(a, b),
                    };
                    match resultado {
                        Ok(r) => println!("Resultado: {}", r),
                        Err(e) => println!("Error: {}", e),
                    }
                }
                _ => println!("Opción inválida"),
            }
        }
    }

    fn leer_numero(mensaje: &str) -> f64 {
        loop {
            print!("{}", mensaje);
            io::stdout().flush().unwrap();
            let mut linea = String::new();
            io::stdin().read_line(&mut linea).unwrap();
            match linea.trim().parse::<f64>() {
                Ok(n) => return n,
                Err(_) => println!("Número inválido, intenta de nuevo."),
            }
        }
    }
}

fn main() {
    menu::ejecutar();
}
````

</details>