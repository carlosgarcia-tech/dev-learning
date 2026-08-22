#!/usr/bin/env bash
# Validación del ejercicio 05 (nivel 05) - Sistema 12-factor.
# Comprueba solucion.json (12 factores) y app.js (stateless, config env, logs stdout).
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SOL="solucion.json"
APP="app.js"
STRUCT="estructura.json"
DIAG="diagrama.txt"

for f in "$SOL" "$APP" "$STRUCT" "$DIAG"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
command -v node >/dev/null 2>&1 || { echo "FAIL: se requiere node"; fail; }

# JSON válidos
python3 -m json.tool "$STRUCT" >/dev/null 2>&1 || { echo "FAIL: $STRUCT no es JSON válido"; fail; }
python3 -m json.tool "$SOL" >/dev/null 2>&1 || { echo "FAIL: $SOL no es JSON válido"; fail; }
node --check "$APP" 2>/dev/null || { echo "FAIL: $APP no compila"; fail; }

# solucion.json tiene los 12 factores (I a XII)
python3 - "$SOL" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    d = json.load(f)
factores = d.get("factores", [])
if len(factores) != 12:
    print(f"FAIL: debe haber 12 factores, hay {len(factores)}"); sys.exit(1)
ids = {f.get("id") for f in factores}
esperados = {"I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII"}
if ids != esperados:
    print("FAIL: faltan factores:", esperados - ids); sys.exit(1)
for f in factores:
    if not f.get("nombre") or not f.get("aplicacion"):
        print("FAIL: cada factor debe tener nombre y aplicacion"); sys.exit(1)
PY

# app.js: lee config del entorno (III Config)
grep -qE "process\.env\.PORT" "$APP" || { echo "FAIL: app.js debe leer PORT del entorno (III Config)"; fail; }
grep -qE "process\.env\.DATABASE_URL" "$APP" || { echo "FAIL: app.js debe leer DATABASE_URL del entorno"; fail; }
# NO debe tener secrets hardcodeados (un valor obvio de secret en string)
if grep -qE "JWT_SECRET\s*=\s*['\"][^'\"]{8,}['\"]" "$APP"; then
  echo "FAIL: app.js NO debe tener secrets hardcodeados"; fail
fi

# app.js: logs a stdout (IX Logs)
grep -qi "console.log\|process.stdout" "$APP" || { echo "FAIL: app.js debe loguear a stdout (IX Logs)"; fail; }

# app.js: stateless - NO debe guardar sesión en memoria (un Map/dict persistente)
# Permitimos sessionStore pero debe referirse a REDIS_URL, no a un Map
if grep -qE "new Map\(\)|sessionStore\s*=\s*\{\}" "$APP"; then
  echo "FAIL: app.js no debe guardar sesión en memoria (VI Processes - stateless)"; fail
fi

echo "OK Tests pasaron"
