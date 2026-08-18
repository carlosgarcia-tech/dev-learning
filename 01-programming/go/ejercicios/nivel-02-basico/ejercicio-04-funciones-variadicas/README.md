# Ejercicio 04 — Funciones variádicas

- **Nivel:** 2/5
- **Tema:** parámetros variádicos (`...T`) y cómo expandirlos
- **Tiempo estimado:** 20 min

## Enunciado

Completa el archivo `main.go` para que:

1. `suma(nums ...int) int` sume todos los números recibidos. Sin argumentos devuelve `0`.
2. `concatenar(sep string, palabras ...string) string` una las palabras con el separador. Sin palabras devuelve `""`.
3. `mayor(nums ...int) (int, error)` devuelva el mayor y un error si no recibe ninguno (`errSinNumeros`).
4. `promedio(nums ...float64) float64` devuelva el promedio. Sin argumentos devuelve `0`.

## Requisitos

- [ ] `suma(1, 2, 3)` devuelve `6` y `suma()` devuelve `0`.
- [ ] `concatenar("-", "a", "b", "c")` devuelve `"a-b-c"`.
- [ ] `mayor(3, 9, 5, 1)` devuelve `9` y `mayor()` devuelve un error.
- [ ] `promedio(2, 4, 6)` devuelve `4`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Dentro de la función, `nums` es un slice normal: recórrelo con `range`.
- `strings.Join(palabras, sep)` hace exactamente lo que pide `concatenar`.
- Para comprobar si no se pasaron números: `if len(nums) == 0`.
- Si tienes un slice `s` y quieres pasarlo como variádicos, usa `f(s...)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import (
	"errors"
	"strings"
)

var errSinNumeros = errors.New("no se pasaron números")

func suma(nums ...int) int {
	total := 0
	for _, n := range nums {
		total += n
	}
	return total
}

func concatenar(sep string, palabras ...string) string {
	return strings.Join(palabras, sep)
}

func mayor(nums ...int) (int, error) {
	if len(nums) == 0 {
		return 0, errSinNumeros
	}
	m := nums[0]
	for _, n := range nums[1:] {
		if n > m {
			m = n
		}
	}
	return m, nil
}

func promedio(nums ...float64) float64 {
	if len(nums) == 0 {
		return 0
	}
	total := 0.0
	for _, n := range nums {
		total += n
	}
	return total / float64(len(nums))
}
````

</details>