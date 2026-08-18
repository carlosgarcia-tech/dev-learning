package main

import "fmt"

import "errors"

var (
	errDivisionPorCero = errors.New("división por cero")
	errRaizNegativa    = errors.New("raíz cuadrada de un número negativo")
	errEdadInvalida    = errors.New("edad inválida")
)

// TODO: devuelve a/b. Si b es 0 devuelve errDivisionPorCero.
func dividir(a, b float64) (float64, error) {
	return 0, nil // TODO: completa la función
}

// TODO: devuelve la raíz cuadrada de n. Si n es negativo devuelve errRaizNegativa.
func raizCuadrada(n float64) (float64, error) {
	return 0, nil // TODO: completa la función
}

// TODO: convierte el texto a entero. Usa strconv.Atoi y propaga el error.
func parsearEntero(s string) (int, error) {
	return 0, nil // TODO: completa la función
}

// TODO: devuelve nil si la edad está entre 0 y 150 (incluidos); si no, errEdadInvalida.
func validarEdad(edad int) error {
	return nil // TODO: completa la función
}

func main() {
	if v, err := dividir(10, 2); err == nil {
		fmt.Println("10/2:", v)
	}
	if v, err := raizCuadrada(16); err == nil {
		fmt.Println("raiz 16:", v)
	}
	if v, err := parsearEntero("42"); err == nil {
		fmt.Println("parse 42:", v)
	}
	fmt.Println("edad 25:", validarEdad(25))
}
