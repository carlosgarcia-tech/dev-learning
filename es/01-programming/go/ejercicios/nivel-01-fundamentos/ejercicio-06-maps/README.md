# Ejercicio 06 — Maps

- **Nivel:** 1/5
- **Tema:** `map[string]T`, `range` sobre mapas y patrones de acumulación
- **Tiempo estimado:** 30 min

## Enunciado

Completa el archivo `main.go` para que:

1. `contarPalabras(texto string) map[string]int` devuelva un mapa con el número de veces que aparece cada palabra del texto (separadas por espacios).
2. `sumarValores(m map[string]int) int` devuelva la suma de todos los valores.
3. `palabraMasFrecuente(texto string) (string, int)` devuelva la palabra que más se repite y cuántas veces.
4. `invertirMapa(m map[string]int) map[int]string` devuelva un mapa invertido: las claves pasan a ser valores y los valores pasan a ser claves.

## Requisitos

- [ ] `contarPalabras("hola mundo hola go")` devuelve `{"hola": 2, "mundo": 1, "go": 1}`.
- [ ] `contarPalabras("")` devuelve un mapa vacío (no `nil`).
- [ ] `sumarValores({a:2, b:3})` devuelve `5`.
- [ ] `palabraMasFrecuente("la casa la luna la sol")` devuelve `("la", 3)`.
- [ ] `invertirMapa({a:1, b:2})` devuelve `{1: "a", 2: "b"}`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Separa el texto con `strings.Fields(texto)` que elimina espacios extra.
- Para contar: `m[palabra]++` funciona porque los mapas devuelven el valor cero si no existe.
- Para la más frecuente, recorre el mapa con `for palabra, veces := range m` y guarda el máximo.
- Para invertir: `resultado[valor] = clave`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "strings"

func contarPalabras(texto string) map[string]int {
	contador := map[string]int{}
	for _, palabra := range strings.Fields(texto) {
		contador[palabra]++
	}
	return contador
}

func sumarValores(m map[string]int) int {
	total := 0
	for _, v := range m {
		total += v
	}
	return total
}

func palabraMasFrecuente(texto string) (string, int) {
	contador := contarPalabras(texto)
	masFrecuente := ""
	masVeces := 0
	for palabra, veces := range contador {
		if veces > masVeces {
			masFrecuente = palabra
			masVeces = veces
		}
	}
	return masFrecuente, masVeces
}

func invertirMapa(m map[string]int) map[int]string {
	invertido := map[int]string{}
	for clave, valor := range m {
		invertido[valor] = clave
	}
	return invertido
}
````

</details>