# Ejercicio 06 — Mini proyecto: almacén de tareas con persistencia

- **Nivel:** 5/5
- **Tema:** integración: structs, errores, `encoding/json`, archivos y `sync.Mutex`
- **Tiempo estimado:** 60 min

## Enunciado

Construye un **almacén de tareas persistente** en un archivo JSON. Integra todo lo aprendido:

1. `NuevoAlmacen(ruta string) *Almacen` → almacén que apunta al archivo `ruta`.
2. `Agregar(titulo string) (Tarea, error)` → siguiente ID correlativo; `errTituloVacio` si el título está vacío.
3. `Listar() []Tarea` y `Pendientes() []Tarea`.
4. `Completar(id int) error` y `Eliminar(id int) error` → `errNoEncontrada` si el ID no existe.
5. `Guardar() error` → serializa a JSON y escribe en `a.ruta` (usa `encoding/json` y `os.WriteFile`).
6. `Cargar() error` → lee `a.ruta`, deserializa y restaura `tareas` **y** `siguienteID`.

Un struct auxiliar para la persistencia puede ser:

```go
type persistencia struct {
	Tareas      []Tarea `json:"tareas"`
	SiguienteID int     `json:"siguiente_id"`
}
```

## Requisitos

- [ ] `Agregar` asigna IDs correlativos (1, 2, ...) y rechaza títulos vacíos.
- [ ] `Completar`/`Eliminar` devuelven `errNoEncontrada` para IDs inexistentes.
- [ ] `Pendientes` excluye las tareas completadas.
- [ ] `Guardar` crea el archivo en disco con el estado serializado.
- [ ] `Cargar` restaura las tareas desde el archivo.
- [ ] `siguienteID` se preserva tras `Cargar` (la siguiente tarea continúa la numeración).
- [ ] `Cargar` de un archivo inexistente devuelve un error.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para persistir sin exportar campos: usa el struct `persistencia` y conviértelo con `Guardar`/`Cargar`.
- `json.Marshal(p)` devuelve `[]byte`; escríbelos con `os.WriteFile(a.ruta, datos, 0o644)`.
- `os.ReadFile(a.ruta)` lee; `json.Unmarshal(datos, &p)` deserializa.
- Restaura `a.tareas = p.Tareas` y `a.siguienteID = p.SiguienteID`.
- Si el archivo no existe, `os.ReadFile` devuelve `*os.PathError`; propágalo como error.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import (
	"encoding/json"
	"errors"
	"os"
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
	errTituloVacio  = errors.New("el título no puede estar vacío")
	errNoEncontrada = errors.New("tarea no encontrada")
	errAlCargar     = errors.New("error al cargar el archivo")
)

type persistencia struct {
	Tareas      []Tarea `json:"tareas"`
	SiguienteID int     `json:"siguiente_id"`
}

func NuevoAlmacen(ruta string) *Almacen {
	return &Almacen{ruta: ruta}
}

func (a *Almacen) Agregar(titulo string) (Tarea, error) {
	if titulo == "" {
		return Tarea{}, errTituloVacio
	}
	a.mu.Lock()
	defer a.mu.Unlock()
	a.siguienteID++
	tarea := Tarea{ID: a.siguienteID, Titulo: titulo}
	a.tareas = append(a.tareas, tarea)
	return tarea, nil
}

func (a *Almacen) Listar() []Tarea {
	a.mu.Lock()
	defer a.mu.Unlock()
	lista := make([]Tarea, len(a.tareas))
	copy(lista, a.tareas)
	return lista
}

func (a *Almacen) Pendientes() []Tarea {
	a.mu.Lock()
	defer a.mu.Unlock()
	pendientes := []Tarea{}
	for _, t := range a.tareas {
		if !t.Completada {
			pendientes = append(pendientes, t)
		}
	}
	return pendientes
}

func (a *Almacen) Completar(id int) error {
	a.mu.Lock()
	defer a.mu.Unlock()
	for i := range a.tareas {
		if a.tareas[i].ID == id {
			a.tareas[i].Completada = true
			return nil
		}
	}
	return errNoEncontrada
}

func (a *Almacen) Eliminar(id int) error {
	a.mu.Lock()
	defer a.mu.Unlock()
	for i := range a.tareas {
		if a.tareas[i].ID == id {
			a.tareas = append(a.tareas[:i], a.tareas[i+1:]...)
			return nil
		}
	}
	return errNoEncontrada
}

func (a *Almacen) Guardar() error {
	a.mu.Lock()
	defer a.mu.Unlock()
	p := persistencia{Tareas: a.tareas, SiguienteID: a.siguienteID}
	datos, err := json.MarshalIndent(p, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(a.ruta, datos, 0o644)
}

func (a *Almacen) Cargar() error {
	a.mu.Lock()
	defer a.mu.Unlock()
	datos, err := os.ReadFile(a.ruta)
	if err != nil {
		return err
	}
	var p persistencia
	if err := json.Unmarshal(datos, &p); err != nil {
		return err
	}
	a.tareas = p.Tareas
	a.siguienteID = p.SiguienteID
	return nil
}
````

</details>