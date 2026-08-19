# 05 — Errores y concurrencia

Este capítulo combina los dos frentes donde Rust brilla: el manejo de errores **como valores** (sin excepciones ni `null`) y la concurrencia **segura por construcción** (el compilador impide carreras de datos). Ambos se apoyan en *ownership*, *borrowing* y *enums*, ya vistos en capítulos anteriores.

## Objetivos

- [ ] Representar la ausencia de valor con `Option<T>` (`Some` / `None`).
- [ ] Representar el éxito o el fallo con `Result<T, E>` (`Ok` / `Err`).
- [ ] Combinar `Option` y `Result` con `map`, `and_then`, `unwrap_or`, `unwrap_or_else`, `map_err`, `ok_or` y `unwrap_or_default`.
- [ ] Extraer valores con `match`, `if let` y los distintos `unwrap*`.
- [ ] Propagar errores hacia arriba con el operador `?`.
- [ ] Definir tipos de error propios (`enum` + `Display` + `std::error::Error`).
- [ ] Distinguir errores recuperables de *panics* y configurar su comportamiento (*unwinding* vs *abort*).
- [ ] Devolver `Result` desde la función `main`.
- [ ] Crear hilos con `std::thread::spawn` y `move` closures.
- [ ] Esperar a los hilos con `join()` y recolectar sus valores de retorno.
- [ ] Compartir estado entre hilos con `Arc<T>` y `Mutex<T>` (patrón `Arc<Mutex<T>>`).
- [ ] Comunicar hilos con canales `mpsc` (`Sender`, `Receiver`, `try_recv`, `recv_timeout`).
- [ ] Conocer las primitivas de sincronización `Barrier` y `Condvar`.
- [ ] Reconocer los patrones de concurrencia más habituales y cuándo elegir cada uno.

## Apuntes

### `Option<T>`

`Option<T>` es un *enum* genérico que representa un valor que **puede o no existir**: `Some(T)` o `None`. Es la alternativa de Rust al `null` de otros lenguajes. La ausencia de valor está **tipada**: no puedes usar un `Option<i32>` donde se espera un `i32` sin extraerlo antes, así que el compilador te obliga a contemplar el caso vacío.

#### Uso habitual

Se usa cuando una función puede no tener resultado: buscar un elemento, parsear un número, consultar un índice, etc.

```rust
fn primera_vocal(s: &str) -> Option<char> {
    for c in s.chars() {
        if "aeiouAEIOU".contains(c) {
            return Some(c);
        }
    }
    None // no hay vocales → ausencia de valor
}

fn main() {
    match primera_vocal("hilo") {
        Some(c) => println!("Primera vocal: {}", c),
        None => println!("No había vocales"),
    }
}
```

| Expresión | Resultado |
|---|---|
| `[1, 2, 3].get(0)` | `Some(&1)` |
| `[1, 2, 3].get(9)` | `None` |

> `Vec::get(i)` devuelve `Option<&T>` y **nunca paniquea**; `v[i]` paniquea si el índice está fuera de rango. Prefiere `.get()` cuando el índice pueda ser inválido.

#### Combinadores: map, and_then, unwrap_or, unwrap_or_else

En vez de anidar `match` a mano, `Option<T>` ofrece métodos que *combinan* opciones.

```rust
fn main() {
    let a: Option<i32> = Some(10);
    let b: Option<i32> = None;

    println!("{:?}", a.map(|n| n * 2));   // Some(20)
    println!("{:?}", b.map(|n| n * 2));   // None

    // and_then: como map, pero el closure devuelve OTRA Option
    println!("{:?}", a.and_then(|n| if n > 5 { Some(n - 5) } else { None })); // Some(5)
    println!("{:?}", b.and_then(|n| if n > 5 { Some(n - 5) } else { None })); // None

    println!("{}", a.unwrap_or(0));          // 10
    println!("{}", b.unwrap_or(0));          // 0
    println!("{}", b.unwrap_or_else(|| 99)); // 99
}
```

| Combinador | Recibe | Devuelve | Comportamiento |
|---|---|---|---|
| `map(f)` | `f: FnOnce(T) -> U` | `Option<U>` | aplica `f` al interior |
| `and_then(f)` | `f: FnOnce(T) -> Option<U>` | `Option<U>` | aplica `f` y "aplana" |
| `unwrap_or(d)` | `d: T` | `T` | valor o default **ya calculado** |
| `unwrap_or_else(f)` | `f: FnOnce() -> T` | `T` | valor o resultado del closure (**perezoso**) |
| `unwrap()` / `expect(m)` | — | `T` | valor o **panic** (con mensaje en `expect`) |
| `is_some()` / `is_none()` | — | `bool` | consulta sin extraer |
| `ok_or(e)` | `e: E` | `Result<T, E>` | convierte `None` en `Err(e)` |

