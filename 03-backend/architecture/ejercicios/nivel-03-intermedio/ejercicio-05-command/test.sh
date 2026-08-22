#!/usr/bin/env bash
# Validación del ejercicio 05 (nivel 03) - Command.
# Comprueba ejecutar/deshacer y el historial del control remoto.
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

for cls in "Comando" "Luz" "EncenderLuz" "ApagarLuz" "ControlRemoto"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done
grep -qE "abstractmethod" "$SOL" || { echo "FAIL: Comando debe ser abstracta"; fail; }
grep -qE "def ejecutar" "$SOL" || { echo "FAIL: debe haber ejecutar"; fail; }
grep -qE "def deshacer" "$SOL" || { echo "FAIL: debe haber deshacer"; fail; }
grep -qE "def pulsar" "$SOL" || { echo "FAIL: ControlRemoto debe tener pulsar"; fail; }
grep -qE "def undo" "$SOL" || { echo "FAIL: ControlRemoto debe tener undo"; fail; }

# Verificación funcional
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

luz = m.Luz()
ctrl = m.ControlRemoto()

ctrl.pulsar(m.EncenderLuz(luz))
if not luz.encendida:
    print("FAIL: tras EncenderLuz, luz debe estar encendida"); sys.exit(1)

ctrl.undo()
if luz.encendida:
    print("FAIL: tras undo de EncenderLuz, luz debe estar apagada"); sys.exit(1)

ctrl.pulsar(m.ApagarLuz(luz))   # ya está apagada, pero ok
ctrl.pulsar(m.EncenderLuz(luz)) # enciende
ctrl.undo()                     # deshace encender → apaga
if luz.encendida:
    print("FAIL: tras secuencia, luz debe estar apagada"); sys.exit(1)

# undo sin historial no rompe
ctrl2 = m.ControlRemoto()
ctrl2.undo()  # no debe lanzar
PY

echo "OK Tests pasaron"
