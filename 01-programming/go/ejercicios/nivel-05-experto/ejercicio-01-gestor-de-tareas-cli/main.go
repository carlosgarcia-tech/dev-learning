package main

import (
	"errors"
	"fmt"
)

// Tarea representa una tarea de la lista.
type Tarea struct {
	ID         int
	Titulo     string
	Completada bool
}

// GestorTareas administra una lista de tareas en memoria.
type GestorTareas struct {
	tareas      []Tarea
	siguienteID int
}

// TODO: devuelve un nuevo gestor vacío.
func NuevoGestor() *GestorTareas {
	return &GestorTareas{} // TODO: completa la función
}

// TODO: agrega una tarea con el título dado, le asigna el siguiente ID y la devuelve.
func (g *GestorTareas) Agregar(titulo string) Tarea {
	return Tarea{} // TODO: completa la función
}

// TODO: marca como completada la tarea con el ID dado. Devuelve un error si no existe.
func (g *GestorTareas) Completar(id int) error {
	return nil // TODO: completa la función
}

// TODO: devuelve solo las tareas pendientes (no completadas).
func (g *GestorTareas) Pendientes() []Tarea {
	return nil // TODO: completa la función
}

// TODO: devuelve el número total de tareas.
func (g *GestorTareas) Contar() int {
	return 0 // TODO: completa la función
}

// TODO: devuelve la tarea con el ID dado. Devuelve un error si no existe.
func (g *GestorTareas) Obtener(id int) (Tarea, error) {
	return Tarea{}, nil // TODO: completa la función
}

var errTareaNoEncontrada = errors.New("tarea no encontrada")

func main() {
	gestor := NuevoGestor()
	gestor.Agregar("Comprar pan")
	gestor.Agregar("Estudiar Go")
	fmt.Println("total:", gestor.Contar())
	fmt.Println("pendientes:", gestor.Pendientes())
	gestor.Completar(1)
	fmt.Println("pendientes tras completar:", gestor.Pendientes())
}