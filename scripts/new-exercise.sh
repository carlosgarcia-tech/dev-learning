#!/usr/bin/env bash
set -euo pipefail

# new-exercise.sh — Crea un ejercicio nuevo con archivos reales + tests.
# Genera: ejercicio-NN-<slug>/ (carpeta) con README.md, stub y test.
#
# El contenido vive directamente en la raíz del repo (la capa es/ se aplanó).
#
# Uso:
#   scripts/new-exercise.sh <seccion/tema> <nivel> <nombre>
#
#   nivel:  1|2|3|4|5  (alias) o nivel-XX-*
#   ejemplo: scripts/new-exercise.sh 01-programming/javascript 1 variables-y-tipos

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

[ $# -ge 3 ] || { echo "Uso: scripts/new-exercise.sh <seccion/tema> <nivel> <nombre>" >&2; exit 1; }

TOPIC_PATH="$1"
LEVEL_ARG="$2"
NAME="$3"

case "$LEVEL_ARG" in
  1) LEVEL="nivel-01-fundamentos" ;;
  2) LEVEL="nivel-02-basico" ;;
  3) LEVEL="nivel-03-intermedio" ;;
  4) LEVEL="nivel-04-avanzado" ;;
  5) LEVEL="nivel-05-experto" ;;
  nivel-*) LEVEL="$LEVEL_ARG" ;;
  *) echo "Nivel inválido: $LEVEL_ARG (usa 1-5)" >&2; exit 1 ;;
esac

LEVEL_NUM="${LEVEL#nivel-}"
LEVEL_NUM="${LEVEL_NUM%%-*}"

TITLE="$(echo "$NAME" | sed -E 's/[-_]/ /g; s/(^| )([a-z])/\U\1\2/g')"

# Detectar extensión según el tema
detect_ext() {
  local topic="$1"
  case "$topic" in
    python) echo "py" ;;
    go) echo "go" ;;
    typescript) echo "ts" ;;
    java) echo "java" ;;
    rust) echo "rs" ;;
    csharp) echo "cs" ;;
    php) echo "php" ;;
    ruby) echo "rb" ;;
    kotlin) echo "kt" ;;
    sql|postgresql|mysql) echo "sql" ;;
    *) echo "js" ;;
  esac
}
TOPIC="$(basename "$TOPIC_PATH")"
EXT="$(detect_ext "$TOPIC")"

dir="$ROOT/$TOPIC_PATH/ejercicios/$LEVEL"
[ -d "$dir" ] || { echo "No existe: $dir (ejecuta scripts/init.sh)" >&2; exit 1; }

next=1
for f in "$dir"/ejercicio-*/README.md "$dir"/ejercicio-*.md; do
  [ -e "$f" ] || continue
  n="$(basename "$(dirname "$f")" | sed -E 's/^ejercicio-([0-9]+)-.*/\1/' 2>/dev/null || echo "$f" | sed -E 's/^(ejercicio|exercise)-([0-9]+)-.*/\2/')"
  [ "$n" -gt "$next" ] 2>/dev/null && next="$n"
done
next=$((next + 1))
num="$(printf '%02d' "$next")"

exdir="$dir/ejercicio-$num-$NAME"
mkdir -p "$exdir"

test_cmd="node --test index.test.js"
[ "$EXT" = "py" ] && test_cmd="python3 -m unittest test_main.py"
[ "$EXT" = "go" ] && test_cmd="go test ./..."

cat > "$exdir/README.md" <<EOF
# Ejercicio $num — $TITLE

- **Nivel:** $LEVEL_NUM/5
- **Tema:** $TOPIC_PATH
- **Tiempo estimado:** 15 min

## Enunciado

Describe aquí qué debe hacer el programa, qué datos usa y qué salida esperada.

## Requisitos

- [ ] Requisito 1
- [ ] Los tests pasan: \`$test_cmd\`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

\`\`\`$EXT
/* Escribe aquí el código de la solución */
\`\`\`

</details>
EOF

cat > "$exdir/index.$EXT" <<'EOF'
// TODO: completa esta implementación para que los tests pasen.
module.exports = {
  // TODO: definir las funciones/valores que esperan los tests.
};
EOF

cat > "$exdir/index.test.$EXT" <<'EOF'
// TODO: escribe los tests que verifican la implementación.
// Ejemplo con node:test:
// const { test } = require("node:test");
// const assert = require("node:assert/strict");
// const impl = require("./index");
EOF

echo "✔ $exdir/README.md"
echo "✔ $exdir/index.$EXT"
echo "✔ $exdir/index.test.$EXT"
