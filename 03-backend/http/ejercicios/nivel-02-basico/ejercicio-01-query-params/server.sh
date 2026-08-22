#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 01 (nivel 2) - query params.
GET /productos con categoria, orden, limite. Puerto 8083.
"""
import http.server
import json
import socketserver
from urllib.parse import urlparse, parse_qs

PRODUCTOS = [
    {"id": 1, "nombre": "Teclado", "categoria": "electronica", "precio": 49.99},
    {"id": 2, "nombre": "Silla", "categoria": "mobiliario", "precio": 120.0},
    {"id": 3, "nombre": "Monitor", "categoria": "electronica", "precio": 249.99},
    {"id": 4, "nombre": "Lampara", "categoria": "mobiliario", "precio": 25.5},
]


class Handler(http.server.BaseHTTPRequestHandler):
    def _send_json(self, status, obj):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        parsed = urlparse(self.path)
        if parsed.path != "/productos":
            self._send_json(404, {"error": "Not Found"})
            return
        qs = parse_qs(parsed.query)
        categoria = qs.get("categoria", [None])[0]
        orden = qs.get("orden", ["asc"])[0]
        limite = qs.get("limite", [None])[0]

        resultados = PRODUCTOS
        if categoria:
            resultados = [p for p in resultados if p["categoria"] == categoria]
        resultados = sorted(resultados, key=lambda p: p["id"], reverse=(orden == "desc"))
        if limite:
            try:
                resultados = resultados[: int(limite)]
            except ValueError:
                pass
        self._send_json(200, {"total": len(resultados), "productos": resultados})

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8083
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
