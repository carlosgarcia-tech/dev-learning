package main

import (
	"math"
	"strings"
	"testing"
)

func TestRectanguloImplementaForma(t *testing.T) {
	var f Forma = Rectangulo{Ancho: 3, Alto: 4}
	if got := f.Area(); got != 12 {
		t.Errorf("Area = %v; se esperaba 12", got)
	}
	if got := f.Nombre(); got != "rectángulo" {
		t.Errorf("Nombre = %q; se esperaba \"rectángulo\"", got)
	}
}

func TestCirculoImplementaForma(t *testing.T) {
	var f Forma = Circulo{Radio: 1}
	if math.Abs(f.Area()-math.Pi) > 1e-9 {
		t.Errorf("Area = %v; se esperaba %v", f.Area(), math.Pi)
	}
	if got := f.Nombre(); got != "círculo" {
		t.Errorf("Nombre = %q; se esperaba \"círculo\"", got)
	}
}

func TestAreaTotal(t *testing.T) {
	formas := []Forma{
		Rectangulo{Ancho: 3, Alto: 4},
		Circulo{Radio: 1},
	}
	if got := areaTotal(formas); math.Abs(got-(12+math.Pi)) > 1e-9 {
		t.Errorf("areaTotal = %v; se esperaba %v", got, 12+math.Pi)
	}
}

func TestAreaTotalVacio(t *testing.T) {
	if got := areaTotal([]Forma{}); got != 0 {
		t.Errorf("areaTotal([]) = %v; se esperaba 0", got)
	}
}

func TestDescribir(t *testing.T) {
	lineas := describir([]Forma{
		Rectangulo{Ancho: 3, Alto: 4},
		Circulo{Radio: 1},
	})
	if len(lineas) != 2 {
		t.Fatalf("describir debe devolver 2 líneas, devolvió %d: %v", len(lineas), lineas)
	}
	if lineas[0] != "rectángulo: 12.00" {
		t.Errorf("línea 0 = %q; se esperaba %q", lineas[0], "rectángulo: 12.00")
	}
	if !strings.Contains(lineas[1], "círculo: 3.14") {
		t.Errorf("línea 1 = %q; debe contener %q", lineas[1], "círculo: 3.14")
	}
}