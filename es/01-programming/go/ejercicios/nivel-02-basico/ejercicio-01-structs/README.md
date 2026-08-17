# Ejercicio 01 — Structs

- **Nivel:** 2/5
- **Tema:** definición de structs, campos y métodos básicos
- **Tiempo estimado:** 20 min

## Enunciado

Completa el archivo `main.go` para que:

1. `nuevaPersona(nombre string, edad int, ciudad string) Persona` devuelva una `Persona` con esos campos.
2. El método `(p Persona) esMayorDeEdad() bool` devuelva `true` si `p.Edad >= 18`.
3. El método `(p Persona) presentacion() string` devuelva el texto `"<Nombre>, <Edad> años, ciudad de <Ciudad>"`.

El tipo `Persona` ya está definido en el stub con los campos `Nombre`, `Edad` y `Ciudad`.

## Requisitos

- [ ] `nuevaPersona("Ana", 30, "Lima")` rellena los tres campos correctamente.
- [ ] `esMayorDeEdad` devuelve `false` para 17 y `true` para 18 y 65.
- [ ] `presentacion` usa exactamente el formato `"Ana, 30 años, ciudad de Lima"`.
- [ ] `presentacion` refleja los valores que recibe la persona.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un struct se crea con `Persona{Nombre: nombre, Edad: edad, Ciudad: ciudad}`.
- Un método se declara igual que una función pero con un *receptor*: `func (p Persona) nombre() tipo { ... }`.
- Dentro del método accedes a los campos con `p.Nombre`, `p.Edad`, `p.Ciudad`.
- Para la presentación usa `fmt.Sprintf`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "fmt"

// Persona representa a una persona con nombre, edad y ciudad.
type Persona struct {
	Nombre string
	Edad   int
	Ciudad string
}

func nuevaPersona(nombre string, edad int, ciudad string) Persona {
	return Persona{Nombre: nombre, Edad: edad, Ciudad: ciudad}
}

func (p Persona) esMayorDeEdad() bool {
	return p.Edad >= 18
}

func (p Persona) presentacion() string {
	return fmt.Sprintf("%s, %d años, ciudad de %s", p.Nombre, p.Edad, p.Ciudad)
}
````

</details>