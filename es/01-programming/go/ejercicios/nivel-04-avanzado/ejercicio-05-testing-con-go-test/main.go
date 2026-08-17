package main

import "fmt"

// TODO: devuelve a + b.
func suma(a, b int) int {
	return 0 // TODO: completa la función
}

// TODO: devuelve a * b.
func multiplica(a, b int) int {
	return 0 // TODO: completa la función
}

// TODO: devuelve true si n es par.
func esPar(n int) bool {
	return false // TODO: completa la función
}

// TODO: devuelve el mayor del slice y un error si está vacío.
func maximo(ns []int) (int, error) {
	return 0, nil // TODO: completa la función
}

func main() {
	fmt.Println(suma(2, 3))
	fmt.Println(multiplica(4, 5))
	fmt.Println("5 es par:", esPar(5))
	if m, err := maximo([]int{3, 9, 5}); err == nil {
		fmt.Println("maximo:", m)
	}
}