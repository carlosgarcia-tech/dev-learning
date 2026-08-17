# Ejercicio 02 — Switch

- **Nivel:** 3/5
- **Tema:** `switch` con expresión, `switch` sin expresión y *type switch*
- **Tiempo estimado:** 25 min

## Enunciado

Completa el archivo `main.go` para que:

1. `diaDeLaSemana(n int) string` devuelva el día (`1` = lunes ... `7` = domingo). Si `n` no está entre 1 y 7 devuelve `"número inválido"`.
2. `mesEnLetras(n int) string` devuelva el mes (`1` = enero ... `12` = diciembre). Si no, `"mes inválido"`.
3. `clasificarNota(nota float64) string` devuelva `suspenso` (< 60), `aprobado` (< 75), `notable` (< 90) o `sobresaliente` (>= 90), usando un `switch` **sin expresión**.
4. `describirValor(v interface{}) string` use un **type switch** para devolver `entero: X`, `texto: X` o `decimal: X`, y `tipo desconocido` para el resto.

## Requisitos

- [ ] `diaDeLaSemana(1)` es `lunes` y `diaDeLaSemana(8)` es `número inválido`.
- [ ] `mesEnLetras(6)` es `junio` y `mesEnLetras(13)` es `mes inválido`.
- [ ] `clasificarNota(59)` es `suspenso` y `clasificarNota(90)` es `sobresaliente`.
- [ ] `describirValor(42)` es `entero: 42`, `describirValor(3.14)` es `decimal: 3.14` y `describirValor(true)` es `tipo desconocido`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Agrupa varios casos en una línea: `case 1, 2, 3:`.
- El `switch` sin expresión evalúa condiciones: `switch { case nota >= 90: ... }`.
- En un type switch: `switch v := valor.(type) { case int: return fmt.Sprintf("entero: %d", v) }`.
- `interface{}` es lo mismo que `any`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "fmt"

func diaDeLaSemana(n int) string {
	switch n {
	case 1:
		return "lunes"
	case 2:
		return "martes"
	case 3:
		return "miércoles"
	case 4:
		return "jueves"
	case 5:
		return "viernes"
	case 6:
		return "sábado"
	case 7:
		return "domingo"
	default:
		return "número inválido"
	}
}

func mesEnLetras(n int) string {
	meses := []string{"enero", "febrero", "marzo", "abril", "mayo", "junio",
		"julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"}
	if n < 1 || n > 12 {
		return "mes inválido"
	}
	return meses[n-1]
}

func clasificarNota(nota float64) string {
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

func describirValor(v interface{}) string {
	switch valor := v.(type) {
	case int:
		return fmt.Sprintf("entero: %d", valor)
	case string:
		return fmt.Sprintf("texto: %s", valor)
	case float64:
		return fmt.Sprintf("decimal: %v", valor)
	default:
		return "tipo desconocido"
	}
}
````

</details>