package main

import "fmt"

// Persona con nombre y edad (se usa con punteros).
type Persona struct {
	Nombre string
	Edad   int
}

// TODO: incrementa en 1 el valor al que apunta p.
func incrementar(p *int) {
	// TODO: completa la función
}

// TODO: intercambia los valores a los que apuntan a y b.
func intercambiar(a, b *int) {
	// TODO: completa la función
}

// TODO: duplica cada elemento del slice (modificando el slice original).
func duplicarValores(ns []int) {
	// TODO: completa la función
}

// TODO: incrementa en 1 la edad de la persona (modifica la persona original).
func envejecer(p *Persona) {
	// TODO: completa la función
}

func main() {
	n := 1
	incrementar(&n)
	fmt.Println("n:", n)
	a, b := 10, 20
	intercambiar(&a, &b)
	fmt.Println("a, b:", a, b)
	ns := []int{1, 2, 3}
	duplicarValores(ns)
	fmt.Println("duplicados:", ns)
	p := Persona{Nombre: "Ana", Edad: 30}
	envejecer(&p)
	fmt.Println("edad:", p.Edad)
}
