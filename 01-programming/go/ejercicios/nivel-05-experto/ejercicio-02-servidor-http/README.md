# Ejercicio 02 — Servidor HTTP

- **Nivel:** 5/5
- **Tema:** `net/http`, `http.ServeMux`, handlers y pruebas con `httptest`
- **Tiempo estimado:** 45 min

## Enunciado

Completa el archivo `main.go` para crear un servidor HTTP con dos rutas:

1. `manejadorSaludo(w http.ResponseWriter, r *http.Request)` responde `Hola, <nombre>!` como texto plano. El nombre viene del query parameter `?nombre=`; si falta, usa `mundo`.
2. `manejadorJSON(w http.ResponseWriter, r *http.Request)` responde el JSON `{"mensaje":"hola desde Go"}` con `Content-Type: application/json`.
3. `crearMux() *http.ServeMux` registra `/saludo` y `/json` (usa `mux.HandleFunc`).
4. `crearServidor(mux http.Handler) *http.Server` devuelve `&http.Server{Addr: ":8080", Handler: mux, ReadTimeout: 5 * time.Second}`.

Prueba con `go run .` y luego `curl http://localhost:8080/saludo?nombre=Ana` en otra terminal.

## Requisitos

- [ ] `GET /saludo` responde `Hola, mundo!` con código 200.
- [ ] `GET /saludo?nombre=Ana` responde `Hola, Ana!`.
- [ ] `GET /json` responde JSON con `Content-Type: application/json`.
- [ ] Un camino no registrado en `crearMux` devuelve `404`.
- [ ] `crearServidor` usa `Addr: ":8080"` y un handler no nulo.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El query parameter se lee con `r.URL.Query().Get("nombre")`.
- Responde con `fmt.Fprintf(w, "Hola, %s!", nombre)`.
- Para JSON: `w.Header().Set("Content-Type", "application/json")` y luego `fmt.Fprint(w, "{\"mensaje\":\"hola desde Go\"}")`.
- `http.NewServeMux()` + `mux.HandleFunc("/saludo", manejadorSaludo)`.
- Los tests usan `httptest`; no necesitas abrir puertos reales.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

import (
	"fmt"
	"net/http"
	"time"
)

func manejadorSaludo(w http.ResponseWriter, r *http.Request) {
	nombre := r.URL.Query().Get("nombre")
	if nombre == "" {
		nombre = "mundo"
	}
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	fmt.Fprintf(w, "Hola, %s!", nombre)
}

func manejadorJSON(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprint(w, `{"mensaje":"hola desde Go"}`)
}

func crearMux() *http.ServeMux {
	mux := http.NewServeMux()
	mux.HandleFunc("/saludo", manejadorSaludo)
	mux.HandleFunc("/json", manejadorJSON)
	return mux
}

func crearServidor(mux http.Handler) *http.Server {
	return &http.Server{
		Addr:        ":8080",
		Handler:     mux,
		ReadTimeout: 5 * time.Second,
	}
}
````

</details>