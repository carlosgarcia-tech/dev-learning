#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 03 (nivel 4) - headers de seguridad.
GET / devuelve HTML con headers de seguridad. Puerto 8097.
"""
import http.server
import socketserver

HTML = b"<!DOCTYPE html><html><body><h1>Seguro</h1></body></html>"


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/":
            self.send_response(404)
            self.send_header("Content-Length", "0")
            self.end_headers()
            return
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(HTML)))
        # Headers de seguridad
        self.send_header("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("X-Frame-Options", "DENY")
        self.send_header("Content-Security-Policy", "default-src 'self'")
        self.end_headers()
        self.wfile.write(HTML)

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8097
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
