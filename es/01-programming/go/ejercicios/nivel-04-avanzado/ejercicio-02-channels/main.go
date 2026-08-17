package main

import (
	"fmt"
)

// TODO: envía cada número por un canal en una goroutine y devuelve los valores recibidos (doblados).
func doblarEnCanal(ns []int) []int {
	return nil // TODO: completa la función
}

// TODO: envía los números por un canal (con buffer) y cuenta cuántos son pares al recibirlos.
func contarParesEnCanal(ns []int) int {
	return 0 // TODO: completa la función
}

// TODO: envía 0..n-1 por un canal con buffer y devuelve todos los valores recibidos.
func enviarYRecibir(n int) []int {
	return nil // TODO: completa la función
}

func main() {
	fmt.Println("dobles:", doblarEnCanal([]int{1, 2, 3}))
	fmt.Println("pares:", contarParesEnCanal([]int{1, 2, 3, 4, 5, 6}))
	fmt.Println("0..4:", enviarYRecibir(5))
}