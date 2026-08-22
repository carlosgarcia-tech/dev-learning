#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 05 (nivel 2) - content negotiation.
GET /dato segun Accept devuelve JSON o XML. Puerto 8087.
"""
import http.server
import socketserver

JSON_BODY = b'{"producto": "Teclado", "precio": 49.99}'
XML_BODY = b'<?xml version="1.0"?><producto><nombre>Teclado</nombre><precio>49.99</precio></producto>'


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/dato":
            self.send_response(404)
            self.send_header("Content-Length", "0")
            self.end_headers()
            return
        accept = self.headers.get("Accept", "*/*")
        if "application/json" in accept or "*/*" in accept:
            self.send_response(200)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Content-Length", str(len(JSON_BODY)))
            self.end_headers()
            self.wfile.write(JSON_BODY)
        elif "application/xml" in accept:
            self.send_response(200)
            self.send_header("Content-Type", "application/xml; charset=utf-8")
            self.send_header("Content-Length", str(len(XML_BODY)))
            self.end_headers()
            self.wfile.write(XML_BODY)
        else:
            self.send_response(406)
            self.send_header("Content-Length", "0")
            self.end_headers()

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8087
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
