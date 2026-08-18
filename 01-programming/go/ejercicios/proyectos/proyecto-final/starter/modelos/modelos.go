// Package modelos define las entidades de dominio de la biblioteca.
package modelos

// GeneroLibro es un enum de los géneros disponibles.
type GeneroLibro string

const (
	Ficcion    GeneroLibro = "ficcion"
	NoFiccion  GeneroLibro = "no_ficcion"
	Ciencia    GeneroLibro = "ciencia"
	Tecnologia GeneroLibro = "tecnologia"
	Historia   GeneroLibro = "historia"
	Otro       GeneroLibro = "otro"
)

// Libro representa un libro de la biblioteca.
type Libro struct {
	ID         int
	Titulo     string
	Autor      string
	ISBN       string
	Anio       int
	Genero     GeneroLibro
	Disponible bool
}

// SetID permite al repositorio asignar el ID automáticamente.
func (l *Libro) SetID(id int) { l.ID = id }

// Miembro representa a una persona registrada en la biblioteca.
type Miembro struct {
	ID       int
	Nombre   string
	Email    string
	Telefono string
	Activo   bool
}

// SetID permite al repositorio asignar el ID automáticamente.
func (m *Miembro) SetID(id int) { m.ID = id }

// Prestamo representa el préstamo de un libro a un miembro.
// FechaInicio y FechaDevolucion se guardan como cadenas ISO ("2006-01-02").
type Prestamo struct {
	ID              int
	IDLibro         int
	IDMiembro       int
	FechaInicio     string
	FechaDevolucion string
	Devuelto        bool
}

// SetID permite al repositorio asignar el ID automáticamente.
func (p *Prestamo) SetID(id int) { p.ID = id }
