# Ejercicio 03 — Select

- **Nivel:** 4/5
- **Tema:** `select`, `time.After` y combinación de canales
- **Tiempo estimado:** 40 min

## Enunciado

Completa el archivo `main.go` para que:

1. `combinarCanales(a, b <-chan int) []int` lea de ambos canales hasta que **los dos** estén cerrados, usando `select`, y devuelva todos los valores en un slice.
2. `recibirDeCualquiera(a, b <-chan int) int` devuelva el primer valor que esté disponible en cualquiera de los dos canales.
3. `conTimeout(canal <-chan int, ms time.Duration) (int, bool)` devuelva `(valor, true)` si el canal entrega antes de `ms` milisegundos, y `(0, false)` si se agota el tiempo. Usa `select` con `time.After`.

## Requisitos

- [ ] `combinarCanales` combina los valores de dos canales (suma total determinista: `15`) y nunca se bloquea.
- [ ] `recibirDeCualquiera` devuelve el valor del canal que está listo.
- [ ] `conTimeout` con valor disponible devuelve `(valor, true)`.
- [ ] `conTimeout` con un canal que nunca recibe devuelve `(0, false)` al agotar el tiempo.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `select` elige entre varios `case` que estén listos (o se bloquea si ninguno lo está).

```go
select {
case v, ok := <-a:
    if !ok { aCerrado = true } else { resultado = append(resultado, v) }
case v, ok := <-b:
    // igual
case <-time.After(duracion):
    return 0, false
}
```

- Un canal **cerrado** sigue siendo seleccionable: `v, ok := <-ch` con `ok == false` te permite detectarlo.
- Para `conTimeout`, `time.After(ms)` envía a un canal cuando pasa el tiempo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "time"

func combinarCanales(a, b <-chan int) []int {
	resultado := []int{}
	aAbierto, bAbierto := true, true
	for aAbierto || bAbierto {
		select {
		case v, ok := <-a:
			if !ok {
				aAbierto = false
			} else {
				resultado = append(resultado, v)
			}
		case v, ok := <-b:
			if !ok {
				bAbierto = false
			} else {
				resultado = append(resultado, v)
			}
		}
	}
	return resultado
}

func recibirDeCualquiera(a, b <-chan int) int {
	select {
	case v := <-a:
		return v
	case v := <-b:
		return v
	}
}

func conTimeout(canal <-chan int, ms time.Duration) (int, bool) {
	select {
	case v := <-canal:
		return v, true
	case <-time.After(ms):
		return 0, false
	}
}
````

</details>