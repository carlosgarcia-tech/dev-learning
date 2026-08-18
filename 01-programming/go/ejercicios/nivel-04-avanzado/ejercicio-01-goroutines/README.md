# Ejercicio 01 — Goroutines

- **Nivel:** 4/5
- **Tema:** goroutines, `sync.WaitGroup` y canales de comunicación
- **Tiempo estimado:** 40 min

## Enunciado

Completa el archivo `main.go` para que:

1. `sumarConcurrente(ns []int, goroutines int) int` sume todos los números repartiendo el trabajo entre `goroutines` goroutines concurrentes. Si `goroutines <= 0` o es mayor que `len(ns)`, ajústalo a un valor sensato. Implementación sugerida:
   - Divide el slice en tramos (uno por goroutine).
   - Cada goroutine suma su tramo y envía el resultado por un canal.
   - Espera con `sync.WaitGroup`, cierra el canal y suma los parciales.
2. `procesarEnParalelo(ns []int, fn func(int) int, goroutines int) []int` aplique `fn` a cada elemento en paralelo y devuelva los resultados **en el mismo orden** que la entrada (usa un índice para escribir en la posición correcta).

## Requisitos

- [ ] `sumarConcurrente([1..10], 3)` devuelve `55` (igual con 1 o 10 goroutines).
- [ ] `sumarConcurrente([])` devuelve `0`.
- [ ] `procesarEnParalelo([1 2 3 4 5], doble, 3)` devuelve `[2 4 6 8 10]`.
- [ ] `procesarEnParalelo` preserva el orden de los resultados.
- [ ] `procesarEnParalelo(..., 0)` funciona (usa al menos 1 goroutine).
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para dividir en tramos: `tramo := (len(ns) + goroutines - 1) / goroutines` y recorre con `for i := 0; i < len(ns); i += tramo`.
- Canal con buffer `make(chan int, goroutines)` evita que los productores se bloqueen antes del `Wait`.
- No olvides `wg.Add(1)` por goroutine, `defer wg.Done()` dentro y `wg.Wait()` antes de leer los parciales.
- En `procesarEnParalelo` envía `(índice, resultado)` por un canal y rellena `resultados[indice]` al recibir, garantizando el orden.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "sync"

func sumarConcurrente(ns []int, goroutines int) int {
	if goroutines < 1 {
		goroutines = 1
	}
	if len(ns) == 0 {
		return 0
	}
	if goroutines > len(ns) {
		goroutines = len(ns)
	}
	parciales := make(chan int, goroutines)
	var wg sync.WaitGroup
	tramo := (len(ns) + goroutines - 1) / goroutines
	for inicio := 0; inicio < len(ns); inicio += tramo {
		fin := inicio + tramo
		if fin > len(ns) {
			fin = len(ns)
		}
		wg.Add(1)
		go func(a, b int) {
			defer wg.Done()
			suma := 0
			for _, n := range ns[a:b] {
				suma += n
			}
			parciales <- suma
		}(inicio, fin)
	}
	wg.Wait()
	close(parciales)
	total := 0
	for p := range parciales {
		total += p
	}
	return total
}

func procesarEnParalelo(ns []int, fn func(int) int, goroutines int) []int {
	if goroutines < 1 {
		goroutines = 1
	}
	resultados := make([]int, len(ns))
	if len(ns) == 0 {
		return resultados
	}
	if goroutines > len(ns) {
		goroutines = len(ns)
	}
	trabajo := make(chan struct {
		indice int
		valor  int
	})
	var wg sync.WaitGroup
	for i := 0; i < goroutines; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for t := range trabajo {
				resultados[t.indice] = fn(t.valor)
			}
		}()
	}
	for i, v := range ns {
		trabajo <- struct {
			indice int
			valor  int
		}{i, v}
	}
	close(trabajo)
	wg.Wait()
	return resultados
}
````

</details>