# Ejercicio 03 — API REST

- **Nivel:** 5/5
- **Tema:** `net/http`, routing con métodos (Go 1.22+), `encoding/json` y `sync.Mutex`
- **Tiempo estimado:** 60 min

## Enunciado

Construye una **API REST de tareas** usando solo la biblioteca estándar.

**Capa de datos** (`Repositorio`):

1. `NuevoRepositorio()` → repositorio vacío con `siguienteID = 1`.
2. `Crear(titulo string) (Tarea, error)` → asigna el siguiente ID; devuelve `errTituloVacio` si el título está vacío.
3. `Obtener(id int) (Tarea, error)`, `Listar() []Tarea`, `Actualizar(id int, titulo string) (Tarea, error)`, `Completar(id int) (Tarea, error)`, `Eliminar(id int) error`.
   - Los que buscan por ID devuelven `errTareaNoEncontrada` si no existe.
   - Protege el mapa con `sync.Mutex` (acceso concurrente seguro).

**Capa HTTP** (`Servidor`), ruta por ruta:

| Método y ruta | Comportamiento |
|---|---|
| `GET /tareas` | 200 con `{"tareas": [...]}` |
| `POST /tareas` | 201 con la tarea; 400 si el JSON o el título son inválidos |
| `GET /tareas/{id}` | 200 con la tarea; 404 si no existe |
| `PUT /tareas/{id}` | 200 con la tarea actualizada; 404 si no existe |
| `DELETE /tareas/{id}` | 204 sin cuerpo; 404 si no existe |
| `PUT /tareas/{id}/completar` | 200 con `completada: true`; 404 si no existe |

Usa los patrones de ruta con método de Go 1.22+ (p. ej. `mux.HandleFunc("GET /tareas", ...)`) y lee el id con `r.PathValue("id")`.

## Requisitos

- [ ] `Crear` asigna IDs correlativos y rechaza títulos vacíos con `errTituloVacio`.
- [ ] `Obtener`/`Actualizar`/`Completar`/`Eliminar` devuelven `errTareaNoEncontrada` para IDs inexistentes.
- [ ] `POST /tareas` devuelve 201 y la tarea creada (id 1, título correcto).
- [ ] `POST /tareas` con título vacío o JSON malformado devuelve 400.
- [ ] `GET /tareas` devuelve `{"tareas": [...]}` con el número correcto de tareas.
- [ ] `GET /tareas/{id}` devuelve 200 o 404 según corresponda.
- [ ] `PUT /tareas/{id}` actualiza el título y `PUT /tareas/{id}/completar` marca como completada.
- [ ] `DELETE /tareas/{id}` devuelve 204 y la tarea desaparece del listado.
- [ ] Una ruta desconocida devuelve 404.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para responder JSON: `w.Header().Set("Content-Type", "application/json")` + `json.NewEncoder(w).Encode(v)`. Crea un helper `escribirJSON`.
- Decodifica el cuerpo con `json.NewDecoder(r.Body).Decode(&estructura)`.
- Un struct anónimo sirve para el cuerpo: `var cuerpo struct { Titulo string `json:"titulo"` }`.
- `r.PathValue("id")` devuelve el segmento capturado por `{id}`; convierte con `strconv.Atoi`.
- Métodos del receptor por puntero en `Servidor` para acceder a `s.repo`.
- Recuerda `defer r.mu.Unlock()` justo después de `r.mu.Lock()`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import (
	"encoding/json"
	"errors"
	"net/http"
	"strconv"
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

func NuevoRepositorio() *Repositorio {
	return &Repositorio{tareas: map[int]Tarea{}, siguienteID: 1}
}

func (r *Repositorio) Crear(titulo string) (Tarea, error) {
	if titulo == "" {
		return Tarea{}, errTituloVacio
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	tarea := Tarea{ID: r.siguienteID, Titulo: titulo}
	r.tareas[tarea.ID] = tarea
	r.siguienteID++
	return tarea, nil
}

func (r *Repositorio) Obtener(id int) (Tarea, error) {
	r.mu.Lock()
	defer r.mu.Unlock()
	tarea, ok := r.tareas[id]
	if !ok {
		return Tarea{}, errTareaNoEncontrada
	}
	return tarea, nil
}

func (r *Repositorio) Listar() []Tarea {
	r.mu.Lock()
	defer r.mu.Unlock()
	lista := make([]Tarea, 0, len(r.tareas))
	for _, t := range r.tareas {
		lista = append(lista, t)
	}
	return lista
}

func (r *Repositorio) Actualizar(id int, titulo string) (Tarea, error) {
	r.mu.Lock()
	defer r.mu.Unlock()
	tarea, ok := r.tareas[id]
	if !ok {
		return Tarea{}, errTareaNoEncontrada
	}
	tarea.Titulo = titulo
	r.tareas[id] = tarea
	return tarea, nil
}

func (r *Repositorio) Completar(id int) (Tarea, error) {
	r.mu.Lock()
	defer r.mu.Unlock()
	tarea, ok := r.tareas[id]
	if !ok {
		return Tarea{}, errTareaNoEncontrada
	}
	tarea.Completada = true
	r.tareas[id] = tarea
	return tarea, nil
}

func (r *Repositorio) Eliminar(id int) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	if _, ok := r.tareas[id]; !ok {
		return errTareaNoEncontrada
	}
	delete(r.tareas, id)
	return nil
}

func (s *Servidor) Router() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /tareas", s.manejadorListar)
	mux.HandleFunc("POST /tareas", s.manejadorCrear)
	mux.HandleFunc("GET /tareas/{id}", s.manejadorObtener)
	mux.HandleFunc("PUT /tareas/{id}", s.manejadorActualizar)
	mux.HandleFunc("DELETE /tareas/{id}", s.manejadorEliminar)
	mux.HandleFunc("PUT /tareas/{id}/completar", s.manejadorCompletar)
	return mux
}

