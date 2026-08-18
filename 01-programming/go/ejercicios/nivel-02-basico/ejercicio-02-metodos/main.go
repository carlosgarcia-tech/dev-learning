package main

import "fmt"

// Rectangulo es una figura geométrica con ancho y alto.
type Rectangulo struct {
	Ancho float64
	Alto  float64
}

// Circulo es una figura geométrica definida por su radio.
type Circulo struct {
	Radio float64
}

// TODO: devuelve el área del rectángulo (ancho * alto).
func (r Rectangulo) Area() float64 {
	return 0 // TODO: completa el método
}

// TODO: devuelve el perímetro del rectángulo (2 * (ancho + alto)).
func (r Rectangulo) Perimetro() float64 {
	return 0 // TODO: completa el método
}

// TODO: devuelve el área del círculo (π * radio^2). Usa math.Pi.
func (c Circulo) Area() float64 {
	return 0 // TODO: completa el método
}

// TODO: devuelve la circunferencia del círculo (2 * π * radio).
func (c Circulo) Circunferencia() float64 {
	return 0 // TODO: completa el método
}

func main() {
	r := Rectangulo{Ancho: 3, Alto: 4}
	c := Circulo{Radio: 1}
	fmt.Println("area rectangulo:", r.Area(), "perimetro:", r.Perimetro())
	fmt.Println("area circulo:", c.Area(), "circunferencia:", c.Circunferencia())
}
