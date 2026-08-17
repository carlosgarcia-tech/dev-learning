package main

import (
	"fmt"
	"time"
)

// TODO: lee de ambos canales hasta que los dos estén cerrados, usando select, y devuelve todos los valores.
func combinarCanales(a, b <-chan int) []int {
	return nil // TODO: completa la función
}

// TODO: devuelve el primer valor disponible de cualquiera de los dos canales (usa select).
func recibirDeCualquiera(a, b <-chan int) int {
	return 0 // TODO: completa la función
}

// TODO: devuelve (valor, true) si el canal entrega un valor antes de que pasen ms milisegundos;
// si se agota el tiempo devuelve (0, false). Usa select con time.After.
func conTimeout(canal <-chan int, ms time.Duration) (int, bool) {
	return 0, false // TODO: completa la función
}

func main() {
	a := make(chan int, 2)
	b := make(chan int, 2)
	a <- 1
	b <- 100
	fmt.Println("primer valor:", recibirDeCualquiera(a, b))
}