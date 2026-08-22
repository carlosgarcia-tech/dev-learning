#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 06 (nivel 4) - Bearer y scopes.
Tokens: admin-token (scope admin), user-token (scope user). Puerto 8100.
"""
import http.server
import json
import socketserver

TOKENS = {
    "admin-token": {"sub": "ana", "scope": "admin"},
    "user-token": {"sub": "bob", "scope": "user"},
}


class Handler(http.server.BaseHTTPRequestHandler):
    def _send(self, status, obj=None):
        body = b"" if obj is None else json.dumps(obj, ensure_ascii=False).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        if body:
            self.wfile.write(body)

    def _auth(self):
        auth = self.headers.get("Authorization", "")
        if not auth.startswith("Bearer "):
            return None
        token = auth[7:]
        return TOKENS.get(token)

    def do_GET(self):
        user = self._auth()
        if user is None:
            self._send(401, {"error": "Unauthorized"})
            return
        if self.path == "/perfil":
            self._send(200, {"usuario": user["sub"]})
        elif self.path == "/admin":
            if user["scope"] == "admin":
                self._send(200, {"admin": True, "usuario": user["sub"]})
            else:
                self._send(403, {"error": "Forbidden", "razon": "scope insuficiente"})
        else:
            self._send(404, {"error": "Not Found"})

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8100
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
