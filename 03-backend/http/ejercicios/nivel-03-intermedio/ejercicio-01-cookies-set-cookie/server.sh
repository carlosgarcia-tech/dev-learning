#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 01 (nivel 3) - cookies.
POST /login -> Set-Cookie sesion. GET /perfil -> lee la cookie. Puerto 8089.
"""
import http.server
import json
import socketserver


class Handler(http.server.BaseHTTPRequestHandler):
    def _send(self, status, body=b"", headers=None):
        self.send_response(status)
        for k, v in (headers or {}).items():
            self.send_header(k, v)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        if body:
            self.wfile.write(body)

    def do_POST(self):
        if self.path == "/login":
            length = int(self.headers.get("Content-Length", 0))
            if length:
                self.rfile.read(length)
            body = json.dumps({"ok": True, "usuario": "ana"}).encode()
            self._send(200, body, {
                "Content-Type": "application/json",
                "Set-Cookie": "sesion=abc123; HttpOnly; Secure; SameSite=Lax; Path=/; Max-Age=3600",
            })
        else:
            self._send(404, b'{"error":"Not Found"}', {"Content-Type": "application/json"})

    def do_GET(self):
        if self.path == "/perfil":
            cookie = self.headers.get("Cookie", "")
            if "sesion=abc123" in cookie:
                body = json.dumps({"usuario": "ana", "perfil": "admin"}).encode()
                self._send(200, body, {"Content-Type": "application/json"})
            else:
                body = json.dumps({"error": "Unauthorized"}).encode()
                self._send(401, body, {"Content-Type": "application/json"})
        else:
            self._send(404, b'{"error":"Not Found"}', {"Content-Type": "application/json"})

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8089
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