func escribirJSON(w http.ResponseWriter, codigo int, v interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(codigo)
	_ = json.NewEncoder(w).Encode(v)
}

func idDeRuta(r *http.Request) (int, error) {
	return strconv.Atoi(r.PathValue("id"))
}

func (s *Servidor) manejadorListar(w http.ResponseWriter, r *http.Request) {
	escribirJSON(w, http.StatusOK, map[string]interface{}{"tareas": s.repo.Listar()})
}

func (s *Servidor) manejadorCrear(w http.ResponseWriter, r *http.Request) {
	var cuerpo struct {
		Titulo string `json:"titulo"`
	}
	if err := json.NewDecoder(r.Body).Decode(&cuerpo); err != nil {
		escribirJSON(w, http.StatusBadRequest, map[string]string{"error": "JSON inválido"})
		return
	}
	tarea, err := s.repo.Crear(cuerpo.Titulo)
	if err != nil {
		escribirJSON(w, http.StatusBadRequest, map[string]string{"error": err.Error()})
		return
	}
	escribirJSON(w, http.StatusCreated, tarea)
}

func (s *Servidor) manejadorObtener(w http.ResponseWriter, r *http.Request) {
	id, err := idDeRuta(r)
	if err != nil {
		escribirJSON(w, http.StatusBadRequest, map[string]string{"error": "id inválido"})
		return
	}
	tarea, err := s.repo.Obtener(id)
	if err != nil {
		escribirJSON(w, http.StatusNotFound, map[string]string{"error": err.Error()})
		return
	}
	escribirJSON(w, http.StatusOK, tarea)
}

func (s *Servidor) manejadorActualizar(w http.ResponseWriter, r *http.Request) {
	id, err := idDeRuta(r)
	if err != nil {
		escribirJSON(w, http.StatusBadRequest, map[string]string{"error": "id inválido"})
		return
	}
	var cuerpo struct {
		Titulo string `json:"titulo"`
	}
	if err := json.NewDecoder(r.Body).Decode(&cuerpo); err != nil {
		escribirJSON(w, http.StatusBadRequest, map[string]string{"error": "JSON inválido"})
		return
	}
	tarea, err := s.repo.Actualizar(id, cuerpo.Titulo)
	if err != nil {
		escribirJSON(w, http.StatusNotFound, map[string]string{"error": err.Error()})
		return
	}
	escribirJSON(w, http.StatusOK, tarea)
}

func (s *Servidor) manejadorEliminar(w http.ResponseWriter, r *http.Request) {
	id, err := idDeRuta(r)
	if err != nil {
		escribirJSON(w, http.StatusBadRequest, map[string]string{"error": "id inválido"})
		return
	}
	if err := s.repo.Eliminar(id); err != nil {
		escribirJSON(w, http.StatusNotFound, map[string]string{"error": err.Error()})
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func (s *Servidor) manejadorCompletar(w http.ResponseWriter, r *http.Request) {
	id, err := idDeRuta(r)
	if err != nil {
		escribirJSON(w, http.StatusBadRequest, map[string]string{"error": "id inválido"})
		return
	}
	tarea, err := s.repo.Completar(id)
	if err != nil {
		escribirJSON(w, http.StatusNotFound, map[string]string{"error": err.Error()})
		return
	}
	escribirJSON(w, http.StatusOK, tarea)
}
````

</details>