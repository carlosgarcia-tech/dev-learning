#!/usr/bin/env bash
# Validación del ejercicio 02 (nivel 05) - Event Sourcing.
# Comprueba que el estado se reconstruye desde eventos.
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

for cls in "CuentaCreada" "Depositado" "Retirado" "EventStore" "CuentaBancaria"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done
for m in "def append" "def load" "def crear" "def depositar" "def retirar" "def from_history"; do
  grep -q "$m" "$SOL" || { echo "FAIL: debe haber $m"; fail; }
done

# Verificación funcional
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

store = m.EventStore()

# Comandos generan eventos
c = m.CuentaBancaria()
c.crear("c1")
c.depositar(100)
c.retirar(30)
c.depositar(20)
if c.saldo != 90:
    print("FAIL: saldo debe ser 90 tras los eventos, es", c.saldo); sys.exit(1)
if len(c.cambios) != 4:
    print("FAIL: debe haber 4 eventos en cambios, hay", len(c.cambios)); sys.exit(1)

# Persistir en el store
for e in c.cambios:
    store.append("c1", e)

# Reconstruir desde el store
eventos = store.load("c1")
c2 = m.CuentaBancaria.from_history(eventos)
if c2.saldo != 90:
    print("FAIL: reconstruido debe tener saldo 90, es", c2.saldo); sys.exit(1)
if c2.id != "c1":
    print("FAIL: reconstruido debe tener id c1, es", c2.id); sys.exit(1)
if len(c2.cambios) != 0:
    print("FAIL: la cuenta reconstruida no debe tener cambios nuevos"); sys.exit(1)

# Retirar más del saldo → error
try:
    c2.retirar(1000)
    print("FAIL: retirar más del saldo debe lanzar"); sys.exit(1)
except ValueError:
    pass
PY

echo "OK Tests pasaron"
