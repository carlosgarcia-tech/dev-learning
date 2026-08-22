#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 06 (nivel 2) - códigos 201 y 204.
Puerto 8088. Demuestra 201/204/200/404 en varias rutas.
"""
import http.server
import json
import socketserver

DB = {1: {"id": 1, "nombre": "Existente"}}


class Handler(http.server.BaseHTTPRequestHandler):
    def _send_json(self, status, obj, location=None):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        if location:
            self.send_header("Location", location)
        self.end_headers()
        self.wfile.write(body)

    def _send_empty(self, status):
        self.send_response(status)
        self.send_header("Content-Length", "0")
        self.end_headers()

    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        if length:
            self.rfile.read(length)
        if self.path == "/recursos":
            nuevo = {"id": 2, "nombre": "Nuevo"}
            self._send_json(201, nuevo, location="/recursos/2")
        elif self.path == "/recursos-sin-body":
            self._send_empty(204)
        else:
            self._send_json(404, {"error": "Not Found"})

    def do_GET(self):
        if self.path == "/recursos/1":
            self._send_json(200, DB[1])
        else:
            self._send_json(404, {"error": "Not Found"})

    def do_PUT(self):
        length = int(self.headers.get("Content-Length", 0))
        data = json.loads(self.rfile.read(length)) if length else {}
        if self.path == "/recursos/1":
            DB[1] = {"id": 1, **data}
            self._send_json(200, DB[1])
        else:
            self._send_json(404, {"error": "Not Found"})

    def do_DELETE(self):
        if self.path == "/recursos/1":
            self._send_empty(204)
        else:
            self._send_json(404, {"error": "Not Found"})

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8088
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