#### if let / match

`match` es exhaustivo: exige cubrir `Some` y `None`. `if let` es azúcar para cuando solo te interesa **un** caso.

```rust
fn main() {
    let nombre: Option<&str> = Some("rust");

    if let Some(n) = nombre {
        println!("Hola, {}", n);
    } else {
        println!("Sin nombre");
    }

    match nombre {
        Some(n) if n.len() > 3 => println!("'{}' es un nombre largo", n),
        Some(n) => println!("'{}' es un nombre corto", n),
        None => println!("Sin nombre"),
    }
}
```

### `Result<T, E>`

`Result<T, E>` representa una operación que puede **tener éxito** (`Ok(T)`) o **fallar** (`Err(E)`). Es la base del manejo de errores en Rust. A diferencia de las excepciones, el error es un **valor** más: se puede devolver, pasar por parámetro o transformar. No existe `catch` ni `throw`; el flujo de error es explícito.

#### Ok y Err

```rust
fn dividir(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err(String::from("división entre cero"))
    } else {
        Ok(a / b)
    }
}

fn main() {
    match dividir(10.0, 2.0) {
        Ok(c) => println!("10 / 2 = {}", c),
        Err(e) => println!("Error: {}", e),
    }
    match dividir(10.0, 0.0) {
        Ok(c) => println!("10 / 0 = {}", c),
        Err(e) => println!("Error: {}", e),
    }
}
```

#### El operador `?`

El operador `?` **extrae** el valor de `Ok` o **propaga** el `Err` a la función que lo llama. Es la forma idiomática de "no me encargo de este error, que lo gestione quien me llame".

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

Reglas de `?`: solo puede usarse en funciones que devuelvan `Result` u `Option`; el `Err` propagado debe ser **convertible** al tipo de error de la función (vía `From`); y es azúcar sintáctico, equivalente a `match expr { Ok(v) => v, Err(e) => return Err(From::from(e)) }`.

> `?` también funciona con `Option`: si el valor es `None`, la función devuelve `None` inmediatamente. Útil para encadenar búsquedas.

#### Combinadores: map_err, unwrap_or_default, ok_or

```rust
fn parsear_numero(s: &str) -> Result<i32, std::num::ParseIntError> {
    s.trim().parse()
}

fn main() {
    println!("{:?}", parsear_numero("42").map(|n| n * 2));                    // Ok(84)
    println!("{:?}", parsear_numero("abc").map_err(|e| format!("inválido: {}", e))); // Err("inválido: ...")

    println!("{}", parsear_numero("abc").unwrap_or_default());                // 0 (Default de i32)

    println!("{:?}", parsear_numero("42").ok());  // Some(42)
    println!("{:?}", parsear_numero("abc").ok()); // None
}
```

| Combinador | De → A | Comportamiento |
|---|---|---|
| `map(f)` | `Result<T, E>` → `Result<U, E>` | transforma el `Ok` |
| `map_err(f)` | `Result<T, E>` → `Result<T, F>` | transforma el `Err` (útil para errores propios) |
| `unwrap_or_default()` | `Result<T, E>` → `T` | `Ok(v)` o `T::default()` |
| `ok()` / `err()` | `Result<T, E>` → `Option<T>` / `Option<E>` | descarta el error / el valor |
| `ok_or(e)` / `ok_or_else(f)` | `Option<T>` → `Result<T, E>` | `None` → `Err(e)` (o `Err(f())`, perezoso) |

### Errores personalizados

Usar `String` o `io::Error` para todo vale en prototipos, pero en programas serios conviene un **tipo de error propio**: el compilador te obliga a cubrir todos los casos y puedes llevar contexto extra.

#### enum de errores con Display

