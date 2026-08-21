// app/main.go — servidor HTTP mínimo en Go (sin dependencias externas)
package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]string{"ok": "true", "runtime": "scratch"})
	})
	fmt.Printf("app (scratch) escuchando en :%s\n", port)
	http.ListenAndServe(":"+port, nil)
}
