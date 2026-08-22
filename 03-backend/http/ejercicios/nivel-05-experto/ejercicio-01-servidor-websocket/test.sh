#!/usr/bin/env bash
# Validación del ejercicio 01 (nivel 5) - servidor WebSocket.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

REQ="peticiones.http"
RESP="respuesta.json"
SRV="server.sh"

for f in "$REQ" "$RESP" "$SRV"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

# Validar peticiones.http
grep -q '^GET /ws HTTP/1\.1$' "$REQ" || { echo "FAIL: falta GET /ws"; fail; }
grep -qi '^Upgrade: websocket$' "$REQ" || { echo "FAIL: falta Upgrade: websocket"; fail; }
grep -qi '^Connection: Upgrade$' "$REQ" || { echo "FAIL: falta Connection: Upgrade"; fail; }
grep -qi '^Sec-WebSocket-Key:' "$REQ" || { echo "FAIL: falta Sec-WebSocket-Key"; fail; }
grep -qi '^Sec-WebSocket-Version: 13$' "$REQ" || { echo "FAIL: falta Sec-WebSocket-Version: 13"; fail; }

# Validar respuesta.json
python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }
python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
if data.get("handshake_status") != 101:
    print("FAIL: handshake_status debe ser 101"); sys.exit(1)
hdrs = [h.lower() for h in data.get("respuesta_headers", [])]
for needed in ["upgrade", "connection", "sec-websocket-accept"]:
    if needed not in hdrs:
        print(f"FAIL: respuesta_headers debe incluir '{needed}'"); sys.exit(1)
print("OK respuesta válida")
PY

# Levantar servidor y hacer el handshake con python (socket puro)
PORT=8101
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  python3 -c "import socket; s=socket.socket(); s.settimeout(0.5); s.connect(('127.0.0.1',8101)); s.close()" 2>/dev/null && break
  sleep 0.1
done

# Hacer handshake y eco con python3 (socket puro)
python3 - <<'PY'
import socket, struct, hashlib, base64

s = socket.socket()
s.settimeout(3)
s.connect(("127.0.0.1", 8101))

key = base64.b64encode(b"the sample nonce").decode()
req = (
    "GET /ws HTTP/1.1\r\n"
    "Host: localhost:8101\r\n"
    "Upgrade: websocket\r\n"
    "Connection: Upgrade\r\n"
    f"Sec-WebSocket-Key: {key}\r\n"
    "Sec-WebSocket-Version: 13\r\n\r\n"
)
s.sendall(req.encode())

# Leer respuesta del handshake
resp = b""
while b"\r\n\r\n" not in resp:
    chunk = s.recv(4096)
    if not chunk:
        break
    resp += chunk

if b"101" not in resp.split(b"\r\n")[0]:
    print("FAIL: el handshake no devolvió 101")
    print("  respuesta:", resp.split(b"\r\n")[0])
    sys.exit(1)
if b"upgrade: websocket" not in resp.lower():
    print("FAIL: respuesta sin Upgrade: websocket"); sys.exit(1)
if b"sec-websocket-accept" not in resp.lower():
    print("FAIL: respuesta sin Sec-WebSocket-Accept"); sys.exit(1)

# Enviar un frame de texto enmascarado "hola"
payload = b"hola"
mask = b"\x12\x34\x56\x78"
masked = bytes(b ^ mask[i % 4] for i, b in enumerate(payload))
frame = bytearray([0x81, 0x80 | len(payload)]) + mask + masked
s.sendall(frame)

# Leer eco
first = s.recv(1)
if not first:
    print("FAIL: no se recibió eco"); sys.exit(1)
opcode = first[0] & 0x0F
length = s.recv(1)[0] & 0x7F
data = s.recv(length)
if data != b"hola":
    print(f"FAIL: el eco no coincide: {data!r}"); sys.exit(1)

# Enviar close
s.sendall(bytearray([0x88, 0x80, 0x00, 0x00, 0x00, 0x00]))
s.close()
print("OK handshake y eco funcionan")
PY

echo "OK Tests pasaron"
