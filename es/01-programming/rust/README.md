# Rust

> Ruta de aprendizaje completa de Rust (edición 2021) en español: guías de estudio, ejercicios por niveles y proyectos integradores.

Rust es un lenguaje de sistemas que garantiza seguridad de memoria sin recolección de basura gracias a su sistema de *ownership*. Es usado en navegadores (Servo), sistemas operativos, CLI, servidores de alto rendimiento y cada vez más en web (WebAssembly).

Esta ruta asume que sabes lo básico de programación pero parte desde cero en Rust. Cada guía introduce la teoría con ejemplos ejecutables y enlaza a los ejercicios que la refuerzan.

Para ejecutar los ejemplos necesitas el compilador `rustc` y el gestor de paquetes `cargo`. Instálalos con [rustup](https://rustup.rs/).

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | `fn main`, tipos, variables, mutabilidad, condicionales, bucles e I/O |
| [02 — Ownership](02-ownership.md) | Ownership, borrowing, referencias y slices |
| [03 — Structs y enums](03-structs-y-enums.md) | `struct`, `impl`, `enum` y `match` |
| [04 — Traits y generics](04-traits-y-generics.md) | Traits, generics, closures e iterators |
| [05 — Errores y concurrencia](05-errores-y-concurrencia.md) | `Option`, `Result`, `threads` y `channels` |

## Ejercicios por nivel

Cada ejercicio incluye enunciado, requisitos, pistas y solución. Compila y ejecuta cada solución con `cargo run` (o `rustc archivo.rs` para programas de un solo archivo).

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | Variables, funciones, control de flujo, strings, arrays y structs |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | Ownership, referencias, enums, `Option`/`Result`, vectores y HashMap |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | Traits, generics, `impl`, patrones, closures e iterators |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | Errores avanzados, lifetimes, threads, channels, trait objects y testing |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | CLI, servidor TCP, caché LRU, event loop, calculadora modular y worker pool |

Índice completo con los 30 ejercicios: [ejercicios/README.md](ejercicios/README.md)

## Proyectos

Al terminar los niveles, integra todo lo aprendido con los [3 proyectos integradores](ejercicios/proyectos/README.md):

1. **Agenda de contactos CLI** — aplicación de consola interactiva con persistencia en archivo.
2. **Servidor TCP de eco con estadísticas** — servidor multiusuario con `std::net`.
3. **Mini base de datos concurrente** — worker pool + canals para procesar comandos en paralelo.

## Compilando los ejemplos

Todos los ejemplos usan **Rust 2021 edition** y solo la biblioteca estándar, por lo que compilan sin dependencias externas:

```bash
# Como proyecto (recomendado)
cargo new mi_proyecto --bin
# copia el código en src/main.rs
cargo run

# Como archivo suelto
rustc archivo.rs
./archivo
```