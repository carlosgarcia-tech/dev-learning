#!/usr/bin/env bash
# Validación del ejercicio 01 (nivel 05) - Event-driven architecture.
# Comprueba pub/sub desacoplado entre publicador y consumidores.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SOL="solucion.py"
STRUCT="estructura.json"
DIAG="diagrama.txt"

for f in "$SOL" "$STRUCT" "$DIAG"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

python3 -m json.tool "$STRUCT" >/dev/null 2>&1 || { echo "FAIL: $STRUCT no es JSON válido"; fail; }
python3 -c "import py_compile; py_compile.compile('$SOL', doraise=True)" 2>/dev/null || { echo "FAIL: $SOL no compila"; fail; }

for cls in "PedidoCreado" "EventBus" "PedidoService" "InventarioHandler" "EnviosHandler"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done
for m in "def publish" "def subscribe" "def crear" "def handle"; do
  grep -q "$m" "$SOL" || { echo "FAIL: debe haber $m"; fail; }
done

# Desacoplamiento: PedidoService NO referencia a InventarioHandler ni EnviosHandler
python3 - "$SOL" <<'PY'
import re, sys
with open(sys.argv[1], encoding="utf-8") as f:
    src = f.read()
m = re.search(r"class PedidoService.*?\n}(?:\s*\n)", src, re.S)
if not m:
    print("FAIL: no se pudo aislar PedidoService"); sys.exit(1)
bloque = m.group(0)
if "InventarioHandler" in bloque or "EnviosHandler" in bloque:
    print("FAIL: PedidoService no debe referenciar a los handlers (acoplamiento)"); sys.exit(1)
PY

# Verificación funcional
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

bus = m.EventBus()
inv = m.InventarioHandler()
env = m.EnviosHandler()
bus.subscribe(m.PedidoCreado, inv.handle)
bus.subscribe(m.PedidoCreado, env.handle)

svc = m.PedidoService(bus)
svc.crear("p-1", 100)
svc.crear("p-2", 50)

if inv.reservas != ["p-1", "p-2"]:
    print("FAIL: InventarioHandler debe recibir p-1 y p-2, fue:", inv.reservas); sys.exit(1)
if env.envios != ["p-1", "p-2"]:
    print("FAIL: EnviosHandler debe recibir p-1 y p-2, fue:", env.envios); sys.exit(1)
PY

echo "OK Tests pasaron"
