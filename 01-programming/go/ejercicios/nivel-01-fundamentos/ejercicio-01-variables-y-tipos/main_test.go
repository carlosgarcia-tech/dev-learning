package main

import (
	"bytes"
	"fmt"
	"io"
	"os"
	"strings"
	"testing"
)

func TestMainFunction(t *testing.T) {
	// Guardar la salida estándar original
	originalStdout := os.Stdout
	r, w, _ := os.Pipe()
	os.Stdout = w

	// Ejecutar la función main
	main()

	// Restaurar la salida estándar
	w.Close()
	os.Stdout = originalStdout

	// Leer la salida
	var buf bytes.Buffer
	io.Copy(&buf, r)
	output := buf.String()

	// Verificar que la salida contiene los datos esperados
	expectedData := []string{
		"Datos del usuario:",
		"Nombre:",
		"Edad:",
		"Altura:",
		"Estudiante:",
	}

	for _, expected := range expectedData {
		if !strings.Contains(output, expected) {
			t.Errorf("La salida no contiene '%s'.\nSalida obtenida:\n%s", expected, output)
		}
	}

	// Verificar que se muestra un número para la edad (puede ser 0 si no se pidió entrada)
	if !strings.ContainsAny(output, "0123456789") {
		t.Error("La salida debe contener números (edad o altura)")
	}

	fmt.Println("✅ ¡Todos los tests pasaron!")
}