# Ejercicio 01 — Gestor de tareas CLI

- **Nivel:** 5/5
- **Tema:** structs, slices, métodos con receptor por puntero y manejo de errores
- **Tiempo estimado:** 45 min

## Enunciado

Completa el archivo `main.go` para construir un **gestor de tareas** en memoria:

1. `NuevoGestor() *GestorTareas` → devuelve un gestor vacío.
2. `(g *GestorTareas) Agregar(titulo string) Tarea` → crea una tarea con el siguiente ID (empieza en 1), la añade y la devuelve.
3. `(g *GestorTareas) Completar(id int) error` → marca como completada la tarea con ese ID, o devuelve `errTareaNoEncontrada`.
4. `(g *GestorTareas) Pendientes() []Tarea` → solo las tareas no completadas.
5. `(g *GestorTareas) Contar() int` → número total de tareas.
6. `(g *GestorTareas) Obtener(id int) (Tarea, error)` → la tarea con ese ID o `errTareaNoEncontrada`.

## Requisitos

- [ ] `NuevoGestor()` empieza vacío (`Contar() == 0`).
- [ ] La primera `Agregar` asigna `ID == 1` y la segunda `ID == 2`.
- [ ] `Completar` marca la tarea y devuelve `errTareaNoEncontrada` para un ID inexistente.
- [ ] `Pendientes()` excluye las tareas completadas.
- [ ] `Obtener` devuelve la tarea correcta y un error para IDs inexistentes.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa receptor por **puntero** (`func (g *GestorTareas) ...`) en los métodos que modifican el gestor.
- En `Agregar`: incrementa primero `g.siguienteID++` y luego `tarea := Tarea{ID: g.siguienteID, Titulo: titulo}` y `g.tareas = append(g.tareas, tarea)`.
- Recorre con `for i := range g.tareas` para modificar el elemento por índice (p. ej. `g.tareas[i].Completada = true`).
- Para `Obtener`/`Completar`, busca el ID con un `for` y devuelve el error de paquete si no lo encuentras.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "errors"

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

var errTareaNoEncontrada = errors.New("tarea no encontrada")

func NuevoGestor() *GestorTareas {
	return &GestorTareas{}
}

func (g *GestorTareas) Agregar(titulo string) Tarea {
	g.siguienteID++
	tarea := Tarea{ID: g.siguienteID, Titulo: titulo}
	g.tareas = append(g.tareas, tarea)
	return tarea
}

func (g *GestorTareas) Completar(id int) error {
	for i := range g.tareas {
		if g.tareas[i].ID == id {
			g.tareas[i].Completada = true
			return nil
		}
	}
	return errTareaNoEncontrada
}

func (g *GestorTareas) Pendientes() []Tarea {
	pendientes := []Tarea{}
	for _, t := range g.tareas {
		if !t.Completada {
			pendientes = append(pendientes, t)
		}
	}
	return pendientes
}

func (g *GestorTareas) Contar() int {
	return len(g.tareas)
}

func (g *GestorTareas) Obtener(id int) (Tarea, error) {
	for _, t := range g.tareas {
		if t.ID == id {
			return t, nil
		}
	}
	return Tarea{}, errTareaNoEncontrada
}
````

</details>