```rust
use std::fmt;

#[derive(Debug)]
enum ErrorDeValidacion {
    CampoVacio,
    DemasiadoCorto { minimo: usize, actual: usize },
    FueraDeRango { valor: i32, minimo: i32, maximo: i32 },
}

// Display controla cómo se ve el error al imprimirlo con {}
impl fmt::Display for ErrorDeValidacion {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            ErrorDeValidacion::CampoVacio => write!(f, "el campo no puede estar vacío"),
            ErrorDeValidacion::DemasiadoCorto { minimo, actual } => {
                write!(f, "se requieren al menos {} caracteres, se recibieron {}", minimo, actual)
            }
            ErrorDeValidacion::FueraDeRango { valor, minimo, maximo } => {
                write!(f, "el valor {} debe estar entre {} y {}", valor, minimo, maximo)
            }
        }
    }
}

fn validar_usuario(nombre: &str, edad: i32) -> Result<(), ErrorDeValidacion> {
    if nombre.is_empty() {
        return Err(ErrorDeValidacion::CampoVacio);
    }
    if nombre.len() < 3 {
        return Err(ErrorDeValidacion::DemasiadoCorto {
            minimo: 3,
            actual: nombre.len(),
        });
    }
    if !(18..=99).contains(&edad) {
        return Err(ErrorDeValidacion::FueraDeRango { valor: edad, minimo: 18, maximo: 99 });
    }
    Ok(())
}

fn main() {
    for (nombre, edad) in [("", 20), ("ab", 20), ("ana", 15), ("ana", 30)] {
        match validar_usuario(nombre, edad) {
            Ok(()) => println!("'{}' con {} años es válido", nombre, edad),
            Err(e) => println!("'{}': {}", nombre, e),
        }
    }
}
```

#### Implementar std::error::Error

El trait `std::error::Error` solo exige `Debug` + `Display`, pero marca el tipo como "error estándar": podrá usarse en `Box<dyn Error>`, en `main -> Result<(), Box<dyn Error>>` y en librerías.

```rust
use std::fmt;

#[derive(Debug)]
enum ErrorDeConfig {
    Archivo(std::io::Error),
    SinContenido,
}

impl fmt::Display for ErrorDeConfig {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            ErrorDeConfig::Archivo(e) => write!(f, "no se pudo leer la configuración: {}", e),
            ErrorDeConfig::SinContenido => write!(f, "la configuración está vacía"),
        }
    }
}

impl std::error::Error for ErrorDeConfig {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            ErrorDeConfig::Archivo(e) => Some(e),
            _ => None,
        }
    }
}

impl From<std::io::Error> for ErrorDeConfig {
    fn from(e: std::io::Error) -> Self {
        ErrorDeConfig::Archivo(e)
    }
}

fn cargar_config(ruta: &str) -> Result<String, ErrorDeConfig> {
    // '?' usa From para convertir io::Error en ErrorDeConfig automáticamente
    let contenido = std::fs::read_to_string(ruta)?;
    if contenido.is_empty() {
        return Err(ErrorDeConfig::SinContenido);
    }
    Ok(contenido)
}

fn main() {
    match cargar_config("config.toml") {
        Ok(c) => println!("Configuración: {}", c),
        Err(e) => eprintln!("Error: {}", e),
    }
}
```

> `From<io::Error>` + `?` = conversión automática de errores: el `?` de `read_to_string` "suba" como `ErrorDeConfig::Archivo` en lugar de como `io::Error`.

#### thiserror y anyhow (mención)

Para proyectos reales existen dos *crates* que generan este andamiaje automáticamente. **No son de la std** (hay que añadirlos al `Cargo.toml`), pero conviene conocerlos:

| Crate | Filosofía | Uso típico |
|---|---|---|
| `thiserror` | Deriva `Display`, `Error` y `From` de un `enum` declarativo | **Librerías**: tipo de error concreto y documentado |
| `anyhow` | Error dinámico con mensajes ricos (`context`) | **Binarios**: solo quieres `?` sin fricción |

> Regla práctica: **`thiserror` para código que otros consumirán (librerías), `anyhow` para el código que solo tú ejecutas (binarios).**

### `panic!` y `expect`

`panic!` detiene la ejecución con un mensaje. Representa un error **irrecuperable**: el estado del programa ya no es fiable (un bug, un invariante roto).

```rust
fn main() {
    // panic!("esto detiene el programa inmediatamente");

    let v = vec![1, 2, 3];
    println!("{:?}", v.get(10)); // None: acceso seguro, sin panic
    // println!("{}", v[10]);      // PANIC: índice fuera de rango
}
```

#### Cuándo usarlos

| Método | Si falla… |
|---|---|
| `unwrap()` | `panic!` genérico |
| `expect("contexto")` | `panic!` con tu mensaje + el error interno |
| `unwrap_or` / `unwrap_or_else` | valor por defecto |
| `match` / `if let` / `?` | flujo controlado |

