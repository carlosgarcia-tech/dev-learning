#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 04 (nivel 4) - rate limiting.
Permite 3 peticiones/min a /api, luego 429 con Retry-After. Puerto 8098.
"""
import http.server
import json
import socketserver
import time

LIMIT = 3
WINDOW = 60  # segundos
requests = []  # lista de timestamps


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
        if self.path != "/api":
            self._send_json(404, {"error": "Not Found"})
            return
        now = time.time()
        # limpiar peticiones fuera de ventana
        global requests
        requests = [t for t in requests if now - t < WINDOW]
        if len(requests) >= LIMIT:
            remaining = 0
            retry = int(WINDOW - (now - requests[0])) + 1
            self._send_json(429, {"error": "Too Many Requests"}, {
                "Retry-After": str(retry),
                "X-RateLimit-Limit": str(LIMIT),
                "X-RateLimit-Remaining": "0",
            })
        else:
            requests.append(now)
            remaining = LIMIT - len(requests)
            self._send_json(200, {"ok": True, "peticion": len(requests)}, {
                "X-RateLimit-Limit": str(LIMIT),
                "X-RateLimit-Remaining": str(remaining),
            })

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8098
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
