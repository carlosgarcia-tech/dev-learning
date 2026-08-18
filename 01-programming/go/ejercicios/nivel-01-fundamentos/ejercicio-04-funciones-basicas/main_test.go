package main

import "testing"

func TestFactorial(t *testing.T) {
	casos := []struct {
		n        int
		esperado int
	}{
		{0, 1},
		{1, 1},
		{5, 120},
		{10, 3628800},
	}
	for _, c := range casos {
		got, err := factorial(c.n)
		if err != nil {
			t.Errorf("factorial(%d) devolvió error inesperado: %v", c.n, err)
		}
		if got != c.esperado {
			t.Errorf("factorial(%d) = %d; se esperaba %d", c.n, got, c.esperado)
		}
	}
}

func TestFactorialNegativoDevuelveError(t *testing.T) {
	if _, err := factorial(-1); err == nil {
		t.Error("factorial(-1) debe devolver un error")
	}
}

func TestEsPrimo(t *testing.T) {
	casos := []struct {
		n        int
		esperado bool
	}{
		{2, true},
		{3, true},
		{7, true},
		{11, true},
		{1, false},
		{4, false},
		{9, false},
		{0, false},
	}
	for _, c := range casos {
		if got := esPrimo(c.n); got != c.esperado {
			t.Errorf("esPrimo(%d) = %v; se esperaba %v", c.n, got, c.esperado)
		}
	}
}

func TestMcd(t *testing.T) {
	casos := []struct {
		a, b     int
		esperado int
	}{
		{12, 18, 6},
		{7, 3, 1},
		{0, 5, 5},
		{48, 18, 6},
		{100, 100, 100},
	}
	for _, c := range casos {
		if got := mcd(c.a, c.b); got != c.esperado {
			t.Errorf("mcd(%d, %d) = %d; se esperaba %d", c.a, c.b, got, c.esperado)
		}
	}
}

func TestPotencia(t *testing.T) {
	casos := []struct {
		base, exp int
		esperado  int
	}{
		{2, 10, 1024},
		{5, 0, 1},
		{3, 3, 27},
		{10, 2, 100},
	}
	for _, c := range casos {
		if got := potencia(c.base, c.exp); got != c.esperado {
			t.Errorf("potencia(%d, %d) = %d; se esperaba %d", c.base, c.exp, got, c.esperado)
		}
	}
}