# 05 — Errores y concurrencia

## Objetivos

- [ ] Manejar ausencia de valores con `Option<T>`.
- [ ] Manejar fallos recuperables con `Result<T, E>`.
- [ ] Propagar errores con el operador `?`.
- [ ] Usar `unwrap`, `expect`, `unwrap_or` y `match` para extraer valores.
- [ ] Lanzar *panics* con `panic!` y saber cuándo evitarlos.
- [ ] Crear hilos con `std::thread` y `move`.
- [ ] Comunicar hilos con canales `std::sync::mpsc`.

## Apuntes

### `Option<T>`

`Option<T>` representa un valor que puede existir (`Some(T)`) o no (`None`). Evita el `null` de otros lenguajes.

```rust
fn buscar_primera_vocal(s: &str) -> Option<char> {
    for c in s.chars() {
        if "aeiou".contains(c) {
            return Some(c);
        }
    }
    None
}

fn main() {
    match buscar_primera_vocal("hilo") {
        Some(c) => println!("Vocal: {}", c),
        None => println!("Sin vocales"),
    }
}
```

### `Result<T, E>`

`Result<T, E>` representa una operación que puede tener éxito (`Ok(T)`) o fallar (`Err(E)`). Es la base del manejo de errores en Rust.

```rust
fn dividir(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err(String::from("división entre cero"))
    } else {
        Ok(a / b)
    }
}
```

### Extraer valores

| Método | Comportamiento |
|---|---|
| `unwrap()` | Devuelve el valor o *panic* si es `None`/`Err`. |
| `expect("mensaje")` | Igual pero con mensaje propio. |
| `unwrap_or(default)` | Valor o un valor por defecto. |
| `unwrap_or_else(f)` | Valor o el resultado de un closure. |
| `ok()` | Convierte `Result` en `Option`. |

```rust
let r = dividir(10.0, 2.0).unwrap();            // 5.0
let r2 = dividir(10.0, 0.0).unwrap_or(0.0);     // 0.0
```

### Propagar con `?`

El operador `?` devuelve el valor de `Ok` o propaga el `Err` hacia arriba. Solo funciona en funciones que devuelven `Result` u `Option`.

```rust
use std::fs::File;
use std::io::{self, Read};

fn leer_archivo(ruta: &str) -> Result<String, io::Error> {
    let mut contenido = String::new();
    File::open(ruta)?.read_to_string(&mut contenido)?;
    Ok(contenido)
}

fn main() {
    match leer_archivo("datos.txt") {
        Ok(c) => println!("Contenido: {}", c),
        Err(e) => println!("No se pudo leer: {}", e),
    }
}
```

### Panics

`panic!` detiene el programa con un mensaje. Se usa para errores irreparables (bugs). Un slice fuera de rango o `unwrap()` sobre `None` también paniquea.

```rust
fn main() {
    // panic!("esto detiene el programa");
    let v = vec![1, 2, 3];
    println!("{:?}", v.get(10)); // None, sin panic
    // println!("{}", v[10]);     // panic: índice fuera de rango
}
```

Usa `.get(i)` en vez de `v[i]` cuando el índice pueda ser inválido.

### Hilos con `std::thread`

Cada hilo es una tarea independiente del sistema operativo. `thread::spawn` recibe un closure; con `move` movemos variables capturadas al hilo. `join()` espera a que el hilo termine.

```rust
use std::thread;
use std::time::Duration;

fn main() {
    let mut handles = Vec::new();

    for i in 0..5 {
        handles.push(thread::spawn(move || {
            thread::sleep(Duration::from_millis(50 * i));
            println!("Hilo {}", i);
        }));
    }

    for h in handles {
        h.join().unwrap();
    }
    println!("Todos terminaron");
}
```

### Canales (`mpsc`)

`mpsc::channel()` crea un canal: múltiples productores (`Sender`, clonable) y un consumidor (`Receiver`).

- `send(v)` envía un valor.
- `recv()` espera bloqueando hasta recibir.
- `try_recv()` intenta sin bloquear.
- Iterar sobre el `Receiver` procesa los mensajes hasta que se cierran todos los remitentes.

