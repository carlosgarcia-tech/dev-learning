package main

import (
	"os"
	"path/filepath"
	"testing"
)

func rutaTemporal(t *testing.T) string {
	t.Helper()
	return filepath.Join(t.TempDir(), "tareas.json")
}

func TestAgregarYListar(t *testing.T) {
	a := NuevoAlmacen(rutaTemporal(t))
	tarea, err := a.Agregar("Comprar pan")
	if err != nil {
		t.Fatalf("Agregar devolvió error: %v", err)
	}
	if tarea.ID != 1 {
		t.Errorf("ID = %d; se esperaba 1", tarea.ID)
	}
	if len(a.Listar()) != 1 {
		t.Errorf("Listar() = %d elementos; se esperaba 1", len(a.Listar()))
	}
}

func TestAgregarTituloVacio(t *testing.T) {
	a := NuevoAlmacen(rutaTemporal(t))
	if _, err := a.Agregar(""); err != errTituloVacio {
		t.Errorf("Agregar(\"\") debe devolver errTituloVacio, obtuvo %v", err)
	}
}

func TestCompletarYEliminar(t *testing.T) {
	a := NuevoAlmacen(rutaTemporal(t))
	a.Agregar("A")
	a.Agregar("B")
	if err := a.Completar(1); err != nil {
		t.Fatalf("Completar(1) devolvió error: %v", err)
	}
	pendientes := a.Pendientes()
	if len(pendientes) != 1 || pendientes[0].ID != 2 {
		t.Errorf("Pendientes() = %+v; se esperaba solo la tarea 2", pendientes)
	}
	if err := a.Eliminar(2); err != nil {
		t.Fatalf("Eliminar(2) devolvió error: %v", err)
	}
	if len(a.Listar()) != 1 {
		t.Errorf("Listar() = %d elementos; se esperaba 1 tras eliminar", len(a.Listar()))
	}
}

func TestErroresNoEncontrada(t *testing.T) {
	a := NuevoAlmacen(rutaTemporal(t))
	if err := a.Completar(99); err != errNoEncontrada {
		t.Errorf("Completar(99) debe devolver errNoEncontrada, obtuvo %v", err)
	}
	if err := a.Eliminar(99); err != errNoEncontrada {
		t.Errorf("Eliminar(99) debe devolver errNoEncontrada, obtuvo %v", err)
	}
}

func TestGuardarYCargar(t *testing.T) {
	ruta := rutaTemporal(t)
	a := NuevoAlmacen(ruta)
	a.Agregar("Comprar pan")
	a.Agregar("Estudiar Go")
	if err := a.Guardar(); err != nil {
		t.Fatalf("Guardar devolvió error: %v", err)
	}
	if _, err := os.Stat(ruta); err != nil {
		t.Fatalf("el archivo %s no existe tras Guardar", ruta)
	}

	otro := NuevoAlmacen(ruta)
	if err := otro.Cargar(); err != nil {
		t.Fatalf("Cargar devolvió error: %v", err)
	}
	if len(otro.Listar()) != 2 {
		t.Errorf("tras Cargar, Listar() = %d elementos; se esperaban 2", len(otro.Listar()))
	}
}

func TestSiguienteIDSePreservaAlCargar(t *testing.T) {
	ruta := rutaTemporal(t)
	a := NuevoAlmacen(ruta)
	a.Agregar("A")
	a.Guardar()

	otro := NuevoAlmacen(ruta)
	otro.Cargar()
	tarea, err := otro.Agregar("B")
	if err != nil {
		t.Fatalf("Agregar tras Cargar devolvió error: %v", err)
	}
	if tarea.ID != 2 {
		t.Errorf("la primera tarea tras Cargar debe tener ID 2, obtuvo %d", tarea.ID)
	}
}

func TestCargarArchivoInexistente(t *testing.T) {
	a := NuevoAlmacen(filepath.Join(t.TempDir(), "no-existe.json"))
	if err := a.Cargar(); err == nil {
		t.Error("Cargar de un archivo inexistente debe devolver un error")
	}
}