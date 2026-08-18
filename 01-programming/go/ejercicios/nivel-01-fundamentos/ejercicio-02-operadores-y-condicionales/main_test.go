package main

import "testing"

func TestClasificarEdad(t *testing.T) {
	casos := []struct {
		edad     int
		esperado string
	}{
		{0, "menor de edad"},
		{15, "menor de edad"},
		{30, "adulto"},
		{64, "adulto"},
		{65, "adulto mayor"},
		{90, "adulto mayor"},
	}
	for _, c := range casos {
		if got := clasificarEdad(c.edad); got != c.esperado {
			t.Errorf("clasificarEdad(%d) = %q; se esperaba %q", c.edad, got, c.esperado)
		}
	}
}

func TestEsPar(t *testing.T) {
	if !esPar(4) {
		t.Error("esPar(4) debe ser true")
	}
	if esPar(7) {
		t.Error("esPar(7) debe ser false")
	}
	if !esPar(0) {
		t.Error("esPar(0) debe ser true")
	}
	if esPar(-3) {
		t.Error("esPar(-3) debe ser false")
	}
}

func TestMayorDeTres(t *testing.T) {
	casos := []struct {
		a, b, c  int
		esperado int
	}{
		{3, 9, 5, 9},
		{-1, -5, -2, -1},
		{7, 7, 7, 7},
		{100, 1, 50, 100},
	}
	for _, c := range casos {
		if got := mayorDeTres(c.a, c.b, c.c); got != c.esperado {
			t.Errorf("mayorDeTres(%d, %d, %d) = %d; se esperaba %d", c.a, c.b, c.c, got, c.esperado)
		}
	}
}

func TestEvaluarNota(t *testing.T) {
	casos := []struct {
		nota     float64
		esperado string
	}{
		{55, "suspenso"},
		{59.9, "suspenso"},
		{60, "aprobado"},
		{74, "aprobado"},
		{75, "notable"},
		{89, "notable"},
		{90, "sobresaliente"},
		{100, "sobresaliente"},
	}
	for _, c := range casos {
		if got := evaluarNota(c.nota); got != c.esperado {
			t.Errorf("evaluarNota(%v) = %q; se esperaba %q", c.nota, got, c.esperado)
		}
	}
}