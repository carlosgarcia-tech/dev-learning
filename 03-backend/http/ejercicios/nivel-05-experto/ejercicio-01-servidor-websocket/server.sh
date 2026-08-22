#!/usr/bin/env python3
"""Servidor de prueba para el ejercicio 01 (nivel 5) - WebSocket.
Handshake 101 + eco de mensajes. Python puro, sin librerías externas. Puerto 8101.
"""
import socket
import hashlib
import base64
import struct
import threading

GUID = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"


def accept_key(key):
    sha = hashlib.sha1((key + GUID).encode()).digest()
    return base64.b64encode(sha).decode()


def parse_headers(data):
    text = data.decode("utf-8", errors="replace")
    lines = text.split("\r\n")
    headers = {}
    for line in lines[1:]:
        if ":" in line:
            k, v = line.split(":", 1)
            headers[k.strip().lower()] = v.strip()
    return lines[0], headers


def recv_frame(conn):
    first = conn.recv(1)
    if not first:
        return None
    opcode = first[0] & 0x0F
    length = conn.recv(1)[0] & 0x7F
    if length == 126:
        length = struct.unpack(">H", conn.recv(2))[0]
    elif length == 127:
        length = struct.unpack(">Q", conn.recv(8))[0]
    mask = conn.recv(4)
    data = conn.recv(length)
    data = bytes(b ^ mask[i % 4] for i, b in enumerate(data))
    return opcode, data


def send_frame(conn, data, opcode=0x1):
    frame = bytearray([0x80 | opcode])
    length = len(data)
    if length < 126:
        frame.append(length)
    elif length < 65536:
        frame.append(126)
        frame += struct.pack(">H", length)
    else:
        frame.append(127)
        frame += struct.pack(">Q", length)
    frame += data
    conn.sendall(frame)


def handle_client(conn):
    try:
        data = conn.recv(4096)
        if not data:
            return
        _, headers = parse_headers(data)
        if headers.get("upgrade", "").lower() != "websocket":
            conn.sendall(b"HTTP/1.1 400 Bad Request\r\n\r\n")
            return
        key = headers.get("sec-websocket-key", "")
        accept = accept_key(key)
        response = (
            "HTTP/1.1 101 Switching Protocols\r\n"
            "Upgrade: websocket\r\n"
            "Connection: Upgrade\r\n"
            f"Sec-WebSocket-Accept: {accept}\r\n\r\n"
        )
        conn.sendall(response.encode())
        # Bucle de eco
        while True:
            result = recv_frame(conn)
            if result is None:
                break
            opcode, payload = result
            if opcode == 0x8:  # close
                break
            send_frame(conn, payload, opcode=0x1)
    except Exception:
        pass
    finally:
        conn.close()


def main():
    srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind(("127.0.0.1", 8101))
    srv.listen(5)
    while True:
        conn, _ = srv.accept()
        threading.Thread(target=handle_client, args=(conn,), daemon=True).start()


if __name__ == "__main__":
    main()