```rust
use std::sync::mpsc;
use std::thread;

fn main() {
    let (tx, rx) = mpsc::channel();
    let tx2 = tx.clone();

    thread::spawn(move || {
        for i in 1..=5 {
            tx.send(format!("productor 1: {}", i)).unwrap();
        }
    });

    thread::spawn(move || {
        for i in 1..=5 {
            tx2.send(format!("productor 2: {}", i)).unwrap();
        }
    });

    for mensaje in rx {
        println!("Recibido: {}", mensaje);
    }
}
```

El bucle termina cuando ambos productores se cierran (se liberan los `Sender`).

### Estado compartido: `Arc` y `Mutex`

Para compartir datos entre hilos se usa `Arc<T>` (referencia contada) y `Mutex<T>` (exclusión mutua).

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let contador = Arc::new(Mutex::new(0));
    let mut handles = Vec::new();

    for _ in 0..4 {
        let contador = Arc::clone(&contador);
        handles.push(thread::spawn(move || {
            for _ in 0..1000 {
                *contador.lock().unwrap() += 1;
            }
        }));
    }

    for h in handles {
        h.join().unwrap();
    }
    println!("Contador final: {}", *contador.lock().unwrap());
}
```

## Ejemplos de código

```rust
// Buscar un elemento con Option y propagar con ?
fn encontrar(nums: &[i32], objetivo: i32) -> Option<usize> {
    nums.iter().position(|&n| n == objetivo)
}

fn posicion_o_negativo(nums: &[i32], objetivo: i32) -> i32 {
    match encontrar(nums, objetivo) {
        Some(pos) => pos as i32,
        None => -1,
    }
}

fn main() {
    let datos = [10, 20, 30];
    println!("Posición de 20: {}", posicion_o_negativo(&datos, 20));
    println!("Posición de 99: {}", posicion_o_negativo(&datos, 99));
}
```

```rust
// Procesar trabajos con canales
use std::sync::mpsc;
use std::thread;

fn main() {
    let (tx, rx) = mpsc::channel();

    let hilo = thread::spawn(move || {
        let mut suma = 0;
        for n in rx {
            suma += n;
            if suma > 10 {
                break;
            }
        }
        suma
    });

    for n in [3, 4, 5, 1, 1] {
        tx.send(n).unwrap();
    }
    drop(tx);

    println!("Suma parcial: {}", hilo.join().unwrap());
}
```

## Ejercicios relacionados

- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/)

## Errores comunes

- **`unwrap()` sobre datos del usuario** → paniquea si la entrada no es válida. Prefiere `match`, `if let` o `unwrap_or`.
- **Olvidar que `recv()` bloquea** → si nadie envía, el hilo se queda esperando. Asegúrate de que los `Sender` se cierren.
- **Mover el `Sender` sin clonar** → si dos hilos deben enviar, clona con `tx.clone()` antes de mover al hilo.
- **Compartir datos sin `Arc`** → los hilos no pueden mover el mismo valor; usa `Arc::clone` para cada hilo.
- **Olvidar `move` en `thread::spawn`** → el closure debe moverse al hilo con `move || { ... }`.
- **`?` en `main`** → `main` no devuelve `Result` por defecto; usa `fn main() -> Result<(), Box<dyn Error>>` o maneja con `match`.
- **`lock()` devuelve un guard** → para acceder al valor usa `*contador.lock().unwrap()`.

## Recursos

- [The Rust Book — Error Handling](https://doc.rust-lang.org/book/ch09-00-error-handling.html)
- [The Rust Book — Concurrency](https://doc.rust-lang.org/book/ch16-00-concurrency.html)
- [std::sync::mpsc — documentación](https://doc.rust-lang.org/std/sync/mpsc/index.html)
- [std::thread — documentación](https://doc.rust-lang.org/std/thread/index.html)
- [Rust By Example — Error handling](https://doc.rust-lang.org/rust-by-example/error.html)