#!/usr/bin/env bash
# Validación del ejercicio 04 (nivel 04) - Circuit Breaker.
# Comprueba los 3 estados y las transiciones.
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

grep -q "class CircuitBreaker" "$SOL" || { echo "FAIL: debe definir CircuitBreaker"; fail; }
grep -qE "def call" "$SOL" || { echo "FAIL: debe tener call"; fail; }
for st in "closed" "open" "half_open"; do
  grep -q "$st" "$SOL" || { echo "FAIL: debe manejar estado '$st'"; fail; }
done

# Verificación funcional
python3 - "$SOL" <<'PY'
import importlib.util, sys, time
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

# umbral=3, reset_seg=0.1 (rápido para tests)
cb = m.CircuitBreaker(umbral=3, reset_seg=0.1)

def falla(): raise ValueError("fallo")
def ok(): return "ok"

# CLOSED: 3 fallos consecutivos → OPEN
for i in range(3):
    try: cb.call(falla)
    except ValueError: pass
if cb.estado != "open":
    print("FAIL: tras 3 fallos debe estar open, es", cb.estado); sys.exit(1)

# OPEN: call lanza RuntimeError (no ejecuta fn)
try:
    cb.call(ok)
    print("FAIL: en open debe lanzar RuntimeError"); sys.exit(1)
except RuntimeError:
    pass

# esperar reset_seg → HALF_OPEN
time.sleep(0.15)
# un éxito → CLOSED
r = cb.call(ok)
if r != "ok":
    print("FAIL: en half_open debería ejecutar y devolver ok"); sys.exit(1)
if cb.estado != "closed":
    print("FAIL: tras éxito en half_open debe estar closed, es", cb.estado); sys.exit(1)

# Volver a abrir y que el fallo en half_open → OPEN
cb2 = m.CircuitBreaker(umbral=2, reset_seg=0.1)
for _ in range(2):
    try: cb2.call(falla)
    except ValueError: pass
if cb2.estado != "open":
    print("FAIL: umbral=2 → open tras 2 fallos"); sys.exit(1)
time.sleep(0.15)
try: cb2.call(falla)
except: pass
if cb2.estado != "open":
    print("FAIL: fallo en half_open debe volver a open, es", cb2.estado); sys.exit(1)
PY

echo "OK Tests pasaron"
