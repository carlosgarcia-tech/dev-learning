package main

import (
	"context"
	"fmt"
	"strings"
	"testing"
	"time"
)

func TestTareaLentaCompleta(t *testing.T) {
	ctx := context.Background()
	got, err := tareaLenta(ctx, 5)
	if err != nil {
		t.Fatalf("tareaLenta no debe devolver error: %v", err)
	}
	if got != "ok" {
		t.Errorf("tareaLenta = %q; se esperaba %q", got, "ok")
	}
}

func TestTareaLentaSeCancela(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Millisecond)
	defer cancel()
	_, err := tareaLenta(ctx, 200)
	if err == nil {
		t.Fatal("tareaLenta con timeout corto debe devolver un error de contexto")
	}
	if !strings.Contains(err.Error(), "deadline exceeded") {
		t.Errorf("el error %q debe indicar deadline exceeded", err)
	}
}

func TestProcesarConContextoExitoso(t *testing.T) {
	ctx := context.Background()
	got, err := procesarConContexto(ctx, func() (string, error) {
		return "listo", nil
	})
	if err != nil {
		t.Fatalf("procesarConContexto devolvió error: %v", err)
	}
	if got != "listo" {
		t.Errorf("procesarConContexto = %q; se esperaba %q", got, "listo")
	}
}

func TestProcesarConContextoCancelaFuncion(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	_, err := procesarConContexto(ctx, func() (string, error) {
		time.Sleep(100 * time.Millisecond)
		return "lento", nil
	})
	if err == nil {
		t.Fatal("procesarConContexto con contexto cancelado debe devolver un error")
	}
	if err != context.Canceled {
		t.Errorf("se esperaba context.Canceled, se obtuvo %v", err)
	}
}

func TestProcesarConContextoPropagaError(t *testing.T) {
	ctx := context.Background()
	_, err := procesarConContexto(ctx, func() (string, error) {
		return "", fmt.Errorf("algo falló")
	})
	if err == nil {
		t.Fatal("procesarConContexto debe propagar el error de fn")
	}
}