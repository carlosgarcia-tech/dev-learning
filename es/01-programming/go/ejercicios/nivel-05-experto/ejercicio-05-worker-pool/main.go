package main

import (
	"fmt"
	"sync"
)

// trabajo es una unidad de trabajo con su índice en la lista original.
type trabajo struct {
	indice int
	valor  int
}

// WorkerPool procesa tareas con un número fijo de goroutines trabajadoras.
type WorkerPool struct {
	workers int
	tareas  chan trabajo
	wg      sync.WaitGroup
}

// TODO: devuelve un worker pool con el número de trabajadores dado (si es < 1 usa 1).
func NuevoWorkerPool(workers int) *WorkerPool {
	return &WorkerPool{workers: workers} // TODO: ajusta workers < 1 a 1
}

// TODO: procesa cada tarea con fn usando los trabajadores del pool y devuelve los resultados en el mismo orden.
func (p *WorkerPool) Procesar(tareas []int, fn func(int) int) []int {
	return nil // TODO: completa la función
}

func main() {
	pool := NuevoWorkerPool(3)
	resultados := pool.Procesar([]int{1, 2, 3, 4, 5, 6}, func(n int) int { return n * n })
	fmt.Println("cuadrados:", resultados)
}