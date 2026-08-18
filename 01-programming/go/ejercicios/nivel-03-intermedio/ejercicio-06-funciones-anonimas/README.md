# Ejercicio 06 — Funciones anónimas

- **Nivel:** 3/5
- **Tema:** funciones como valores, closures y funciones de orden superior
- **Tiempo estimado:** 30 min

## Enunciado

Completa el archivo `main.go` para que:

1. `aplicar(a, b int, op func(int, int) int) int` ejecute la función `op` con `a` y `b` y devuelva su resultado.
2. `crearContador() func() int` devuelva una función (closure) que en cada llamada devuelva `1`, `2`, `3`, ... Cada closure creado es independiente.
3. `filtrar(ns []int, f func(int) bool) []int` devuelva un nuevo slice con los elementos que cumplen la condición `f`.
4. `transformar(ns []int, f func(int) int) []int` devuelva un nuevo slice con cada elemento transformado por `f`.

## Requisitos

- [ ] `aplicar(3, 4, func(a, b int) int { return a * b })` devuelve `12`.
- [ ] Un closure de `crearContador` devuelve `1`, `2`, `3` en llamadas sucesivas.
- [ ] Dos closures creados con `crearContador` son independientes entre sí.
- [ ] `filtrar([1 2 3 4 5 6], esPar)` devuelve `[2 4 6]`.
- [ ] `transformar([1 2 3], doble)` devuelve `[2 4 6]`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Una función se puede pasar como argumento y llamarse como `op(a, b)`.
- Un **closure** captura variables de su entorno: declara `contador := 0` fuera del `return` y modifícala dentro.
- `filtrar` es como `filter` en otros lenguajes: recorre y solo hace `append` cuando `f(n)` es `true`.
- `transformar` es como `map`: construye el resultado con `f(n)` para cada `n`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

func aplicar(a, b int, op func(int, int) int) int {
	return op(a, b)
}

func crearContador() func() int {
	contador := 0
	return func() int {
		contador++
		return contador
	}
}

func filtrar(ns []int, f func(int) bool) []int {
	resultado := []int{}
	for _, n := range ns {
		if f(n) {
			resultado = append(resultado, n)
		}
	}
	return resultado
}

func transformar(ns []int, f func(int) int) []int {
	resultado := make([]int, len(ns))
	for i, n := range ns {
		resultado[i] = f(n)
	}
	return resultado
}
````

</details>