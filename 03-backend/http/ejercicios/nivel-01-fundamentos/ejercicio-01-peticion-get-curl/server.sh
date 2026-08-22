#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 01 - GET con curl.
Responde a GET /saludo y a GET /. Puerto 8080.
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
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/saludo":
            self._send_json(200, {"mensaje": "Hola, mundo"})
        elif self.path == "/":
            self._send_json(200, {"servicio": "demo", "version": 1})
        else:
            self._send_json(404, {"error": "Not Found", "path": self.path})

    def log_message(self, *args):
        pass  # silenciar logs


if __name__ == "__main__":
    PORT = 8080
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
