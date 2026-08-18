package main

import (
	"strings"
	"testing"
)

func TestNuevaPersona(t *testing.T) {
	p := nuevaPersona("Ana", 30, "Lima")
	if p.Nombre != "Ana" || p.Edad != 30 || p.Ciudad != "Lima" {
		t.Errorf("nuevaPersona devolvió %+v; se esperaba {Ana 30 Lima}", p)
	}
}

func TestEsMayorDeEdad(t *testing.T) {
	casos := []struct {
		edad     int
		esperado bool
	}{
		{17, false},
		{18, true},
		{30, true},
		{65, true},
	}
	for _, c := range casos {
		p := Persona{Nombre: "X", Edad: c.edad}
		if got := p.esMayorDeEdad(); got != c.esperado {
			t.Errorf("esMayorDeEdad(edad=%d) = %v; se esperaba %v", c.edad, got, c.esperado)
		}
	}
}

func TestPresentacion(t *testing.T) {
	p := nuevaPersona("Ana", 30, "Lima")
	esperado := "Ana, 30 años, ciudad de Lima"
	if got := p.presentacion(); got != esperado {
		t.Errorf("presentacion() = %q; se esperaba %q", got, esperado)
	}
}

func TestPresentacionReflejaOtrosValores(t *testing.T) {
	p := Persona{Nombre: "Pablo", Edad: 25, Ciudad: "Bogotá"}
	presentacion := p.presentacion()
	for _, parte := range []string{"Pablo", "25 años", "Bogotá"} {
		if !strings.Contains(presentacion, parte) {
			t.Errorf("presentacion %q debe contener %q", presentacion, parte)
		}
	}
}