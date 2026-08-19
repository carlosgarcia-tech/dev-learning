//! Sistema de Gestión de Biblioteca — interfaz de consola.

use std::io::{self, BufRead, Write};

use proyectofinal::datos::Repositorio;
use proyectofinal::modelos::{GeneroLibro, Libro, Miembro, Prestamo};
use proyectofinal::servicios::{BibliotecaService, ReportesService};

fn leer_linea<R: BufRead>(entrada: &mut R) -> String {
    let mut linea = String::new();
    entrada
        .read_line(&mut linea)
        .expect("error al leer de la consola");
    linea.trim().to_string()
}

fn main() {
    let mut servicio = BibliotecaService::nuevo(
        Repositorio::<Libro>::nuevo(),
        Repositorio::<Miembro>::nuevo(),
        Repositorio::<Prestamo>::nuevo(),
    );

    let mut entrada = io::BufReader::new(io::stdin());

    loop {
        println!("\n=== Sistema de Gestión de Biblioteca ===");
        println!("1. Dar de alta un libro");
        println!("2. Buscar libros");
        println!("3. Dar de alta un miembro");
        println!("4. Crear préstamo");
        println!("5. Devolver préstamo");
        println!("6. Préstamos vencidos");
        println!("7. Resumen");
        println!("0. Salir");
        print!("Opción: ");
        io::stdout().flush().expect("error al mostrar el menú");

        let opcion = leer_linea(&mut entrada);

        match opcion.as_str() {
            "1" => {
                print!("Título: ");
                io::stdout().flush().unwrap();
                let titulo = leer_linea(&mut entrada);
                print!("Autor: ");
                io::stdout().flush().unwrap();
                let autor = leer_linea(&mut entrada);
                print!("ISBN: ");
                io::stdout().flush().unwrap();
                let isbn = leer_linea(&mut entrada);
                print!("Año: ");
                io::stdout().flush().unwrap();
                let anio: u32 = leer_linea(&mut entrada).parse().unwrap_or(0);
                print!("Género (ficcion/no_ficcion/ciencia/tecnologia/historia/otro): ");
                io::stdout().flush().unwrap();
                let genero = match leer_linea(&mut entrada).as_str() {
                    "ficcion" => GeneroLibro::Ficcion,
                    "no_ficcion" => GeneroLibro::NoFiccion,
                    "ciencia" => GeneroLibro::Ciencia,
                    "tecnologia" => GeneroLibro::Tecnologia,
                    "historia" => GeneroLibro::Historia,
                    _ => GeneroLibro::Otro,
                };
                match servicio.alta_libro(&titulo, &autor, &isbn, anio, genero) {
                    Ok(libro) => println!("Libro dado de alta con ID {}", libro.id),
                    Err(e) => println!("Error: {e}"),
                }
            }
            "2" => {
                print!("Texto a buscar: ");
                io::stdout().flush().unwrap();
                let texto = leer_linea(&mut entrada);
                let resultados = servicio.buscar_libros(&texto);
                if resultados.is_empty() {
                    println!("Sin resultados.");
                }
                for libro in resultados {
                    println!("[{}] {} — {}", libro.id, libro.titulo, libro.autor);
                }
            }
            "3" => {
                print!("Nombre: ");
                io::stdout().flush().unwrap();
                let nombre = leer_linea(&mut entrada);
                print!("Email: ");
                io::stdout().flush().unwrap();
                let email = leer_linea(&mut entrada);
                print!("Teléfono: ");
                io::stdout().flush().unwrap();
                let telefono = leer_linea(&mut entrada);
                match servicio.alta_miembro(&nombre, &email, &telefono) {
                    Ok(miembro) => println!("Miembro dado de alta con ID {}", miembro.id),
                    Err(e) => println!("Error: {e}"),
                }
            }
            "4" => {
                print!("ID del libro: ");
                io::stdout().flush().unwrap();
                let id_libro: u32 = leer_linea(&mut entrada).parse().unwrap_or(0);
                print!("ID del miembro: ");
                io::stdout().flush().unwrap();
                let id_miembro: u32 = leer_linea(&mut entrada).parse().unwrap_or(0);
                match servicio.crear_prestamo(id_libro, id_miembro) {
                    Ok(prestamo) => println!(
                        "Préstamo {} creado (devolución el {})",
                        prestamo.id, prestamo.fecha_devolucion
                    ),
                    Err(e) => println!("Error: {e}"),
                }
            }
            "5" => {
                print!("ID del préstamo: ");
                io::stdout().flush().unwrap();
                let id_prestamo: u32 = leer_linea(&mut entrada).parse().unwrap_or(0);
                match servicio.devolver_prestamo(id_prestamo) {
                    Ok(_) => println!("Préstamo devuelto."),
                    Err(e) => println!("Error: {e}"),
                }
            }
            "6" => {
                let vencidos = servicio.prestamos_vencidos();
                if vencidos.is_empty() {
                    println!("No hay préstamos vencidos.");
                }
                for p in vencidos {
                    println!(
                        "Préstamo {} (libro {}) vencido el {}",
                        p.id, p.id_libro, p.fecha_devolucion
                    );
                }
            }
            "7" => {
                let reportes = ReportesService::nuevo(&servicio);
                for (clave, valor) in reportes.resumen() {
                    println!("{clave}: {valor}");
                }
            }
            "0" => {
                println!("¡Hasta luego!");
                break;
            }
            _ => println!("Opción no válida."),
        }
    }
}