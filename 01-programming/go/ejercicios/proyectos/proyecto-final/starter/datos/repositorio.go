// Package datos define el repositorio genérico en memoria.
package datos

// ConID es implementado por las entidades que tienen ID propio y permiten
// que el repositorio lo asigne automáticamente.
type ConID interface {
	SetID(id int)
}

// Repositorio es un almacén genérico en memoria indexado por ID.
// Se usa como capa de persistencia durante el desarrollo.
type Repositorio[T any] struct {
	datos map[int]T
	sigID int
}

// Nuevo crea un repositorio vacío para el tipo T.
func Nuevo[T any]() *Repositorio[T] {
	return &Repositorio[T]{
		datos: make(map[int]T),
		sigID: 1,
	}
}

// Crear asigna un ID nuevo al elemento, lo guarda y lo devuelve.
func (r *Repositorio[T]) Crear(elem T) T {
	// TODO: si elem implementa ConID (type assertion), asígnale r.sigID.
	// Guarda elem en r.datos con la clave r.sigID, incrementa r.sigID
	// y devuelve elem.
	panic("TODO: implementar Crear")
}

// Listar devuelve todos los elementos guardados.
func (r *Repositorio[T]) Listar() []T {
	// TODO: recorre r.datos y devuelve los valores en un slice.
	panic("TODO: implementar Listar")
}

// Obtener devuelve el elemento con el ID dado.
func (r *Repositorio[T]) Obtener(id int) (T, bool) {
	// TODO: devuelve el elemento de r.datos[id] y true si existe.
	panic("TODO: implementar Obtener")
}

// Actualizar reemplaza el elemento con el mismo ID (el ID debe estar dentro
// del elemento). Devuelve true si existía.
func (r *Repositorio[T]) Actualizar(id int, elem T) bool {
	// TODO: si id existe en r.datos, reemplázalo y devuelve true; si no, false.
	panic("TODO: implementar Actualizar")
}

// Eliminar borra el elemento con el ID dado y devuelve true si existía.
func (r *Repositorio[T]) Eliminar(id int) bool {
	// TODO: si id existe en r.datos, elimínalo y devuelve true; si no, false.
	panic("TODO: implementar Eliminar")
}
