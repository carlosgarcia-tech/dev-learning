package main

import (
	"fmt"
	"net/http"
)

// TODO: responde "Hola, <nombre>!" como text/plain. Si no hay ?nombre= usa "mundo".
func manejadorSaludo(w http.ResponseWriter, r *http.Request) {
	// TODO: completa la función
}

// TODO: responde {"mensaje":"hola desde Go"} con Content-Type application/json.
func manejadorJSON(w http.ResponseWriter, r *http.Request) {
	// TODO: completa la función
}

// TODO: devuelve un ServeMux con las rutas "/saludo" -> manejadorSaludo y "/json" -> manejadorJSON.
func crearMux() *http.ServeMux {
	return http.NewServeMux() // TODO: registra las rutas
}

// TODO: devuelve un servidor HTTP con Addr ":8080" y el handler dado.
func crearServidor(mux http.Handler) *http.Server {
	return &http.Server{} // TODO: completa la función
}

func main() {
	servidor := crearServidor(crearMux())
	fmt.Println("Escuchando en", servidor.Addr)
	fmt.Println("Prueba con: curl http://localhost:8080/saludo?nombre=Ana")
	if err := http.ListenAndServe(servidor.Addr, servidor.Handler); err != nil {
		fmt.Println(err)
	}
}