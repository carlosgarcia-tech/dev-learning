# Ejercicio 05 — Arrays y slices

- **Nivel:** 1/5
- **Tema:** `[]T`, `append`, `len`, `range` y operaciones con slices
- **Tiempo estimado:** 30 min

## Enunciado

Completa el archivo `main.go` para que:

1. `promedio(ns []float64) float64` devuelva el promedio de los números. Si el slice está vacío devuelve `0`.
2. `invertir(ns []int) []int` devuelva un **nuevo** slice con los números en orden inverso, sin modificar el original.
3. `maximo(ns []int) (int, error)` devuelva el mayor de los números. Si el slice está vacío devuelve `errSliceVacio`.
4. `eliminarDuplicados(ns []int) []int` devuelva un nuevo slice conservando la primera aparición de cada número.

## Requisitos

- [ ] `promedio([1 2 3 4])` devuelve `2.5` y `promedio([])` devuelve `0`.
- [ ] `invertir([1 2 3])` devuelve `[3 2 1]` y no modifica el slice original.
- [ ] `maximo([5 2 9 1])` devuelve `(9, nil)` y `maximo([])` devuelve un error.
- [ ] `eliminarDuplicados([1 2 2 3 1])` devuelve `[1 2 3]`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa `len(ns)` para recorrer el slice por índice y `for i := len(ns)-1; i >= 0; i--` para invertir.
- En `invertir` crea un slice nuevo: `resultado := make([]int, len(ns))` y rellena por índices.
- Para `maximo` guarda el primero como candidato y compara con el resto.
- Para `eliminarDuplicados` usa un `map[int]bool` como "visto" y `append` para construir el resultado.
- Recuerda: pasar un slice a una función no lo copia; por eso debes construir otro explícitamente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "errors"

var errSliceVacio = errors.New("el slice está vacío")

func promedio(ns []float64) float64 {
	if len(ns) == 0 {
		return 0
	}
	suma := 0.0
	for _, n := range ns {
		suma += n
	}
	return suma / float64(len(ns))
}

func invertir(ns []int) []int {
	resultado := make([]int, len(ns))
	for i := 0; i < len(ns); i++ {
		resultado[i] = ns[len(ns)-1-i]
	}
	return resultado
}

func maximo(ns []int) (int, error) {
	if len(ns) == 0 {
		return 0, errSliceVacio
	}
	mayor := ns[0]
	for _, n := range ns[1:] {
		if n > mayor {
			mayor = n
		}
	}
	return mayor, nil
}

func eliminarDuplicados(ns []int) []int {
	vistos := make(map[int]bool)
	resultado := []int{}
	for _, n := range ns {
		if !vistos[n] {
			vistos[n] = true
			resultado = append(resultado, n)
		}
	}
	return resultado
}
````

</details>