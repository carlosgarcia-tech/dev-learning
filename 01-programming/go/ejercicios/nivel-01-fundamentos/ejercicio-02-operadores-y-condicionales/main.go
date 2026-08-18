package main

import "fmt"

// TODO: devuelve "menor de edad", "adulto" o "adulto mayor" según la edad (<18, <65, >=65).
func clasificarEdad(edad int) string {
	return "" // TODO: completa la función
}

// TODO: devuelve true si n es par y false si es impar.
func esPar(n int) bool {
	return false // TODO: completa la función
}

// TODO: devuelve el mayor de tres números.
func mayorDeTres(a, b, c int) int {
	return 0 // TODO: completa la función
}

// TODO: devuelve "suspenso" (<60), "aprobado" (<75), "notable" (<90) o "sobresaliente" (>=90).
func evaluarNota(nota float64) string {
	return "" // TODO: completa la función
}

func main() {
	fmt.Println(clasificarEdad(30))
	fmt.Println("4 es par:", esPar(4))
	fmt.Println("mayor de 3,9,5:", mayorDeTres(3, 9, 5))
	fmt.Println("nota 85:", evaluarNota(85))
}
