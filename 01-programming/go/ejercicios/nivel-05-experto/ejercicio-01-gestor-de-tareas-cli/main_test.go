package main

import (
	"testing"
)

func TestNuevoGestorVacio(t *testing.T) {
	g := NuevoGestor()
	if g == nil {
		t.Fatal("NuevoGestor() no debe devolver nil")
	}
	if g.Contar() != 0 {
		t.Errorf("Contar() = %d; se esperaba 0", g.Contar())
	}
}

func TestAgregar(t *testing.T) {
	g := NuevoGestor()
	tarea := g.Agregar("Comprar pan")
	if tarea.ID != 1 {
		t.Errorf("la primera tarea debe tener ID 1, obtuvo %d", tarea.ID)
	}
	if tarea.Titulo != "Comprar pan" {
		t.Errorf("Titulo = %q; se esperaba %q", tarea.Titulo, "Comprar pan")
	}
	if tarea.Completada {
		t.Error("una tarea nueva no debe estar completada")
	}
	if g.Contar() != 1 {
		t.Errorf("Contar() = %d; se esperaba 1", g.Contar())
	}
}

func TestAgregarIncrementaIDs(t *testing.T) {
	g := NuevoGestor()
	g.Agregar("A")
	segunda := g.Agregar("B")
	if segunda.ID != 2 {
		t.Errorf("la segunda tarea debe tener ID 2, obtuvo %d", segunda.ID)
	}
}

func TestCompletar(t *testing.T) {
	g := NuevoGestor()
	g.Agregar("A")
	g.Agregar("B")
	if err := g.Completar(1); err != nil {
		t.Fatalf("Completar(1) devolvió error: %v", err)
	}
	if err := g.Completar(99); err != errTareaNoEncontrada {
		t.Errorf("Completar(99) debe devolver errTareaNoEncontrada, obtuvo %v", err)
	}
	tarea, _ := g.Obtener(1)
	if !tarea.Completada {
		t.Error("la tarea 1 debe estar completada después de Completar(1)")
	}
}

func TestPendientes(t *testing.T) {
	g := NuevoGestor()
	g.Agregar("A")
	g.Agregar("B")
	g.Agregar("C")
	g.Completar(2)
	pendientes := g.Pendientes()
	if len(pendientes) != 2 {
		t.Fatalf("Pendientes() = %d elementos; se esperaban 2", len(pendientes))
	}
	for _, p := range pendientes {
		if p.Completada {
			t.Errorf("la tarea %d aparece en Pendientes pero está completada", p.ID)
		}
	}
}

func TestObtener(t *testing.T) {
	g := NuevoGestor()
	g.Agregar("A")
	tarea, err := g.Obtener(1)
	if err != nil {
		t.Fatalf("Obtener(1) devolvió error: %v", err)
	}
	if tarea.Titulo != "A" {
		t.Errorf("Obtener(1).Titulo = %q; se esperaba %q", tarea.Titulo, "A")
	}
	if _, err := g.Obtener(42); err != errTareaNoEncontrada {
		t.Errorf("Obtener(42) debe devolver errTareaNoEncontrada, obtuvo %v", err)
	}
}