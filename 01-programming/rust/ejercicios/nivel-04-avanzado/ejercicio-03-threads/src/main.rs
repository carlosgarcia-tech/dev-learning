use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

fn lanzar_hilos(n: usize) -> Vec<thread::JoinHandle<()>> {
    let mut handles = Vec::new();

    for i in 0..n {
        handles.push(thread::spawn(move || {
            println!("Hilo {} empezando", i);
            thread::sleep(Duration::from_millis(50 * i as u64));
            println!("Hilo {} terminó", i);
        }));
    }

    handles
}

fn unir_hilos(handles: Vec<thread::JoinHandle<()>>) {
    for h in handles {
        h.join().unwrap();
    }
}

fn contar_concurrente(num_hilos: usize, incrementos: usize) -> i32 {
    let contador = Arc::new(Mutex::new(0));
    let mut handles = Vec::new();

    for _ in 0..num_hilos {
        let contador = Arc::clone(&contador);
        handles.push(thread::spawn(move || {
            for _ in 0..incrementos {
                let mut guard = contador.lock().unwrap();
                *guard += 1;
            }
        }));
    }

    for h in handles {
        h.join().unwrap();
    }

    let total = *contador.lock().unwrap();
    total
}

fn main() {
    let handles = lanzar_hilos(5);
    unir_hilos(handles);
    println!("Todos los hilos terminaron");

    let total = contar_concurrente(4, 1000);
    println!("Contador final: {}", total);
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn contar_concurrente_suma_todos_los_incrementos() {
        assert_eq!(contar_concurrente(4, 1000), 4000);
        assert_eq!(contar_concurrente(10, 100), 1000);
    }

    #[test]
    fn contar_concurrente_con_un_hilo() {
        assert_eq!(contar_concurrente(1, 500), 500);
    }

    #[test]
    fn lanzar_y_unir_hilos_funciona() {
        let handles = lanzar_hilos(3);
        unir_hilos(handles);
    }
}