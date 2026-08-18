package main

import (
	"reflect"
	"testing"
)

func TestSumarConcurrente(t *testing.T) {
	ns := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	if got := sumarConcurrente(ns, 3); got != 55 {
		t.Errorf("sumarConcurrente(ns, 3) = %d; se esperaba 55", got)
	}
	if got := sumarConcurrente(ns, 1); got != 55 {
		t.Errorf("sumarConcurrente(ns, 1) = %d; se esperaba 55", got)
	}
	if got := sumarConcurrente(ns, 10); got != 55 {
		t.Errorf("sumarConcurrente(ns, 10) = %d; se esperaba 55", got)
	}
}

func TestSumarConcurrenteVacio(t *testing.T) {
	if got := sumarConcurrente([]int{}, 4); got != 0 {
		t.Errorf("sumarConcurrente([]) = %d; se esperaba 0", got)
	}
}

func TestProcesarEnParaleloDobla(t *testing.T) {
	ns := []int{1, 2, 3, 4, 5}
	got := procesarEnParalelo(ns, func(n int) int { return n * 2 }, 3)
	esperado := []int{2, 4, 6, 8, 10}
	if !reflect.DeepEqual(got, esperado) {
		t.Errorf("procesarEnParalelo = %v; se esperaba %v", got, esperado)
	}
}

func TestProcesarEnParaleloPreservaOrden(t *testing.T) {
	ns := []int{10, 20, 30}
	got := procesarEnParalelo(ns, func(n int) int { return n + 1 }, 2)
	esperado := []int{11, 21, 31}
	if !reflect.DeepEqual(got, esperado) {
		t.Errorf("procesarEnParalelo = %v; se esperaba %v", got, esperado)
	}
}

func TestProcesarEnParaleloGoroutinesCero(t *testing.T) {
	got := procesarEnParalelo([]int{1, 2}, func(n int) int { return n * n }, 0)
	if !reflect.DeepEqual(got, []int{1, 4}) {
		t.Errorf("procesarEnParalelo(goroutines=0) = %v; se esperaba [1 4]", got)
	}
}