package main

import (
	"reflect"
	"testing"

	"ejercicio-05-paquetes-y-modulos/matematica"
)

func TestSuma(t *testing.T) {
	if got := matematica.Suma(2, 3); got != 5 {
		t.Errorf("Suma(2, 3) = %d; se esperaba 5", got)
	}
	if got := matematica.Suma(-1, 1); got != 0 {
		t.Errorf("Suma(-1, 1) = %d; se esperaba 0", got)
	}
}

func TestProducto(t *testing.T) {
	if got := matematica.Producto(4, 5); got != 20 {
		t.Errorf("Producto(4, 5) = %d; se esperaba 20", got)
	}
	if got := matematica.Producto(0, 100); got != 0 {
		t.Errorf("Producto(0, 100) = %d; se esperaba 0", got)
	}
}

func TestFactorial(t *testing.T) {
	casos := []struct {
		n        int
		esperado int
	}{
		{0, 1},
		{1, 1},
		{5, 120},
	}
	for _, c := range casos {
		got, err := matematica.Factorial(c.n)
		if err != nil {
			t.Errorf("Factorial(%d) devolvió error: %v", c.n, err)
		}
		if got != c.esperado {
			t.Errorf("Factorial(%d) = %d; se esperaba %d", c.n, got, c.esperado)
		}
	}
}

func TestFactorialNegativo(t *testing.T) {
	if _, err := matematica.Factorial(-1); err == nil {
		t.Error("Factorial(-1) debe devolver un error")
	}
}

func TestFibonacci(t *testing.T) {
	casos := []struct {
		n        int
		esperado []int
	}{
		{0, []int{}},
		{1, []int{0}},
		{7, []int{0, 1, 1, 2, 3, 5, 8}},
	}
	for _, c := range casos {
		if got := matematica.Fibonacci(c.n); !reflect.DeepEqual(got, c.esperado) {
			t.Errorf("Fibonacci(%d) = %v; se esperaba %v", c.n, got, c.esperado)
		}
	}
}