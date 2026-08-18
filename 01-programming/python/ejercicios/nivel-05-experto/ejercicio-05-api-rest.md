# Ejercicio 05 — API REST

- **Nivel:** 5/5
- **Tema:** http.server, API REST, JSON, CRUD, persistencia
- **Tiempo estimado:** 60 min

## Enunciado

Crea un archivo `api.py` que implemente una **API REST pura** (sin dependencias, con `http.server`) para gestionar libros. Persistencia en `libros.json`.

Endpoints:

- `GET /libros` → lista todos los libros.
- `GET /libros/<id>` → un libro por id, o `404 {"error": "no encontrado"}`.
- `POST /libros` → crea un libro. El cuerpo es JSON: `{"titulo": "...", "autor": "..."}`. Valida que `titulo` no esté vacío (si no, `400 {"error": "titulo requerido"}`). Asigna un id autoincremental y devuelve `201` con el libro creado.
- `PUT /libros/<id>` → actualiza `titulo` y/o `autor`, devuelve `200` con el libro actualizado.
- `DELETE /libros/<id>` → elimina y responde `204` sin cuerpo.

Cada libro: `{"id": int, "titulo": str, "autor": str}`. Los datos se cargan de `libros.json` (o `[]`) y se guardan en cada mutación.

Arranca en `localhost:8000` con `HTTPServer` y `serve_forever()`.

Prueba con `curl`:

```
$ python3 api.py &
$ curl -X POST http://localhost:8000/libros -d '{"titulo":"Python","autor":"Van Rossum"}'
$ curl http://localhost:8000/libros
$ curl http://localhost:8000/libros/1
$ curl -X PUT http://localhost:8000/libros/1 -d '{"titulo":"Python 3"}'
$ curl -X DELETE http://localhost:8000/libros/1
```

## Requisitos

- [ ] Parsear la ruta y el método en `do_GET`/`do_POST`/`do_PUT`/`do_DELETE`.
- [ ] Leer el cuerpo JSON con `self.rfile.read(longitud)`.
- [ ] Validar `titulo` vacío → `400`.
- [ ] Devolver códigos correctos: `200`, `201`, `204`, `400`, `404`.
- [ ] Persistir en `libros.json` en cada mutación.
- [ ] Probar el CRUD completo con `curl`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `parts = self.path.strip("/").split("/")` da `["libros", id]`.
- La longitud del cuerpo está en `self.headers.get("Content-Length")`; conviértela a `int`.
- `json.loads` para el cuerpo; `json.dumps` para las respuestas.
- Para `204`, no envíes cuerpo: solo `self.send_response(204)` + `self.end_headers()`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

ARCHIVO = "libros.json"


def cargar():
    if not os.path.exists(ARCHIVO):
        return []
    with open(ARCHIVO, "r", encoding="utf-8") as f:
        return json.load(f)


def guardar(libros):
    with open(ARCHIVO, "w", encoding="utf-8") as f:
        json.dump(libros, f, ensure_ascii=False, indent=2)


class ApiHandler(BaseHTTPRequestHandler):
    def _json(self, codigo, datos):
        cuerpo = json.dumps(datos, ensure_ascii=False).encode("utf-8")
        self.send_response(codigo)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(cuerpo)))
        self.end_headers()
        self.wfile.write(cuerpo)

    def _leer_cuerpo(self):
        longitud = int(self.headers.get("Content-Length", 0))
        if longitud == 0:
            return {}
        return json.loads(self.rfile.read(longitud).decode("utf-8"))

    def _ruta(self):
        partes = self.path.strip("/").split("/")
        return partes[0], int(partes[1]) if len(partes) > 1 and partes[1] else None

    def do_GET(self):
        recurso, libro_id = self._ruta()
        if recurso != "libros":
            self._json(404, {"error": "no encontrado"})
            return
        libros = cargar()
        if libro_id is None:
            self._json(200, libros)
            return
        for libro in libros:
            if libro["id"] == libro_id:
                self._json(200, libro)
                return
        self._json(404, {"error": "no encontrado"})

    def do_POST(self):
        recurso, _ = self._ruta()
        if recurso != "libros":
            self._json(404, {"error": "no encontrado"})
            return
        datos = self._leer_cuerpo()
        if not datos.get("titulo"):
            self._json(400, {"error": "titulo requerido"})
            return
        libros = cargar()
        nuevo_id = max((l["id"] for l in libros), default=0) + 1
        nuevo = {"id": nuevo_id, "titulo": datos["titulo"], "autor": datos.get("autor", "")}
        libros.append(nuevo)
        guardar(libros)
        self._json(201, nuevo)

    def do_PUT(self):
        recurso, libro_id = self._ruta()
        if recurso != "libros" or libro_id is None:
            self._json(404, {"error": "no encontrado"})
            return
        datos = self._leer_cuerpo()
        libros = cargar()
        for libro in libros:
            if libro["id"] == libro_id:
                libro["titulo"] = datos.get("titulo", libro["titulo"])
                libro["autor"] = datos.get("autor", libro["autor"])
                guardar(libros)
                self._json(200, libro)
                return
        self._json(404, {"error": "no encontrado"})

    def do_DELETE(self):
        recurso, libro_id = self._ruta()
        if recurso != "libros" or libro_id is None:
            self._json(404, {"error": "no encontrado"})
            return
        libros = cargar()
        nuevos = [l for l in libros if l["id"] != libro_id]
        if len(nuevos) == len(libros):
            self._json(404, {"error": "no encontrado"})
            return
        guardar(nuevos)
        self.send_response(204)
        self.end_headers()

    def log_message(self, formato, *args):
        print(f"[api] {formato % args}")


if __name__ == "__main__":
    servidor = HTTPServer(("localhost", 8000), ApiHandler)
    print("API en http://localhost:8000")
    servidor.serve_forever()
````

</details>