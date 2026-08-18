package main

import (
	"errors"
	"strings"
	"testing"

	"proyectofinal/datos"
	"proyectofinal/modelos"
	"proyectofinal/servicios"
)

func setup() (*servicios.BibliotecaService, *servicios.ReportesService) {
	libros := datos.Nuevo[modelos.Libro]()
	miembros := datos.Nuevo[modelos.Miembro]()
	prestamos := datos.Nuevo[modelos.Prestamo]()
	s := servicios.NuevoBiblioteca(libros, miembros, prestamos)
	r := servicios.NuevoReportes(s)
	return s, r
}

func TestAltaLibro(t *testing.T) {
	s, _ := setup()

	libro, err := s.AltaLibro("El Quijote", "Miguel de Cervantes", "9788420412146", 1605, modelos.Ficcion)
	if err != nil {
		t.Fatalf("AltaLibro inesperado: %v", err)
	}
	if libro.Titulo != "El Quijote" {
		t.Errorf("título = %q, se esperaba %q", libro.Titulo, "El Quijote")
	}
	if !libro.Disponible {
		t.Errorf("el libro debe crearse disponible")
	}
}

func TestAltaLibroValidaDatos(t *testing.T) {
	s, _ := setup()

	if _, err := s.AltaLibro("", "Autor", "1", 2020, modelos.Otro); !errors.Is(err, servicios.ErrDatosInvalidos) {
		t.Errorf("título vacío debe devolver ErrDatosInvalidos, se obtuvo %v", err)
	}
	if _, err := s.AltaLibro("Título", "", "1", 2020, modelos.Otro); !errors.Is(err, servicios.ErrDatosInvalidos) {
		t.Errorf("autor vacío debe devolver ErrDatosInvalidos, se obtuvo %v", err)
	}
}

func TestBuscarLibros(t *testing.T) {
	s, _ := setup()
	s.AltaLibro("El Quijote", "Miguel de Cervantes", "1", 1605, modelos.Ficcion)
	s.AltaLibro("Cien años de soledad", "Gabriel García Márquez", "2", 1967, modelos.Ficcion)
	s.AltaLibro("Introducción a Go", "Alan Donovan", "3", 2015, modelos.Tecnologia)

	resultados := s.BuscarLibros("quijote")
	if len(resultados) != 1 {
		t.Fatalf("se esperaba 1 resultado, se obtuvo %d", len(resultados))
	}
	if resultados[0].Titulo != "El Quijote" {
		t.Errorf("resultado = %q, se esperaba El Quijote", resultados[0].Titulo)
	}

	resultados = s.BuscarLibros("go")
	if len(resultados) != 1 {
		t.Fatalf("búsqueda 'go' debe dar 1 resultado, se obtuvo %d", len(resultados))
	}

	if s.BuscarLibros("inexistente") == nil {
		t.Errorf("BuscarLibros sin coincidencias debe devolver slice vacío, no nil")
	}
}

func TestAltaMiembroYEmailDuplicado(t *testing.T) {
	s, _ := setup()

	m, err := s.AltaMiembro("Ana López", "ana@correo.com", "600111222")
	if err != nil {
		t.Fatalf("AltaMiembro inesperado: %v", err)
	}
	if !m.Activo {
		t.Errorf("el miembro debe crearse activo")
	}

	if _, err := s.AltaMiembro("Ana 2", "ana@correo.com", "600111223"); !errors.Is(err, servicios.ErrEmailDuplicado) {
		t.Errorf("email repetido debe devolver ErrEmailDuplicado, se obtuvo %v", err)
	}

	if _, err := s.AltaMiembro("", "otro@correo.com", "600111224"); !errors.Is(err, servicios.ErrDatosInvalidos) {
		t.Errorf("nombre vacío debe devolver ErrDatosInvalidos, se obtuvo %v", err)
	}
}

func TestCrearPrestamo(t *testing.T) {
	s, _ := setup()

	libro, _ := s.AltaLibro("El Quijote", "Cervantes", "1", 1605, modelos.Ficcion)
	miembro, _ := s.AltaMiembro("Ana López", "ana@correo.com", "600111222")

	p, err := s.CrearPrestamo(libro.ID, miembro.ID)
	if err != nil {
		t.Fatalf("CrearPrestamo inesperado: %v", err)
	}
	if p.Devuelto {
		t.Errorf("un préstamo nuevo no debe estar devuelto")
	}

	// El mismo libro no puede prestarse de nuevo
	if _, err := s.CrearPrestamo(libro.ID, miembro.ID); !errors.Is(err, servicios.ErrLibroNoDisponible) {
		t.Errorf("libro prestado debe devolver ErrLibroNoDisponible, se obtuvo %v", err)
	}
}

