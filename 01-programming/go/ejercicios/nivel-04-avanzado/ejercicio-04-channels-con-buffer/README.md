# Ejercicio 04 — Channels con buffer

- **Nivel:** 4/5
- **Tema:** canales con buffer, productor-consumidor y sincronización
- **Tiempo estimado:** 35 min

## Enunciado

Completa el archivo `main.go` para que:

1. `productorConsumidor(n, buffer int) int`:
   - Crea un canal con capacidad `buffer`.
   - Una goroutine consumidora recorre el canal y acumula la suma.
   - El código principal envía `1, 2, ..., n`, cierra el canal y devuelve la suma.
   - Para devolver la suma desde la goroutine usa un segundo canal (o un canal con buffer de 1).
2. `llenarBuffer(n, buffer int) []int`:
   - Crea un canal con capacidad `buffer`, envía `0, 1, ..., n-1` (con `n <= buffer`, así los envíos no se bloquean), lo cierra y devuelve todos los valores recibidos.

> Nota: enviar más valores que la capacidad del buffer sin que nadie consuma **bloquea** la goroutine. Por eso en `llenarBuffer` los tests usan `n <= buffer`; en `productorConsumidor` el consumidor (goroutine) desbloquea los envíos aunque `n > buffer`.

## Requisitos

- [ ] `productorConsumidor(10, 3)` devuelve `55` (el consumidor permite `n > buffer`).
- [ ] `productorConsumidor(4, 100)` devuelve `10` (buffer grande, sin bloqueos).
- [ ] `llenarBuffer(5, 5)` devuelve `[0 1 2 3 4]` y `llenarBuffer(3, 10)` devuelve `[0 1 2]`.
- [ ] `llenarBuffer(0, 2)` devuelve `[]`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un canal con buffer permite enviar `buffer` valores sin que nadie reciba todavía.
- El consumidor debe terminar antes de devolver el resultado: espera con `sync.WaitGroup` o recibe por un canal de resultado.
- El patrón de resultado: la goroutine envía la suma a `resultado := make(chan int, 1)` y el código principal hace `return <-resultado`.
- Cierra el canal con `close(ch)` tras el último envío para que el `range` del consumidor termine.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

func productorConsumidor(n, buffer int) int {
	ch := make(chan int, buffer)
	resultado := make(chan int, 1)
	go func() {
		total := 0
		for v := range ch {
			total += v
		}
		resultado <- total
	}()
	for i := 1; i <= n; i++ {
		ch <- i
	}
	close(ch)
	return <-resultado
}

func llenarBuffer(n, buffer int) []int {
	ch := make(chan int, buffer)
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