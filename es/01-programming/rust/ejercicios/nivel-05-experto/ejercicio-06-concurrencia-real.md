# Ejercicio 06 — Concurrencia real: worker pool

- **Nivel:** 5/5
- **Tema:** `Arc<Mutex<Receiver>>`, `Box<dyn FnOnce() + Send>`, diseño concurrente
- **Tiempo estimado:** 60 min

## Enunciado

Crea un programa `worker_pool.rs` que implemente un **pool de trabajadores**:

1. `type Trabajo = Box<dyn FnOnce() + Send>`.
2. `struct Pool { enviador: mpsc::Sender<Trabajo>, trabajadores: Vec<thread::JoinHandle<()>> }`.
3. `Pool::nuevo(tamano: usize)`:
   - Crea el canal y envuelve el `Receiver` en `Arc<Mutex<_>>`.
   - Lanza `tamano` hilos que en un `loop` esperan un trabajo con `rx.lock().unwrap().recv()` y lo ejecutan; si el canal se cierra (`Err`), salen con `break`.
4. `Pool::ejecutar<F>(&self, f: F) where F: FnOnce() + Send + 'static` envía el trabajo `Box::new(f)`.
5. `Pool::esperar(self)` cierra el canal con `drop(self.enviador)` y hace `join` de todos los hilos.
6. En `main`: crea un pool de 4, envía 20 tareas que calculen sumas y cuenten tiempo, y al final llama `pool.esperar()`.

Salida esperada (ejemplo):

```
Trabajador 2 ejecutando tarea
Tarea 3 completada (suma = 4999950000, 1 ms)
...
Todas las tareas terminaron.
```

## Requisitos

- [ ] `Trabajo` es `Box<dyn FnOnce() + Send>`.
- [ ] El `Receiver` se comparte con `Arc<Mutex<_>>`.
- [ ] Los trabajadores terminan solos cuando se cierra el canal.
- [ ] `ejecutar` acepta cualquier closure `FnOnce + Send + 'static`.
- [ ] `esperar` une todos los hilos y el programa termina sin colgarse.
- [ ] Ejecutarlo localmente con `cargo run` (o `rustc worker_pool.rs && ./worker_pool`) y verificar que las 20 tareas se completan.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `use std::sync::mpsc; use std::sync::{Arc, Mutex}; use std::thread;`.
- El worker: `loop { let trabajo = rx.lock().unwrap().recv(); match trabajo { Ok(t) => t(), Err(_) => break } }`.
- `Arc::clone(&rx)` dentro del `for id in 0..tamano`.
- Para enviar: `self.enviador.send(Box::new(f)).unwrap();`.
- Cerrar el canal: al soltar el último `Sender` (`drop`), `recv()` devuelve `Err` y los hilos salen.
- Mide tiempo con `std::time::Instant`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
use std::sync::mpsc;
use std::sync::{Arc, Mutex};
use std::thread;

type Trabajo = Box<dyn FnOnce() + Send>;

struct Pool {
    enviador: mpsc::Sender<Trabajo>,
    trabajadores: Vec<thread::JoinHandle<()>>,
}

impl Pool {
    fn nuevo(tamano: usize) -> Pool {
        let (enviador, rx) = mpsc::channel();
        let rx = Arc::new(Mutex::new(rx));

        let mut trabajadores = Vec::new();
        for id in 0..tamano {
            let rx = Arc::clone(&rx);
            trabajadores.push(thread::spawn(move || loop {
                let trabajo = rx.lock().unwrap().recv();
                match trabajo {
                    Ok(t) => {
                        println!("Trabajador {} ejecutando tarea", id);
                        t();
                    }
                    Err(_) => break,
                }
            }));
        }

        Pool {
            enviador,
            trabajadores,
        }
    }

    fn ejecutar<F>(&self, f: F)
    where
        F: FnOnce() + Send + 'static,
    {
        self.enviador.send(Box::new(f)).unwrap();
    }

    fn esperar(self) {
        drop(self.enviador);
        for t in self.trabajadores {
            t.join().unwrap();
        }
    }
}

fn main() {
    let pool = Pool::nuevo(4);

    for i in 0..20 {
        pool.ejecutar(move || {
            let inicio = std::time::Instant::now();
            let mut suma = 0u64;
            for n in 0..100_000 {
                suma += n;
            }
            println!(
                "Tarea {} completada (suma = {}, {} ms)",
                i,
                suma,
                inicio.elapsed().as_millis()
            );
        });
    }

    pool.esperar();
    println!("Todas las tareas terminaron.");
}
````

</details>