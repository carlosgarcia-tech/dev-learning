package main

import (
	"reflect"
	"testing"
)

func TestContarPalabras(t *testing.T) {
	got := contarPalabras("hola mundo hola go")
	esperado := map[string]int{"hola": 2, "mundo": 1, "go": 1}
	if !reflect.DeepEqual(got, esperado) {
		t.Errorf("contarPalabras = %v; se esperaba %v", got, esperado)
	}
}

func TestContarPalabrasVacio(t *testing.T) {
	got := contarPalabras("")
	if got == nil || len(got) != 0 {
		t.Errorf("contarPalabras(\"\") debe devolver un mapa vacío, obtuvo %v", got)
	}
}

func TestSumarValores(t *testing.T) {
	casos := []struct {
		m        map[string]int
		esperado int
	}{
		{map[string]int{"a": 2, "b": 3}, 5},
		{map[string]int{}, 0},
		{map[string]int{"x": -5, "y": 5}, 0},
	}
	for _, c := range casos {
		if got := sumarValores(c.m); got != c.esperado {
			t.Errorf("sumarValores(%v) = %d; se esperaba %d", c.m, got, c.esperado)
		}
	}
}

func TestPalabraMasFrecuente(t *testing.T) {
	palabra, cantidad := palabraMasFrecuente("la casa la luna la sol")
	if palabra != "la" {
		t.Errorf("palabraMasFrecuente: palabra = %q; se esperaba \"la\"", palabra)
	}
	if cantidad != 3 {
		t.Errorf("palabraMasFrecuente: cantidad = %d; se esperaba 3", cantidad)
	}
}

func TestPalabraMasFrecuenteUnaSola(t *testing.T) {
	palabra, cantidad := palabraMasFrecuente("solo")
	if palabra != "solo" || cantidad != 1 {
		t.Errorf("palabraMasFrecuente(\"solo\") = (%q, %d); se esperaba (\"solo\", 1)", palabra, cantidad)
	}
}

func TestInvertirMapa(t *testing.T) {
	got := invertirMapa(map[string]int{"a": 1, "b": 2})
	esperado := map[int]string{1: "a", 2: "b"}
	if !reflect.DeepEqual(got, esperado) {
		t.Errorf("invertirMapa = %v; se esperaba %v", got, esperado)
	}
}