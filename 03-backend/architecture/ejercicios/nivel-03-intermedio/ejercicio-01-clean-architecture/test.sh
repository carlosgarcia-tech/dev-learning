#!/usr/bin/env bash
# Validación del ejercicio 01 (nivel 03) - Clean Architecture.
# Comprueba aislamiento del dominio (Dependency Rule) y comportamiento.
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

for cls in "Pedido" "PedidoRepository" "CrearPedidoUseCase" "PedidoController"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done
grep -qE "def total" "$SOL" || { echo "FAIL: Pedido debe tener total"; fail; }
grep -qE "def save" "$SOL" || { echo "FAIL: PedidoRepository debe tener save"; fail; }
grep -qE "abstractmethod" "$SOL" || { echo "FAIL: PedidoRepository debe ser abstracta"; fail; }

# Dependency Rule: la entidad Pedido y el use case NO importan HTTP/BD ni framework
python3 - "$SOL" <<'PY'
import re, sys
with open(sys.argv[1], encoding="utf-8") as f:
    src = f.read()

def extract_class(name):
    m = re.search(rf"class {name}.*?\n}}", src, re.S)
    return m.group(0) if m else ""

for cls in ("Pedido", "CrearPedidoUseCase"):
    bloque = extract_class(cls)
    if not bloque:
        print(f"FAIL: no se pudo aislar {cls}"); sys.exit(1)
    # No debe mencionar frameworks web ni SQL directo
    for forb in ("flask", "django", "express", "fastapi", "INSERT", "SELECT", "request", "response"):
        if forb in bloque:
            print(f"FAIL: {cls} no debe referenciar '{forb}' (Dependency Rule)"); sys.exit(1)
PY

# Verificación funcional
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

repo = m.InMemoryPedidoRepository()
uc = m.CrearPedidoUseCase(repo)
ctrl = m.PedidoController(uc)

ok = ctrl.post({"items": [{"precio": 10, "cantidad": 2}]})
if ok["status"] != 201: print("FAIL: pedido válido → 201, es", ok["status"]); sys.exit(1)
if not ok["body"]["id"]: print("FAIL: debe devolver un id"); sys.exit(1)

bad = ctrl.post({"items": [{"precio": 0, "cantidad": 0}]})
if bad["status"] != 400: print("FAIL: pedido total 0 → 400"); sys.exit(1)

# El repo guardó el pedido
if len(repo.db) != 1: print("FAIL: el repo debe tener 1 pedido guardado"); sys.exit(1)
PY

echo "OK Tests pasaron"
