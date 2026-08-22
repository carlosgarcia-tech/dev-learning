#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 06 (nivel 3) - Last-Modified.
GET /doc con Last-Modified fijo. If-Modified-Since >= fecha -> 304. Puerto 8094.
"""
import http.server
import json
import socketserver
from email.utils import parsedate_to_datetime

LAST_MOD = "Wed, 21 Oct 2025 07:28:00 GMT"
BODY = json.dumps({"documento": "contenido"}).encode()


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/doc":
            self.send_response(404)
            self.send_header("Content-Length", "0")
            self.end_headers()
            return
        ims = self.headers.get("If-Modified-Since")
        if ims:
            try:
                d_ims = parsedate_to_datetime(ims)
                d_lm = parsedate_to_datetime(LAST_MOD)
                if d_ims >= d_lm:
                    self.send_response(304)
                    self.send_header("Last-Modified", LAST_MOD)
                    self.send_header("Content-Length", "0")
                    self.end_headers()
                    return
            except Exception:
                pass
        self.send_response(200)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Last-Modified", LAST_MOD)
        self.send_header("Content-Length", str(len(BODY)))
        self.end_headers()
        self.wfile.write(BODY)

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8094
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