Regla de oro: `expect` es mejor que `unwrap` porque documenta la **suposición** en el mensaje. Si puedes recuperarte, no paniquees: devuelve `Err`.

#### Unwinding y abort

Por defecto, un `panic!` **desenrolla la pila** (*unwinding*): ejecuta los destructores (`Drop`) de las variables en el camino y termina el hilo actual. Si ocurre en el hilo principal, termina el proceso.

```toml
[profile.release]
panic = "abort"   # en release: abortar sin desenrollar (binario más pequeño y rápido)
```

| Estrategia | Ventajas | Inconvenientes |
|---|---|---|
| `unwind` (default) | ejecuta destructores; el hilo puede morir solo; permite `catch_unwind` | binarios algo mayores |
| `abort` | binarios más pequeños y rápidos | sin destructores; un `panic` en un hilo **mata todo el proceso** |

### Result en funciones main

Desde Rust 1.26, `main` puede devolver un `Result`. Si devuelve `Err`, el runtime imprime el error y termina con código de salida distinto de cero. `Box<dyn Error>` es el "error comodín": cualquier tipo que implemente `std::error::Error` cabe, y `?` convierte con `From`.

```rust
use std::error::Error;
use std::fs::File;
use std::io::Read;

fn leer_numero(ruta: &str) -> Result<i32, Box<dyn Error>> {
    let mut contenido = String::new();
    File::open(ruta)?.read_to_string(&mut contenido)?;
    let n: i32 = contenido.trim().parse()?;
    Ok(n)
}

fn main() -> Result<(), Box<dyn Error>> {
    let n = leer_numero("numero.txt")?;
    println!("El número leído es {}", n);
    Ok(())
}
```

### Threads

Un **hilo** es una línea de ejecución independiente que comparte la memoria del proceso.

#### thread::spawn

`thread::spawn` recibe un closure y lo ejecuta en un hilo nuevo:

```rust
use std::thread;
use std::time::Duration;

fn main() {
    let manejador = thread::spawn(|| {
        for i in 1..=5 {
            println!("Hilo: mensaje {}", i);
            thread::sleep(Duration::from_millis(20));
        }
    });

    for i in 1..=3 {
        println!("Principal: paso {}", i);
        thread::sleep(Duration::from_millis(10));
    }

    manejador.join().unwrap();
    println!("Hilo terminado, programa completo");
}
```

El orden de impresión entre el hilo y el principal es **indeterminado** (depende del planificador del sistema operativo).

#### join

`thread::spawn` devuelve un `JoinHandle<T>`. `join()` **bloquea** hasta que el hilo termina y devuelve `Result<T, Box<dyn Any>>`: `Ok(v)` es el valor que devolvió el closure; `Err` si el hilo paniqueó.

```rust
use std::thread;

fn main() {
    let h1 = thread::spawn(|| 10 * 2);
    let h2 = thread::spawn(|| {
        let mut suma = 0;
        for n in 1..=100 {
            suma += n;
        }
        suma
    });

    let r1 = h1.join().unwrap(); // Ok(20)
    let r2 = h2.join().unwrap(); // Ok(5050)
    println!("Resultados: {} y {}", r1, r2);
}
```

> Si **no** llamas a `join()`, no hay garantía de que el hilo termine antes de que acabe `main`: al salir, los hilos en marcha se abandonan. `join()` además propaga cualquier *panic* del hilo.

#### move closures en hilos

Para usar datos capturados, el closure debe **moverse** al hilo con `move`. Sin `move`, el closure intentaría *tomar prestado*, y el compilador no puede garantizar que el hilo no viva más que el borrow.

```rust
use std::thread;

fn main() {
    let mut manejadores = Vec::new();

    for i in 0..5 {
        manejadores.push(thread::spawn(move || {
            println!("Hilo número {}", i);
            i * i
        }));
    }

    for h in manejadores {
        println!("Resultado del hilo: {}", h.join().unwrap());
    }
}
```

Sin `move` esto **no compila**:

```rust
// ESTE CÓDIGO NO COMPILA — E0382: use of moved value
//
// fn main() {
//     let nombre = String::from("rust");
//     let h = thread::spawn(move || {
//         println!("{}", nombre); // nombre se mueve al hilo
//     });
//     println!("{}", nombre); // E0382: borrow of moved value `nombre`
//     h.join().unwrap();
// }
```

