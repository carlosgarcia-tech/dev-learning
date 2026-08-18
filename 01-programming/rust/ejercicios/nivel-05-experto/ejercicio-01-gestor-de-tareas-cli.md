# Ejercicio 01 — Gestor de tareas CLI

- **Nivel:** 5/5
- **Tema:** CLI interactivo, `std::io`, structs, `match`
- **Tiempo estimado:** 45 min

## Enunciado

Crea un programa `gestor.rs` (o un proyecto `cargo new gestor --bin`) que sea un gestor de tareas interactivo en consola. Un bucle `loop` lee comandos de la terminal:

- `agregar <descripción>` → añade una tarea nueva.
- `listar` → muestra todas las tareas con su estado `[ ]`/`[x]`.
- `completar <id>` → marca una tarea como completada.
- `eliminar <id>` → borra una tarea.
- `ayuda` → muestra los comandos disponibles.
- `salir` → termina el programa.

Cada tarea se modela con un `struct Tarea { id: usize, descripcion: String, completada: bool }`. El `id` se asigna de forma incremental.

## Requisitos

- [ ] El bucle principal usa `loop` y `break` al leer `salir`.
- [ ] Los comandos se interpretan con `match` sobre la primera palabra.
- [ ] `agregar` separa la descripción del comando con `splitn`.
- [ ] `completar` y `eliminar` parsean el `id` a `usize` y manejan el caso de no existir.
- [ ] `listar` muestra `[ ]` o `[x]` según `completada`.
- [ ] Ejecutarlo localmente con `cargo run` (o `rustc gestor.rs && ./gestor`) y probar `agregar`, `listar`, `completar`, `eliminar` y `salir`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para leer línea: `let mut linea = String::new(); io::stdin().read_line(&mut linea).unwrap();`.
- Recuerda `use std::io::{self, Write};` y `io::stdout().flush().unwrap();` para mostrar el prompt `> `.
- `linea.trim()` elimina el `\n` final.
- `partes[1]` contiene la descripción si el comando fue `agregar ...`.
- `find(|t| t.id == id)` busca la tarea; `retain` la elimina.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
use std::io::{self, Write};

struct Tarea {
    id: usize,
    descripcion: String,
    completada: bool,
}

impl Tarea {
    fn nueva(id: usize, descripcion: String) -> Tarea {
        Tarea {
            id,
            descripcion,
            completada: false,
        }
    }
}

fn main() {
    let mut tareas: Vec<Tarea> = Vec::new();
    let mut siguiente_id = 1;

    println!("=== Gestor de tareas ===");
    imprimir_ayuda();

    loop {
        print!("> ");
        io::stdout().flush().unwrap();

        let mut linea = String::new();
        io::stdin().read_line(&mut linea).unwrap();
        let linea = linea.trim();

        if linea.is_empty() {
            continue;
        }

        let partes: Vec<&str> = linea.splitn(2, ' ').collect();
        match partes[0] {
            "agregar" => {
                if partes.len() < 2 {
                    println!("Uso: agregar <descripción>");
                    continue;
                }
                let descripcion = partes[1].to_string();
                tareas.push(Tarea::nueva(siguiente_id, descripcion.clone()));
                println!("Tarea {} añadida: {}", siguiente_id, descripcion);
                siguiente_id += 1;
            }
            "listar" => {
                if tareas.is_empty() {
                    println!("No hay tareas.");
                } else {
                    for t in &tareas {
                        let estado = if t.completada { "[x]" } else { "[ ]" };
                        println!("{} {} {}", t.id, estado, t.descripcion);
                    }
                }
            }
            "completar" => {
                if let Some(id) = partes.get(1).and_then(|s| s.parse::<usize>().ok()) {
                    match tareas.iter_mut().find(|t| t.id == id) {
                        Some(t) => {
                            t.completada = true;
                            println!("Tarea {} completada", id);
                        }
                        None => println!("No existe la tarea {}", id),
                    }
                } else {
                    println!("Uso: completar <id>");
                }
            }
            "eliminar" => {
                if let Some(id) = partes.get(1).and_then(|s| s.parse::<usize>().ok()) {
                    let antes = tareas.len();
                    tareas.retain(|t| t.id != id);
                    if tareas.len() < antes {
                        println!("Tarea {} eliminada", id);
                    } else {
                        println!("No existe la tarea {}", id);
                    }
                } else {
                    println!("Uso: eliminar <id>");
                }
            }
            "ayuda" => imprimir_ayuda(),
            "salir" => {
                println!("¡Hasta luego!");
                break;
            }
            _ => {
                println!("Comando desconocido: {}", partes[0]);
                imprimir_ayuda();
            }
        }
    }
}

fn imprimir_ayuda() {
    println!("Comandos:");
    println!("  agregar <descripción>");
    println!("  listar");
    println!("  completar <id>");
    println!("  eliminar <id>");
    println!("  ayuda");
    println!("  salir");
}
````

</details>