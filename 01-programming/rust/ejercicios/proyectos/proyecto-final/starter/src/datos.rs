//! Datos define el repositorio genérico en memoria.

use std::collections::HashMap;

/// Trait implementado por las entidades que tienen ID propio y permiten que
/// el repositorio lo asigne automáticamente.
pub trait ConID {
    fn set_id(&mut self, id: u32);
}

/// Repositorio es un almacén genérico en memoria indexado por ID.
/// Se usa como capa de persistencia durante el desarrollo.
pub struct Repositorio<T> {
    datos: HashMap<u32, T>,
    sig_id: u32,
}

impl<T> Repositorio<T> {
    /// Crea un repositorio vacío para el tipo `T`.
    pub fn nuevo() -> Self {
        Repositorio {
            datos: HashMap::new(),
            sig_id: 1,
        }
    }

    /// Asigna un ID nuevo al elemento, lo guarda y lo devuelve.
    pub fn crear(&mut self, mut elem: T) -> T
    where
        T: ConID + Clone,
    {
        // TODO: asigna elem.set_id(self.sig_id), guarda elem en self.datos
        // con la clave self.sig_id, incrementa self.sig_id y devuelve elem.
        todo!("implementar Repositorio::crear")
    }

    /// Devuelve todos los elementos guardados.
    pub fn listar(&self) -> Vec<T>
    where
        T: Clone,
    {
        // TODO: recorre self.datos y devuelve los valores en un Vec.
        todo!("implementar Repositorio::listar")
    }

    /// Devuelve el elemento con el ID dado, si existe.
    pub fn obtener(&self, id: u32) -> Option<T>
    where
        T: Clone,
    {
        // TODO: devuelve el elemento de self.datos[id] si existe.
        todo!("implementar Repositorio::obtener")
    }

    /// Reemplaza el elemento con el mismo ID (el ID debe estar dentro del
    /// elemento). Devuelve true si existía.
    pub fn actualizar(&mut self, id: u32, elem: T) -> bool {
        // TODO: si id existe en self.datos, reemplázalo y devuelve true; si no, false.
        todo!("implementar Repositorio::actualizar")
    }

    /// Borra el elemento con el ID dado y devuelve true si existía.
    pub fn eliminar(&mut self, id: u32) -> bool {
        // TODO: si id existe en self.datos, elimínalo y devuelve true; si no, false.
        todo!("implementar Repositorio::eliminar")
    }
}

/// Implementación de `ConID` para `Libro`, `Miembro` y `Prestamo`.
impl ConID for crate::modelos::Libro {
    fn set_id(&mut self, id: u32) {
        self.id = id;
    }
}

impl ConID for crate::modelos::Miembro {
    fn set_id(&mut self, id: u32) {
        self.id = id;
    }
}

impl ConID for crate::modelos::Prestamo {
    fn set_id(&mut self, id: u32) {
        self.id = id;
    }
}