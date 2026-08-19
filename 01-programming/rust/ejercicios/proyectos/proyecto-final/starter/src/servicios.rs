//! Servicios contiene la lógica de negocio de la biblioteca.

use std::fmt;
use std::time::{SystemTime, UNIX_EPOCH};

use crate::datos::Repositorio;
use crate::modelos::{GeneroLibro, Libro, Miembro, Prestamo};

/// Duración máxima de un préstamo en días.
pub const DIAS_DE_PRESTAMO: u32 = 14;

/// Errores de negocio personalizados.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ErrorBiblioteca {
    /// El libro ya está prestado.
    LibroNoDisponible,
    /// El miembro está inactivo.
    MiembroInactivo,
    /// El email ya está registrado.
    EmailDuplicado,
    /// Entidad no encontrada.
    EntidadNoEncontrada,
    /// Datos inválidos.
    DatosInvalidos,
}

impl fmt::Display for ErrorBiblioteca {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let msg = match self {
            ErrorBiblioteca::LibroNoDisponible => "el libro ya está prestado",
            ErrorBiblioteca::MiembroInactivo => "el miembro está inactivo",
            ErrorBiblioteca::EmailDuplicado => "el email ya está registrado",
            ErrorBiblioteca::EntidadNoEncontrada => "entidad no encontrada",
            ErrorBiblioteca::DatosInvalidos => "datos inválidos",
        };
        write!(f, "{msg}")
    }
}

impl std::error::Error for ErrorBiblioteca {}

/// Agrupa la lógica de negocio sobre los repositorios.
pub struct BibliotecaService {
    libros: Repositorio<Libro>,
    miembros: Repositorio<Miembro>,
    prestamos: Repositorio<Prestamo>,
}

impl BibliotecaService {
    /// Crea el servicio con los repositorios dados.
    pub fn nuevo(
        libros: Repositorio<Libro>,
        miembros: Repositorio<Miembro>,
        prestamos: Repositorio<Prestamo>,
    ) -> Self {
        BibliotecaService {
            libros,
            miembros,
            prestamos,
        }
    }

    /// Da de alta un libro validando título y autor no vacíos.
    pub fn alta_libro(
        &mut self,
        titulo: &str,
        autor: &str,
        isbn: &str,
        anio: u32,
        genero: GeneroLibro,
    ) -> Result<Libro, ErrorBiblioteca> {
        // TODO: si titulo o autor están vacíos, devuelve Err(ErrorBiblioteca::DatosInvalidos).
        // Crea el Libro con disponible=true y guárdalo con self.libros.crear.
        // Devuelve el libro creado.
        todo!("implementar alta_libro")
    }

    /// Devuelve los libros cuyo título o autor contengan `texto`
    /// (sin distinguir mayúsculas).
    pub fn buscar_libros(&self, texto: &str) -> Vec<Libro> {
        // TODO: recorre self.libros.listar() y filtra por coincidencia en
        // titulo o autor (usa to_lowercase y contains).
        todo!("implementar buscar_libros")
    }

    /// Da de alta un miembro validando email único y campos no vacíos.
    pub fn alta_miembro(
        &mut self,
        nombre: &str,
        email: &str,
        telefono: &str,
    ) -> Result<Miembro, ErrorBiblioteca> {
        // TODO: si nombre o email están vacíos, Err(ErrorBiblioteca::DatosInvalidos).
        // Si ya existe un miembro con ese email, Err(ErrorBiblioteca::EmailDuplicado).
        // Crea el Miembro con activo=true y guárdalo con self.miembros.crear.
        todo!("implementar alta_miembro")
    }

    /// Crea un préstamo de `DIAS_DE_PRESTAMO` días validando que el libro
    /// esté disponible y el miembro esté activo.
    pub fn crear_prestamo(
        &mut self,
        id_libro: u32,
        id_miembro: u32,
    ) -> Result<Prestamo, ErrorBiblioteca> {
        // TODO: obtén el libro (si no existe, Err(ErrorBiblioteca::EntidadNoEncontrada)).
        // Si no está disponible, Err(ErrorBiblioteca::LibroNoDisponible). Obtén el
        // miembro (si no existe, Err(ErrorBiblioteca::EntidadNoEncontrada)). Si no está
        // activo, Err(ErrorBiblioteca::MiembroInactivo). Crea el Prestamo con
        // fecha_inicio=hoy y fecha_devolucion=hoy+DIAS_DE_PRESTAMO en ISO (usa hoy_iso
        // y sumar_dias). Marca el libro como no disponible, guarda todo y devuelve el
        // préstamo.
        todo!("implementar crear_prestamo")
    }

