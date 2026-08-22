#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 02 (nivel 2) - POST con JSON.
POST /usuarios -> 201 con id y activo. Puerto 8084.
"""
import http.server
import json
import socketserver

DB = []


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

    def do_POST(self):
        if self.path == "/usuarios":
            length = int(self.headers.get("Content-Length", 0))
            try:
                data = json.loads(self.rfile.read(length) if length else b"")
            except Exception:
                self._send_json(400, {"error": "JSON inválido"})
                return
            if "nombre" not in data or "email" not in data:
                self._send_json(422, {"error": "Faltan nombre/email"})
                return
            nuevo = {
                "id": len(DB) + 1,
                "nombre": data["nombre"],
                "email": data["email"],
                "activo": True,
            }
            DB.append(nuevo)
            self._send_json(201, nuevo, location=f"/usuarios/{nuevo['id']}")
        else:
            self._send_json(404, {"error": "Not Found"})

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8084
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
