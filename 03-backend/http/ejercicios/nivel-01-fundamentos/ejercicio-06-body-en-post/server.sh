#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 06 - body en POST.
POST /productos -> 201 Created con el recurso creado (id=1). Puerto 8082.
"""
import http.server
import json
import socketserver


class Handler(http.server.BaseHTTPRequestHandler):
    def _send_json(self, status, obj):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Location", "/productos/1")
        self.end_headers()
        self.wfile.write(body)

    def do_POST(self):
        if self.path == "/productos":
            length = int(self.headers.get("Content-Length", 0))
            raw = self.rfile.read(length) if length else b""
            try:
                data = json.loads(raw)
            except Exception:
                self._send_json(400, {"error": "JSON inválido"})
                return
            if "nombre" not in data or "precio" not in data:
                self._send_json(422, {"error": "Faltan nombre/precio"})
                return
            creado = {"id": 1, "nombre": data["nombre"], "precio": data["precio"]}
            self._send_json(201, creado)
        else:
            self._send_json(404, {"error": "Not Found"})

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8082
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
