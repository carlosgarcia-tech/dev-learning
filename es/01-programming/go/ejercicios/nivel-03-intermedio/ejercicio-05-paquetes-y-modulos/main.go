package main

import (
	"ejercicio-05-paquetes-y-modulos/matematica"
	"fmt"
)

func main() {
	fmt.Println("Suma:", matematica.Suma(2, 3))
	fmt.Println("Producto:", matematica.Producto(4, 5))
	if f, err := matematica.Factorial(5); err == nil {
		fmt.Println("5!:", f)
	}
	fmt.Println("Fibonacci:", matematica.Fibonacci(8))
}