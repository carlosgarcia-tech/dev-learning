package main

import (
	"errors"
	"fmt"
)

// TODO: devuelve n! (factorial). Si n es negativo devuelve un error.
func factorial(n int) (int, error) {
	return 0, nil // TODO: completa la función
}

// TODO: devuelve true si n es primo. Recuerda que 1 no es primo.
func esPrimo(n int) bool {
	return false // TODO: completa la función
}

// TODO: devuelve el máximo común divisor de a y b (algoritmo de Euclides).
func mcd(a, b int) int {
	return 0 // TODO: completa la función
}

// TODO: devuelve base elevado a exp (exp >= 0), sin usar el paquete math.
func potencia(base, exp int) int {
	return 0 // TODO: completa la función
}

var errFactorialNegativo = errors.New("el factorial no está definido para números negativos")

func main() {
	if f, err := factorial(5); err == nil {
		fmt.Println("5! =", f)
	}
	fmt.Println("7 es primo:", esPrimo(7))
	fmt.Println("mcd(12,18):", mcd(12, 18))
	fmt.Println("2^10:", potencia(2, 10))
}
