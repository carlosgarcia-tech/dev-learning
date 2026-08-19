# Ejercicio 02 — Servidor TCP

- **Nivel:** 5/5
- **Tema:** `std::net::TcpListener`, `TcpStream`, protocolo HTTP mínimo
- **Tiempo estimado:** 45 min

## Enunciado

Crea un programa `servidor.rs` que sea un servidor TCP/HTTP mínimo con la biblioteca estándar:

1. Escuche en `127.0.0.1:7878` con `TcpListener::bind`.
2. Acepte conexiones con un `for stream in listener.incoming()`.
3. Lea la primera línea de la petición con un `BufReader`.
4. Analice método y ruta (`GET /`, `GET /saludo`, cualquier otra → 404).
5. Responda un HTTP con `HTTP/1.1 200 OK`, `Content-Length` correcto y el cuerpo.
6. Cierre la conexión con `flush`.

Prueba con un navegador (`http://127.0.0.1:7878/`) o con `curl http://127.0.0.1:7878/saludo`.

## Requisitos

- [ ] `TcpListener::bind("127.0.0.1:7878")` con `.expect`.
- [ ] Leer la petición con `BufReader::new(stream.try_clone().unwrap())`.
- [ ] El `match` distingue `GET /`, `GET /saludo` y el resto (404).
- [ ] La respuesta incluye `Content-Length` con la longitud del cuerpo en bytes.
- [ ] Ejecutarlo localmente con `cargo run` (o `rustc servidor.rs && ./servidor`) y probarlo con `curl` en otra terminal.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `use std::io::{BufRead, BufReader, Write}; use std::net::{TcpListener, TcpStream};`.
- `let mut primera_linea = String::new(); reader.read_line(&mut primera_linea)?` (o `.unwrap()`).
- La línea es del estilo `GET /saludo HTTP/1.1`.
- Respuesta: `"{}\r\nContent-Length: {}\r\nContent-Type: text/plain\r\n\r\n{}"`.
- `stream.write_all(...).unwrap(); stream.flush().unwrap();`.
- `for stream in listener.incoming()` acepta conexiones en bucle; usa `match stream { Ok(s) => ..., Err(e) => ... }`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````rust
use std::io::{BufRead, BufReader, Write};
use std::net::{TcpListener, TcpStream};

fn construir_respuesta(metodo: &str, ruta: &str) -> String {
    let (status, cuerpo) = match (metodo, ruta) {
        ("GET", "/") => ("HTTP/1.1 200 OK", "Hola desde el servidor Rust"),
        ("GET", "/saludo") => ("HTTP/1.1 200 OK", "¡Saludos desde Rust!"),
        _ => ("HTTP/1.1 404 NOT FOUND", "404 - No encontrado"),
    };

    format!(
        "{}\r\nContent-Length: {}\r\nContent-Type: text/plain\r\n\r\n{}",
        status,
        cuerpo.len(),
        cuerpo
    )
}

fn main() {
    let listener = TcpListener::bind("127.0.0.1:7878").expect("No se pudo abrir el puerto 7878");
    println!("Servidor escuchando en http://127.0.0.1:7878");

    for stream in listener.incoming() {
        match stream {
            Ok(stream) => manejar_conexion(stream),
            Err(e) => println!("Error de conexión: {}", e),
        }
    }
}

fn manejar_conexion(mut stream: TcpStream) {
    let mut reader = BufReader::new(stream.try_clone().unwrap());

    let mut primera_linea = String::new();
    if reader.read_line(&mut primera_linea).is_err() {
        return;
    }

    println!("Recibido: {}", primera_linea.trim());

    let mut partes = primera_linea.trim().split_whitespace();
    let metodo = partes.next().unwrap_or("");
    let ruta = partes.next().unwrap_or("");

    let respuesta = construir_respuesta(metodo, ruta);

    stream.write_all(respuesta.as_bytes()).unwrap();
    stream.flush().unwrap();
}
````

</details>