    /// Marca un préstamo como devuelto y libera el libro.
    pub fn devolver_prestamo(
        &mut self,
        id_prestamo: u32,
    ) -> Result<Prestamo, ErrorBiblioteca> {
        // TODO: obtén el préstamo (si no existe, Err(ErrorBiblioteca::EntidadNoEncontrada)).
        // Pon devuelto=true y fecha_devolucion=hoy. Marca el libro como disponible
        // y guarda los cambios. Devuelve el préstamo.
        todo!("implementar devolver_prestamo")
    }

    /// Devuelve los préstamos activos cuya fecha de devolución es anterior
    /// a hoy.
    pub fn prestamos_vencidos(&self) -> Vec<Prestamo> {
        // TODO: filtra self.prestamos.listar() por !devuelto y fecha_devolucion <
        // hoy_iso() (las cadenas ISO se comparan lexicográficamente).
        todo!("implementar prestamos_vencidos")
    }
}

/// Devuelve la fecha actual en formato ISO ("YYYY-MM-DD").
fn hoy_iso() -> String {
    let segundos = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("reloj del sistema posterior a 1970")
        .as_secs() as i64;
    iso_desde_dias(segundos / 86_400)
}

/// Suma `n` días a una fecha ISO y devuelve la fecha resultante en ISO.
fn sumar_dias(iso: &str, n: i64) -> String {
    iso_desde_dias(dias_desde_epoch(iso) + n)
}

fn es_bisiesto(anio: u32) -> bool {
    (anio % 4 == 0 && anio % 100 != 0) || anio % 400 == 0
}

/// Días que tiene cada mes (febrero se ajusta con el bisiesto).
fn dias_en_mes(anio: u32, mes: u32) -> u32 {
    match mes {
        1 | 3 | 5 | 7 | 8 | 10 | 12 => 31,
        4 | 6 | 9 | 11 => 30,
        2 if es_bisiesto(anio) => 29,
        2 => 28,
        _ => 0,
    }
}

/// Convierte una fecha ISO a días transcurridos desde 1970-01-01.
fn dias_desde_epoch(iso: &str) -> i64 {
    let partes: Vec<&str> = iso.split('-').collect();
    if partes.len() != 3 {
        return 0;
    }
    let anio: u32 = partes[0].parse().unwrap_or(0);
    let mes: u32 = partes[1].parse().unwrap_or(1);
    let dia: u32 = partes[2].parse().unwrap_or(1);

    let mut dias = 0;
    for a in 1970..anio {
        dias += if es_bisiesto(a) { 366 } else { 365 };
    }
    for m in 1..mes {
        dias += dias_en_mes(anio, m) as i64;
    }
    dias + (dia as i64 - 1)
}

/// Convierte días desde 1970-01-01 a una fecha ISO.
fn iso_desde_dias(dias: i64) -> String {
    let mut anio = 1970i64;
    let mut restantes = dias;
    loop {
        let anio_len = if es_bisiesto(anio as u32) { 366 } else { 365 };
        if restantes < anio_len {
            break;
        }
        restantes -= anio_len;
        anio += 1;
    }
    let mut mes = 1u32;
    loop {
        let mes_len = dias_en_mes(anio as u32, mes) as i64;
        if restantes < mes_len {
            break;
        }
        restantes -= mes_len;
        mes += 1;
    }
    format!("{anio:04}-{mes:02}-{:02}", restantes + 1)
}

/// Item de un ranking de libros o miembros.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Conteo {
    pub nombre: String,
    pub prestamos: usize,
}

/// Genera métricas sobre la biblioteca.
pub struct ReportesService<'a> {
    biblioteca: &'a BibliotecaService,
}

impl<'a> ReportesService<'a> {
    /// Crea el servicio de reportes.
    pub fn nuevo(biblioteca: &'a BibliotecaService) -> Self {
        ReportesService { biblioteca }
    }

    /// Devuelve un mapa con los totales de la biblioteca.
    pub fn resumen(&self) -> std::collections::HashMap<String, usize> {
        // TODO: devuelve un mapa con las claves:
        // "libros", "libros_disponibles", "libros_prestados",
        // "miembros_activos" y "prestamos_activos".
        todo!("implementar resumen")
    }

    /// Devuelve los `n` libros más prestados, ordenados de mayor a menor.
    pub fn top_libros(&self, n: usize) -> Vec<Conteo> {
        // TODO: cuenta los préstamos por id_libro, resuelve los títulos y
        // devuelve los n primeros ordenados por número de préstamos descendente.
        todo!("implementar top_libros")
    }

    /// Devuelve los `n` miembros más activos por número de préstamos.
    pub fn top_miembros(&self, n: usize) -> Vec<Conteo> {
        // TODO: cuenta los préstamos por id_miembro, resuelve los nombres y
        // devuelve los n primeros ordenados por número de préstamos descendente.
        todo!("implementar top_miembros")
    }
}