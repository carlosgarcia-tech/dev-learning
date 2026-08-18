package main

import (
	"errors"
	"fmt"
)

// TODO: devuelve la suma de todos los números pasados. Sin argumentos devuelve 0.
func suma(nums ...int) int {
	return 0 // TODO: completa la función
}

// TODO: une las palabras con el separador sep. Sin palabras devuelve "".
func concatenar(sep string, palabras ...string) string {
	return "" // TODO: completa la función
}

// TODO: devuelve el mayor de los números y un error si no se pasa ninguno.
func mayor(nums ...int) (int, error) {
	return 0, nil // TODO: completa la función
}

// TODO: devuelve el promedio de los números. Sin argumentos devuelve 0.
func promedio(nums ...float64) float64 {
	return 0 // TODO: completa la función
}

var errSinNumeros = errors.New("no se pasaron números")

func main() {
	fmt.Println("suma:", suma(1, 2, 3))
	fmt.Println("concat:", concatenar("-", "a", "b", "c"))
	if m, err := mayor(3, 9, 5); err == nil {
		fmt.Println("mayor:", m)
	}
	fmt.Println("promedio:", promedio(2, 4, 6))
}
