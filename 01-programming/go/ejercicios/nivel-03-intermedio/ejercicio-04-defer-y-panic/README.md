# Ejercicio 04 — Defer, panic y recover

- **Nivel:** 3/5
- **Tema:** `defer`, `panic`, `recover` y funciones con valores de retorno nombrados
- **Tiempo estimado:** 30 min

## Enunciado

Completa el archivo `main.go` para que:

1. `dividirSeguro(a, b int) (resultado int, err error)` devuelva `a / b`. Si `b == 0`, lanza `panic("división por cero")` y, gracias a un `defer` con `recover`, devuelve `(0, error)`. El error debe contener el texto `"división por cero"`.
2. `ejecutarSeguro(fn func()) (err error)` ejecute `fn`. Si `fn` lanza un `panic`, lo captura con `recover` y lo devuelve como `error` (incluyendo el mensaje del panic).

## Requisitos

- [ ] `dividirSeguro(10, 2)` devuelve `(5, nil)`.
- [ ] `dividirSeguro(7, 0)` devuelve `(0, err)` sin propagar el panic, y el error contiene `"división por cero"`.
- [ ] `ejecutarSeguro` ejecuta la función cuando no hay panic y devuelve `nil`.
- [ ] `ejecutarSeguro` convierte un panic en un error cuyo mensaje incluye el del panic.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `recover()` solo funciona dentro de una función diferida. El patrón típico:

```go
func f() (err error) {
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("panic recuperado: %v", r)
		}
	}()
	// código que puede hacer panic
	return
}
```

- El `defer` debe registrarse **antes** del código que puede lanzar panic.
- Los nombres de retorno (`resultado`, `err`) te permiten modificarlos dentro del `defer`.
- `panic` acepta cualquier valor; normalmente un string o un `error`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "fmt"

func dividirSeguro(a, b int) (resultado int, err error) {
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("panic recuperado: %v", r)
		}
	}()
	if b == 0 {
		panic("división por cero")
	}
	return a / b, nil
}

func ejecutarSeguro(fn func()) (err error) {
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("panic recuperado: %v", r)
		}
	}()
	fn()
	return nil
}
````

</details>