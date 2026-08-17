package main

import "testing"

func TestEsPalindromo(t *testing.T) {
	casos := []struct {
		s        string
		esperado bool
	}{
		{"ana", true},
		{"reconocer", true},
		{"anita lava la tina", true},
		{"luz azul", true},
		{"hola", false},
		{"programacion", false},
	}
	for _, c := range casos {
		if got := esPalindromo(c.s); got != c.esperado {
			t.Errorf("esPalindromo(%q) = %v; se esperaba %v", c.s, got, c.esperado)
		}
	}
}

func TestInvertir(t *testing.T) {
	casos := []struct {
		s        string
		esperado string
	}{
		{"", ""},
		{"abc", "cba"},
		{"hola mundo", "odnum aloh"},
		{"áéí", "íéá"},
	}
	for _, c := range casos {
		if got := invertir(c.s); got != c.esperado {
			t.Errorf("invertir(%q) = %q; se esperaba %q", c.s, got, c.esperado)
		}
	}
}

func TestContarPalabrasCadena(t *testing.T) {
	casos := []struct {
		s        string
		esperado int
	}{
		{"", 0},
		{"hola", 1},
		{"hola mundo go", 3},
		{"  con  espacios  extra  ", 3},
	}
	for _, c := range casos {
		if got := contarPalabrasCadena(c.s); got != c.esperado {
			t.Errorf("contarPalabrasCadena(%q) = %d; se esperaba %d", c.s, got, c.esperado)
		}
	}
}

func TestCapitalizar(t *testing.T) {
	casos := []struct {
		s        string
		esperado string
	}{
		{"hola mundo", "Hola Mundo"},
		{"go es genial", "Go Es Genial"},
		{"", ""},
		{"solo", "Solo"},
	}
	for _, c := range casos {
		if got := capitalizar(c.s); got != c.esperado {
			t.Errorf("capitalizar(%q) = %q; se esperaba %q", c.s, got, c.esperado)
		}
	}
}