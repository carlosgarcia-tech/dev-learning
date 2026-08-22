#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 04 (nivel 2) - DELETE y 204.
DELETE /tareas/7 -> 204. Puerto 8086.
"""
import http.server
import json
import socketserver

DB = {7: {"id": 7, "titulo": "Aprender HTTP"}}


class Handler(http.server.BaseHTTPRequestHandler):
    def _send_json(self, status, obj):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_DELETE(self):
        if self.path == "/tareas/7":
            if 7 in DB:
                del DB[7]
                self.send_response(204)
                self.send_header("Content-Length", "0")
                self.end_headers()
            else:
                self._send_json(404, {"error": "Not Found"})
        else:
            self._send_json(404, {"error": "Not Found"})

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    PORT = 8086
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
