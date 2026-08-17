package main

import "fmt"

// Persona representa a una persona con nombre, edad y ciudad.
type Persona struct {
	Nombre string
	Edad   int
	Ciudad string
}

// TODO: devuelve una nueva Persona con los datos dados.
func nuevaPersona(nombre string, edad int, ciudad string) Persona {
	return Persona{} // TODO: completa la función
}

// TODO: devuelve true si la edad de la persona es mayor o igual a 18.
func (p Persona) esMayorDeEdad() bool {
	return false // TODO: completa la función
}

// TODO: devuelve "Nombre, X años, ciudad de Y".
func (p Persona) presentacion() string {
	return "" // TODO: completa la función
}

func main() {
	p := nuevaPersona("Ana", 30, "Lima")
	fmt.Println(p.presentacion())
	fmt.Println("es mayor de edad:", p.esMayorDeEdad())
}
