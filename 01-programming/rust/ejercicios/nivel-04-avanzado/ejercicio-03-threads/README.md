# Ejercicio 03 — Threads

- **Nivel:** 4/5
- **Tema:** `std::thread`, `move`, `join`, `Arc`, `Mutex`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un programa `threads.rs` que:

1. Lance 5 hilos, cada uno imprima su índice y duerma un tiempo proporcional (`50 * i` milisegundos).
2. Use `move` para capturar el índice en el closure.
3. Recoja los `JoinHandle` en un `Vec` y espere a todos con `join`.
4. Comparta un contador con `Arc<Mutex<i32>>` entre 4 hilos, incrementándolo 1000 veces cada uno.
5. Imprima el contador final (debe ser 4000).

Salida esperada (ejemplo):

```
Hilo 0 empezando
Hilo 1 empezando
...
Todos los hilos terminaron
Contador final: 4000
```

## Requisitos

- [ ] Los 5 hilos usan `move` y se guardan en un `Vec<JoinHandle<_>>`.
- [ ] Todos los hilos se unen con `join().unwrap()`.
- [ ] El contador compartido usa `Arc<Mutex<i32>>` y `Arc::clone` por hilo.
- [ ] El valor final del contador es 4000.
- [ ] Ejecutarlo localmente con `rustc threads.rs && ./threads` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `thread::spawn(move || { ... })` mueve `i` al hilo.
- `h.join().unwrap()` espera al hilo.
- `Arc::new(Mutex::new(0))` crea el contador compartido.
- Dentro de cada hilo: `*contador.lock().unwrap() += 1;`.
- `thread::sleep(Duration::from_millis(...))` espera un tiempo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
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
````

</details>