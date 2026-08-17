# Ejercicio 01 — Interfaces

- **Nivel:** 3/5
- **Tema:** interfaces, satisfacción implícita y polimorfismo
- **Tiempo estimado:** 30 min

## Enunciado

Completa el archivo `main.go` para que los tipos `Rectangulo` y `Circulo` **satisfagan implícitamente** la interfaz `Forma`:

1. `(r Rectangulo) Area() float64` → `ancho * alto`.
2. `(r Rectangulo) Nombre() string` → `"rectángulo"`.
3. `(c Circulo) Area() float64` → `math.Pi * radio * radio`.
4. `(c Circulo) Nombre() string` → `"círculo"`.
5. `areaTotal(formas []Forma) float64` sume las áreas de todas las formas.
6. `describir(formas []Forma) []string` devuelva una línea por forma con el formato `"<nombre>: <área>"` (área con 2 decimales, p. ej. `rectángulo: 12.00`).

En Go una interfaz se satisface **sin declararlo**: basta con implementar los métodos.

## Requisitos

- [ ] `Rectangulo{3, 4}` y `Circulo{1}` se pueden asignar a una variable de tipo `Forma`.
- [ ] `areaTotal` suma `12 + π` para `[Rectangulo{3,4}, Circulo{1}]` y devuelve `0` para un slice vacío.
- [ ] `describir` devuelve `rectángulo: 12.00` y una línea que contiene `círculo: 3.14`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En Go no escribes `implements Forma`: si `Rectangulo` tiene `Area()` y `Nombre()`, ya la cumple.
- El receptor debe ser por valor (`func (r Rectangulo) ...`) para que la asignación `var f Forma = Rectangulo{...}` compile.
- En `areaTotal` recorre el slice y suma `f.Area()` para cada `Forma`.
- Para `describir` usa `fmt.Sprintf("%s: %.2f", f.Nombre(), f.Area())`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import (
	"fmt"
	"math"
)

// Forma es implementada por figuras geométricas que saben calcular su área y su nombre.
type Forma interface {
	Area() float64
	Nombre() string
}

// Rectangulo es una figura con ancho y alto.
type Rectangulo struct {
	Ancho float64
	Alto  float64
}

// Circulo es una figura definida por su radio.
type Circulo struct {
	Radio float64
}

func (r Rectangulo) Area() float64 {
	return r.Ancho * r.Alto
}

func (r Rectangulo) Nombre() string {
	return "rectángulo"
}

func (c Circulo) Area() float64 {
	return math.Pi * c.Radio * c.Radio
}

func (c Circulo) Nombre() string {
	return "círculo"
}

func areaTotal(formas []Forma) float64 {
	total := 0.0
	for _, f := range formas {
		total += f.Area()
	}
	return total
}

func describir(formas []Forma) []string {
	lineas := []string{}
	for _, f := range formas {
		lineas = append(lineas, fmt.Sprintf("%s: %.2f", f.Nombre(), f.Area()))
	}
	return lineas
}
````

</details>