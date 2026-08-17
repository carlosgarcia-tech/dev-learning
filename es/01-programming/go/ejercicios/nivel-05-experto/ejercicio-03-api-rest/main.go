package main

import (
	"errors"
	"fmt"
	"net/http"
	"sync"
)

// Tarea es el recurso de la API.
type Tarea struct {
	ID         int    `json:"id"`
	Titulo     string `json:"titulo"`
	Completada bool   `json:"completada"`
}

// Repositorio almacena tareas en memoria con acceso concurrente seguro.
type Repositorio struct {
	mu          sync.Mutex
	tareas      map[int]Tarea
	siguienteID int
}

// Servidor expone la API REST sobre un repositorio.
type Servidor struct {
	repo *Repositorio
}

var (
	errTareaNoEncontrada = errors.New("tarea no encontrada")
	errTituloVacio       = errors.New("el título no puede estar vacío")
)

// TODO: devuelve un repositorio vacío con siguienteID = 1.
func NuevoRepositorio() *Repositorio {
	return &Repositorio{} // TODO: completa la función
}

// TODO: crea una tarea con el siguiente ID. Devuelve errTituloVacio si el título está vacío.
func (r *Repositorio) Crear(titulo string) (Tarea, error) {
	return Tarea{}, nil // TODO: completa la función
}

// TODO: devuelve la tarea con el ID dado o errTareaNoEncontrada.
func (r *Repositorio) Obtener(id int) (Tarea, error) {
	return Tarea{}, nil // TODO: completa la función
}

// TODO: devuelve todas las tareas.
func (r *Repositorio) Listar() []Tarea {
	return nil // TODO: completa la función
}

// TODO: actualiza el título de la tarea o devuelve errTareaNoEncontrada.
func (r *Repositorio) Actualizar(id int, titulo string) (Tarea, error) {
	return Tarea{}, nil // TODO: completa la función
}

// TODO: marca la tarea como completada o devuelve errTareaNoEncontrada.
func (r *Repositorio) Completar(id int) (Tarea, error) {
	return Tarea{}, nil // TODO: completa la función
}

// TODO: elimina la tarea o devuelve errTareaNoEncontrada.
func (r *Repositorio) Eliminar(id int) error {
	return nil // TODO: completa la función
}

// TODO: devuelve el router con las rutas REST (usa los patrones con método de Go 1.22).
// GET /tareas, POST /tareas, GET/PUT/DELETE /tareas/{id}, PUT /tareas/{id}/completar
func (s *Servidor) Router() http.Handler {
	return http.NewServeMux() // TODO: registra las rutas
}

// TODO: responde la lista de tareas en JSON (200).
func (s *Servidor) manejadorListar(w http.ResponseWriter, r *http.Request) {
	// TODO: completa el manejador
}

// TODO: crea una tarea desde el cuerpo JSON. 201 con la tarea; 400 si falla la validación.
func (s *Servidor) manejadorCrear(w http.ResponseWriter, r *http.Request) {
	// TODO: completa el manejador
}

// TODO: devuelve una tarea por id (200) o 404 si no existe.
func (s *Servidor) manejadorObtener(w http.ResponseWriter, r *http.Request) {
	// TODO: completa el manejador
}

// TODO: actualiza el título de una tarea (200) o 404 si no existe.
func (s *Servidor) manejadorActualizar(w http.ResponseWriter, r *http.Request) {
	// TODO: completa el manejador
}

// TODO: elimina una tarea (204) o 404 si no existe.
func (s *Servidor) manejadorEliminar(w http.ResponseWriter, r *http.Request) {
	// TODO: completa el manejador
}

// TODO: marca como completada una tarea (200) o 404 si no existe.
func (s *Servidor) manejadorCompletar(w http.ResponseWriter, r *http.Request) {
	// TODO: completa el manejador
}

func main() {
	repo := NuevoRepositorio()
	servidor := &Servidor{repo: repo}
	fmt.Println("API de tareas escuchando en :8081")
	fmt.Println("Prueba: curl -X POST -d '{\"titulo\":\"Aprender Go\"}' http://localhost:8081/tareas")
	if err := http.ListenAndServe(":8081", servidor.Router()); err != nil {
		fmt.Println(err)
	}
}