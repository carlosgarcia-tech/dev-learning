package main

import "testing"

func TestGuardarYObtener(t *testing.T) {
	cache := NuevoCacheLRU(2)
	cache.Guardar("a", 1)
	cache.Guardar("b", 2)
	if cache.Contar() != 2 {
		t.Errorf("Contar() = %d; se esperaba 2", cache.Contar())
	}
	valor, ok := cache.Obtener("a")
	if !ok || valor != 1 {
		t.Errorf("Obtener(\"a\") = (%d, %v); se esperaba (1, true)", valor, ok)
	}
	valor, ok = cache.Obtener("b")
	if !ok || valor != 2 {
		t.Errorf("Obtener(\"b\") = (%d, %v); se esperaba (2, true)", valor, ok)
	}
}

func TestObtenerInexistente(t *testing.T) {
	cache := NuevoCacheLRU(1)
	cache.Guardar("a", 1)
	if _, ok := cache.Obtener("z"); ok {
		t.Error("Obtener(\"z\") debe devolver false")
	}
}

func TestEvictaLoMenosUsado(t *testing.T) {
	cache := NuevoCacheLRU(2)
	cache.Guardar("a", 1)
	cache.Guardar("b", 2)
	cache.Guardar("c", 3) // expulsa "a"
	if cache.Existe("a") {
		t.Error("la clave \"a\" debió expulsarse al llenarse la caché")
	}
	if !cache.Existe("b") || !cache.Existe("c") {
		t.Error("las claves \"b\" y \"c\" deben seguir en la caché")
	}
	if cache.Contar() != 2 {
		t.Errorf("Contar() = %d; se esperaba 2", cache.Contar())
	}
}

func TestObtenerEvitaExpulsion(t *testing.T) {
	cache := NuevoCacheLRU(2)
	cache.Guardar("a", 1)
	cache.Guardar("b", 2)
	cache.Obtener("a") // "a" pasa a ser la más reciente
	cache.Guardar("c", 3)
	if cache.Existe("b") {
		t.Error("la clave \"b\" debió expulsarse (no se usó recientemente)")
	}
	if !cache.Existe("a") || !cache.Existe("c") {
		t.Error("las claves \"a\" y \"c\" deben seguir en la caché")
	}
}

func TestGuardarActualizaValor(t *testing.T) {
	cache := NuevoCacheLRU(1)
	cache.Guardar("a", 1)
	cache.Guardar("a", 2)
	if cache.Contar() != 1 {
		t.Errorf("Contar() = %d; se esperaba 1 (la clave no se duplica)", cache.Contar())
	}
	valor, ok := cache.Obtener("a")
	if !ok || valor != 2 {
		t.Errorf("Obtener(\"a\") = (%d, %v); se esperaba (2, true)", valor, ok)
	}
}

func TestCapacidadCero(t *testing.T) {
	cache := NuevoCacheLRU(0)
	cache.Guardar("a", 1)
	if cache.Contar() != 0 {
		t.Errorf("una caché de capacidad 0 no debe guardar nada, Contar() = %d", cache.Contar())
	}
}