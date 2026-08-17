package main

import (
	"fmt"
	"testing"
)

func TestSuma(t *testing.T) {
	casos := []struct {
		a, b, esperado int
	}{
		{1, 2, 3},
		{0, 0, 0},
		{-1, 1, 0},
		{100, 250, 350},
	}
	for _, c := range casos {
		t.Run(fmt.Sprintf("%d+%d", c.a, c.b), func(t *testing.T) {
			if got := suma(c.a, c.b); got != c.esperado {
				t.Errorf("suma(%d, %d) = %d; se esperaba %d", c.a, c.b, got, c.esperado)
			}
		})
	}
}

func TestMultiplica(t *testing.T) {
	casos := []struct {
		a, b, esperado int
	}{
		{4, 5, 20},
		{0, 100, 0},
		{-3, 2, -6},
		{7, 7, 49},
	}
	for _, c := range casos {
		t.Run(fmt.Sprintf("%dx%d", c.a, c.b), func(t *testing.T) {
			if got := multiplica(c.a, c.b); got != c.esperado {
				t.Errorf("multiplica(%d, %d) = %d; se esperaba %d", c.a, c.b, got, c.esperado)
			}
		})
	}
}

func TestEsPar(t *testing.T) {
	casos := []struct {
		n        int
		esperado bool
	}{
		{2, true},
		{3, false},
		{0, true},
		{-4, true},
	}
	for _, c := range casos {
		t.Run(fmt.Sprintf("esPar(%d)", c.n), func(t *testing.T) {
			if got := esPar(c.n); got != c.esperado {
				t.Errorf("esPar(%d) = %v; se esperaba %v", c.n, got, c.esperado)
			}
		})
	}
}

func TestMaximo(t *testing.T) {
	casos := []struct {
		nombre   string
		ns       []int
		esperado int
		hayError bool
	}{
		{"varios", []int{3, 9, 5}, 9, false},
		{"negativos", []int{-1, -5, -2}, -1, false},
		{"uno", []int{7}, 7, false},
		{"vacio", []int{}, 0, true},
	}
	for _, c := range casos {
		t.Run(c.nombre, func(t *testing.T) {
			got, err := maximo(c.ns)
			if c.hayError {
				if err == nil {
					t.Error("maximo([]) debe devolver un error")
				}
				return
			}
			if err != nil {
				t.Fatalf("maximo(%v) devolvió error: %v", c.ns, err)
			}
			if got != c.esperado {
				t.Errorf("maximo(%v) = %d; se esperaba %d", c.ns, got, c.esperado)
			}
		})
	}
}