package main

import (
	"reflect"
	"testing"
)

func TestDoblarEnCanal(t *testing.T) {
	got := doblarEnCanal([]int{1, 2, 3})
	if !reflect.DeepEqual(got, []int{2, 4, 6}) {
		t.Errorf("doblarEnCanal = %v; se esperaba [2 4 6]", got)
	}
}

func TestDoblarEnCanalVacio(t *testing.T) {
	got := doblarEnCanal([]int{})
	if !reflect.DeepEqual(got, []int{}) {
		t.Errorf("doblarEnCanal([]) = %v; se esperaba []", got)
	}
}

func TestContarParesEnCanal(t *testing.T) {
	if got := contarParesEnCanal([]int{1, 2, 3, 4, 5, 6}); got != 3 {
		t.Errorf("contarParesEnCanal = %d; se esperaba 3", got)
	}
	if got := contarParesEnCanal([]int{1, 3, 5}); got != 0 {
		t.Errorf("contarParesEnCanal([1 3 5]) = %d; se esperaba 0", got)
	}
}

func TestEnviarYRecibir(t *testing.T) {
	got := enviarYRecibir(5)
	if !reflect.DeepEqual(got, []int{0, 1, 2, 3, 4}) {
		t.Errorf("enviarYRecibir(5) = %v; se esperaba [0 1 2 3 4]", got)
	}
	if got := enviarYRecibir(0); !reflect.DeepEqual(got, []int{}) {
		t.Errorf("enviarYRecibir(0) = %v; se esperaba []", got)
	}
}