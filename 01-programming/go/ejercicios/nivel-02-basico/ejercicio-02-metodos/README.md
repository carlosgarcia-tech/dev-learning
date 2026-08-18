# Ejercicio 02 — Métodos

- **Nivel:** 2/5
- **Tema:** métodos con receptor por valor y el paquete `math`
- **Tiempo estimado:** 20 min

## Enunciado

Completa el archivo `main.go` para que los tipos `Rectangulo` y `Circulo` tengan sus métodos:

1. `(r Rectangulo) Area() float64` → `ancho * alto`.
2. `(r Rectangulo) Perimetro() float64` → `2 * (ancho + alto)`.
3. `(c Circulo) Area() float64` → `math.Pi * radio * radio`.
4. `(c Circulo) Circunferencia() float64` → `2 * math.Pi * radio`.

Un método con receptor por valor (`func (r Rectangulo) ...`) recibe una **copia** del struct; es suficiente aquí porque no modificamos nada.

## Requisitos

- [ ] `Rectangulo{3, 4}.Area()` devuelve `12` y `.Perimetro()` devuelve `14`.
- [ ] `Rectangulo{0.5, 2}.Area()` devuelve `1`.
- [ ] `Circulo{1}.Area()` devuelve `π` (aproximadamente `3.14159...`).
- [ ] `Circulo{1}.Circunferencia()` devuelve `2π`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `math.Pi` ya existe; no escribas `3.1416` a mano.
- El radio al cuadrado se escribe `c.Radio * c.Radio` (o `math.Pow(c.Radio, 2)`).
- Los tests comparan con una tolerancia de `1e-9`, así que no redondees.
- Para usar `math` añade `import "math"`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "math"

// Rectangulo es una figura geométrica con ancho y alto.
type Rectangulo struct {
	Ancho float64
	Alto  float64
}

// Circulo es una figura geométrica definida por su radio.
type Circulo struct {
	Radio float64
}

func (r Rectangulo) Area() float64 {
	return r.Ancho * r.Alto
}

func (r Rectangulo) Perimetro() float64 {
	return 2 * (r.Ancho + r.Alto)
}

func (c Circulo) Area() float64 {
	return math.Pi * c.Radio * c.Radio
}

func (c Circulo) Circunferencia() float64 {
	return 2 * math.Pi * c.Radio
}
````

</details>