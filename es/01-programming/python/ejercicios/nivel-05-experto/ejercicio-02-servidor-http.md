# Ejercicio 02 — Servidor HTTP

- **Nivel:** 5/5
- **Tema:** http.server, HTTPServer, BaseHTTPRequestHandler
- **Tiempo estimado:** 40 min

## Enunciado

Crea un archivo `servidor.py` que use `http.server.HTTPServer` y `BaseHTTPRequestHandler` para servir:

1. `GET /` → responde 200 con un HTML mínimo: `<h1>Servidor Python</h1><p>Hola desde http.server</p>`.
2. `GET /saludo?nombre=Ana` → responde `Hola, Ana!` con tipo `text/plain`.
3. `GET /estado` → responde un JSON `{"estado": "ok", "version": "1.0"}` con tipo `application/json`.
4. `GET /404` → responde 404 con `No encontrado`.
5. Cualquier otro método (POST, etc.) → responde 405 `Método no permitido`.

Arranca en `localhost:8000`. Usa `self.path`, `urlparse` para separar la ruta de la query y `urllib.parse.parse_qs` para leer parámetros. Deja el servidor escuchando con `serve_forever()`.

Prueba con `curl`:

```
$ python3 servidor.py &        # se queda escuchando
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
- [ ] Levantar el servidor y probar los 4 endpoints con `curl`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `parsed = urlparse(self.path)`; `parsed.path` es la ruta y `parse_qs(parsed.query)` el diccionario de parámetros.
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


class MiHandler(BaseHTTPRequestHandler):
    def _responder(self, codigo, contenido, tipo):
        self.send_response(codigo)
        self.send_header("Content-Type", tipo)
        self.send_header("Content-Length", str(len(contenido)))
        self.end_headers()
        self.wfile.write(contenido)

    def do_GET(self):
        parsed = urlparse(self.path)

        if parsed.path == "/":
            html = "<h1>Servidor Python</h1><p>Hola desde http.server</p>"
            self._responder(200, html.encode("utf-8"), "text/html; charset=utf-8")
        elif parsed.path == "/saludo":
            params = parse_qs(parsed.query)
            nombre = params.get("nombre", ["mundo"])[0]
            mensaje = f"Hola, {nombre}!"
            self._responder(200, mensaje.encode("utf-8"), "text/plain; charset=utf-8")
        elif parsed.path == "/estado":
            cuerpo = json.dumps({"estado": "ok", "version": "1.0"}).encode("utf-8")
            self._responder(200, cuerpo, "application/json; charset=utf-8")
        else:
            self._responder(404, b"No encontrado", "text/plain; charset=utf-8")

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