package main

import "fmt"

// TODO: devuelve un mapa con el número de veces que aparece cada palabra (separadas por espacios).
func contarPalabras(texto string) map[string]int {
	return nil // TODO: completa la función
}

// TODO: devuelve la suma de todos los valores del mapa.
func sumarValores(m map[string]int) int {
	return 0 // TODO: completa la función
}

// TODO: devuelve la palabra más frecuente y cuántas veces aparece. En empate, cualquiera es válida.
func palabraMasFrecuente(texto string) (string, int) {
	return "", 0 // TODO: completa la función
}

// TODO: devuelve un mapa invertido: claves pasan a ser valores y viceversa (los valores son únicos).
func invertirMapa(m map[string]int) map[int]string {
	return nil // TODO: completa la función
}

func main() {
	fmt.Println("palabras:", contarPalabras("hola mundo hola"))
	fmt.Println("suma:", sumarValores(map[string]int{"a": 2, "b": 3}))
	palabra, veces := palabraMasFrecuente("la casa la luna la sol")
	fmt.Println("mas frecuente:", palabra, veces)
	fmt.Println("invertido:", invertirMapa(map[string]int{"a": 1, "b": 2}))
}
