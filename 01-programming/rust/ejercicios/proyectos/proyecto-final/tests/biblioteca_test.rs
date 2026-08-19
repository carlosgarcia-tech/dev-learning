//! Tests de referencia de la capa de servicios.
//!
//! Ejecuta con `cargo test` desde esta carpeta.

use proyectofinal::datos::Repositorio;
use proyectofinal::modelos::{GeneroLibro, Libro, Miembro, Prestamo};
use proyectofinal::servicios::{BibliotecaService, ErrorBiblioteca, ReportesService};

fn setup() -> BibliotecaService {
    BibliotecaService::nuevo(
        Repositorio::<Libro>::nuevo(),
        Repositorio::<Miembro>::nuevo(),
        Repositorio::<Prestamo>::nuevo(),
    )
}

#[test]
fn alta_libro() {
    let mut s = setup();
    let libro = s
        .alta_libro("El Quijote", "Miguel de Cervantes", "9788420412146", 1605, GeneroLibro::Ficcion)
        .expect("AltaLibro inesperado");
    assert_eq!(libro.titulo, "El Quijote");
    assert!(libro.disponible, "el libro debe crearse disponible");
}

#[test]
fn alta_libro_valida_datos() {
    let mut s = setup();
    let err_titulo = s.alta_libro("", "Autor", "1", 2020, GeneroLibro::Otro);
    assert_eq!(err_titulo, Err(ErrorBiblioteca::DatosInvalidos));
    let err_autor = s.alta_libro("Titulo", "", "1", 2020, GeneroLibro::Otro);
    assert_eq!(err_autor, Err(ErrorBiblioteca::DatosInvalidos));
}

#[test]
fn buscar_libros() {
    let mut s = setup();
    s.alta_libro("El Quijote", "Miguel de Cervantes", "1", 1605, GeneroLibro::Ficcion).unwrap();
    s.alta_libro("Cien años de soledad", "Gabriel García Márquez", "2", 1967, GeneroLibro::Ficcion).unwrap();
    s.alta_libro("Introducción a Rust", "Steve Klabnik", "3", 2015, GeneroLibro::Tecnologia).unwrap();

    let resultados = s.buscar_libros("quijote");
    assert_eq!(resultados.len(), 1);
    assert_eq!(resultados[0].titulo, "El Quijote");

    let resultados = s.buscar_libros("rust");
    assert_eq!(resultados.len(), 1);

    let sin_resultados = s.buscar_libros("inexistente");
    assert!(sin_resultados.is_empty(), "sin coincidencias debe ser Vec vacío");
}

#[test]
fn alta_miembro_y_email_duplicado() {
    let mut s = setup();
    let m = s
        .alta_miembro("Ana López", "ana@correo.com", "600111222")
        .expect("AltaMiembro inesperado");
    assert!(m.activo, "el miembro debe crearse activo");

    let duplicado = s.alta_miembro("Ana 2", "ana@correo.com", "600111223");
    assert_eq!(duplicado, Err(ErrorBiblioteca::EmailDuplicado));

    let invalido = s.alta_miembro("", "otro@correo.com", "600111224");
    assert_eq!(invalido, Err(ErrorBiblioteca::DatosInvalidos));
}

#[test]
fn crear_prestamo() {
    let mut s = setup();
    let libro = s
        .alta_libro("El Quijote", "Cervantes", "1", 1605, GeneroLibro::Ficcion)
        .unwrap();
    let miembro = s.alta_miembro("Ana López", "ana@correo.com", "600111222").unwrap();

    let p = s.crear_prestamo(libro.id, miembro.id).expect("CrearPrestamo inesperado");
    assert!(!p.devuelto, "un préstamo nuevo no debe estar devuelto");

    let repetido = s.crear_prestamo(libro.id, miembro.id);
    assert_eq!(repetido, Err(ErrorBiblioteca::LibroNoDisponible));
}

#[test]
fn crear_prestamo_libro_no_existe() {
    let mut s = setup();
    let miembro = s.alta_miembro("Ana", "ana@correo.com", "1").unwrap();
    let err = s.crear_prestamo(999, miembro.id);
    assert_eq!(err, Err(ErrorBiblioteca::EntidadNoEncontrada));
}

#[test]
fn devolver_prestamo() {
    let mut s = setup();
    let libro = s
        .alta_libro("El Quijote", "Cervantes", "1", 1605, GeneroLibro::Ficcion)
        .unwrap();
    let miembro = s.alta_miembro("Ana", "ana@correo.com", "1").unwrap();
    let p = s.crear_prestamo(libro.id, miembro.id).unwrap();

    let devuelto = s.devolver_prestamo(p.id).expect("DevolverPrestamo inesperado");
    assert!(devuelto.devuelto, "el préstamo debe quedar devuelto");

    let de_nuevo = s.crear_prestamo(libro.id, miembro.id);
    assert!(de_nuevo.is_ok(), "tras la devolución el libro debe poder prestarse");

    let inexistente = s.devolver_prestamo(999);
    assert_eq!(inexistente, Err(ErrorBiblioteca::EntidadNoEncontrada));
}

