package main

import "testing"

func TestSuma(t *testing.T) {
	casos := []struct {
		nums     []int
		esperado int
	}{
		{[]int{}, 0},
		{[]int{5}, 5},
		{[]int{1, 2, 3}, 6},
		{[]int{-1, -2, 3}, 0},
	}
	for _, c := range casos {
		if got := suma(c.nums...); got != c.esperado {
			t.Errorf("suma(%v) = %d; se esperaba %d", c.nums, got, c.esperado)
		}
	}
}

func TestConcatenar(t *testing.T) {
	if got := concatenar("-", "a", "b", "c"); got != "a-b-c" {
		t.Errorf("concatenar = %q; se esperaba %q", got, "a-b-c")
	}
	if got := concatenar(", "); got != "" {
		t.Errorf("concatenar sin palabras = %q; se esperaba \"\"", got)
	}
	if got := concatenar("+", "solo"); got != "solo" {
		t.Errorf("concatenar con una palabra = %q; se esperaba \"solo\"", got)
	}
}

func TestMayor(t *testing.T) {
	got, err := mayor(3, 9, 5, 1)
	if err != nil {
		t.Fatalf("mayor devolvió error inesperado: %v", err)
	}
	if got != 9 {
		t.Errorf("mayor = %d; se esperaba 9", got)
	}
	if _, err := mayor(); err == nil {
		t.Error("mayor() sin argumentos debe devolver un error")
	}
}

func TestPromedio(t *testing.T) {
	if got := promedio(2, 4, 6); got != 4 {
		t.Errorf("promedio(2,4,6) = %v; se esperaba 4", got)
	}
	if got := promedio(); got != 0 {
		t.Errorf("promedio() = %v; se esperaba 0", got)
	}
	if got := promedio(10, 20); got != 15 {
		t.Errorf("promedio(10,20) = %v; se esperaba 15", got)
	}
}