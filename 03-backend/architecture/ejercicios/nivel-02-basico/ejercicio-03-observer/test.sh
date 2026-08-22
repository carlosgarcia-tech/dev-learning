#!/usr/bin/env bash
# Validación del ejercicio 03 (nivel 02) - Observer.
# Comprueba suscripción, notificación y desuscripción.
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
python3 -c "import py_compile; py_compile.compile('$SOL', doraise=True)" 2>/dev/null || { echo "FAIL: $SOL no compila con python3"; fail; }

for cls in "Observador" "LoggerObservador" "ContadorObservador" "EventoBus"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done
grep -qE "abstractmethod" "$SOL" || { echo "FAIL: Observador debe ser abstracta"; fail; }
grep -qE "def actualizar" "$SOL" || { echo "FAIL: Observador debe tener actualizar"; fail; }
for m in "def suscribir" "def desuscribir" "def publicar"; do
  grep -q "$m" "$SOL" || { echo "FAIL: EventoBus debe tener $m"; fail; }
done

# Verificación funcional
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

bus = m.EventoBus()
logger = m.LoggerObservador()
cont = m.ContadorObservador()
bus.suscribir(logger); bus.suscribir(cont)

bus.publicar("user.created", {"id": 1})
bus.publicar("user.deleted", {"id": 1})

if logger.logs != [("user.created", {"id": 1}), ("user.deleted", {"id": 1})]:
    print("FAIL: LoggerObservador debe recibir ambos eventos"); sys.exit(1)
if cont.count != 2:
    print("FAIL: ContadorObservador debe contar 2, es", cont.count); sys.exit(1)

# desuscripción
bus.desuscribir(cont)
bus.publicar("user.updated", {"id": 1})
if cont.count != 2:
    print("FAIL: tras desuscribir, ContadorObservador no debe recibir más"); sys.exit(1)
if len(logger.logs) != 3:
    print("FAIL: LoggerObservador sí debe seguir recibiendo"); sys.exit(1)
PY

echo "OK Tests pasaron"
