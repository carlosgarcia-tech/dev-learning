package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"

	"proyectofinal/datos"
	"proyectofinal/modelos"
	"proyectofinal/servicios"
)

func main() {
	libros := datos.Nuevo[modelos.Libro]()
	miembros := datos.Nuevo[modelos.Miembro]()
	prestamos := datos.Nuevo[modelos.Prestamo]()

	servicio := servicios.NuevoBiblioteca(libros, miembros, prestamos)
	reportes := servicios.NuevoReportes(servicio)
	_ = reportes

	leer := bufio.NewReader(os.Stdin)
	for {
		fmt.Println("\n=== Sistema de Gestión de Biblioteca ===")
		fmt.Println("1. Dar de alta un libro")
		fmt.Println("2. Buscar libros")
		fmt.Println("3. Dar de alta un miembro")
		fmt.Println("4. Crear préstamo")
		fmt.Println("5. Devolver préstamo")
		fmt.Println("6. Préstamos vencidos")
		fmt.Println("7. Resumen")
		fmt.Println("0. Salir")
		fmt.Print("Opción: ")

		opcion, _ := leer.ReadString('\n')
		opcion = strings.TrimSpace(opcion)

		switch opcion {
		case "1":
			// TODO: lee título, autor, ISBN, año y género por consola y
			// llama a servicio.AltaLibro. Muestra el resultado o el error.
		case "2":
			fmt.Print("Texto a buscar: ")
			texto, _ := leer.ReadString('\n')
			texto = strings.TrimSpace(texto)
			// TODO: llama a servicio.BuscarLibros(texto) y lista los
			// resultados con su ID, título y autor.
		case "3":
			// TODO: lee nombre, email y teléfono por consola y llama a
			// servicio.AltaMiembro. Muestra el resultado o el error.
		case "4":
			// TODO: lee el ID del libro y del miembro y llama a
			// servicio.CrearPrestamo. Muestra el préstamo o el error.
		case "5":
			// TODO: lee el ID del préstamo y llama a servicio.DevolverPrestamo.
			// Muestra el préstamo o el error.
		case "6":
			// TODO: llama a servicio.PrestamosVencidos y muestra cada
			// préstamo vencido o "No hay préstamos vencidos".
		case "7":
			// TODO: llama a reportes.Resumen y muestra cada total en una
			// línea (clave: valor).
		case "0":
			fmt.Println("¡Hasta luego!")
			return
		default:
			fmt.Println("Opción no válida.")
		}
	}
}
