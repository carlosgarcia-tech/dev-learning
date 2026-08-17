package main

import (
	"reflect"
	"testing"
)

func TestEliminarIndice(t *testing.T) {
	got, err := eliminarIndice([]int{1, 2, 3, 4}, 1)
	if err != nil {
		t.Fatalf("eliminarIndice devolvió error: %v", err)
	}
	if !reflect.DeepEqual(got, []int{1, 3, 4}) {
		t.Errorf("eliminarIndice = %v; se esperaba [1 3 4]", got)
	}

	got, err = eliminarIndice([]int{1, 2, 3}, 0)
	if err != nil || !reflect.DeepEqual(got, []int{2, 3}) {
		t.Errorf("eliminarIndice(índice 0) = %v, %v; se esperaba [2 3]", got, err)
	}

	got, err = eliminarIndice([]int{1}, 0)
	if err != nil || !reflect.DeepEqual(got, []int{}) {
		t.Errorf("eliminarIndice(slice de 1) = %v, %v; se esperaba []", got, err)
	}
}

func TestEliminarIndiceFueraDeRango(t *testing.T) {
	if _, err := eliminarIndice([]int{1, 2}, 5); err != errIndiceFueraDeRango {
		t.Errorf("eliminarIndice(índice 5) debe devolver errIndiceFueraDeRango, obtuvo %v", err)
	}
	if _, err := eliminarIndice([]int{1, 2}, -1); err != errIndiceFueraDeRango {
		t.Errorf("eliminarIndice(índice -1) debe devolver errIndiceFueraDeRango, obtuvo %v", err)
	}
}

func TestRotarIzquierda(t *testing.T) {
	casos := []struct {
		ns       []int
		k        int
		esperado []int
	}{
		{[]int{1, 2, 3, 4, 5}, 2, []int{3, 4, 5, 1, 2}},
		{[]int{1, 2, 3, 4, 5}, 0, []int{1, 2, 3, 4, 5}},
		{[]int{1, 2, 3, 4, 5}, 5, []int{1, 2, 3, 4, 5}},
		{[]int{1, 2, 3}, 7, []int{2, 3, 1}},
		{[]int{}, 3, []int{}},
	}
	for _, c := range casos {
		if got := rotarIzquierda(c.ns, c.k); !reflect.DeepEqual(got, c.esperado) {
			t.Errorf("rotarIzquierda(%v, %d) = %v; se esperaba %v", c.ns, c.k, got, c.esperado)
		}
	}
}

func TestMoverCerosAlFinal(t *testing.T) {
	casos := []struct {
		ns       []int
		esperado []int
	}{
		{[]int{0, 1, 0, 3, 12}, []int{1, 3, 12, 0, 0}},
		{[]int{1, 2, 3}, []int{1, 2, 3}},
		{[]int{0, 0, 0}, []int{0, 0, 0}},
		{[]int{}, []int{}},
	}
	for _, c := range casos {
		if got := moverCerosAlFinal(c.ns); !reflect.DeepEqual(got, c.esperado) {
			t.Errorf("moverCerosAlFinal(%v) = %v; se esperaba %v", c.ns, got, c.esperado)
		}
	}
}

func TestFusionarOrdenado(t *testing.T) {
	casos := []struct {
		a, b     []int
		esperado []int
	}{
		{[]int{1, 3, 5}, []int{2, 4, 6}, []int{1, 2, 3, 4, 5, 6}},
		{[]int{}, []int{1, 2}, []int{1, 2}},
		{[]int{1, 2}, []int{}, []int{1, 2}},
		{[]int{1, 1, 2}, []int{1, 3}, []int{1, 1, 1, 2, 3}},
	}
	for _, c := range casos {
		if got := fusionarOrdenado(c.a, c.b); !reflect.DeepEqual(got, c.esperado) {
			t.Errorf("fusionarOrdenado(%v, %v) = %v; se esperaba %v", c.a, c.b, got, c.esperado)
		}
	}
}