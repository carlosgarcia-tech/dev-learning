package main

import (
	"reflect"
	"testing"
)

func TestAplicar(t *testing.T) {
	if got := aplicar(3, 4, func(a, b int) int { return a * b }); got != 12 {
		t.Errorf("aplicar(mult) = %d; se esperaba 12", got)
	}
	if got := aplicar(10, 5, func(a, b int) int { return a - b }); got != 5 {
		t.Errorf("aplicar(resta) = %d; se esperaba 5", got)
	}
}

func TestCrearContador(t *testing.T) {
	contador := crearContador()
	if got := contador(); got != 1 {
		t.Errorf("primera llamada = %d; se esperaba 1", got)
	}
	if got := contador(); got != 2 {
		t.Errorf("segunda llamada = %d; se esperaba 2", got)
	}
	if got := contador(); got != 3 {
		t.Errorf("tercera llamada = %d; se esperaba 3", got)
	}
}

func TestCrearContadorIndependientes(t *testing.T) {
	a := crearContador()
	b := crearContador()
	a()
	a()
	if got := a(); got != 3 {
		t.Errorf("contador a = %d; se esperaba 3", got)
	}
	if got := b(); got != 1 {
		t.Errorf("contador b = %d; se esperaba 1 (independiente)", got)
	}
}

func TestFiltrar(t *testing.T) {
	esPar := func(n int) bool { return n%2 == 0 }
	if got := filtrar([]int{1, 2, 3, 4, 5, 6}, esPar); !reflect.DeepEqual(got, []int{2, 4, 6}) {
		t.Errorf("filtrar(pares) = %v; se esperaba [2 4 6]", got)
	}
	if got := filtrar([]int{}, esPar); !reflect.DeepEqual(got, []int{}) {
		t.Errorf("filtrar([]) = %v; se esperaba []", got)
	}
}

func TestTransformar(t *testing.T) {
	doble := func(n int) int { return n * 2 }
	if got := transformar([]int{1, 2, 3}, doble); !reflect.DeepEqual(got, []int{2, 4, 6}) {
		t.Errorf("transformar(doble) = %v; se esperaba [2 4 6]", got)
	}
	cuadrado := func(n int) int { return n * n }
	if got := transformar([]int{2, 3, 4}, cuadrado); !reflect.DeepEqual(got, []int{4, 9, 16}) {
		t.Errorf("transformar(cuadrado) = %v; se esperaba [4 9 16]", got)
	}
}