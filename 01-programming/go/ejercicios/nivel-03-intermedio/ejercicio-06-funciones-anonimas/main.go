package main

import "fmt"

// TODO: aplica la operación op a a y b y devuelve el resultado.
func aplicar(a, b int, op func(int, int) int) int {
	return 0 // TODO: completa la función
}

// TODO: devuelve un closure que cuenta: cada llamada devuelve 1, 2, 3, ...
func crearContador() func() int {
	return func() int { return 0 } // TODO: completa la función
}

// TODO: devuelve un nuevo slice con los elementos que cumplen la condición f.
func filtrar(ns []int, f func(int) bool) []int {
	return nil // TODO: completa la función
}

// TODO: devuelve un nuevo slice con cada elemento transformado por f.
func transformar(ns []int, f func(int) int) []int {
	return nil // TODO: completa la función
}

func main() {
	contador := crearContador()
	fmt.Println(aplicar(3, 4, func(a, b int) int { return a * b }))
	fmt.Println(contador(), contador(), contador())
	esPar := func(n int) bool { return n%2 == 0 }
	fmt.Println(filtrar([]int{1, 2, 3, 4, 5, 6}, esPar))
	fmt.Println(transformar([]int{1, 2, 3}, func(n int) int { return n * 2 }))
}