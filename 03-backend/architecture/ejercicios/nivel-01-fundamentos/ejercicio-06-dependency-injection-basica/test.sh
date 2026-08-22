#!/usr/bin/env bash
# Validación del ejercicio 06 - Dependency Injection básica (DIP).
# Comprueba que LoggerService reciba el logger por constructor en vez de crearlo.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SOL="solucion.js"
STRUCT="estructura.json"
DIAG="diagrama.txt"

# 1. Archivos esperados existen
for f in "$SOL" "$STRUCT" "$DIAG"; do
  if [[ ! -f "$f" ]]; then
    echo "FAIL: falta $f"
    fail
  fi
done

# 2. python3 disponible
if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

# 3. estructura.json es JSON válido
if ! python3 -m json.tool "$STRUCT" >/dev/null 2>&1; then
  echo "FAIL: $STRUCT no es JSON válido"
  fail
fi

# 4. node disponible
if ! command -v node >/dev/null 2>&1; then
  echo "FAIL: se requiere node"
  fail
fi

# 5. solucion.js compila
if ! node --check "$SOL" 2>/dev/null; then
  echo "FAIL: $SOL no compila con node --check"
  fail
fi

# 6. Define las clases requeridas
for cls in "Logger" "ConsoleLogger" "MemoryLogger" "LoggerService"; do
  if ! grep -q "class $cls" "$SOL"; then
    echo "FAIL: $SOL debe definir la clase $cls"
    fail
  fi
done

# 7. Logger tiene método log
if ! grep -qE "log\s*\(" "$SOL"; then
  echo "FAIL: Logger debe tener método log"
  fail
fi

# 8. LoggerService NO crea el logger con new (debe recibirlo)
#    Extraemos el constructor de LoggerService y comprobamos que no hay new ConsoleLogger/MemoryLogger
python3 - "$SOL" <<'PY'
import re, sys
with open(sys.argv[1], encoding="utf-8") as f:
    src = f.read()
m = re.search(r"class LoggerService\s*\{", src)
if not m:
    print("FAIL: no se encontró LoggerService"); sys.exit(1)
start = m.end()
depth = 1; i = start
while i < len(src) and depth > 0:
    if src[i] == "{": depth += 1
    elif src[i] == "}": depth -= 1
    i += 1
clase = src[start:i-1]
if re.search(r"new\s+(ConsoleLogger|MemoryLogger)", clase):
    print("FAIL: LoggerService NO debe crear el logger con new (debe inyectarlo)")
    sys.exit(1)
# el constructor debe tener un parámetro (el logger)
ctor = re.search(r"constructor\s*\(([^)]*)\)", clase)
if not ctor or len(ctor.group(1).strip()) == 0:
    print("FAIL: LoggerService.constructor debe recibir el logger por parámetro")
    sys.exit(1)
PY

# 9. Verificación funcional: MemoryLogger captura mensajes
node -e '
const { MemoryLogger, LoggerService } = require("./'"$SOL"'");
const mem = new MemoryLogger();
const svc = new LoggerService(mem);
svc.registrar("uno");
svc.registrar("dos");
if (mem.mensajes.length !== 2 || mem.mensajes[0] !== "uno" || mem.mensajes[1] !== "dos") {
  console.error("FAIL: MemoryLogger debe capturar los mensajes"); process.exit(1);
}
' || fail

echo "OK Tests pasaron"
