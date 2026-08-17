package main

import "testing"

func TestSumaPrimeros(t *testing.T) {
	casos := []struct {
		n        int
		esperado int
	}{
		{0, 0},
		{1, 1},
		{5, 15},
		{10, 55},
		{-3, 0},
	}
	for _, c := range casos {
		if got := sumaPrimeros(c.n); got != c.esperado {
			t.Errorf("sumaPrimeros(%d) = %d; se esperaba %d", c.n, got, c.esperado)
		}
	}
}

func TestTablaMultiplicar(t *testing.T) {
	tabla := tablaMultiplicar(3)
	if len(tabla) != 10 {
		t.Fatalf("la tabla debe tener 10 líneas, tiene %d", len(tabla))
	}
	esperadas := []string{
		"3 x 1 = 3",
		"3 x 5 = 15",
		"3 x 10 = 30",
	}
	for _, esperada := range esperadas {
		encontrada := false
		for _, linea := range tabla {
			if linea == esperada {
				encontrada = true
			}
		}
		if !encontrada {
			t.Errorf("la tabla debe contener %q; recibida: %v", esperada, tabla)
		}
	}
}

func TestContarVocales(t *testing.T) {
	casos := []struct {
		texto    string
		esperado int
	}{
		{"", 0},
		{"Hola Mundo", 4},
		{"xyz", 0},
		{"AEIOU", 5},
		{"Murcielago", 5},
	}
	for _, c := range casos {
		if got := contarVocales(c.texto); got != c.esperado {
			t.Errorf("contarVocales(%q) = %d; se esperaba %d", c.texto, got, c.esperado)
		}
	}
}

func TestFibonacci(t *testing.T) {
	casos := []struct {
		n        int
		esperado []int
	}{
		{0, []int{}},
		{1, []int{0}},
		{2, []int{0, 1}},
		{7, []int{0, 1, 1, 2, 3, 5, 8}},
	}
	for _, c := range casos {
		got := fibonacci(c.n)
		if len(got) != len(c.esperado) {
			t.Fatalf("fibonacci(%d) longitud = %d; se esperaba %d", c.n, len(got), len(c.esperado))
		}
		for i := range got {
			if got[i] != c.esperado[i] {
				t.Errorf("fibonacci(%d)[%d] = %d; se esperaba %d", c.n, i, got[i], c.esperado[i])
			}
		}
	}
}