package main

import (
	"reflect"
	"testing"
)

func TestPromedio(t *testing.T) {
	casos := []struct {
		ns       []float64
		esperado float64
	}{
		{[]float64{1, 2, 3, 4}, 2.5},
		{[]float64{10, 20}, 15},
		{[]float64{}, 0},
		{[]float64{5}, 5},
	}
	for _, c := range casos {
		if got := promedio(c.ns); got != c.esperado {
			t.Errorf("promedio(%v) = %v; se esperaba %v", c.ns, got, c.esperado)
		}
	}
}

func TestInvertir(t *testing.T) {
	casos := []struct {
		ns       []int
		esperado []int
	}{
		{[]int{1, 2, 3}, []int{3, 2, 1}},
		{[]int{}, []int{}},
		{[]int{7}, []int{7}},
		{[]int{5, 5}, []int{5, 5}},
	}
	for _, c := range casos {
		if got := invertir(c.ns); !reflect.DeepEqual(got, c.esperado) {
			t.Errorf("invertir(%v) = %v; se esperaba %v", c.ns, got, c.esperado)
		}
	}
}

func TestMaximo(t *testing.T) {
	got, err := maximo([]int{5, 2, 9, 1})
	if err != nil {
		t.Fatalf("maximo devolvió error inesperado: %v", err)
	}
	if got != 9 {
		t.Errorf("maximo = %d; se esperaba 9", got)
	}

	if _, err := maximo([]int{}); err == nil {
		t.Error("maximo([]) debe devolver un error")
	}
}

func TestEliminarDuplicados(t *testing.T) {
	casos := []struct {
		ns       []int
		esperado []int
	}{
		{[]int{1, 2, 2, 3, 1}, []int{1, 2, 3}},
		{[]int{}, []int{}},
		{[]int{4, 4, 4}, []int{4}},
		{[]int{7, 8, 9}, []int{7, 8, 9}},
	}
	for _, c := range casos {
		if got := eliminarDuplicados(c.ns); !reflect.DeepEqual(got, c.esperado) {
			t.Errorf("eliminarDuplicados(%v) = %v; se esperaba %v", c.ns, got, c.esperado)
		}
	}
}