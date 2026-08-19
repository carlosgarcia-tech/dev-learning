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

fn agregar_tarea(tareas: &mut Vec<Tarea>, siguiente_id: &mut usize, descripcion: String) -> usize {
    let id = *siguiente_id;
    tareas.push(Tarea::nueva(id, descripcion));
    *siguiente_id += 1;
    id
}

fn completar_tarea(tareas: &mut Vec<Tarea>, id: usize) -> bool {
    match tareas.iter_mut().find(|t| t.id == id) {
        Some(t) => {
            t.completada = true;
            true
        }
        None => false,
    }
}

fn eliminar_tarea(tareas: &mut Vec<Tarea>, id: usize) -> bool {
    let antes = tareas.len();
    tareas.retain(|t| t.id != id);
    tareas.len() < antes
}

fn contar_pendientes(tareas: &Vec<Tarea>) -> usize {
    tareas.iter().filter(|t| !t.completada).count()
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
                let id = agregar_tarea(&mut tareas, &mut siguiente_id, descripcion.clone());
                println!("Tarea {} añadida: {}", id, descripcion);
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
                    if completar_tarea(&mut tareas, id) {
                        println!("Tarea {} completada", id);
                    } else {
                        println!("No existe la tarea {}", id);
                    }
                } else {
                    println!("Uso: completar <id>");
                }
            }
            "eliminar" => {
                if let Some(id) = partes.get(1).and_then(|s| s.parse::<usize>().ok()) {
                    if eliminar_tarea(&mut tareas, id) {
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
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn nueva_crea_tarea_sin_completar() {
        let t = Tarea::nueva(1, String::from("estudiar"));
        assert_eq!(t.id, 1);
        assert_eq!(t.descripcion, "estudiar");
        assert!(!t.completada);
    }

    #[test]
    fn agregar_incrementa_lista_e_ids() {
        let mut tareas = Vec::new();
        let mut siguiente_id = 1;
        let id1 = agregar_tarea(&mut tareas, &mut siguiente_id, String::from("a"));
        let id2 = agregar_tarea(&mut tareas, &mut siguiente_id, String::from("b"));
        assert_eq!(id1, 1);
        assert_eq!(id2, 2);
        assert_eq!(tareas.len(), 2);
    }

    #[test]
    fn completar_marca_la_tarea() {
        let mut tareas = Vec::new();
        let mut siguiente_id = 1;
        agregar_tarea(&mut tareas, &mut siguiente_id, String::from("a"));
        assert!(completar_tarea(&mut tareas, 1));
        assert!(tareas[0].completada);
        assert!(!completar_tarea(&mut tareas, 99));
    }

    #[test]
    fn eliminar_quita_la_tarea() {
        let mut tareas = Vec::new();
        let mut siguiente_id = 1;
        agregar_tarea(&mut tareas, &mut siguiente_id, String::from("a"));
        agregar_tarea(&mut tareas, &mut siguiente_id, String::from("b"));
        assert!(eliminar_tarea(&mut tareas, 1));
        assert_eq!(tareas.len(), 1);
        assert_eq!(tareas[0].id, 2);
        assert!(!eliminar_tarea(&mut tareas, 99));
    }

    #[test]
    fn contar_pendientes_solo_cuenta_sin_completar() {
        let mut tareas = Vec::new();
        let mut siguiente_id = 1;
        agregar_tarea(&mut tareas, &mut siguiente_id, String::from("a"));
        agregar_tarea(&mut tareas, &mut siguiente_id, String::from("b"));
        agregar_tarea(&mut tareas, &mut siguiente_id, String::from("c"));
        completar_tarea(&mut tareas, 1);
        assert_eq!(contar_pendientes(&tareas), 2);
    }
}