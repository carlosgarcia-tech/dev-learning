package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
)

func nuevoServidorTest(t *testing.T) *httptest.Server {
	t.Helper()
	repo := NuevoRepositorio()
	servidor := httptest.NewServer((&Servidor{repo: repo}).Router())
	t.Cleanup(servidor.Close)
	return servidor
}

func peticionJSON(t *testing.T, metodo, url, cuerpo string) (int, map[string]interface{}) {
	t.Helper()
	var reader io.Reader
	if cuerpo != "" {
		reader = bytes.NewBufferString(cuerpo)
	}
	req, err := http.NewRequest(metodo, url, reader)
	if err != nil {
		t.Fatalf("creando petición: %v", err)
	}
	if cuerpo != "" {
		req.Header.Set("Content-Type", "application/json")
	}
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		t.Fatalf("petición %s %s falló: %v", metodo, url, err)
	}
	defer resp.Body.Close()
	data := map[string]interface{}{}
	body, _ := io.ReadAll(resp.Body)
	if len(body) > 0 {
		_ = json.Unmarshal(body, &data)
	}
	return resp.StatusCode, data
}

func TestRepositorioCrearYObtener(t *testing.T) {
	repo := NuevoRepositorio()
	tarea, err := repo.Crear("Comprar pan")
	if err != nil {
		t.Fatalf("Crear devolvió error: %v", err)
	}
	if tarea.ID != 1 {
		t.Errorf("ID = %d; se esperaba 1", tarea.ID)
	}
	obtenida, err := repo.Obtener(1)
	if err != nil || obtenida.Titulo != "Comprar pan" {
		t.Errorf("Obtener(1) = %+v, %v", obtenida, err)
	}
}

func TestRepositorioCrearTituloVacio(t *testing.T) {
	repo := NuevoRepositorio()
	if _, err := repo.Crear(""); err != errTituloVacio {
		t.Errorf("Crear(\"\") debe devolver errTituloVacio, obtuvo %v", err)
	}
}

func TestRepositorioActualizarCompletarEliminar(t *testing.T) {
	repo := NuevoRepositorio()
	repo.Crear("A")
	actualizada, err := repo.Actualizar(1, "A actualizada")
	if err != nil || actualizada.Titulo != "A actualizada" {
		t.Errorf("Actualizar = %+v, %v", actualizada, err)
	}
	completada, err := repo.Completar(1)
	if err != nil || !completada.Completada {
		t.Errorf("Completar = %+v, %v", completada, err)
	}
	if err := repo.Eliminar(1); err != nil {
		t.Errorf("Eliminar devolvió error: %v", err)
	}
	if _, err := repo.Obtener(1); err != errTareaNoEncontrada {
		t.Errorf("tras eliminar, Obtener(1) debe devolver errTareaNoEncontrada, obtuvo %v", err)
	}
}

func TestAPIPostYGet(t *testing.T) {
	servidor := nuevoServidorTest(t)
	codigo, data := peticionJSON(t, http.MethodPost, servidor.URL+"/tareas", `{"titulo":"Aprender Go"}`)
	if codigo != http.StatusCreated {
		t.Fatalf("POST /tareas -> %d; se esperaba 201", codigo)
	}
	if data["id"].(float64) != 1 || data["titulo"] != "Aprender Go" {
		t.Errorf("respuesta POST = %v", data)
	}
	codigo, lista := peticionJSON(t, http.MethodGet, servidor.URL+"/tareas", "")
	if codigo != http.StatusOK {
		t.Fatalf("GET /tareas -> %d; se esperaba 200", codigo)
	}
	items, ok := lista["tareas"].([]interface{})
	if !ok || len(items) != 1 {
		t.Errorf("GET /tareas debe devolver una lista con 1 tarea, obtuvo %v", lista)
	}
}

func TestAPIPostTituloVacio(t *testing.T) {
	servidor := nuevoServidorTest(t)
	codigo, _ := peticionJSON(t, http.MethodPost, servidor.URL+"/tareas", `{"titulo":""}`)
	if codigo != http.StatusBadRequest {
		t.Errorf("POST con título vacío -> %d; se esperaba 400", codigo)
	}
}