func TestCrearPrestamoLibroNoExiste(t *testing.T) {
	s, _ := setup()
	miembro, _ := s.AltaMiembro("Ana", "ana@correo.com", "1")

	if _, err := s.CrearPrestamo(999, miembro.ID); !errors.Is(err, servicios.ErrEntidadNoEncontrada) {
		t.Errorf("libro inexistente debe devolver ErrEntidadNoEncontrada, se obtuvo %v", err)
	}
}

func TestDevolverPrestamo(t *testing.T) {
	s, _ := setup()

	libro, _ := s.AltaLibro("El Quijote", "Cervantes", "1", 1605, modelos.Ficcion)
	miembro, _ := s.AltaMiembro("Ana", "ana@correo.com", "1")
	p, _ := s.CrearPrestamo(libro.ID, miembro.ID)

	devuelto, err := s.DevolverPrestamo(p.ID)
	if err != nil {
		t.Fatalf("DevolverPrestamo inesperado: %v", err)
	}
	if !devuelto.Devuelto {
		t.Errorf("el préstamo debe quedar devuelto")
	}

	// El libro vuelve a estar disponible
	_, err = s.CrearPrestamo(libro.ID, miembro.ID)
	if err != nil {
		t.Errorf("tras la devolución el libro debe poder prestarse, se obtuvo %v", err)
	}

	if _, err := s.DevolverPrestamo(999); !errors.Is(err, servicios.ErrEntidadNoEncontrada) {
		t.Errorf("préstamo inexistente debe devolver ErrEntidadNoEncontrada, se obtuvo %v", err)
	}
}

func TestResumen(t *testing.T) {
	s, r := setup()

	s.AltaLibro("A", "Autor", "1", 2020, modelos.Otro)
	s.AltaLibro("B", "Autor", "2", 2020, modelos.Otro)
	m, _ := s.AltaMiembro("Ana", "ana@correo.com", "1")
	_, _ = s.CrearPrestamo(1, m.ID)

	resumen := r.Resumen()
	if resumen["libros"] != 2 {
		t.Errorf("libros = %d, se esperaba 2", resumen["libros"])
	}
	if resumen["libros_disponibles"] != 1 {
		t.Errorf("libros_disponibles = %d, se esperaba 1", resumen["libros_disponibles"])
	}
	if resumen["libros_prestados"] != 1 {
		t.Errorf("libros_prestados = %d, se esperaba 1", resumen["libros_prestados"])
	}
	if resumen["miembros_activos"] != 1 {
		t.Errorf("miembros_activos = %d, se esperaba 1", resumen["miembros_activos"])
	}
	if resumen["prestamos_activos"] != 1 {
		t.Errorf("prestamos_activos = %d, se esperaba 1", resumen["prestamos_activos"])
	}
}

func TestTopLibros(t *testing.T) {
	s, r := setup()

	libroA, _ := s.AltaLibro("A", "Autor", "1", 2020, modelos.Otro)
	libroB, _ := s.AltaLibro("B", "Autor", "2", 2020, modelos.Otro)
	m, _ := s.AltaMiembro("Ana", "ana@correo.com", "1")

	_, _ = s.CrearPrestamo(libroA.ID, m.ID)
	_, _ = s.DevolverPrestamo(1)
	_, _ = s.CrearPrestamo(libroA.ID, m.ID)
	_, _ = s.DevolverPrestamo(2)
	_, _ = s.CrearPrestamo(libroB.ID, m.ID)

	top := r.TopLibros(2)
	if len(top) != 2 {
		t.Fatalf("TopLibros debe devolver 2, se obtuvo %d", len(top))
	}
	if top[0].Nombre != "A" || top[0].Prestamos != 2 {
		t.Errorf("top[0] = %+v, se esperaba A con 2 préstamos", top[0])
	}
	if top[1].Nombre != "B" || top[1].Prestamos != 1 {
		t.Errorf("top[1] = %+v, se esperaba B con 1 préstamo", top[1])
	}
}