Al mover `nombre` al hilo, ya no puedes usarlo en el hilo principal. La solución es `Arc` (abajo) o no usarlo después.

### Compartición de datos entre hilos

Los datos compartidos entre hilos deben cumplir **`Send`** (mover a otro hilo) y **`Sync`** (compartir por referencia). El compilador verifica estas propiedades: *es imposible* escribir una carrera de datos accidental en Rust estable.

| Tipo | `Send` | `Sync` | Motivo |
|---|---|---|---|
| `i32`, `String`, `Vec<T>` (`T: Send`) | sí | sí | sin punteros internos compartidos |
| `Rc<T>` | **no** | **no** | conteo de referencias no atómico |
| `Arc<T>` | sí | `T: Sync` | conteo de referencias **atómico** |
| `Mutex<T>` | `T: Send` | `T: Send` | exclusión mutua interna |

#### Arc<T> (conteo de referencias atómico)

`Rc<T>` permite varios dueños dentro de **un hilo**; `Arc<T>` (A de *atómico*) hace lo mismo **entre hilos**. `Arc::clone` incrementa el contador atómico sin copiar los datos.

```rust
use std::sync::Arc;
use std::thread;

fn main() {
    let datos = Arc::new(vec![1, 2, 3, 4, 5]);
    let mut manejadores = Vec::new();

    for _ in 0..3 {
        let datos = Arc::clone(&datos); // cada hilo recibe su propia "clave"
        manejadores.push(thread::spawn(move || {
            let suma: i32 = datos.iter().sum();
            println!("Suma desde un hilo: {}", suma);
        }));
    }

    for h in manejadores {
        h.join().unwrap();
    }
}
```

> `Arc` solo da **lectura** compartida. Para modificar el valor compartido necesitas un `Mutex` dentro del `Arc`. Mover un `Rc` a un hilo es **E0277** (no es `Send`).

#### Mutex<T>

`Mutex<T>` protege un valor con **exclusión mutua**: solo un hilo accede a la vez. `lock()` devuelve un `MutexGuard<T>` (un *smart pointer*); al salir del ámbito, la guardia se libera sola, y `*guardia` da acceso al interior gracias a `Deref`/`DerefMut`.

- `lock()` devuelve `Result` por el **envenenamiento**: si un hilo paniquea sosteniendo la guardia, el mutex queda marcado y los `lock()` siguientes devuelven `Err(PoisonError)`. `unwrap()` es lo habitual.
- Mientras la guardia existe, **ningún otro hilo toca el valor**. Mantén el ámbito corto para no bloquear a los demás.

#### Arc<Mutex<T>> como patrón

`Arc<Mutex<T>>` = *todos tienen acceso al mismo valor (Arc), pero solo uno a la vez (Mutex)*. Es el contador compartido clásico: cuatro hilos incrementan un contador común 1000 veces cada uno y el resultado es siempre 4000 (programa completo en el **ejemplo 2**). Sin el `Mutex` habría carrera de datos; y con `Arc<i32>` el compilador no te dejaría modificarlo por referencia.

### Channels

Los canales de `std::sync::mpsc` (múltiples **productores**, único **consumidor**) pasan **mensajes** entre hilos.

#### mpsc::channel

```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        for i in 1..=5 {
            tx.send(format!("mensaje {}", i)).unwrap();
            thread::sleep(Duration::from_millis(30));
        }
    });

    for recibido in rx {
        println!("Recibido: {}", recibido);
    }
    println!("Canal cerrado: todos los emisores terminaron");
}
```

El bucle `for recibido in rx` itera **hasta que se cierran todos los `Sender`**. Cuando el hilo termina, su `Sender` se suelta, el canal se cierra y el bucle acaba.

#### Sender y Receiver

`mpsc::channel()` devuelve `(Sender<T>, Receiver<T>)`. El `Sender` se puede **clonar** (más productores); el `Receiver` **no**.

| Método | Bloquea | Comportamiento |
|---|---|---|
| `send(v)` | si el buffer está lleno | `Result<(), SendError<T>>` (`Err` si el receptor se soltó) |
| `recv()` | **sí** | espera hasta recibir; `Err` si el canal se cierra |
| `try_recv()` | **no** | `Ok(v)`, `Err(Empty)` o `Err(Disconnected)` |
| `recv_timeout(t)` | hasta `t` | igual que `recv` con límite; `Err(Timeout)` si no llega nada |

