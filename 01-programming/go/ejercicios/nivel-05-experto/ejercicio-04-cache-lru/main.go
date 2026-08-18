package main

import (
	"container/list"
	"fmt"
)

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

// TODO: devuelve una caché nueva con la capacidad dada (datos y orden inicializados).
func NuevoCacheLRU(capacidad int) *CacheLRU {
	return &CacheLRU{capacidad: capacidad} // TODO: inicializa datos y orden
}

// TODO: devuelve (valor, true) si la clave existe (y la marca como recién usada); si no, (0, false).
func (c *CacheLRU) Obtener(clave string) (int, bool) {
	return 0, false // TODO: completa la función
}

// TODO: guarda la clave con su valor. Si ya existía, actualiza el valor y la marca como recién usada.
// Si la caché está llena, expulsa el elemento usado hace más tiempo.
func (c *CacheLRU) Guardar(clave string, valor int) {
	// TODO: completa la función
}

// TODO: devuelve el número de elementos almacenados.
func (c *CacheLRU) Contar() int {
	return 0 // TODO: completa la función
}

// TODO: devuelve true si la clave existe en la caché.
func (c *CacheLRU) Existe(clave string) bool {
	return false // TODO: completa la función
}

func main() {
	cache := NuevoCacheLRU(3)
	cache.Guardar("a", 1)
	cache.Guardar("b", 2)
	cache.Guardar("c", 3)
	fmt.Println("a existe:", cache.Existe("a"), "| elementos:", cache.Contar())
	valor, ok := cache.Obtener("b")
	fmt.Println("obtener b:", valor, ok)
}