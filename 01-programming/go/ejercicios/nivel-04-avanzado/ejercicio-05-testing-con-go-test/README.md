# Ejercicio 05 — Testing con go test

- **Nivel:** 4/5
- **Tema:** `testing`, tests de tabla, subtests con `t.Run` y casos de error
- **Tiempo estimado:** 40 min

## Enunciado

Este ejercicio tiene dos partes:

1. **Implementación:** completa las funciones de `main.go`:
   - `suma(a, b int) int`, `multiplica(a, b int) int`, `esPar(n int) bool`.
   - `maximo(ns []int) (int, error)` — devuelve el mayor, y un error si el slice está vacío.
2. **Tests:** ya están escritos en `main_test.go` con el patrón de **tests de tabla** y **subtests** (`t.Run`). Fíjate en cómo se declaran, se recorren y se reportan los errores con `t.Errorf`/`t.Fatalf`.

## Requisitos

- [ ] `suma` pasa los 4 casos de la tabla (incluye negativos y cero).
- [ ] `multiplica` pasa los 4 casos.
- [ ] `esPar` pasa los 4 casos.
- [ ] `maximo` pasa los casos normales y devuelve error para un slice vacío.
- [ ] Los tests pasan: `go test ./...`
- [ ] Prueba también `go test -v` para ver los subtests ejecutándose uno a uno.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un test de tabla es un slice de structs con campos de entrada y el resultado esperado; se recorre con un `for`.
- `t.Run(nombre, func(t *testing.T){...})` crea un subtest: con `go test -v` verás cada caso por separado.
- `t.Errorf` falla el test pero continúa; `t.Fatalf` corta el subtest.
- `maximo` vacío devuelve `errSliceVacio`; puedes definirlo como `var errSliceVacio = errors.New("el slice está vacío")`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "errors"

var errSliceVacio = errors.New("el slice está vacío")

func suma(a, b int) int {
	return a + b
}

func multiplica(a, b int) int {
	return a * b
}

func esPar(n int) bool {
	return n%2 == 0
}

func maximo(ns []int) (int, error) {
	if len(ns) == 0 {
		return 0, errSliceVacio
	}
	m := ns[0]
	for _, n := range ns[1:] {
		if n > m {
			m = n
		}
	}
	return m, nil
}
````

El archivo `main_test.go` no requiere cambios.

</details>