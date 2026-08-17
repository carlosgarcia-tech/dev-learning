# Ejercicio 04 — Caché LRU

- **Nivel:** 5/5
- **Tema:** `container/list`, estructuras de datos y política de expulsión LRU
- **Tiempo estimado:** 60 min

## Enunciado

Implementa una **caché LRU** (Least Recently Used) con capacidad limitada. Cuando la caché está llena y se añade una clave nueva, se **expulsa la clave usada hace más tiempo**.

Completa `main.go`:

1. `NuevoCacheLRU(capacidad int) *CacheLRU` → inicializa `datos` (mapa clave → nodo de la lista) y `orden` (lista doblemente enlazada).
2. `(c *CacheLRU) Obtener(clave string) (int, bool)` → devuelve `(valor, true)` si existe y la marca como recién usada (muévela al frente). Si no existe, `(0, false)`.
3. `(c *CacheLRU) Guardar(clave string, valor int)` → guarda; si la clave ya existía, actualiza el valor y la mueve al frente; si está llena, elimina el elemento del final (`c.orden.Back()`).
4. `(c *CacheLRU) Contar() int` → `c.orden.Len()`.
5. `(c *CacheLRU) Existe(clave string) bool`.

## Requisitos

- [ ] `Guardar` + `Obtener` funcionan para dos claves con capacidad 2.
- [ ] `Obtener` de una clave inexistente devuelve `false`.
- [ ] Con capacidad 2 y 3 guardados, la clave más antigua se expulsa (`Existe` devuelve `false`).
- [ ] `Obtener` evita que una clave sea expulsada (la convierte en la más reciente).
- [ ] `Guardar` una clave existente actualiza el valor sin duplicarla.
- [ ] Una caché de capacidad 0 no guarda nada.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `list.New()` crea una lista doblemente enlazada; `PushFront`, `MoveToFront`, `Back`, `Remove` y `Len` son sus métodos.
- El mapa guarda `map[string]*list.Element` para poder localizar un nodo y moverlo al frente en O(1).
- Cada nodo guarda una `entradaLRU{clave, valor}`; accede con `elem.Value.(entradaLRU)`.
- Al expulsar: `viejo := c.orden.Back(); c.orden.Remove(viejo); delete(c.datos, viejo.Value.(entradaLRU).clave)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import "container/list"

// entradaLRU es el dato guardado en cada nodo de la lista.
type entradaLRU struct {
	clave string
	valor int
}

// CacheLRU implementa una caché de capacidad limitada que expulsa el elemento
// usado hace más tiempo (Least Recently Used) cuando se llena.
type CacheLRU struct {
	capacidad int
	datos     map[string]*list.Element
	orden     *list.List
}

func NuevoCacheLRU(capacidad int) *CacheLRU {
	return &CacheLRU{
		capacidad: capacidad,
		datos:     make(map[string]*list.Element),
		orden:     list.New(),
	}
}

func (c *CacheLRU) Obtener(clave string) (int, bool) {
	elem, ok := c.datos[clave]
	if !ok {
		return 0, false
	}
	c.orden.MoveToFront(elem)
	return elem.Value.(entradaLRU).valor, true
}

func (c *CacheLRU) Guardar(clave string, valor int) {
	if c.capacidad <= 0 {
		return
	}
	if elem, ok := c.datos[clave]; ok {
		elem.Value = entradaLRU{clave: clave, valor: valor}
		c.orden.MoveToFront(elem)
		return
	}
	if c.orden.Len() >= c.capacidad {
		viejo := c.orden.Back()
		if viejo != nil {
			c.orden.Remove(viejo)
			delete(c.datos, viejo.Value.(entradaLRU).clave)
		}
	}
	elem := c.orden.PushFront(entradaLRU{clave: clave, valor: valor})
	c.datos[clave] = elem
}

func (c *CacheLRU) Contar() int {
	return c.orden.Len()
}

func (c *CacheLRU) Existe(clave string) bool {
	_, ok := c.datos[clave]
	return ok
}
````

</details>