#### try_recv y recv_timeout

Para no bloquear indefinidamente: encuestas con `try_recv` o esperas con límite.

```rust
use std::sync::mpsc;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel();

    println!("{:?}", rx.try_recv()); // Err(Empty): aún no hay nada

    tx.send(7).unwrap();
    println!("{:?}", rx.try_recv()); // Ok(7)
    println!("{:?}", rx.try_recv()); // Err(Empty): ya se consumió

    tx.send(10).unwrap();
    match rx.recv_timeout(Duration::from_millis(100)) {
        Ok(v) => println!("Recibido dentro del plazo: {}", v),
        Err(e) => println!("Sin mensaje a tiempo: {:?}", e),
    }
}
```

#### Múltiples productores (tx clone)

Cada productor necesita su copia del `Sender`, clonada **antes** de moverla al hilo: `let tx_a = tx.clone();` por cada hilo extra, y los mensajes se agregan en el único `Receiver` (programa completo en el **ejemplo 3**). Cuando todos los `Sender` se sueltan, el canal se cierra y `recv()`/el bucle termina.

> Si te quedas con una copia del `Sender` sin soltar, el `Receiver` nunca verá el canal cerrado y `recv()` se quedará esperando.

### Sincronización avanzada (mención)

`Arc<Mutex>` y los canales cubren la mayoría de casos. Para escenarios más finos, la std ofrece más primitivas.

#### Barrier, Condvar

**`Barrier`**: un grupo de hilos se **encuentran** en un punto antes de continuar todos juntos (fases de cómputo paralelo).

```rust
use std::sync::{Arc, Barrier};
use std::thread;

fn main() {
    let barrera = Arc::new(Barrier::new(3));
    let mut manejadores = Vec::new();

    for i in 0..3 {
        let barrera = Arc::clone(&barrera);
        manejadores.push(thread::spawn(move || {
            println!("Hilo {} llegó a la barrera", i);
            barrera.wait(); // bloquea hasta que los 3 estén aquí
            println!("Hilo {} continuó después de la barrera", i);
        }));
    }

    for h in manejadores {
        h.join().unwrap();
    }
}
```

**`Condvar`** (variable de condición): un hilo **espera** a que se cumpla una condición sin quemar CPU. Siempre se usa con un `Mutex`.

```rust
use std::sync::{Arc, Condvar, Mutex};
use std::thread;
use std::time::Duration;

fn main() {
    let par = Arc::new((Mutex::new(false), Condvar::new()));
    let par_hilo = Arc::clone(&par);

    thread::spawn(move || {
        let (bloqueo, cvar) = &*par_hilo;
        thread::sleep(Duration::from_millis(100));
        let mut listo = bloqueo.lock().unwrap();
        *listo = true;
        cvar.notify_one(); // avisa al hilo que espera
    });

    let (bloqueo, cvar) = &*par;
    let mut listo = bloqueo.lock().unwrap();
    while !*listo { // patrón habitual: while (no if) contra despertados espurios
        listo = cvar.wait(listo).unwrap();
    }
    println!("El hilo avisó que está listo");
}
```

| Primitiva | Problema que resuelve |
|---|---|
| `Barrier` | que un grupo espere a todos (estilo *fork-join* en medio del cómputo) |
| `Condvar` | esperar una condición sin *busy-wait* (reemplaza al `while (!cond){}` de C) |
| `RwLock<T>` | lecturas concurrentes + escritura exclusiva (`Mutex` optimizado para mucha lectura) |

### Patrones de concurrencia

| Patrón | Piezas | Cuándo usarlo |
|---|---|---|
| Contador / estado compartido | `Arc<Mutex<T>>` | varios hilos acumulan cambios sobre el mismo valor |
| Lectura compartida | `Arc<T>` (`T: Sync`) | todos leen, nadie escribe |
| Mensajes uno a uno | `mpsc::channel` | un productor → un consumidor |
| Mensajes muchos a uno | `tx.clone()` por hilo | trabajos repartidos que un solo hilo consume |
| Fases paralelas | `Barrier` | todos terminan una fase y arrancan la siguiente |
| Señal de condición | `Mutex` + `Condvar` | un hilo espera una condición que otro produce |

> Cuando los productores reparten trabajo y los consumidores devuelven resultados por otro canal, tienes un **pool de trabajadores** (*worker pool*), el patrón más común para paralelizar procesamiento (ver ejemplo 3).

