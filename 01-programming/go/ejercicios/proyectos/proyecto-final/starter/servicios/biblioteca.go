// Package servicios contiene la lógica de negocio de la biblioteca.
package servicios

import (
	"errors"
	"time"

	"proyectofinal/datos"
	"proyectofinal/modelos"
)

// DiasDePrestamo es la duración máxima de un préstamo.
const DiasDePrestamo = 14

// Errores de negocio personalizados.
var (
	ErrLibroNoDisponible   = errors.New("el libro ya está prestado")
	ErrMiembroInactivo     = errors.New("el miembro está inactivo")
	ErrEmailDuplicado      = errors.New("el email ya está registrado")
	ErrEntidadNoEncontrada = errors.New("entidad no encontrada")
	ErrDatosInvalidos      = errors.New("datos inválidos")
)

// BibliotecaService agrupa la lógica de negocio sobre los repositorios.
type BibliotecaService struct {
	libros    *datos.Repositorio[modelos.Libro]
	miembros  *datos.Repositorio[modelos.Miembro]
	prestamos *datos.Repositorio[modelos.Prestamo]
}

// NuevoBiblioteca crea el servicio con los repositorios dados.
func NuevoBiblioteca(
	libros *datos.Repositorio[modelos.Libro],
	miembros *datos.Repositorio[modelos.Miembro],
	prestamos *datos.Repositorio[modelos.Prestamo],
) *BibliotecaService {
	return &BibliotecaService{libros: libros, miembros: miembros, prestamos: prestamos}
}

// AltaLibro da de alta un libro validando título y autor no vacíos.
func (s *BibliotecaService) AltaLibro(titulo, autor, isbn string, anio int, genero modelos.GeneroLibro) (modelos.Libro, error) {
	// TODO: si titulo o autor están vacíos, devuelve ErrDatosInvalidos.
	// Crea el Libro con Disponible=true y guárdalo con s.libros.Crear.
	// Devuelve el libro creado y nil.
	return modelos.Libro{}, ErrDatosInvalidos
}

// BuscarLibros devuelve los libros cuyo título o autor contengan texto
// (sin distinguir mayúsculas).
func (s *BibliotecaService) BuscarLibros(texto string) []modelos.Libro {
	// TODO: recorre s.libros.Listar() y filtra por coincidencia en Titulo o
	// Autor (usa strings.Contains y strings.ToLower).
	return nil
}

// AltaMiembro da de alta un miembro validando email único y campos no vacíos.
func (s *BibliotecaService) AltaMiembro(nombre, email, telefono string) (modelos.Miembro, error) {
	// TODO: si nombre o email están vacíos, ErrDatosInvalidos.
	// Si ya existe un miembro con ese email, ErrEmailDuplicado.
	// Crea el Miembro con Activo=true y guárdalo con s.miembros.Crear.
	return modelos.Miembro{}, ErrDatosInvalidos
}

// CrearPrestamo crea un préstamo de DiasDePrestamo días validando que el
// libro esté disponible y el miembro esté activo.
func (s *BibliotecaService) CrearPrestamo(idLibro, idMiembro int) (modelos.Prestamo, error) {
	// TODO: obtén el libro (si no existe, ErrEntidadNoEncontrada). Si no está
	// disponible, ErrLibroNoDisponible. Obtén el miembro (si no existe,
	// ErrEntidadNoEncontrada). Si no está activo, ErrMiembroInactivo.
	// Crea el Prestamo con fechaInicio=hoy y fechaDevolucion=hoy+14d en ISO.
	// Marca el libro como no disponible, guarda todo y devuelve el préstamo.
	return modelos.Prestamo{}, ErrEntidadNoEncontrada
}

// DevolverPrestamo marca un préstamo como devuelto y libera el libro.
func (s *BibliotecaService) DevolverPrestamo(idPrestamo int) (modelos.Prestamo, error) {
	// TODO: obtén el préstamo (si no existe, ErrEntidadNoEncontrada).
	// Pon Devuelto=true y FechaDevolucion=hoy. Marca el libro como disponible
	// y guarda los cambios. Devuelve el préstamo.
	return modelos.Prestamo{}, ErrEntidadNoEncontrada
}

// PrestamosVencidos devuelve los préstamos activos cuya fecha de devolución
// es anterior a hoy.
func (s *BibliotecaService) PrestamosVencidos() []modelos.Prestamo {
	// TODO: filtra s.prestamos.Listar() por !Devuelto y FechaDevolucion < hoy
	// (compara cadenas ISO o parsea con time.Parse).
	return nil
}

func hoyISO() string {
	return time.Now().Format("2006-01-02")
}

// ReportesService genera métricas sobre la biblioteca.
type ReportesService struct {
	biblioteca *BibliotecaService
}

// NuevoReportes crea el servicio de reportes.
func NuevoReportes(biblioteca *BibliotecaService) *ReportesService {
	return &ReportesService{biblioteca: biblioteca}
}

// Resumen devuelve un mapa con los totales de la biblioteca.
func (r *ReportesService) Resumen() map[string]int {
	// TODO: devuelve un mapa con las claves:
	// "libros", "libros_disponibles", "libros_prestados",
	// "miembros_activos" y "prestamos_activos".
	return nil
}

// TopLibros devuelve los n libros más prestados, ordenados de mayor a menor,
// como slice de {Titulo, Prestamos}.
type Conteo struct {
	Nombre    string
	Prestamos int
}

func (r *ReportesService) TopLibros(n int) []Conteo {
	// TODO: cuenta los préstamos por idLibro, resuelve los títulos y
	// devuelve los n primeros ordenados por número de préstamos descendente.
	return nil
}

// TopMiembros devuelve los n miembros más activos por número de préstamos.
func (r *ReportesService) TopMiembros(n int) []Conteo {
	// TODO: cuenta los préstamos por idMiembro, resuelve los nombres y
	// devuelve los n primeros ordenados por número de préstamos descendente.
	return nil
}
