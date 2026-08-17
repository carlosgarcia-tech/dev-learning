package main

import (
	"strings"
	"testing"
)

func TestDividirSeguroOK(t *testing.T) {
	got, err := dividirSeguro(10, 2)
	if err != nil {
		t.Fatalf("dividirSeguro(10, 2) devolvió error: %v", err)
	}
	if got != 5 {
		t.Errorf("dividirSeguro(10, 2) = %d; se esperaba 5", got)
	}
}

func TestDividirSeguroPorCero(t *testing.T) {
	got, err := dividirSeguro(7, 0)
	if err == nil {
		t.Fatal("dividirSeguro(7, 0) debe devolver un error (panic recuperado)")
	}
	if got != 0 {
		t.Errorf("dividirSeguro(7, 0) = %d; se esperaba el valor cero 0", got)
	}
	if !strings.Contains(err.Error(), "división por cero") {
		t.Errorf("el error %q debe contener \"división por cero\"", err)
	}
}

func TestEjecutarSeguroSinPanic(t *testing.T) {
	llamada := false
	err := ejecutarSeguro(func() {
		llamada = true
	})
	if err != nil {
		t.Fatalf("ejecutarSeguro sin panic devolvió error: %v", err)
	}
	if !llamada {
		t.Error("la función pasada a ejecutarSeguro debe ejecutarse")
	}
}

func TestEjecutarSeguroConPanic(t *testing.T) {
	err := ejecutarSeguro(func() {
		panic("algo salió mal")
	})
	if err == nil {
		t.Fatal("ejecutarSeguro debe devolver un error cuando la función lanza panic")
	}
	if !strings.Contains(err.Error(), "algo salió mal") {
		t.Errorf("el error %q debe contener el mensaje del panic", err)
	}
}