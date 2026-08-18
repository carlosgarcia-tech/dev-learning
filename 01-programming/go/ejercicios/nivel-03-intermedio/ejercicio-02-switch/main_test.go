package main

import "testing"

func TestDiaDeLaSemana(t *testing.T) {
	casos := []struct {
		n        int
		esperado string
	}{
		{1, "lunes"},
		{2, "martes"},
		{3, "miércoles"},
		{4, "jueves"},
		{5, "viernes"},
		{6, "sábado"},
		{7, "domingo"},
		{0, "número inválido"},
		{8, "número inválido"},
	}
	for _, c := range casos {
		if got := diaDeLaSemana(c.n); got != c.esperado {
			t.Errorf("diaDeLaSemana(%d) = %q; se esperaba %q", c.n, got, c.esperado)
		}
	}
}

func TestMesEnLetras(t *testing.T) {
	casos := []struct {
		n        int
		esperado string
	}{
		{1, "enero"},
		{6, "junio"},
		{12, "diciembre"},
		{0, "mes inválido"},
		{13, "mes inválido"},
	}
	for _, c := range casos {
		if got := mesEnLetras(c.n); got != c.esperado {
			t.Errorf("mesEnLetras(%d) = %q; se esperaba %q", c.n, got, c.esperado)
		}
	}
}

func TestClasificarNota(t *testing.T) {
	casos := []struct {
		nota     float64
		esperado string
	}{
		{59, "suspenso"},
		{60, "aprobado"},
		{74, "aprobado"},
		{75, "notable"},
		{89, "notable"},
		{90, "sobresaliente"},
		{100, "sobresaliente"},
	}
	for _, c := range casos {
		if got := clasificarNota(c.nota); got != c.esperado {
			t.Errorf("clasificarNota(%v) = %q; se esperaba %q", c.nota, got, c.esperado)
		}
	}
}

func TestDescribirValor(t *testing.T) {
	casos := []struct {
		v        interface{}
		esperado string
	}{
		{42, "entero: 42"},
		{-7, "entero: -7"},
		{"hola", "texto: hola"},
		{3.14, "decimal: 3.14"},
		{true, "tipo desconocido"},
	}
	for _, c := range casos {
		if got := describirValor(c.v); got != c.esperado {
			t.Errorf("describirValor(%v) = %q; se esperaba %q", c.v, got, c.esperado)
		}
	}
}