#[test]
fn resumen() {
    let mut s = setup();
    s.alta_libro("A", "Autor", "1", 2020, GeneroLibro::Otro).unwrap();
    s.alta_libro("B", "Autor", "2", 2020, GeneroLibro::Otro).unwrap();
    let m = s.alta_miembro("Ana", "ana@correo.com", "1").unwrap();
    s.crear_prestamo(1, m.id).unwrap();

    let r = ReportesService::nuevo(&s);
    let resumen = r.resumen();
    assert_eq!(resumen.get("libros"), Some(&2));
    assert_eq!(resumen.get("libros_disponibles"), Some(&1));
    assert_eq!(resumen.get("libros_prestados"), Some(&1));
    assert_eq!(resumen.get("miembros_activos"), Some(&1));
    assert_eq!(resumen.get("prestamos_activos"), Some(&1));
}

#[test]
fn top_libros() {
    let mut s = setup();
    let libro_a = s.alta_libro("A", "Autor", "1", 2020, GeneroLibro::Otro).unwrap();
    let libro_b = s.alta_libro("B", "Autor", "2", 2020, GeneroLibro::Otro).unwrap();
    let m = s.alta_miembro("Ana", "ana@correo.com", "1").unwrap();

    let p1 = s.crear_prestamo(libro_a.id, m.id).unwrap();
    s.devolver_prestamo(p1.id).unwrap();
    let p2 = s.crear_prestamo(libro_a.id, m.id).unwrap();
    s.devolver_prestamo(p2.id).unwrap();
    let p3 = s.crear_prestamo(libro_b.id, m.id).unwrap();
    let _ = p3;

    let r = ReportesService::nuevo(&s);
    let top = r.top_libros(2);
    assert_eq!(top.len(), 2);
    assert_eq!(top[0].nombre, "A");
    assert_eq!(top[0].prestamos, 2);
    assert_eq!(top[1].nombre, "B");
    assert_eq!(top[1].prestamos, 1);
}

#[test]
fn top_miembros() {
    let mut s = setup();
    let m1 = s.alta_miembro("Ana", "ana@correo.com", "1").unwrap();
    let m2 = s.alta_miembro("Luis", "luis@correo.com", "2").unwrap();
    let libro_a = s.alta_libro("A", "Autor", "1", 2020, GeneroLibro::Otro).unwrap();
    let libro_b = s.alta_libro("B", "Autor", "2", 2020, GeneroLibro::Otro).unwrap();

    s.crear_prestamo(libro_a.id, m1.id).unwrap();
    s.crear_prestamo(libro_b.id, m1.id).unwrap();

    // m2 nunca pide prestado; aparece con 0 préstamos en el ranking.
    let _ = (m2.nombre.clone(), m2.id);

    let r = ReportesService::nuevo(&s);
    let top = r.top_miembros(2);
    assert_eq!(top.len(), 2);
    assert_eq!(top[0].nombre, "Ana");
    assert_eq!(top[0].prestamos, 2);
    assert_eq!(top[1].nombre, "Luis");
    assert_eq!(top[1].prestamos, 0);
}

#[test]
fn prestamos_vencidos() {
    let mut s = setup();
    let libro = s.alta_libro("A", "Autor", "1", 2020, GeneroLibro::Otro).unwrap();
    let m = s.alta_miembro("Ana", "ana@correo.com", "1").unwrap();
    s.crear_prestamo(libro.id, m.id).unwrap();

    let vencidos = s.prestamos_vencidos();
    assert!(vencidos.is_empty(), "un préstamo recién creado no está vencido");
}

#[test]
fn top_libros_descendente() {
    let mut s = setup();
    let libro_a = s.alta_libro("A", "Autor", "1", 2020, GeneroLibro::Otro).unwrap();
    let m = s.alta_miembro("Ana", "ana@correo.com", "1").unwrap();

    let p1 = s.crear_prestamo(libro_a.id, m.id).unwrap();
    s.devolver_prestamo(p1.id).unwrap();
    let p2 = s.crear_prestamo(libro_a.id, m.id).unwrap();
    let _ = p2;

    let r = ReportesService::nuevo(&s);
    let top = r.top_libros(1);
    assert_eq!(top.len(), 1);
    assert_eq!(top[0].prestamos, 2, "debe contar préstamos acumulados");
}

#[test]
fn buscar_sin_mayusculas() {
    let mut s = setup();
    s.alta_libro("Cien Años de Soledad", "Gabriel García Márquez", "2", 1967, GeneroLibro::Ficcion).unwrap();

    let res = s.buscar_libros("años");
    assert_eq!(res.len(), 1, "búsqueda en minúsculas debe encontrar 'Años'");
    let res = s.buscar_libros("GARCÍA");
    assert_eq!(res.len(), 1, "búsqueda en mayúsculas debe encontrar 'García'");
}

#[test]
fn ids_incrementales() {
    let mut s = setup();
    let libro1 = s.alta_libro("A", "Autor", "1", 2020, GeneroLibro::Otro).unwrap();
    let libro2 = s.alta_libro("B", "Autor", "2", 2020, GeneroLibro::Otro).unwrap();
    assert_eq!((libro1.id, libro2.id), (1, 2));
}

#[test]
fn ids_prestamos() {
    let mut s = setup();
    let libro_a = s.alta_libro("A", "Autor", "1", 2020, GeneroLibro::Otro).unwrap();
    let libro_b = s.alta_libro("B", "Autor", "2", 2020, GeneroLibro::Otro).unwrap();
    let m = s.alta_miembro("Ana", "ana@correo.com", "1").unwrap();

    let p1 = s.crear_prestamo(libro_a.id, m.id).unwrap();
    let p2 = s.crear_prestamo(libro_b.id, m.id).unwrap();
    assert_ne!(p1.id, p2.id, "los préstamos no deben compartir ID");
}