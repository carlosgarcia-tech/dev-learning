#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 01 (nivel 4) - JWT.
Emite un token con secreto 'supersecreto' y verifica GET /me. Puerto 8095.
"""
import http.server
import json
import socketserver
import hmac
import hashlib
import base64

SECRET = b"supersecreto"

# Token precomputado para el ejercicio
HEADER = {"alg": "HS256", "typ": "JWT"}
PAYLOAD = {"sub": "user_42", "role": "admin", "iat": 1724304000, "exp": 9999999999}


def b64url(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode("ascii")


def make_token():
    h = b64url(json.dumps(HEADER, separators=(",", ":")).encode())
    p = b64url(json.dumps(PAYLOAD, separators=(",", ":")).encode())
    sig = hmac.new(SECRET, (h + "." + p).encode(), hashlib.sha256).digest()
    s = b64url(sig)
    return f"{h}.{p}.{s}"


def verify(token):
    try:
        h, p, s = token.split(".")
    except ValueError:
        return False
    expected = b64url(hmac.new(SECRET, (h + "." + p).encode(), hashlib.sha256).digest())
    return hmac.compare_digest(expected, s)


class Handler(http.server.BaseHTTPRequestHandler):
    def _send_json(self, status, obj):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/token":
            self._send_json(200, {"token": make_token()})
        elif self.path == "/me":
            auth = self.headers.get("Authorization", "")
            if not auth.startswith("Bearer "):
                self._send_json(401, {"error": "Falta Bearer token"})
                return
            token = auth[7:]
            if verify(token):
                self._send_json(200, {"sub": "user_42", "role": "admin"})
            else:
                self._send_json(401, {"error": "Token inválido"})
        else:
            self._send_json(404, {"error": "Not Found"})

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8095
    # Escribir el token en token.txt si no existe
    import os
    here = os.path.dirname(os.path.abspath(__file__))
    token_path = os.path.join(here, "token.txt")
    if not os.path.exists(token_path):
        with open(token_path, "w") as f:
            f.write(make_token())
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
