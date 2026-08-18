package main

import "fmt"

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

// TODO: devuelve el área del rectángulo (ancho * alto).
func (r Rectangulo) Area() float64 {
	return 0 // TODO: completa el método
}

// TODO: devuelve "rectángulo".
func (r Rectangulo) Nombre() string {
	return "" // TODO: completa el método
}

// TODO: devuelve el área del círculo (π * radio^2).
func (c Circulo) Area() float64 {
	return 0 // TODO: completa el método
}

// TODO: devuelve "círculo".
func (c Circulo) Nombre() string {
	return "" // TODO: completa el método
}

// TODO: devuelve la suma de las áreas de todas las formas.
func areaTotal(formas []Forma) float64 {
	return 0 // TODO: completa la función
}

// TODO: devuelve "nombre: área" con el área a 2 decimales, una línea por forma.
func describir(formas []Forma) []string {
	return nil // TODO: completa la función
}
func main() {
	formas := []Forma{
		Rectangulo{Ancho: 3, Alto: 4},
		Circulo{Radio: 1},
	}
	for _, linea := range describir(formas) {
		fmt.Println(linea)
	}
	fmt.Println("área total:", areaTotal(formas))
}
