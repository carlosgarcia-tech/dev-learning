package main

import (
	"reflect"
	"testing"
)

func TestIncrementar(t *testing.T) {
	n := 1
	incrementar(&n)
	if n != 2 {
		t.Errorf("incrementar: n = %d; se esperaba 2", n)
	}
}

func TestIncrementarParteDeCero(t *testing.T) {
	n := 0
	incrementar(&n)
	incrementar(&n)
	incrementar(&n)
	if n != 3 {
		t.Errorf("tres incrementos: n = %d; se esperaba 3", n)
	}
}

func TestIntercambiar(t *testing.T) {
	a, b := 10, 20
	intercambiar(&a, &b)
	if a != 20 || b != 10 {
		t.Errorf("intercambiar: a=%d, b=%d; se esperaba a=20, b=10", a, b)
	}
}

func TestDuplicarValores(t *testing.T) {
	ns := []int{1, 2, 3}
	duplicarValores(ns)
	esperado := []int{2, 4, 6}
	if !reflect.DeepEqual(ns, esperado) {
		t.Errorf("duplicarValores = %v; se esperaba %v", ns, esperado)
	}
}

func TestEnvejecer(t *testing.T) {
	p := Persona{Nombre: "Ana", Edad: 30}
	envejecer(&p)
	if p.Edad != 31 {
		t.Errorf("envejecer: Edad = %d; se esperaba 31", p.Edad)
	}
}