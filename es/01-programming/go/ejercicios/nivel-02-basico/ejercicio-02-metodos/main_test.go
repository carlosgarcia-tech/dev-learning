package main

import (
	"math"
	"testing"
)

func casiIgual(a, b float64) bool {
	return math.Abs(a-b) < 1e-9
}

func TestRectanguloArea(t *testing.T) {
	casos := []struct {
		r        Rectangulo
		esperado float64
	}{
		{Rectangulo{Ancho: 3, Alto: 4}, 12},
		{Rectangulo{Ancho: 0.5, Alto: 2}, 1},
		{Rectangulo{Ancho: 7, Alto: 7}, 49},
	}
	for _, c := range casos {
		if got := c.r.Area(); !casiIgual(got, c.esperado) {
			t.Errorf("Area(%+v) = %v; se esperaba %v", c.r, got, c.esperado)
		}
	}
}

func TestRectanguloPerimetro(t *testing.T) {
	casos := []struct {
		r        Rectangulo
		esperado float64
	}{
		{Rectangulo{Ancho: 3, Alto: 4}, 14},
		{Rectangulo{Ancho: 1, Alto: 1}, 4},
		{Rectangulo{Ancho: 0.5, Alto: 0.5}, 2},
	}
	for _, c := range casos {
		if got := c.r.Perimetro(); !casiIgual(got, c.esperado) {
			t.Errorf("Perimetro(%+v) = %v; se esperaba %v", c.r, got, c.esperado)
		}
	}
}

func TestCirculoArea(t *testing.T) {
	c := Circulo{Radio: 1}
	if got := c.Area(); !casiIgual(got, math.Pi) {
		t.Errorf("Area(Circulo{1}) = %v; se esperaba %v", got, math.Pi)
	}
	c2 := Circulo{Radio: 2}
	if got := c2.Area(); !casiIgual(got, 4*math.Pi) {
		t.Errorf("Area(Circulo{2}) = %v; se esperaba %v", got, 4*math.Pi)
	}
}

func TestCirculoCircunferencia(t *testing.T) {
	c := Circulo{Radio: 1}
	if got := c.Circunferencia(); !casiIgual(got, 2*math.Pi) {
		t.Errorf("Circunferencia(Circulo{1}) = %v; se esperaba %v", got, 2*math.Pi)
	}
}