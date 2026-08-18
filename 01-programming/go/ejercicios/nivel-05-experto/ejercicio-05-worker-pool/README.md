# Ejercicio 05 — Worker pool

- **Nivel:** 5/5
- **Tema:** patrón worker pool: goroutines trabajadoras, canal de trabajo y resultados ordenados
- **Tiempo estimado:** 60 min

## Enunciado

Implementa un **worker pool**: un número fijo de goroutines procesan tareas que llegan por un canal.

Completa `main.go`:

1. `NuevoWorkerPool(workers int) *WorkerPool` → devuelve un pool; si `workers < 1`, úsalo como `1`.
2. `(p *WorkerPool) Procesar(tareas []int, fn func(int) int) []int`:
   - Lanza `p.workers` goroutines que leen del canal `tareas` y guardan `fn(valor)` en la posición `indice`.
   - El hilo principal (o una goroutine productora) envía cada `(indice, valor)` por el canal y lo cierra.
   - Espera con `p.wg.Wait()` y devuelve el slice de resultados **en el mismo orden** que la entrada.

## Requisitos

- [ ] `Procesar([1 2 3 4], doble)` con 2 workers devuelve `[2 4 6 8]`.
- [ ] `Procesar([5 6 7], cuadrado)` con 3 workers devuelve `[25 36 49]`.
- [ ] `Procesar([])` devuelve un slice vacío sin colgarse.
- [ ] `NuevoWorkerPool(0)` funciona como si tuviera 1 worker.
- [ ] Los resultados preservan el orden de entrada incluso con varios workers.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El canal debe ser **sin buffer** (`make(chan trabajo)`); un productor lo envía y las workers lo consumen.
- Cada worker: `for t := range canal { resultados[t.indice] = fn(t.valor) }`.
- El productor puede ser una goroutine que envía todos los `(indice, valor)` y luego `close(canal)`.
- `wg.Add(1)` por worker, `defer wg.Done()` dentro; el hilo principal llama `wg.Wait()`.
- Escribir cada resultado en su índice garantiza el orden sin necesidad de locks.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "sync"

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

func NuevoWorkerPool(workers int) *WorkerPool {
	if workers < 1 {
		workers = 1
	}
	return &WorkerPool{workers: workers}
}

func (p *WorkerPool) Procesar(tareas []int, fn func(int) int) []int {
	resultados := make([]int, len(tareas))
	if len(tareas) == 0 {
		return resultados
	}
	canalTrabajo := make(chan trabajo)
	go func() {
		for i, v := range tareas {
			canalTrabajo <- trabajo{indice: i, valor: v}
		}
		close(canalTrabajo)
	}()
	for i := 0; i < p.workers; i++ {
		p.wg.Add(1)
		go func() {
			defer p.wg.Done()
			for t := range canalTrabajo {
				resultados[t.indice] = fn(t.valor)
			}
		}()
	}
	p.wg.Wait()
	return resultados
}
````

</details>