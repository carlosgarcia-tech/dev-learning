# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs, urlparse


def respuesta_para_ruta(ruta):
    # TODO: devuelve (codigo, contenido, tipo) según la ruta:
    # "/" HTML, "/saludo" con parámetro nombre, "/estado" JSON, resto 404
    raise NotImplementedError


class MiHandler(BaseHTTPRequestHandler):
    def _responder(self, codigo, contenido, tipo):
        # TODO: envía la respuesta completa (send_response, headers, wfile)
        raise NotImplementedError

    def do_GET(self):
        # TODO: usa respuesta_para_ruta(self.path) y responde
        raise NotImplementedError

    def do_POST(self):
        # TODO: responde 405 con "Método no permitido"
        raise NotImplementedError

    def log_message(self, formato, *args):
        print(f"[servidor] {self.address_string()} - {formato % args}")


if __name__ == "__main__":
    servidor = HTTPServer(("localhost", 8000), MiHandler)
    print("Servidor en http://localhost:8000")
    servidor.serve_forever()