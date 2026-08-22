#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 04 (nivel 3) - redirecciones 301/302.
/viejo -> 301 -> /nuevo ; /temp -> 302 -> /nuevo. Puerto 8092.
"""
import http.server
import json
import socketserver


class Handler(http.server.BaseHTTPRequestHandler):
    def _redirect(self, status, location):
        self.send_response(status)
        self.send_header("Location", location)
        self.send_header("Content-Length", "0")
        self.end_headers()

    def _send_json(self, status, obj):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/viejo":
            self._redirect(301, "/nuevo")
        elif self.path == "/temp":
            self._redirect(302, "/nuevo")
        elif self.path == "/nuevo":
            self._send_json(200, {"mensaje": "Estás en /nuevo"})
        else:
            self._send_json(404, {"error": "Not Found"})

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8092
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
