#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 03 (nivel 2) - PUT.
PUT /productos/1 -> 200 con recurso reemplazado. Puerto 8085.
"""
import http.server
import json
import socketserver

DB = {1: {"id": 1, "nombre": "Teclado", "precio": 49.99, "stock": 10}}


class Handler(http.server.BaseHTTPRequestHandler):
    def _send_json(self, status, obj):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_PUT(self):
        if self.path == "/productos/1":
            length = int(self.headers.get("Content-Length", 0))
            try:
                data = json.loads(self.rfile.read(length) if length else b"")
            except Exception:
                self._send_json(400, {"error": "JSON inválido"})
                return
            # PUT reemplaza todo el recurso, conservando el id
            nuevo = {"id": 1}
            nuevo.update(data)
            DB[1] = nuevo
            self._send_json(200, nuevo)
        else:
            self._send_json(404, {"error": "Not Found"})

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8085
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
