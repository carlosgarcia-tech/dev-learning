# Ejercicio 05 — Paquetes y módulos

- **Nivel:** 3/5
- **Tema:** módulos Go, subpaquetes e importaciones locales
- **Tiempo estimado:** 30 min

## Enunciado

Este ejercicio tiene un **módulo** (`go.mod`) con un **subpaquete** `matematica/`. Completa las funciones del paquete `matematica` (archivo `matematica/operaciones.go`):

1. `Suma(a, b int) int` → `a + b`.
2. `Producto(a, b int) int` → `a * b`.
3. `Factorial(n int) (int, error)` → `n!`, con error si `n < 0`.
4. `Fibonacci(n int) []int` → los primeros `n` términos de la serie (`0, 1, 1, 2, 3, 5, ...`).

El archivo `main.go` ya importa el paquete local con `import "ejercicio-05-paquetes-y-modulos/matematica"` y demuestra su uso.

## Requisitos

- [ ] `matematica.Suma(2, 3)` devuelve `5`.
- [ ] `matematica.Producto(4, 5)` devuelve `20`.
- [ ] `matematica.Factorial(5)` devuelve `120`, `Factorial(0)` devuelve `1` y `Factorial(-1)` devuelve un error.
- [ ] `matematica.Fibonacci(7)` devuelve `[0 1 1 2 3 5 8]`.
- [ ] Los tests pasan: `go test ./...` (desde esta carpeta)
- [ ] `go run .` imprime los resultados de las 4 operaciones.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Las funciones exportadas empiezan con **mayúscula**; las internas con minúscula.
- La ruta de importación es `modulo/subcarpeta`: `ejercicio-05-paquetes-y-modulos/matematica`.
- `go test ./...` recorre el paquete raíz y sus subpaquetes.
- `Fibonacci(0)` debe devolver un slice vacío, no `nil` (o el test de `DeepEqual` fallará).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

Archivo `matematica/operaciones.go`:

````go
package matematica

import "errors"

var errFactorialNegativo = errors.New("el factorial no está definido para números negativos")

func Suma(a, b int) int {
	return a + b
}

func Producto(a, b int) int {
	return a * b
}

func Factorial(n int) (int, error) {
	if n < 0 {
		return 0, errFactorialNegativo
	}
	resultado := 1
	for i := 2; i <= n; i++ {
		resultado *= i
	}
	return resultado, nil
}

func Fibonacci(n int) []int {
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

El archivo `main.go` no necesita cambios.

</details>