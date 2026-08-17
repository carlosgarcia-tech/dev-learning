# Ejercicio 06 — Context

- **Nivel:** 4/5
- **Tema:** `context.Context`, cancelación y timeouts
- **Tiempo estimado:** 40 min

## Enunciado

Completa el archivo `main.go` para que:

1. `tareaLenta(ctx context.Context, ms int) (string, error)` simule una tarea que tarda `ms` milisegundos: usa `select` entre `time.After(ms)` (devuelve `"ok", nil`) y `ctx.Done()` (devuelve `ctx.Err()`).
2. `procesarConContexto(ctx context.Context, fn func() (string, error)) (string, error)`:
   - Ejecute `fn` en una goroutine.
   - Si `fn` termina con resultado o error, lo devuelve.
   - Si `ctx` se cancela/expiere antes, devuelve `ctx.Err()`.

## Requisitos

- [ ] `tareaLenta(background, 5)` devuelve `("ok", nil)`.
- [ ] `tareaLenta` con un contexto de timeout de 10 ms y trabajo de 200 ms devuelve un error de contexto.
- [ ] `procesarConContexto` con un contexto normal devuelve el resultado de `fn`.
- [ ] `procesarConContexto` con un contexto ya cancelado devuelve un error aunque `fn` tarde.
- [ ] `procesarConContexto` propaga los errores que devuelve `fn`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `context.WithTimeout` y `context.WithCancel` crean contextos cancelables; `ctx.Done()` devuelve un canal que se cierra al cancelar.
- En `procesarConContexto` crea canales con buffer (1) para el resultado y el error, y elige con `select` entre ellos y `ctx.Done()`.
- `ctx.Err()` devuelve `context.Canceled` o `context.DeadlineExceeded`.
- Recuerda `defer cancel()` en los tests para liberar el contexto.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import (
	"context"
	"time"
)

func tareaLenta(ctx context.Context, ms int) (string, error) {
	select {
	case <-time.After(time.Duration(ms) * time.Millisecond):
		return "ok", nil
	case <-ctx.Done():
		return "", ctx.Err()
	}
}

func procesarConContexto(ctx context.Context, fn func() (string, error)) (string, error) {
	resultado := make(chan string, 1)
	errores := make(chan error, 1)
	go func() {
		v, err := fn()
		if err != nil {
			errores <- err
			return
		}
		resultado <- v
	}()
	select {
	case v := <-resultado:
		return v, nil
	case err := <-errores:
		return "", err
	case <-ctx.Done():
		return "", ctx.Err()
	}
}
````

</details>