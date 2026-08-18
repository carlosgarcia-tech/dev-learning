package main

import "fmt"

// TODO: un productor envía 1..n por un canal con buffer; un consumidor (goroutine) suma y devuelve el total.
func productorConsumidor(n, buffer int) int {
	return 0 // TODO: completa la función
}

// TODO: llena un canal con buffer con 0..n-1 y devuelve todos los valores recibidos.
func llenarBuffer(n, buffer int) []int {
	return nil // TODO: completa la función
}

func main() {
	fmt.Println("suma 1..10 con buffer 3:", productorConsumidor(10, 3))
	fmt.Println("0..4 con buffer 2:", llenarBuffer(5, 2))
}