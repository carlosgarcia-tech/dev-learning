package main

import (
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestManejadorSaludo(t *testing.T) {
	peticion := httptest.NewRequest(http.MethodGet, "/saludo", nil)
	respuesta := httptest.NewRecorder()
	manejadorSaludo(respuesta, peticion)

	if respuesta.Code != http.StatusOK {
		t.Errorf("status = %d; se esperaba 200", respuesta.Code)
	}
	body, _ := io.ReadAll(respuesta.Result().Body)
	if string(body) != "Hola, mundo!" {
		t.Errorf("body = %q; se esperaba %q", body, "Hola, mundo!")
	}
}

func TestManejadorSaludoConNombre(t *testing.T) {
	peticion := httptest.NewRequest(http.MethodGet, "/saludo?nombre=Ana", nil)
	respuesta := httptest.NewRecorder()
	manejadorSaludo(respuesta, peticion)

	body, _ := io.ReadAll(respuesta.Result().Body)
	if string(body) != "Hola, Ana!" {
		t.Errorf("body = %q; se esperaba %q", body, "Hola, Ana!")
	}
}

func TestManejadorJSON(t *testing.T) {
	peticion := httptest.NewRequest(http.MethodGet, "/json", nil)
	respuesta := httptest.NewRecorder()
	manejadorJSON(respuesta, peticion)

	if ct := respuesta.Header().Get("Content-Type"); !strings.HasPrefix(ct, "application/json") {
		t.Errorf("Content-Type = %q; se esperaba application/json", ct)
	}
	body, _ := io.ReadAll(respuesta.Result().Body)
	if !strings.Contains(string(body), "hola desde Go") {
		t.Errorf("el body %q debe contener \"hola desde Go\"", body)
	}
}

func TestCrearMuxRutas(t *testing.T) {
	servidor := httptest.NewServer(crearMux())
	defer servidor.Close()

	resp, err := http.Get(servidor.URL + "/saludo")
	if err != nil {
		t.Fatalf("GET /saludo falló: %v", err)
	}
	resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		t.Errorf("GET /saludo -> %d; se esperaba 200", resp.StatusCode)
	}

	resp, err = http.Get(servidor.URL + "/no-existe")
	if err != nil {
		t.Fatalf("GET /no-existe falló: %v", err)
	}
	resp.Body.Close()
	if resp.StatusCode != http.StatusNotFound {
		t.Errorf("GET /no-existe -> %d; se esperaba 404", resp.StatusCode)
	}
}

func TestCrearServidor(t *testing.T) {
	mux := http.NewServeMux()
	servidor := crearServidor(mux)
	if servidor.Addr != ":8080" {
		t.Errorf("Addr = %q; se esperaba \":8080\"", servidor.Addr)
	}
	if servidor.Handler == nil {
		t.Error("Handler no debe ser nil")
	}
}