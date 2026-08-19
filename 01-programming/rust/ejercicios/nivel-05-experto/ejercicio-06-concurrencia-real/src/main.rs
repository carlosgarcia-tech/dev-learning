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
        let (enviador, rx) = mpsc::channel::<Trabajo>();
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

fn sumar_hasta(n: u64) -> u64 {
    (0..=n).sum()
}

fn main() {
    let pool = Pool::nuevo(4);

    for i in 0..20 {
        pool.ejecutar(move || {
            let inicio = std::time::Instant::now();
            let suma = sumar_hasta(99_999);
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
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sumar_hasta_es_correcta() {
        assert_eq!(sumar_hasta(0), 0);
        assert_eq!(sumar_hasta(5), 15);
        assert_eq!(sumar_hasta(100_000), 5_000_050_000);
    }

    #[test]
    fn pool_ejecuta_todas_las_tareas() {
        let pool = Pool::nuevo(4);
        let total = Arc::new(Mutex::new(0u64));

        for i in 0..10 {
            let total = Arc::clone(&total);
            pool.ejecutar(move || {
                let mut t = total.lock().unwrap();
                *t += i as u64;
            });
        }

        pool.esperar();
        assert_eq!(*total.lock().unwrap(), 45);
    }

    #[test]
    fn pool_con_un_solo_trabajador_funciona() {
        let pool = Pool::nuevo(1);
        pool.ejecutar(|| {});
        pool.esperar();
    }
}