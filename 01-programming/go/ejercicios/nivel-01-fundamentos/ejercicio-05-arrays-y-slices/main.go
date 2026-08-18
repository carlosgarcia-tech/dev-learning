package main

import (
	"errors"
	"fmt"
)

// TODO: devuelve el promedio de los números. Si el slice está vacío devuelve 0.
func promedio(ns []float64) float64 {
	return 0 // TODO: completa la función
}

// TODO: devuelve un nuevo slice con los números en orden inverso (no modifiques el original).
func invertir(ns []int) []int {
	return nil // TODO: completa la función
}

// TODO: devuelve el mayor de los números y un error si el slice está vacío.
func maximo(ns []int) (int, error) {
	return 0, nil // TODO: completa la función
}

// TODO: devuelve un nuevo slice con los números, conservando la primera aparición y eliminando duplicados.
func eliminarDuplicados(ns []int) []int {
	return nil // TODO: completa la función
}

var errSliceVacio = errors.New("el slice está vacío")

func main() {
	fmt.Println("promedio:", promedio([]float64{1, 2, 3, 4}))
	fmt.Println("invertir:", invertir([]int{1, 2, 3}))
	if m, err := maximo([]int{5, 2, 9, 1}); err == nil {
		fmt.Println("maximo:", m)
	}
	fmt.Println("sin duplicados:", eliminarDuplicados([]int{1, 2, 2, 3}))
}
