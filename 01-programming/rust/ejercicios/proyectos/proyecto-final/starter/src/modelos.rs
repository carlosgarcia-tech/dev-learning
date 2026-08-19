//! Modelos define las entidades de dominio de la biblioteca.

/// Géneros disponibles para clasificar un libro.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum GeneroLibro {
    Ficcion,
    NoFiccion,
    Ciencia,
    Tecnologia,
    Historia,
    Otro,
}

/// Libro representa un libro de la biblioteca.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Libro {
    pub id: u32,
    pub titulo: String,
    pub autor: String,
    pub isbn: String,
    pub anio: u32,
    pub genero: GeneroLibro,
    pub disponible: bool,
}

impl Libro {
    pub fn set_id(&mut self, id: u32) {
        self.id = id;
    }

    pub fn id(&self) -> u32 {
        self.id
    }
}

/// Miembro representa a una persona registrada en la biblioteca.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Miembro {
    pub id: u32,
    pub nombre: String,
    pub email: String,
    pub telefono: String,
    pub activo: bool,
}

impl Miembro {
    pub fn set_id(&mut self, id: u32) {
        self.id = id;
    }

    pub fn id(&self) -> u32 {
        self.id
    }
}

/// Préstamo representa el préstamo de un libro a un miembro.
/// `fecha_inicio` y `fecha_devolucion` se guardan como cadenas ISO ("2006-01-02").
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Prestamo {
    pub id: u32,
    pub id_libro: u32,
    pub id_miembro: u32,
    pub fecha_inicio: String,
    pub fecha_devolucion: String,
    pub devuelto: bool,
}

impl Prestamo {
    pub fn set_id(&mut self, id: u32) {
        self.id = id;
    }

    pub fn id(&self) -> u32 {
        self.id
    }
}