func TestAPIPostMalformado(t *testing.T) {
	servidor := nuevoServidorTest(t)
	codigo, _ := peticionJSON(t, http.MethodPost, servidor.URL+"/tareas", `{"titulo":`)
	if codigo != http.StatusBadRequest {
		t.Errorf("POST con JSON malformado -> %d; se esperaba 400", codigo)
	}
}

func TestAPIGetPorID(t *testing.T) {
	servidor := nuevoServidorTest(t)
	peticionJSON(t, http.MethodPost, servidor.URL+"/tareas", `{"titulo":"Comprar pan"}`)
	codigo, data := peticionJSON(t, http.MethodGet, servidor.URL+"/tareas/1", "")
	if codigo != http.StatusOK {
		t.Fatalf("GET /tareas/1 -> %d; se esperaba 200", codigo)
	}
	if data["titulo"] != "Comprar pan" {
		t.Errorf("GET /tareas/1 devolvió %v", data)
	}
}

func TestAPIGetNoExiste(t *testing.T) {
	servidor := nuevoServidorTest(t)
	codigo, _ := peticionJSON(t, http.MethodGet, servidor.URL+"/tareas/99", "")
	if codigo != http.StatusNotFound {
		t.Errorf("GET /tareas/99 -> %d; se esperaba 404", codigo)
	}
}

func TestAPIPutYCompletar(t *testing.T) {
	servidor := nuevoServidorTest(t)
	peticionJSON(t, http.MethodPost, servidor.URL+"/tareas", `{"titulo":"A"}`)

	codigo, data := peticionJSON(t, http.MethodPut, servidor.URL+"/tareas/1", `{"titulo":"A nueva"}`)
	if codigo != http.StatusOK || data["titulo"] != "A nueva" {
		t.Errorf("PUT /tareas/1 -> %d, %v; se esperaba 200 con título nuevo", codigo, data)
	}

	codigo, data = peticionJSON(t, http.MethodPut, servidor.URL+"/tareas/1/completar", "")
	if codigo != http.StatusOK || data["completada"] != true {
		t.Errorf("PUT /tareas/1/completar -> %d, %v; se esperaba 200 con completada=true", codigo, data)
	}
}

func TestAPIPutNoExiste(t *testing.T) {
	servidor := nuevoServidorTest(t)
	codigo, _ := peticionJSON(t, http.MethodPut, servidor.URL+"/tareas/77", `{"titulo":"X"}`)
	if codigo != http.StatusNotFound {
		t.Errorf("PUT /tareas/77 -> %d; se esperaba 404", codigo)
	}
}

func TestAPIDelete(t *testing.T) {
	servidor := nuevoServidorTest(t)
	peticionJSON(t, http.MethodPost, servidor.URL+"/tareas", `{"titulo":"A"}`)
	codigo, _ := peticionJSON(t, http.MethodDelete, servidor.URL+"/tareas/1", "")
	if codigo != http.StatusNoContent {
		t.Errorf("DELETE /tareas/1 -> %d; se esperaba 204", codigo)
	}
	codigo, _ = peticionJSON(t, http.MethodGet, servidor.URL+"/tareas/1", "")
	if codigo != http.StatusNotFound {
		t.Errorf("tras el DELETE, GET /tareas/1 -> %d; se esperaba 404", codigo)
	}
}

func TestAPIRutaDesconocida(t *testing.T) {
	servidor := nuevoServidorTest(t)
	codigo, _ := peticionJSON(t, http.MethodGet, servidor.URL+"/otra", "")
	if codigo != http.StatusNotFound {
		t.Errorf("GET /otra -> %d; se esperaba 404", codigo)
	}
}

func TestAPIGetListaConVarias(t *testing.T) {
	servidor := nuevoServidorTest(t)
	for _, titulo := range []string{"A", "B", "C"} {
		cuerpo := fmt.Sprintf(`{"titulo":"%s"}`, titulo)
		codigo, _ := peticionJSON(t, http.MethodPost, servidor.URL+"/tareas", cuerpo)
		if codigo != http.StatusCreated {
			t.Fatalf("POST %s -> %d; se esperaba 201", cuerpo, codigo)
		}
	}
	_, lista := peticionJSON(t, http.MethodGet, servidor.URL+"/tareas", "")
	items := lista["tareas"].([]interface{})
	if len(items) != 3 {
		t.Errorf("GET /tareas debe devolver 3 tareas, obtuvo %d", len(items))
	}
}