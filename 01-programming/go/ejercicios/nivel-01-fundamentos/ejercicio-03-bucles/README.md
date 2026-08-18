# Ejercicio 03 — Bucles

- **Nivel:** 1/5
- **Tema:** `for` clásico, `for` con `range` y acumulación de resultados
- **Tiempo estimado:** 25 min

## Enunciado

Completa el archivo `main.go` para que:

1. `sumaPrimeros(n int) int` sume `1 + 2 + ... + n`. Si `n <= 0` devuelve `0`.
2. `tablaMultiplicar(n int) []string` devuelva un slice con las 10 líneas `"n x i = resultado"` para `i` de 1 a 10.
3. `contarVocales(texto string) int` cuente las vocales (`a`, `e`, `i`, `o`, `u`) del texto sin distinguir mayúsculas.
4. `fibonacci(n int) []int` devuelva los primeros `n` términos de la serie de Fibonacci (`0, 1, 1, 2, 3, 5, 8, ...`).

En Go solo existe `for`. Úsalo en su forma clásica y con `range` para recorrer strings.

## Requisitos

- [ ] `sumaPrimeros(5)` devuelve `15` y `sumaPrimeros(10)` devuelve `55`.
- [ ] `tablaMultiplicar(3)` tiene 10 líneas y contiene `"3 x 5 = 15"` y `"3 x 10 = 30"`.
- [ ] `contarVocales("Hola Mundo")` devuelve `4` (cuenta `o, a, u, o`).
- [ ] `fibonacci(7)` devuelve `[0 1 1 2 3 5 8]`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Acumula con `total += i` dentro de un `for i := 1; i <= n; i++`.
- Construye la tabla con `append(tabla, fmt.Sprintf("%d x %d = %d", n, i, n*i))`.
- Para las vocales recorre el texto con `for _, letra := range texto` y compara cada `rune` contra las vocales en minúscula y mayúscula (o usa `strings.ToLower`).
- En Fibonacci guarda los dos últimos valores: `a, b := 0, 1` y luego `a, b = b, a+b`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import (
	"fmt"
	"strings"
)

func sumaPrimeros(n int) int {
	total := 0
	for i := 1; i <= n; i++ {
		total += i
	}
	return total
}

func tablaMultiplicar(n int) []string {
	tabla := []string{}
	for i := 1; i <= 10; i++ {
		tabla = append(tabla, fmt.Sprintf("%d x %d = %d", n, i, n*i))
	}
	return tabla
}

func contarVocales(texto string) int {
	contador := 0
	for _, letra := range strings.ToLower(texto) {
		switch letra {
		case 'a', 'e', 'i', 'o', 'u':
			contador++
		}
	}
	return contador
}

func fibonacci(n int) []int {
	if n <= 0 {
		return []int{}
	}
	serie := make([]int, n)
	serie[0] = 0
	if n == 1 {
		return serie
	}
	serie[1] = 1
	for i := 2; i < n; i++ {
		serie[i] = serie[i-1] + serie[i-2]
	}
	return serie
}
````

</details>