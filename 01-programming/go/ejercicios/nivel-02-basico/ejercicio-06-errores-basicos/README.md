# Ejercicio 06 — Errores básicos

- **Nivel:** 2/5
- **Tema:** tipo `error`, `errors.New`, `fmt.Errorf` y propagación de errores
- **Tiempo estimado:** 25 min

## Enunciado

Completa el archivo `main.go` para que:

1. `dividir(a, b float64) (float64, error)` devuelva `a/b` y, si `b == 0`, `errDivisionPorCero`.
2. `raizCuadrada(n float64) (float64, error)` devuelva `math.Sqrt(n)` y, si `n < 0`, `errRaizNegativa`.
3. `parsearEntero(s string) (int, error)` convierta el texto a entero con `strconv.Atoi` y propague su error.
4. `validarEdad(edad int) error` devuelva `nil` si la edad está entre `0` y `150` (incluidos) y `errEdadInvalida` en caso contrario.

## Requisitos

- [ ] `dividir(10, 2)` devuelve `(5, nil)` y `dividir(1, 0)` devuelve exactamente `errDivisionPorCero`.
- [ ] `raizCuadrada(16)` devuelve `(4, nil)` y `raizCuadrada(-1)` devuelve `errRaizNegativa`.
- [ ] `parsearEntero("42")` devuelve `(42, nil)` y `parsearEntero("abc")` devuelve un error.
- [ ] `validarEdad` acepta `0`, `30` y `150`, y rechaza `-1` y `151` con `errEdadInvalida`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Compara errores con `==` cuando sean variables de paquete creadas con `errors.New`: `if err != errDivisionPorCero { ... }`.
- `strconv.Atoi(s)` ya devuelve `(int, error)`; propágalo tal cual: `return strconv.Atoi(s)`.
- Para `raizCuadrada` recuerda importar `math`.
- En Go lo convencional es devolver el **valor cero** (`0`, `""`, `false`) junto al error cuando algo falla.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import (
	"errors"
	"math"
	"strconv"
)

var (
	errDivisionPorCero = errors.New("división por cero")
	errRaizNegativa    = errors.New("raíz cuadrada de un número negativo")
	errEdadInvalida    = errors.New("edad inválida")
)

func dividir(a, b float64) (float64, error) {
	if b == 0 {
		return 0, errDivisionPorCero
	}
	return a / b, nil
}

func raizCuadrada(n float64) (float64, error) {
	if n < 0 {
		return 0, errRaizNegativa
	}
	return math.Sqrt(n), nil
}

func parsearEntero(s string) (int, error) {
	return strconv.Atoi(s)
}

func validarEdad(edad int) error {
	if edad < 0 || edad > 150 {
		return errEdadInvalida
	}
	return nil
}
````

</details>