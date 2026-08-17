package main

import (
	"reflect"
	"testing"
)

func TestProductorConsumidor(t *testing.T) {
	if got := productorConsumidor(10, 3); got != 55 {
		t.Errorf("productorConsumidor(10, 3) = %d; se esperaba 55", got)
	}
}

func TestProductorConsumidorBufferUno(t *testing.T) {
	if got := productorConsumidor(1, 1); got != 1 {
		t.Errorf("productorConsumidor(1, 1) = %d; se esperaba 1", got)
	}
}

func TestProductorConsumidorBufferGrande(t *testing.T) {
	if got := productorConsumidor(4, 100); got != 10 {
		t.Errorf("productorConsumidor(4, 100) = %d; se esperaba 10", got)
	}
}

func TestLlenarBuffer(t *testing.T) {
	got := llenarBuffer(5, 5)
	if !reflect.DeepEqual(got, []int{0, 1, 2, 3, 4}) {
		t.Errorf("llenarBuffer(5, 5) = %v; se esperaba [0 1 2 3 4]", got)
	}
}

func TestLlenarBufferGrande(t *testing.T) {
	got := llenarBuffer(3, 10)
	if !reflect.DeepEqual(got, []int{0, 1, 2}) {
		t.Errorf("llenarBuffer(3, 10) = %v; se esperaba [0 1 2]", got)
	}
}

func TestLlenarBufferCero(t *testing.T) {
	if got := llenarBuffer(0, 2); !reflect.DeepEqual(got, []int{}) {
		t.Errorf("llenarBuffer(0, 2) = %v; se esperaba []", got)
	}
}