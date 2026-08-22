#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 03 (nivel 3) - ETag y 304.
GET /recurso con ETag "v1". Si If-None-Match coincide -> 304. Puerto 8091.
"""
import http.server
import json
import socketserver

ETAG = '"v1"'
BODY = json.dumps({"mensaje": "Hola"}).encode()


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/recurso":
            self.send_response(404)
            self.send_header("Content-Length", "0")
            self.end_headers()
            return
        inm = self.headers.get("If-None-Match", "")
        if inm == ETAG:
            self.send_response(304)
            self.send_header("ETag", ETAG)
            self.send_header("Content-Length", "0")
            self.end_headers()
        else:
            self.send_response(200)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("ETag", ETAG)
            self.send_header("Cache-Control", "max-age=60")
            self.send_header("Content-Length", str(len(BODY)))
            self.end_headers()
            self.wfile.write(BODY)

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8091
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
