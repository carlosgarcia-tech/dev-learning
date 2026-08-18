# Ejercicio 03 — Slices avanzados

- **Nivel:** 3/5
- **Tema:** manipulación avanzada de slices: `append`, `copy`, `%` y fusión
- **Tiempo estimado:** 35 min

## Enunciado

Completa el archivo `main.go` para que:

1. `eliminarIndice(ns []int, i int) ([]int, error)` devuelva un nuevo slice sin el elemento del índice `i`. Si `i` no está entre `0` y `len(ns)-1`, devuelve `errIndiceFueraDeRango`.
2. `rotarIzquierda(ns []int, k int) []int` devuelva un nuevo slice rotado `k` posiciones a la izquierda. `k` puede ser mayor que la longitud (usa `k % len(ns)`).
3. `moverCerosAlFinal(ns []int) []int` devuelva un nuevo slice con los ceros al final, manteniendo el orden de los demás.
4. `fusionarOrdenado(a, b []int) []int` combine dos slices **ya ordenados** en uno solo ordenado.

## Requisitos

- [ ] `eliminarIndice([1 2 3 4], 1)` devuelve `[1 3 4]` y un índice fuera de rango devuelve `errIndiceFueraDeRango`.
- [ ] `rotarIzquierda([1 2 3 4 5], 2)` devuelve `[3 4 5 1 2]` y `rotarIzquierda([1 2 3], 7)` devuelve `[2 3 1]`.
- [ ] `moverCerosAlFinal([0 1 0 3 12])` devuelve `[1 3 12 0 0]`.
- [ ] `fusionarOrdenado([1 3 5], [2 4 6])` devuelve `[1 2 3 4 5 6]`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para eliminar el índice `i`: `append(ns[:i], ns[i+1:]...)` — pero cuidado: esto modifica el array subyacente. Para un slice nuevo usa `append([]int{}, ns[:i]...)` y luego `append(resultado, ns[i+1:]...)`.
- En `rotarIzquierda`: `k = k % len(ns)` (cuidado con `len(ns) == 0`) y devuelve `append(append([]int{}, ns[k:]...), ns[:k]...)`.
- En `moverCerosAlFinal` recorre el slice y añade los no-ceros; después rellena el resto con ceros (o cuenta ceros y usa `append`).
- En `fusionarOrdenado` usa dos índices `i`, `j` y compara `a[i]` con `b[j]`; cuando uno se agota, vuelca el resto.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "errors"

var errIndiceFueraDeRango = errors.New("índice fuera de rango")

func eliminarIndice(ns []int, i int) ([]int, error) {
	if i < 0 || i >= len(ns) {
		return nil, errIndiceFueraDeRango
	}
	resultado := append([]int{}, ns[:i]...)
	resultado = append(resultado, ns[i+1:]...)
	return resultado, nil
}

func rotarIzquierda(ns []int, k int) []int {
	if len(ns) == 0 {
		return []int{}
	}
	k = k % len(ns)
	resultado := append([]int{}, ns[k:]...)
	resultado = append(resultado, ns[:k]...)
	return resultado
}

func moverCerosAlFinal(ns []int) []int {
	resultado := []int{}
	ceros := 0
	for _, n := range ns {
		if n == 0 {
			ceros++
		} else {
			resultado = append(resultado, n)
		}
	}
	for i := 0; i < ceros; i++ {
		resultado = append(resultado, 0)
	}
	return resultado
}

func fusionarOrdenado(a, b []int) []int {
	resultado := []int{}
	i, j := 0, 0
	for i < len(a) && j < len(b) {
		if a[i] < b[j] {
			resultado = append(resultado, a[i])
			i++
		} else {
			resultado = append(resultado, b[j])
			j++
		}
	}
	resultado = append(resultado, a[i:]...)
	resultado = append(resultado, b[j:]...)
	return resultado
}
````

</details>