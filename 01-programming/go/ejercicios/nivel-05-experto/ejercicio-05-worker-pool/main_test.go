package main

import (
	"reflect"
	"testing"
)

func TestProcesarDobla(t *testing.T) {
	pool := NuevoWorkerPool(2)
	got := pool.Procesar([]int{1, 2, 3, 4}, func(n int) int { return n * 2 })
	if !reflect.DeepEqual(got, []int{2, 4, 6, 8}) {
		t.Errorf("Procesar(doble) = %v; se esperaba [2 4 6 8]", got)
	}
}

func TestProcesarCuadrados(t *testing.T) {
	pool := NuevoWorkerPool(3)
	got := pool.Procesar([]int{5, 6, 7}, func(n int) int { return n * n })
	if !reflect.DeepEqual(got, []int{25, 36, 49}) {
		t.Errorf("Procesar(cuadrado) = %v; se esperaba [25 36 49]", got)
	}
}

func TestProcesarVacio(t *testing.T) {
	pool := NuevoWorkerPool(2)
	got := pool.Procesar([]int{}, func(n int) int { return n })
	if !reflect.DeepEqual(got, []int{}) {
		t.Errorf("Procesar([]) = %v; se esperaba []", got)
	}
}

func TestProcesarWorkersCero(t *testing.T) {
	pool := NuevoWorkerPool(0)
	got := pool.Procesar([]int{3, 4}, func(n int) int { return n + 1 })
	if !reflect.DeepEqual(got, []int{4, 5}) {
		t.Errorf("Procesar(workers=0) = %v; se esperaba [4 5]", got)
	}
}

func TestProcesarPreservaOrden(t *testing.T) {
	entrada := []int{10, 20, 30, 40, 50}
	pool := NuevoWorkerPool(4)
	got := pool.Procesar(entrada, func(n int) int { return n * 10 })
	esperado := []int{100, 200, 300, 400, 500}
	if !reflect.DeepEqual(got, esperado) {
		t.Errorf("Procesar = %v; se esperaba %v", got, esperado)
	}
}