## Ejemplos de código

### Ejemplo 1 — Validación con errores personalizados

`enum` de errores con `Display` y `Error`, usado por una función de validación y combinado con `?`.

```rust
use std::fmt;

#[derive(Debug)]
enum ErrorUsuario {
    NombreVacio,
    NombreCorto(usize),
    EmailSinArroba,
    EdadInvalida(i32),
}

impl fmt::Display for ErrorUsuario {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            ErrorUsuario::NombreVacio => write!(f, "el nombre no puede estar vacío"),
            ErrorUsuario::NombreCorto(n) => {
                write!(f, "el nombre debe tener al menos 3 caracteres (tiene {})", n)
            }
            ErrorUsuario::EmailSinArroba => write!(f, "el email debe contener '@'"),
            ErrorUsuario::EdadInvalida(e) => write!(f, "la edad {} no está entre 0 y 130", e),
        }
    }
}

impl std::error::Error for ErrorUsuario {}

fn validar_nombre(nombre: &str) -> Result<(), ErrorUsuario> {
    let n = nombre.trim().chars().count();
    if n == 0 {
        return Err(ErrorUsuario::NombreVacio);
    }
    if n < 3 {
        return Err(ErrorUsuario::NombreCorto(n));
    }
    Ok(())
}

fn validar_email(email: &str) -> Result<(), ErrorUsuario> {
    if !email.contains('@') {
        return Err(ErrorUsuario::EmailSinArroba);
    }
    Ok(())
}

fn validar_edad(edad: i32) -> Result<(), ErrorUsuario> {
    if !(0..=130).contains(&edad) {
        return Err(ErrorUsuario::EdadInvalida(edad));
    }
    Ok(())
}

fn validar_registro(nombre: &str, email: &str, edad: i32) -> Result<(), ErrorUsuario> {
    validar_nombre(nombre)?;
    validar_email(email)?;
    validar_edad(edad)?;
    Ok(())
}

fn main() {
    let registros = [
        ("", "ana@correo.com", 25),
        ("Al", "ana@correo.com", 25),
        ("Ana", "anacorreo.com", 25),
        ("Ana", "ana@correo.com", 300),
        ("Ana", "ana@correo.com", 25),
    ];
    for (nombre, email, edad) in registros {
        match validar_registro(nombre, email, edad) {
            Ok(()) => println!("Registro válido: {} <{}>", nombre, email),
            Err(e) => println!("Rechazado '{}': {}", nombre, e),
        }
    }
}
```

### Ejemplo 2 — Contador compartido con `Arc<Mutex<T>>`

Cuatro hilos incrementan un contador común 1000 veces cada uno. El resultado es siempre 4000.

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let contador = Arc::new(Mutex::new(0u64));
    let mut manejadores = Vec::new();

    for id in 0..4 {
        let contador = Arc::clone(&contador);
        manejadores.push(thread::spawn(move || {
            for _ in 0..1000 {
                let mut guardia = contador.lock().unwrap();
                *guardia += 1;
            }
            println!("Hilo {} terminó", id);
        }));
    }

    for h in manejadores {
        h.join().unwrap();
    }

    println!("Contador final: {}", *contador.lock().unwrap());
}
```

### Ejemplo 3 — Canal con varios productores (*worker pool*)

Varios hilos productores envían resultados a un único consumidor que los agrega.

```rust
use std::sync::mpsc;
use std::thread;

fn cuadrado(n: u64) -> u64 {
    thread::sleep(std::time::Duration::from_millis(n * 5));
    n * n
}

