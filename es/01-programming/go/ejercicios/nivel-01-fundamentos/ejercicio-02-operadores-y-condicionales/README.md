# Ejercicio 02 — Operadores y condicionales

- **Nivel:** 1/5
- **Tema:** operadores aritméticos, comparación, lógicos y `if`/`else if`/`else`
- **Tiempo estimado:** 20 min

## Enunciado

Completa el archivo `main.go` para que:

1. `clasificarEdad(edad int) string` devuelva `menor de edad` si `edad < 18`, `adulto` si `edad < 65` y `adulto mayor` en caso contrario.
2. `esPar(n int) bool` devuelva `true` si `n` es divisible entre 2 y `false` si no.
3. `mayorDeTres(a, b, c int) int` devuelva el mayor de los tres números.
4. `evaluarNota(nota float64) string` devuelva `suspenso` (< 60), `aprobado` (< 75), `notable` (< 90) o `sobresaliente` (>= 90).

Recuerda que en Go el `if` no usa paréntesis pero las llaves son obligatorias, y el `else` debe ir en la misma línea que la llave de cierre (`} else {`).

## Requisitos

- [ ] Los tres rangos de `clasificarEdad` funcionan (15 → `menor de edad`, 30 → `adulto`, 70 → `adulto mayor`).
- [ ] `esPar` funciona también con `0` y negativos.
- [ ] `mayorDeTres` funciona con números negativos y empates.
- [ ] `evaluarNota` respeta los límites (60, 75, 90).
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El operador módulo `%` devuelve el resto de la división: `n % 2 == 0` significa par.
- Evalúa las condiciones de `evaluarNota` de mayor a menor (`nota >= 90` primero) o usa `else if` con límites inferiores.
- Para `mayorDeTres` puedes comparar `a` con `b`, luego el mayor con `c`, o usar dos condicionales anidados.
- Cuidado: `nota` es `float64`, así que usa `nota >= 90` y no `nota > 89`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

func clasificarEdad(edad int) string {
	if edad < 18 {
		return "menor de edad"
	} else if edad < 65 {
		return "adulto"
	}
	return "adulto mayor"
}

func esPar(n int) bool {
	return n%2 == 0
}

func mayorDeTres(a, b, c int) int {
	mayor := a
	if b > mayor {
		mayor = b
	}
	if c > mayor {
		mayor = c
	}
	return mayor
}

func evaluarNota(nota float64) string {
	switch {
	case nota >= 90:
		return "sobresaliente"
	case nota >= 75:
		return "notable"
	case nota >= 60:
		return "aprobado"
	default:
		return "suspenso"
	}
}
````

</details>