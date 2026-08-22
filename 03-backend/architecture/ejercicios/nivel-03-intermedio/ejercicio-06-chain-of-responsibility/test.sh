#!/usr/bin/env bash
# Validación del ejercicio 06 (nivel 03) - Chain of Responsibility.
# Comprueba la cadena de manejadores y el corte en auth.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SOL="solucion.js"
STRUCT="estructura.json"
DIAG="diagrama.txt"

for f in "$SOL" "$STRUCT" "$DIAG"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
command -v node >/dev/null 2>&1 || { echo "FAIL: se requiere node"; fail; }

python3 -m json.tool "$STRUCT" >/dev/null 2>&1 || { echo "FAIL: $STRUCT no es JSON válido"; fail; }
node --check "$SOL" 2>/dev/null || { echo "FAIL: $SOL no compila"; fail; }

for cls in "Manejador" "AuthHandler" "LogHandler" "NegocioHandler"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done
grep -qE "setNext\s*\(" "$SOL" || { echo "FAIL: Manejador debe tener setNext"; fail; }
grep -qE "manejar\s*\(" "$SOL" || { echo "FAIL: Manejador debe tener manejar"; fail; }

# Los concretos extienden Manejador
grep -qE "class AuthHandler\s+extends\s+Manejador" "$SOL" || { echo "FAIL: AuthHandler debe extender Manejador"; fail; }

# Verificación funcional
node -e '
const { AuthHandler, LogHandler, NegocioHandler } = require("./'"$SOL"'");
const auth = new AuthHandler();
const log = new LogHandler();
const biz = new NegocioHandler();
auth.setNext(log).setNext(biz);  // cadena

// Sin token → 401, corta la cadena
const r1 = auth.manejar({ path: "/x" });
if (r1.status !== 401) { console.error("FAIL: sin token → 401, es", r1.status); process.exit(1); }

// Con token → 200
const r2 = auth.manejar({ path: "/x", token: 1 });
if (r2.status !== 200) { console.error("FAIL: con token → 200, es", r2.status); process.exit(1); }
' || fail

echo "OK Tests pasaron"
