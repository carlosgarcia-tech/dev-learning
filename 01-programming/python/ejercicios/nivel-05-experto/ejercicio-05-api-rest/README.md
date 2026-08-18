# Ejercicio 05 — API REST

- **Nivel:** 5/5
- **Tema:** http.server, API REST, JSON, CRUD, persistencia
- **Tiempo estimado:** 60 min

## Enunciado

Completa `main.py` para que implemente una **API REST pura** (sin dependencias, con `http.server`) para gestionar libros. Persistencia en `libros.json`. Cada libro: `{"id": int, "titulo": str, "autor": str}`. Los datos se cargan de `libros.json` (o `[]`) y se guardan en cada mutación.

Funciones de lógica de negocio (testables sin servidor):

1. `cargar(ruta=ARCHIVO)` — lee los libros de `ruta`; si el archivo no existe, devuelve `[]`.
2. `guardar(ruta, libros)` — escribe los libros en `ruta` con `json.dump`.
3. `listar_libros(libros)` — devuelve `(200, libros)`.
4. `obtener_libro(libros, libro_id)` — devuelve `(200, libro)` o `(404, {"error": "no encontrado"})`.
5. `crear_libro(libros, datos)` — valida que `titulo` no esté vacío (si no, `(400, {"error": "titulo requerido"})`); asigna id autoincremental, añade el libro y devuelve `(201, libro)`. El `autor` se toma de `datos.get("autor", "")`.
6. `actualizar_libro(libros, libro_id, datos)` — actualiza `titulo` y/o `autor` y devuelve `(200, libro)` o `(404, {"error": "no encontrado"})`.
7. `eliminar_libro(libros, libro_id)` — elimina y devuelve `(204, None)` o `(404, {"error": "no encontrado"})`.

Clase `ApiHandler(BaseHTTPRequestHandler)` con:
- `_json(codigo, datos)` — responde JSON.
- `_leer_cuerpo()` — lee el cuerpo JSON (`self.rfile.read(longitud)`).
- `_ruta()` — devuelve `(recurso, libro_id)` a partir de `self.path`.
- `do_GET` / `do_POST` / `do_PUT` / `do_DELETE` — despachan los endpoints usando las funciones de negocio y persisten con `guardar` en cada mutación.

En `if __name__ == "__main__":`, arranca en `localhost:8000` con `HTTPServer` y `serve_forever()`.

Endpoints:

- `GET /libros` → lista todos los libros.
- `GET /libros/<id>` → un libro por id, o `404 {"error": "no encontrado"}`.
- `POST /libros` → crea un libro. El cuerpo es JSON: `{"titulo": "...", "autor": "..."}`. Valida que `titulo` no esté vacío (si no, `400 {"error": "titulo requerido"}`). Asigna un id autoincremental y devuelve `201` con el libro creado.
- `PUT /libros/<id>` → actualiza `titulo` y/o `autor`, devuelve `200` con el libro actualizado.
- `DELETE /libros/<id>` → elimina y responde `204` sin cuerpo.

Prueba con `curl`:

```
$ python3 main.py &
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
- [ ] Los tests pasan: `python3 test_main.py`

> **Cómo ejecutar los tests**
>
> Desde la carpeta del ejercicio:
>
> ```bash
> python3 test_main.py
> ```
>
> El runner devuelve `0` si todos los tests pasan y `1` si falla alguno.

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


def cargar(ruta=ARCHIVO):
    if not os.path.exists(ruta):
        return []
    with open(ruta, "r", encoding="utf-8") as f:
        return json.load(f)


def guardar(ruta, libros):
    with open(ruta, "w", encoding="utf-8") as f:
        json.dump(libros, f, ensure_ascii=False, indent=2)


def listar_libros(libros):
    return 200, libros


def obtener_libro(libros, libro_id):
    for libro in libros:
        if libro["id"] == libro_id:
            return 200, libro
    return 404, {"error": "no encontrado"}


def crear_libro(libros, datos):
    if not datos.get("titulo"):
        return 400, {"error": "titulo requerido"}
    nuevo_id = max((l["id"] for l in libros), default=0) + 1
    nuevo = {"id": nuevo_id, "titulo": datos["titulo"], "autor": datos.get("autor", "")}
    libros.append(nuevo)
    return 201, nuevo


def actualizar_libro(libros, libro_id, datos):
    for libro in libros:
        if libro["id"] == libro_id:
            libro["titulo"] = datos.get("titulo", libro["titulo"])
            libro["autor"] = datos.get("autor", libro["autor"])
            return 200, libro
    return 404, {"error": "no encontrado"}


def eliminar_libro(libros, libro_id):
    for i, libro in enumerate(libros):
        if libro["id"] == libro_id:
            libros.pop(i)
            return 204, None
    return 404, {"error": "no encontrado"}


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
            codigo, cuerpo = listar_libros(libros)
        else:
            codigo, cuerpo = obtener_libro(libros, libro_id)
        self._json(codigo, cuerpo)

    def do_POST(self):
        recurso, _ = self._ruta()
        if recurso != "libros":
            self._json(404, {"error": "no encontrado"})
            return
        datos = self._leer_cuerpo()
        libros = cargar()
        codigo, cuerpo = crear_libro(libros, datos)
        if codigo == 201:
            guardar(libros)
        self._json(codigo, cuerpo)

    def do_PUT(self):
        recurso, libro_id = self._ruta()
        if recurso != "libros" or libro_id is None:
            self._json(404, {"error": "no encontrado"})
            return
        datos = self._leer_cuerpo()
        libros = cargar()
        codigo, cuerpo = actualizar_libro(libros, libro_id, datos)
        if codigo == 200:
            guardar(libros)
        self._json(codigo, cuerpo)

    def do_DELETE(self):
        recurso, libro_id = self._ruta()
        if recurso != "libros" or libro_id is None:
            self._json(404, {"error": "no encontrado"})
            return
        libros = cargar()
        codigo, cuerpo = eliminar_libro(libros, libro_id)
        if codigo == 204:
            guardar(libros)
            self.send_response(204)
            self.end_headers()
            return
        self._json(codigo, cuerpo)

    def log_message(self, formato, *args):
        print(f"[api] {formato % args}")


if __name__ == "__main__":
    servidor = HTTPServer(("localhost", 8000), ApiHandler)
    print("API en http://localhost:8000")
    servidor.serve_forever()
````

</details>