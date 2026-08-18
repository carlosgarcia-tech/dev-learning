package main

import (
	"testing"
	"time"
)

func TestCombinarCanalesSumaDeterminista(t *testing.T) {
	a := make(chan int)
	b := make(chan int)
	go func() {
		for _, v := range []int{1, 2} {
			a <- v
		}
		close(a)
	}()
	go func() {
		for _, v := range []int{3, 4, 5} {
			b <- v
		}
		close(b)
	}()
	valores := combinarCanales(a, b)
	if len(valores) != 5 {
		t.Fatalf("combinarCanales devolvió %d valores; se esperaban 5", len(valores))
	}
	suma := 0
	for _, v := range valores {
		suma += v
	}
	if suma != 15 {
		t.Errorf("suma = %d; se esperaba 15", suma)
	}
}

func TestCombinarCanalesContenido(t *testing.T) {
	a := make(chan int, 1)
	b := make(chan int, 1)
	a <- 7
	close(a)
	b <- 9
	close(b)
	valores := combinarCanales(a, b)
	vistos := map[int]bool{}
	for _, v := range valores {
		vistos[v] = true
	}
	if !vistos[7] || !vistos[9] {
		t.Errorf("combinarCanales debe contener 7 y 9, obtuvo %v", valores)
	}
}

func TestRecibirDeCualquiera(t *testing.T) {
	a := make(chan int, 1)
	b := make(chan int, 1)
	b <- 99
	if got := recibirDeCualquiera(a, b); got != 99 {
		t.Errorf("recibirDeCualquiera = %d; se esperaba 99", got)
	}
	a <- 5
	if got := recibirDeCualquiera(a, b); got != 5 {
		t.Errorf("recibirDeCualquiera = %d; se esperaba 5", got)
	}
}

func TestConTimeoutConValor(t *testing.T) {
	ch := make(chan int, 1)
	ch <- 7
	got, ok := conTimeout(ch, 50*time.Millisecond)
	if !ok || got != 7 {
		t.Errorf("conTimeout con valor = (%d, %v); se esperaba (7, true)", got, ok)
	}
}

func TestConTimeoutAgotado(t *testing.T) {
	ch := make(chan int)
	got, ok := conTimeout(ch, 20*time.Millisecond)
	if ok {
		t.Errorf("conTimeout agotado debe devolver false, obtuvo %d, %v", got, ok)
	}
	if got != 0 {
		t.Errorf("conTimeout agotado debe devolver 0 como valor, obtuvo %d", got)
	}
}