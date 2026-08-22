#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 02 (nivel 5) - SSE.
GET /events envía un evento por segundo en formato SSE. Puerto 8102.
"""
import http.server
import socketserver
import time
import json


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/events":
            self.send_response(404)
            self.send_header("Content-Length", "0")
            self.end_headers()
            return
        self.send_response(200)
        self.send_header("Content-Type", "text/event-stream")
        self.send_header("Cache-Control", "no-cache")
        self.send_header("Connection", "keep-alive")
        self.end_headers()
        i = 0
        try:
            while True:
                i += 1
                msg = json.dumps({"n": i, "time": int(time.time())})
                self.wfile.write(f"data: {msg}\n\n".encode())
                self.wfile.flush()
                time.sleep(1)
                if i >= 3:  # limitar para el test
                    break
        except (BrokenPipeError, ConnectionResetError):
            pass

    def log_message(self, *args):
        pass


# Manejador con soporte para streaming (no buferear)
class StreamingServer(socketserver.ThreadingTCPServer):
    allow_reuse_address = True


if __name__ == "__main__":
    PORT = 8102
    with StreamingServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
