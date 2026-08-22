#!/usr/bin/env bash
# Validación del ejercicio 04 (nivel 05) - Escalabilidad horizontal (LB + stateless).
# Comprueba round-robin, least-connections y salto de instancias down.
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

for cls in "Instancia" "LoadBalancer"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done
for m in "def health\|health\s*\(\)" "distribute\s*\(" "add\s*\(" "remove\s*\("; do
  grep -qE "$m" "$SOL" || { echo "FAIL: debe haber $m"; fail; }
done
grep -qi "round-robin\|round_robin" "$SOL" || { echo "FAIL: debe soportar round-robin"; fail; }
grep -qi "least-connections\|least_connections" "$SOL" || { echo "FAIL: debe soportar least-connections"; fail; }

# Verificación funcional
node -e '
(async () => {
  const { Instancia, LoadBalancer } = require("./'"$SOL"'");
  const lb = new LoadBalancer();
  const i1 = new Instancia("i1");
  const i2 = new Instancia("i2");
  const i3 = new Instancia("i3");
  lb.add(i1).add(i2).add(i3);

  // round-robin: 3 peticiones → una a cada instancia
  const r1 = await lb.distribute({}, "round-robin");
  const r2 = await lb.distribute({}, "round-robin");
  const r3 = await lb.distribute({}, "round-robin");
  const ids = new Set([r1.handled_by, r2.handled_by, r3.handled_by]);
  if (ids.size !== 3) { console.error("FAIL: round-robin debe repartir entre las 3"); process.exit(1); }

  // i3 cae → se salta
  i3.up = false;
  const r4 = await lb.distribute({}, "round-robin");
  if (r4.handled_by === "i3") { console.error("FAIL: i3 down no debe recibir tráfico"); process.exit(1); }

  // todas down → error
  i1.up = false; i2.up = false;
  try {
    lb.distribute({}, "round-robin");
    console.error("FAIL: todas down debe lanzar error"); process.exit(1);
  } catch (e) { /* ok */ }

  // least-connections: elige al de menos conexiones
  const lb2 = new LoadBalancer();
  const a = new Instancia("a"); const b = new Instancia("b");
  lb2.add(a).add(b);
  a.conexiones = 5; b.conexiones = 1;
  const r = await lb2.distribute({}, "least-connections");
  if (r.handled_by !== "b") { console.error("FAIL: least-connections debe elegir b (1<5)"); process.exit(1); }
})();
' || fail

echo "OK Tests pasaron"
