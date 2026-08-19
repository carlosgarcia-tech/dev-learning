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
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn raiz_responde_200() {
        let respuesta = construir_respuesta("GET", "/");
        assert!(respuesta.starts_with("HTTP/1.1 200 OK"));
        assert!(respuesta.contains("Hola desde el servidor Rust"));
    }

    #[test]
    fn saludo_responde_200() {
        let respuesta = construir_respuesta("GET", "/saludo");
        assert!(respuesta.starts_with("HTTP/1.1 200 OK"));
        assert!(respuesta.contains("¡Saludos desde Rust!"));
    }

    #[test]
    fn ruta_desconocida_responde_404() {
        let respuesta = construir_respuesta("GET", "/otra");
        assert!(respuesta.starts_with("HTTP/1.1 404 NOT FOUND"));
        assert!(respuesta.contains("404 - No encontrado"));
    }

    #[test]
    fn content_length_coincide_con_el_cuerpo() {
        let respuesta = construir_respuesta("GET", "/");
        let cuerpo = "Hola desde el servidor Rust";
        assert!(respuesta.contains(&format!("Content-Length: {}", cuerpo.len())));
    }
}