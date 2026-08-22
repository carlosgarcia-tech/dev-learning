#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 02 (nivel 4) - OAuth flow simulado.
Simula Authorization Server + Resource Server. Puerto 8096.
"""
import http.server
import json
import socketserver
from urllib.parse import urlparse, parse_qs

AUTH_CODE = "CODE_123"
ACCESS_TOKEN = "TOKEN_ABC"
CLIENT = {"client_id": "app123", "client_secret": "secret"}


class Handler(http.server.BaseHTTPRequestHandler):
    def _send_json(self, status, obj, headers=None):
        body = json.dumps(obj, ensure_ascii=False).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        for k, v in (headers or {}).items():
            self.send_header(k, v)
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        parsed = urlparse(self.path)
        if parsed.path == "/authorize":
            qs = parse_qs(parsed.query)
            if qs.get("client_id", [""])[0] != CLIENT["client_id"]:
                self._send_json(400, {"error": "invalid_client"})
                return
            redirect = qs.get("redirect_uri", [""])[0]
            state = qs.get("state", [""])[0]
            location = f"{redirect}?code={AUTH_CODE}&state={state}"
            self.send_response(302)
            self.send_header("Location", location)
            self.send_header("Content-Length", "0")
            self.end_headers()
        elif parsed.path == "/api/perfil":
            auth = self.headers.get("Authorization", "")
            if auth == f"Bearer {ACCESS_TOKEN}":
                self._send_json(200, {"usuario": "ana", "email": "ana@ejemplo.com"})
            else:
                self._send_json(401, {"error": "invalid_token"})
        else:
            self._send_json(404, {"error": "Not Found"})

    def do_POST(self):
        if self.path == "/token":
            length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(length).decode() if length else ""
            qs = parse_qs(body)
            if (qs.get("grant_type", [""])[0] == "authorization_code"
                    and qs.get("code", [""])[0] == AUTH_CODE
                    and qs.get("client_id", [""])[0] == CLIENT["client_id"]
                    and qs.get("client_secret", [""])[0] == CLIENT["client_secret"]):
                self._send_json(200, {
                    "access_token": ACCESS_TOKEN,
                    "token_type": "Bearer",
                    "expires_in": 3600,
                })
            else:
                self._send_json(400, {"error": "invalid_grant"})
        else:
            self._send_json(404, {"error": "Not Found"})

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8096
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
