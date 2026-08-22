#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 05 (nivel 3) - auth Basic.
GET /privado protegido con Basic admin:secreto. Puerto 8093.
"""
import http.server
import json
import socketserver
import base64


class Handler(http.server.BaseHTTPRequestHandler):
    def _send(self, status, obj=None, headers=None):
        body = b"" if obj is None else json.dumps(obj, ensure_ascii=False).encode()
        self.send_response(status)
        for k, v in (headers or {}).items():
            self.send_header(k, v)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        if body:
            self.wfile.write(body)

    def do_GET(self):
        if self.path != "/privado":
            self._send(404, {"error": "Not Found"})
            return
        auth = self.headers.get("Authorization", "")
        if not auth.startswith("Basic "):
            self._send(401, {"error": "Unauthorized"},
                       {"WWW-Authenticate": 'Basic realm="api"'})
            return
        try:
            decoded = base64.b64decode(auth[6:]).decode("utf-8")
            user, _, pw = decoded.partition(":")
        except Exception:
            self._send(401, {"error": "Unauthorized"},
                       {"WWW-Authenticate": 'Basic realm="api"'})
            return
        if user == "admin" and pw == "secreto":
            self._send(200, {"mensaje": "Acceso concedido", "usuario": "admin"})
        else:
            self._send(401, {"error": "Unauthorized"},
                       {"WWW-Authenticate": 'Basic realm="api"'})

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8093
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
