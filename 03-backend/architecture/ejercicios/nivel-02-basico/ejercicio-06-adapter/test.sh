#!/usr/bin/env bash
# Validación del ejercicio 06 (nivel 02) - Adapter.
# Comprueba que el adapter adapte la interfaz legacy a la esperada.
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

for cls in "Pago" "PagoLegacy" "PagoAdapter"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done
grep -qE "abstractmethod" "$SOL" || { echo "FAIL: Pago debe ser abstracta"; fail; }
grep -qE "def pagar" "$SOL" || { echo "FAIL: Pago debe tener pagar"; fail; }
grep -qE "def haz_pago" "$SOL" || { echo "FAIL: PagoLegacy debe tener haz_pago"; fail; }

# PagoAdapter hereda de Pago
grep -qE "class PagoAdapter\s*\(\s*Pago" "$SOL" || { echo "FAIL: PagoAdapter debe heredar de Pago"; fail; }

# Verificación funcional
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

adapter = m.PagoAdapter(m.PagoLegacy())
res = adapter.pagar(9.99)
if "999" not in res:
    print("FAIL: pagar(9.99) debe delegar a haz_pago(999), fue:", res); sys.exit(1)
res2 = adapter.pagar(1.0)
if "100" not in res2:
    print("FAIL: pagar(1.0) debe delegar a haz_pago(100), fue:", res2); sys.exit(1)
# El adapter ES un Pago
if not isinstance(adapter, m.Pago):
    print("FAIL: PagoAdapter debe ser instancia de Pago"); sys.exit(1)
PY

echo "OK Tests pasaron"
