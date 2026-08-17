package main

import (
	"errors"
	"fmt"
)

// TODO: devuelve un nuevo slice sin el elemento del índice i. Si i es inválido devuelve un error.
func eliminarIndice(ns []int, i int) ([]int, error) {
	return nil, nil // TODO: completa la función
}

// TODO: devuelve un nuevo slice rotado k posiciones a la izquierda (k puede ser mayor que len(ns)).
func rotarIzquierda(ns []int, k int) []int {
	return nil // TODO: completa la función
}

// TODO: devuelve un nuevo slice con los ceros movidos al final, manteniendo el orden del resto.
func moverCerosAlFinal(ns []int) []int {
	return nil // TODO: completa la función
}

// TODO: fusiona dos slices ordenados de menor a mayor en uno solo ordenado.
func fusionarOrdenado(a, b []int) []int {
	return nil // TODO: completa la función
}

var errIndiceFueraDeRango = errors.New("índice fuera de rango")

func main() {
	if r, err := eliminarIndice([]int{1, 2, 3, 4}, 1); err == nil {
		fmt.Println("eliminarIndice:", r)
	}
	fmt.Println("rotarIzquierda:", rotarIzquierda([]int{1, 2, 3, 4, 5}, 2))
	fmt.Println("moverCerosAlFinal:", moverCerosAlFinal([]int{0, 1, 0, 3, 12}))
	fmt.Println("fusionarOrdenado:", fusionarOrdenado([]int{1, 3, 5}, []int{2, 4, 6}))
}
