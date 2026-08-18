# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

ARCHIVO = "libros.json"


def cargar(ruta=ARCHIVO):
    # TODO: devuelve [] si el archivo no existe; si no, json.load(ruta)
    raise NotImplementedError


def guardar(ruta, libros):
    # TODO: escribe libros en ruta con json.dump
    raise NotImplementedError


def listar_libros(libros):
    # TODO: devuelve (200, libros)
    raise NotImplementedError


def obtener_libro(libros, libro_id):
    # TODO: devuelve (200, libro) o (404, {"error": "no encontrado"})
    raise NotImplementedError


def crear_libro(libros, datos):
    # TODO: valida titulo (400 si vacío), asigna id autoincremental
    # y devuelve (201, libro)
    raise NotImplementedError


def actualizar_libro(libros, libro_id, datos):
    # TODO: actualiza titulo/autor y devuelve (200, libro) o (404, ...)
    raise NotImplementedError


def eliminar_libro(libros, libro_id):
    # TODO: elimina y devuelve (204, None) o (404, ...)
    raise NotImplementedError


class ApiHandler(BaseHTTPRequestHandler):
    def _json(self, codigo, datos):
        # TODO: envía una respuesta JSON
        raise NotImplementedError

    def _leer_cuerpo(self):
        # TODO: lee el cuerpo JSON con self.rfile.read(longitud)
        raise NotImplementedError

    def _ruta(self):
        # TODO: devuelve (recurso, libro_id) desde self.path
        raise NotImplementedError

    def do_GET(self):
        # TODO: GET /libros y GET /libros/<id>
        raise NotImplementedError

    def do_POST(self):
        # TODO: crea un libro (201) o 400/404
        raise NotImplementedError

    def do_PUT(self):
        # TODO: actualiza un libro (200) o 404
        raise NotImplementedError

    def do_DELETE(self):
        # TODO: elimina un libro (204) o 404
        raise NotImplementedError

    def log_message(self, formato, *args):
        print(f"[api] {formato % args}")


if __name__ == "__main__":
    servidor = HTTPServer(("localhost", 8000), ApiHandler)
    print("API en http://localhost:8000")
    servidor.serve_forever()