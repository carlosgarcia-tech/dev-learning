# Ejercicio 04 — Funciones básicas

- **Nivel:** 1/5
- **Tema:** funciones, valores de retorno múltiple y `error`
- **Tiempo estimado:** 25 min

## Enunciado

Completa el archivo `main.go` para que:

1. `factorial(n int) (int, error)` devuelva `n!`. Si `n` es negativo devuelve el error `errFactorialNegativo`.
2. `esPrimo(n int) bool` devuelva `true` si `n` es un número primo. Recuerda que `0` y `1` no lo son.
3. `mcd(a, b int) int` devuelva el máximo común divisor usando el algoritmo de Euclides: repite `b, a = a%b, b` hasta que `b` sea `0`; el resultado es `a`.
4. `potencia(base, exp int) int` devuelva `base^exp` para `exp >= 0` multiplicando en un bucle (sin usar `math.Pow`).

## Requisitos

- [ ] `factorial(5)` devuelve `120` y `factorial(0)` devuelve `1`.
- [ ] `factorial(-1)` devuelve un error.
- [ ] `esPrimo` identifica primos reales (`2`, `3`, `7`, `11`) y rechaza `0`, `1`, `4` y `9`.
- [ ] `mcd(12, 18)` devuelve `6` y `mcd(0, 5)` devuelve `5`.
- [ ] `potencia(2, 10)` devuelve `1024` y `potencia(5, 0)` devuelve `1`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `factorial(0) == 1` y `factorial(n) == n * factorial(n-1)`.
- En `esPrimo`, comprueba primero `n < 2`; luego recorre `i` de 2 hasta `n-1` (o hasta `n/2`) y devuelve `false` si `n%i == 0`.
- Euclides: `for b != 0 { a, b = b, a%b }` y devuelve `a`.
- En `potencia` inicializa `resultado := 1` y multiplica `exp` veces.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "errors"

var errFactorialNegativo = errors.New("el factorial no está definido para números negativos")

func factorial(n int) (int, error) {
	if n < 0 {
		return 0, errFactorialNegativo
	}
	resultado := 1
	for i := 2; i <= n; i++ {
		resultado *= i
	}
	return resultado, nil
}

func esPrimo(n int) bool {
	if n < 2 {
		return false
	}
	for i := 2; i*i <= n; i++ {
		if n%i == 0 {
			return false
		}
	}
	return true
}

func mcd(a, b int) int {
	for b != 0 {
		a, b = b, a%b
	}
	return a
}

func potencia(base, exp int) int {
	resultado := 1
	for i := 0; i < exp; i++ {
		resultado *= base
	}
	return resultado
}
````

</details>