fn main() {
    let (tx, rx) = mpsc::channel();
    let trabajos: Vec<u64> = (1..=10).collect();

    let mut manejadores = Vec::new();
    for trozo in trabajos.chunks(3) {
        let tx = tx.clone();
        let trabajos = trozo.to_vec();
        manejadores.push(thread::spawn(move || {
            for n in trabajos {
                let resultado = cuadrado(n);
                tx.send((n, resultado)).unwrap();
            }
        }));
    }
    drop(tx); // sin esto, el receptor esperaría para siempre

    let mut suma_total = 0u64;
    for (n, resultado) in rx {
        println!("{}^2 = {}", n, resultado);
        suma_total += resultado;
    }

    for h in manejadores {
        h.join().unwrap();
    }
    println!("Suma de cuadrados del 1 al 10: {}", suma_total);
}
```

## Ejercicios relacionados

- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)
- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/)

## Errores comunes

| # | Error | Mensaje | Explicación y solución |
|---|---|---|---|
| 1 | **`unwrap()` sobre datos del usuario** | *runtime:* `thread 'main' panicked at ...` | Paniquea si la entrada no es válida. Prefiere `match`, `if let`, `unwrap_or` o `?`. |
| 2 | **`E0277` — `Rc` no es `Send`** | `` `Rc<i32>` cannot be sent between threads safely; the trait `Send` is not implemented for `Rc<i32>` `` | Mover un `Rc` a `thread::spawn` falla porque el conteo no es atómico. Usa `Arc::clone`. |
| 3 | **`E0382` — usar un valor movido** | `` use of moved value: `nombre` `` | Tras `move` hacia un hilo, el dato ya no está en el hilo principal. No lo uses después (o usa `Arc`). |
| 4 | **`E0502` — préstamo mutable con inmutable activo** | `` cannot borrow `v` as mutable because it is also borrowed as immutable `` | `let r = &v[0]; v.push(4);` es inválido. Reordena la mutación o copia el valor. |
| 5 | **`E0596` — mutar a través de `&`** | `` cannot borrow `*x` as mutable, as it is behind a `&` reference `` | Llamar a un método que pide `&mut self` (o hacer `&mut *x`) a través de un `&` falla. Usa `&mut` desde el origen o cambia el diseño. |
| 6 | **`E0621` — faltan vidas explícitas** | `` explicit lifetime required in the type of `y` `` | `fn foo<'a>(x: &'a i32, y: &i32) -> &'a i32` que devuelve `y` falla: `y` no tiene la vida `'a`. Anota `y: &'a i32` o no devuelvas `y`. |
| 7 | **`E0308` — tipos incompatibles** | `` mismatched types; expected `i32`, found `&str` `` | `let x: i32 = "hola";` no compila. Convierte con `parse()` (devuelve `Result`) o cambia el tipo. |
| 8 | **`E0271` — `Item` del iterador equivocado** | `` expected `IntoIter<i32>` to be an iterator that yields `u32`, but it yields `i32` `` | Pasar un iterador de `i32` donde se espera `Iterator<Item = u32>` falla. Alinea los tipos con `as` o `parse`. |
| 9 | **`?` en `main` sin `Result`** | `` the `?` operator can only be used in a function that returns `Result` or `Option` `` | Cambia la firma: `fn main() -> Result<(), Box<dyn Error>>`, o gestiona el error con `match`. |
| 10 | **Olvidar el `*` de la guardia** | *compile:* `expected integer, found MutexGuard<...>` / *runtime:* bloqueo | Accede con `*contador.lock().unwrap()` y suelta la guardia pronto. |
| 11 | **`recv()` que bloquea para siempre** | *runtime:* el programa se queda colgado | Si un `Sender` sobrevive, el canal nunca se cierra. Haz `drop(tx)` al terminar de enviar. |
| 12 | **Dos hilos comparten el `Sender` sin clonar** | `E0382` (moved value) | Cada productor necesita su copia: clona con `tx.clone()` **antes** de mover al hilo. |
| 13 | **Olvidar `move` en `thread::spawn`** | `E0373` (*closure may outlive the current function*) | El closure sin `move` intenta *tomar prestado*; los hilos requieren propiedad. Usa `move || { ... }`. |

## Recursos

- [The Rust Book — Capítulo 9: Error Handling](https://doc.rust-lang.org/book/ch09-00-error-handling.html)
- [The Rust Book — Capítulo 16: Fearless Concurrency](https://doc.rust-lang.org/book/ch16-00-concurrency.html)
- [std::option::Option — documentación](https://doc.rust-lang.org/std/option/enum.Option.html)
- [std::result::Result — documentación](https://doc.rust-lang.org/std/result/enum.Result.html)
- [std::error::Error — documentación](https://doc.rust-lang.org/std/error/trait.Error.html)
- [std::thread — documentación](https://doc.rust-lang.org/std/thread/index.html)
- [std::sync — documentación (Arc, Mutex, Barrier, Condvar)](https://doc.rust-lang.org/std/sync/index.html)
- [std::sync::mpsc — documentación](https://doc.rust-lang.org/std/sync/mpsc/index.html)
- [Rust By Example — Error handling](https://doc.rust-lang.org/rust-by-example/error.html)
- [Rust By Example — Concurrency](https://doc.rust-lang.org/rust-by-example/std_misc/threads.html)