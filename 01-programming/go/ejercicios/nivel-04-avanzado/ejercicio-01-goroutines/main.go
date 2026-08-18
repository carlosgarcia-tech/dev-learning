package main

import "fmt"

// TODO: suma todos los números repartiendo el trabajo entre "goroutines" goroutines concurrentes.
// Usa sync.WaitGroup y un canal para acumular las sumas parciales.
func sumarConcurrente(ns []int, goroutines int) int {
	return 0 // TODO: completa la función
}

// TODO: aplica fn a cada elemento y devuelve los resultados en el mismo orden,
// procesando en paralelo con "goroutines" goroutines.
func procesarEnParalelo(ns []int, fn func(int) int, goroutines int) []int {
	return nil // TODO: completa la función
}

func main() {
	ns := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	fmt.Println("suma concurrente:", sumarConcurrente(ns, 3))
	fmt.Println("dobles:", procesarEnParalelo(ns, func(n int) int { return n * 2 }, 4))
}