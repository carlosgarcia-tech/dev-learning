# Ejercicio 05 — Cadenas

- **Nivel:** 2/5
- **Tema:** `strings` (`ToLower`, `Fields`, `Join`, `ReplaceAll`) y `[]rune`
- **Tiempo estimado:** 30 min

## Enunciado

Completa el archivo `main.go` para que:

1. `esPalindromo(s string) bool` devuelva `true` si el texto se lee igual al revés, ignorando mayúsculas y espacios. Por ejemplo, `"anita lava la tina"` es palíndromo.
2. `invertir(s string) string` devuelva el texto invertido respetando tildes y caracteres Unicode (usa `[]rune`).
3. `contarPalabrasCadena(s string) int` devuelva cuántas palabras tiene el texto, ignorando espacios sobrantes.
4. `capitalizar(s string) string` devuelva el texto con la primera letra de cada palabra en mayúscula.

## Requisitos

- [ ] `esPalindromo("anita lava la tina")` devuelve `true` y `esPalindromo("hola")` devuelve `false`.
- [ ] `invertir("hola mundo")` devuelve `"odnum aloh"` y `invertir("áéí")` devuelve `"íéá"`.
- [ ] `contarPalabrasCadena("  con  espacios  extra  ")` devuelve `3` (ignora los espacios sobrantes).
- [ ] `capitalizar("go es genial")` devuelve `"Go Es Genial"`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Normaliza el texto antes de comprobar el palíndromo: `strings.ToLower` y elimina espacios con `strings.ReplaceAll(s, " ", "")` o `strings.Fields` + `strings.Join`.
- Un `string` se recorre por bytes; para invertir correctamente convierte a `[]rune` y recorre con dos índices (`i`, `j`).
- `strings.Fields(s)` devuelve las palabras sin espacios sobrantes; `len(...)` te da el número.
- Para `capitalizar` divide con `Fields`, convierte a mayúscula solo la primera letra (`strings.ToUpper(palabra[:1]) + palabra[1:]`) y vuelve a unir con `Join`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "strings"

func esPalindromo(s string) bool {
	s = strings.ToLower(s)
	s = strings.ReplaceAll(s, " ", "")
	return s == invertir(s)
}

func invertir(s string) string {
	runas := []rune(s)
	for i, j := 0, len(runas)-1; i < j; i, j = i+1, j-1 {
		runas[i], runas[j] = runas[j], runas[i]
	}
	return string(runas)
}

func contarPalabrasCadena(s string) int {
	return len(strings.Fields(s))
}

func capitalizar(s string) string {
	palabras := strings.Fields(s)
	for i, palabra := range palabras {
		if len(palabra) > 0 {
			palabras[i] = strings.ToUpper(palabra[:1]) + palabra[1:]
		}
	}
	return strings.Join(palabras, " ")
}
````

</details>