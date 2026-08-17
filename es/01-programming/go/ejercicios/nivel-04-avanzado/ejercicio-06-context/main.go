package main

import (
	"context"
	"fmt"
)

// TODO: ejecuta fn en una goroutine y devuelve su resultado; si ctx se cancela antes, devuelve el error del contexto.
func procesarConContexto(ctx context.Context, fn func() (string, error)) (string, error) {
	return "", nil // TODO: completa la función
}

// TODO: simula una tarea que tarda ms milisegundos, pero se cancela si ctx expira antes.
func tareaLenta(ctx context.Context, ms int) (string, error) {
	return "", nil // TODO: completa la función
}

func main() {
	ctx := context.Background()
	fmt.Println(tareaLenta(ctx, 10))
	resultado, err := procesarConContexto(ctx, func() (string, error) {
		return "listo", nil
	})
	fmt.Println(resultado, err)
}