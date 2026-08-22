#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 06 (nivel 5) - GraphQL sobre HTTP.
Endpoint POST /graphql con un resolver simple. Puerto 8103.
"""
import http.server
import json
import socketserver
import re

PRODUCTOS = {
    1: {"id": 1, "nombre": "Teclado", "precio": 49.99},
    2: {"id": 2, "nombre": "Monitor", "precio": 249.99},
}


def resolve(query):
    # Parser muy simple: { producto(id: N) { campos } }
    m = re.search(r"producto\s*\(\s*id:\s*(\d+)\s*\)\s*\{([^}]*)\}", query)
    if not m:
        return {"errors": [{"message": "Query inválida"}]}
    pid = int(m.group(1))
    campos = [c.strip() for c in m.group(2).split() if c.strip()]
    prod = PRODUCTOS.get(pid)
    if not prod:
        return {"data": {"producto": None}}
    resultado = {c: prod.get(c) for c in campos}
    return {"data": {"producto": resultado}}


class Handler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path != "/graphql":
            self.send_response(404)
            self.send_header("Content-Length", "0")
            self.end_headers()
            return
        length = int(self.headers.get("Content-Length", 0))
        try:
            body = json.loads(self.rfile.read(length) if length else b"{}")
        except Exception:
            resp = {"errors": [{"message": "JSON inválido"}]}
            self._send(resp)
            return
        query = body.get("query", "")
        result = resolve(query)
        self._send(result)

    def _send(self, obj):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8103
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
