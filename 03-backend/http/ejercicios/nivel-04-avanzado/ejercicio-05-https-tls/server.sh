#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 05 (nivel 4) - HTTPS y TLS.
Sirve / con HSTS para ilustrar el header. Puerto 8099.
"""
import http.server
import socketserver

BODY = b'{"seguro": true, "transporte": "TLS"}'


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/":
            self.send_response(404)
            self.send_header("Content-Length", "0")
            self.end_headers()
            return
        self.send_response(200)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(BODY)))
        self.send_header("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
        self.end_headers()
        self.wfile.write(BODY)

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8099
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
