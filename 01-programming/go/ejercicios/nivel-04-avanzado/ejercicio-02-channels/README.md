# Ejercicio 02 — Channels

- **Nivel:** 4/5
- **Tema:** canales, `chan` sin buffer, `for range` y `close`
- **Tiempo estimado:** 40 min

## Enunciado

Completa el archivo `main.go` para que:

1. `doblarEnCanal(ns []int) []int` envíe cada número doblado por un canal (con una goroutine productora) y recoja los valores recibidos en un slice.
2. `contarParesEnCanal(ns []int) int` envíe los números por un canal con buffer, lo cierre y cuente los pares al recibirlos.
3. `enviarYRecibir(n int) []int` envíe `0, 1, ..., n-1` por un canal con buffer y devuelva todos los valores recibidos.

## Requisitos

- [ ] `doblarEnCanal([1 2 3])` devuelve `[2 4 6]` y `doblarEnCanal([])` devuelve `[]`.
- [ ] `contarParesEnCanal([1 2 3 4 5 6])` devuelve `3` y `contarParesEnCanal([1 3 5])` devuelve `0`.
- [ ] `enviarYRecibir(5)` devuelve `[0 1 2 3 4]` y `enviarYRecibir(0)` devuelve `[]`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un canal se crea con `make(chan int)` (sin buffer) o `make(chan int, n)` (con buffer).
- `ch <- v` envía; `v := <-ch` recibe; `for v := range ch` recibe hasta que se cierra con `close(ch)`.
- Un canal sin buffer requiere que el productor y el consumidor estén listos a la vez: usa una goroutine productora.
- **Cierra el canal en el productor** (`defer close(ch)`) y recorre con `range` en el consumidor.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

func doblarEnCanal(ns []int) []int {
	ch := make(chan int)
	go func() {
		defer close(ch)
		for _, v := range ns {
			ch <- v * 2
		}
	}()
	resultado := []int{}
	for v := range ch {
		resultado = append(resultado, v)
	}
	return resultado
}

func contarParesEnCanal(ns []int) int {
	ch := make(chan int, len(ns))
	for _, v := range ns {
		ch <- v
	}
	close(ch)
	pares := 0
	for v := range ch {
		if v%2 == 0 {
			pares++
		}
	}
	return pares
}

func enviarYRecibir(n int) []int {
	ch := make(chan int, n)
	for i := 0; i < n; i++ {
		ch <- i
	}
	close(ch)
	resultado := []int{}
	for v := range ch {
		resultado = append(resultado, v)
	}
	return resultado
}
````

</details>