package main

import (
	"math"
	"testing"
)

func TestDividir(t *testing.T) {
	got, err := dividir(10, 2)
	if err != nil {
		t.Fatalf("dividir(10, 2) devolvió error: %v", err)
	}
	if got != 5 {
		t.Errorf("dividir(10, 2) = %v; se esperaba 5", got)
	}

	if _, err := dividir(1, 0); err == nil {
		t.Error("dividir(1, 0) debe devolver errDivisionPorCero")
	} else if err != errDivisionPorCero {
		t.Errorf("dividir(1, 0) devolvió %v; se esperaba errDivisionPorCero", err)
	}
}

func TestRaizCuadrada(t *testing.T) {
	got, err := raizCuadrada(16)
	if err != nil {
		t.Fatalf("raizCuadrada(16) devolvió error: %v", err)
	}
	if math.Abs(got-4) > 1e-9 {
		t.Errorf("raizCuadrada(16) = %v; se esperaba 4", got)
	}

	if _, err := raizCuadrada(-1); err == nil {
		t.Error("raizCuadrada(-1) debe devolver un error")
	} else if err != errRaizNegativa {
		t.Errorf("raizCuadrada(-1) devolvió %v; se esperaba errRaizNegativa", err)
	}
}

func TestParsearEntero(t *testing.T) {
	got, err := parsearEntero("42")
	if err != nil {
		t.Fatalf("parsearEntero(\"42\") devolvió error: %v", err)
	}
	if got != 42 {
		t.Errorf("parsearEntero(\"42\") = %d; se esperaba 42", got)
	}

	if _, err := parsearEntero("abc"); err == nil {
		t.Error("parsearEntero(\"abc\") debe devolver un error")
	}
}

func TestValidarEdad(t *testing.T) {
	for _, edad := range []int{0, 1, 30, 150} {
		if err := validarEdad(edad); err != nil {
			t.Errorf("validarEdad(%d) debe devolver nil, obtuvo %v", edad, err)
		}
	}
	for _, edad := range []int{-1, 151} {
		if err := validarEdad(edad); err != errEdadInvalida {
			t.Errorf("validarEdad(%d) debe devolver errEdadInvalida, obtuvo %v", edad, err)
		}
	}
}