func TestTopMiembros(t *testing.T) {
	s, r := setup()

	m1, _ := s.AltaMiembro("Ana", "ana@correo.com", "1")
	m2, _ := s.AltaMiembro("Luis", "luis@correo.com", "2")

	libroA, _ := s.AltaLibro("A", "Autor", "1", 2020, modelos.Otro)
	libroB, _ := s.AltaLibro("B", "Autor", "2", 2020, modelos.Otro)

	_, _ = s.CrearPrestamo(libroA.ID, m1.ID)
	_, _ = s.CrearPrestamo(libroB.ID, m1.ID)

	// m2 nunca pide prestado, aparece con 0 préstamos.
	_ = m2

	top := r.TopMiembros(2)
	if len(top) != 2 {
		t.Fatalf("TopMiembros debe devolver 2, se obtuvo %d", len(top))
	}
	if top[0].Nombre != "Ana" || top[0].Prestamos != 2 {
		t.Errorf("top[0] = %+v, se esperaba Ana con 2 préstamos", top[0])
	}
	if top[1].Nombre != "Luis" || top[1].Prestamos != 0 {
		t.Errorf("top[1] = %+v, se esperaba Luis con 0 préstamos", top[1])
	}
}

func TestPrestamosVencidos(t *testing.T) {
	s, _ := setup()
	// No hay préstamos con fechas pasadas recién creados, solo validamos que
	// un préstamo recién creado no aparece como vencido.
	libro, _ := s.AltaLibro("A", "Autor", "1", 2020, modelos.Otro)
	m, _ := s.AltaMiembro("Ana", "ana@correo.com", "1")
	_, _ = s.CrearPrestamo(libro.ID, m.ID)

	if vencidos := s.PrestamosVencidos(); len(vencidos) != 0 {
		t.Errorf("PrestamosVencidos = %d, se esperaba 0", len(vencidos))
	}
}

func TestTopLibrosDescendente(t *testing.T) {
	s, r := setup()
	libroA, _ := s.AltaLibro("A", "Autor", "1", 2020, modelos.Otro)
	m, _ := s.AltaMiembro("Ana", "ana@correo.com", "1")

	_, _ = s.CrearPrestamo(libroA.ID, m.ID)
	_, _ = s.DevolverPrestamo(1)
	_, _ = s.CrearPrestamo(libroA.ID, m.ID)

	top := r.TopLibros(1)
	if len(top) != 1 {
		t.Fatalf("TopLibros(1) debe devolver 1 elemento")
	}
	if top[0].Prestamos != 2 {
		t.Errorf("debe contar préstamos acumulados, se obtuvo %d", top[0].Prestamos)
	}
}

// Comprueba que la búsqueda no distingue mayúsculas.
func TestBuscarSinMayusculas(t *testing.T) {
	s, _ := setup()
	s.AltaLibro("Cien Años de Soledad", "Gabriel García Márquez", "2", 1967, modelos.Ficcion)

	if res := s.BuscarLibros("años"); len(res) != 1 {
		t.Errorf("búsqueda en minúsculas debe encontrar 'Años', se obtuvo %d", len(res))
	}
	if res := s.BuscarLibros("GARCÍA"); len(res) != 1 {
		t.Errorf("búsqueda en mayúsculas debe encontrar 'García', se obtuvo %d", len(res))
	}
}

// Valida que AltaLibro asigne IDs incrementales.
func TestIDsIncrementales(t *testing.T) {
	s, _ := setup()
	libro1, _ := s.AltaLibro("A", "Autor", "1", 2020, modelos.Otro)
	libro2, _ := s.AltaLibro("B", "Autor", "2", 2020, modelos.Otro)

	if libro1.ID != 1 || libro2.ID != 2 {
		t.Errorf("IDs = (%d, %d), se esperaba (1, 2)", libro1.ID, libro2.ID)
	}
}

// Valida que los IDs asignados al crear préstamos no se pisan.
func TestIDsPrestamos(t *testing.T) {
	s, _ := setup()
	libroA, _ := s.AltaLibro("A", "Autor", "1", 2020, modelos.Otro)
	libroB, _ := s.AltaLibro("B", "Autor", "2", 2020, modelos.Otro)
	m, _ := s.AltaMiembro("Ana", "ana@correo.com", "1")

	p1, _ := s.CrearPrestamo(libroA.ID, m.ID)
	p2, _ := s.CrearPrestamo(libroB.ID, m.ID)

	if p1.ID == p2.ID {
		t.Errorf("los préstamos no deben compartir ID (%d)", p1.ID)
	}
}

var _ = strings.TrimSpace