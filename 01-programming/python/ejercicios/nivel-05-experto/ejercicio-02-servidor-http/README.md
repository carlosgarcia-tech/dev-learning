# Ejercicio 02 — Servidor HTTP

- **Nivel:** 5/5
- **Tema:** http.server, HTTPServer, BaseHTTPRequestHandler
- **Tiempo estimado:** 40 min

## Enunciado

Completa `main.py` para que implemente un servidor HTTP con `http.server.HTTPServer` y `BaseHTTPRequestHandler`:

1. `respuesta_para_ruta(ruta)` — función pura que recibe la ruta de la petición (con su query, p. ej. `/saludo?nombre=Ana`) y devuelve una tupla `(codigo, contenido, tipo)` con el código de estado, el contenido como `str` y el `Content-Type`:
   - `GET /` → `(200, "<h1>Servidor Python</h1><p>Hola desde http.server</p>", "text/html; charset=utf-8")`.
   - `GET /saludo?nombre=Ana` → `(200, "Hola, Ana!", "text/plain; charset=utf-8")`; si no hay parámetro `nombre`, usa `mundo`.
   - `GET /estado` → `(200, '{"estado": "ok", "version": "1.0"}', "application/json; charset=utf-8")`.
   - cualquier otra ruta → `(404, "No encontrado", "text/plain; charset=utf-8")`.
2. Clase `MiHandler(BaseHTTPRequestHandler)`:
   - `_responder(codigo, contenido, tipo)` — envía la respuesta completa (headers + body en bytes).
   - `do_GET()` — usa `respuesta_para_ruta(self.path)` y responde.
   - `do_POST()` — responde `405` con `Método no permitido`.
3. En `if __name__ == "__main__":`, levanta `HTTPServer(("localhost", 8000), MiHandler)` y deja el servidor con `serve_forever()`.

Usa `urlparse` para separar la ruta de la query y `parse_qs` para leer parámetros.

Prueba con `curl`:

```
$ python3 main.py &        # se queda escuchando
$ curl http://localhost:8000/
$ curl "http://localhost:8000/saludo?nombre=Ana"
$ curl http://localhost:8000/estado
$ curl -X POST http://localhost:8000/
```

## Requisitos

- [ ] Subclasificar `BaseHTTPRequestHandler`.
- [ ] Implementar `do_GET` y `do_POST` (405).
- [ ] Usar `urlparse` y `parse_qs` para el parámetro `nombre`.
- [ ] Devolver el `Content-Type` correcto (HTML, text, JSON).
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

- `parsed = urlparse(ruta)`; `parsed.path` es la ruta y `parse_qs(parsed.query)` el diccionario de parámetros.
- `self.send_response(codigo)` + `self.send_header(...)` + `self.end_headers()` + `self.wfile.write(bytes)`.
- Para responder 404: `self.send_response(404)`.
- `HTTPServer(("localhost", 8000), MiHandler).serve_forever()`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs, urlparse


def respuesta_para_ruta(ruta):
    parsed = urlparse(ruta)

    if parsed.path == "/":
        return (200, "<h1>Servidor Python</h1><p>Hola desde http.server</p>", "text/html; charset=utf-8")

    if parsed.path == "/saludo":
        nombre = parse_qs(parsed.query).get("nombre", ["mundo"])[0]
        return (200, f"Hola, {nombre}!", "text/plain; charset=utf-8")

    if parsed.path == "/estado":
        return (200, json.dumps({"estado": "ok", "version": "1.0"}), "application/json; charset=utf-8")

    return (404, "No encontrado", "text/plain; charset=utf-8")


class MiHandler(BaseHTTPRequestHandler):
    def _responder(self, codigo, contenido, tipo):
        self.send_response(codigo)
        self.send_header("Content-Type", tipo)
        self.send_header("Content-Length", str(len(contenido)))
        self.end_headers()
        self.wfile.write(contenido)

    def do_GET(self):
        codigo, contenido, tipo = respuesta_para_ruta(self.path)
        self._responder(codigo, contenido.encode("utf-8"), tipo)

    def do_POST(self):
        self._responder(405, "Método no permitido".encode("utf-8"), "text/plain; charset=utf-8")

    def log_message(self, formato, *args):
        print(f"[servidor] {self.address_string()} - {formato % args}")


if __name__ == "__main__":
    servidor = HTTPServer(("localhost", 8000), MiHandler)
    print("Servidor en http://localhost:8000")
    servidor.serve_forever()
````

</details>