package main

import (
	"errors"
	"fmt"
	"sync"
)

// Tarea es el registro persistido.
type Tarea struct {
	ID         int    `json:"id"`
	Titulo     string `json:"titulo"`
	Completada bool   `json:"completada"`
}

// Almacen gestiona tareas con persistencia en un archivo JSON.
type Almacen struct {
	mu          sync.Mutex
	ruta        string
	tareas      []Tarea
	siguienteID int
}

var (
	errTituloVacio   = errors.New("el título no puede estar vacío")
	errNoEncontrada  = errors.New("tarea no encontrada")
	errAlCargar      = errors.New("error al cargar el archivo")
)

// TODO: devuelve un almacén nuevo apuntando al archivo ruta (no carga nada todavía).
func NuevoAlmacen(ruta string) *Almacen {
	return &Almacen{} // TODO: completa la función
}

// TODO: agrega una tarea con el siguiente ID. Devuelve errTituloVacio si el título está vacío.
func (a *Almacen) Agregar(titulo string) (Tarea, error) {
	return Tarea{}, nil // TODO: completa la función
}

// TODO: devuelve todas las tareas.
func (a *Almacen) Listar() []Tarea {
	return nil // TODO: completa la función
}

// TODO: devuelve solo las tareas pendientes.
func (a *Almacen) Pendientes() []Tarea {
	return nil // TODO: completa la función
}

// TODO: marca como completada la tarea con el ID dado o devuelve errNoEncontrada.
func (a *Almacen) Completar(id int) error {
	return nil // TODO: completa la función
}

// TODO: elimina la tarea con el ID dado o devuelve errNoEncontrada.
func (a *Almacen) Eliminar(id int) error {
	return nil // TODO: completa la función
}

// TODO: serializa el estado a JSON y lo escribe en a.ruta.
func (a *Almacen) Guardar() error {
	return nil // TODO: completa la función
}

// TODO: lee el archivo a.ruta, deserializa y restaura tareas y siguienteID.
func (a *Almacen) Cargar() error {
	return nil // TODO: completa la función
}

func main() {
	almacen := NuevoAlmacen("tareas.json")
	almacen.Agregar("Comprar pan")
	almacen.Agregar("Estudiar Go")
	if err := almacen.Guardar(); err != nil {
		fmt.Println(err)
	}
	otro := NuevoAlmacen("tareas.json")
	if err := otro.Cargar(); err != nil {
		fmt.Println(err)
	}
	fmt.Println("tareas:", otro.Listar())
}