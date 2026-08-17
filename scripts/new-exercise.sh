#!/usr/bin/env bash
set -euo pipefail

# new-exercise.sh — Crea un ejercicio nuevo con archivos reales + tests (spec v2)
# en es/ y en/. Genera: <slug>.md (enunciado), <slug>.<ext> (stub), <slug>.test.<ext> (tests).
#
# Uso:
#   scripts/new-exercise.sh <seccion/tema> <nivel> <nombre> [es|en]
#
#   nivel:  1|2|3|4|5  (alias) o nivel-XX-*
#   ejemplo: scripts/new-exercise.sh 01-programming/javascript 1 variables-y-tipos

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

[ $# -ge 3 ] || { echo "Uso: scripts/new-exercise.sh <seccion/tema> <nivel> <nombre> [es|en]" >&2; exit 1; }

TOPIC_PATH="$1"
LEVEL_ARG="$2"
NAME="$3"

LANGS=()
for arg in "$@"; do
  case "$arg" in
    es|en) LANGS+=("$arg") ;;
  esac
done
[ ${#LANGS[@]} -eq 0 ] && LANGS=(es en)

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
    cpp) echo "cpp" ;;
    csharp) echo "cs" ;;
    php) echo "php" ;;
    ruby) echo "rb" ;;
    kotlin) echo "kt" ;;
    swift) echo "swift" ;;
    sql|postgresql|mysql) echo "sql" ;;
    *) echo "js" ;;
  esac
}
TOPIC="$(basename "$TOPIC_PATH")"
EXT="$(detect_ext "$TOPIC")"

for lang in "${LANGS[@]}"; do
  dir="$ROOT/$lang/$TOPIC_PATH/ejercicios/$LEVEL"
  [ -d "$dir" ] || { echo "No existe: $dir (ejecuta scripts/init.sh)" >&2; exit 1; }

  next=1
  for f in "$dir"/ejercicio-*.md "$dir"/exercise-*.md; do
    [ -e "$f" ] || continue
    n="$(basename "$f" | sed -E 's/^(ejercicio|exercise)-([0-9]+)-.*/\2/')"
    [ "$n" -gt "$next" ] && next="$n"
  done
  next=$((next + 1))
  num="$(printf '%02d' "$next")"

  base="$(basename "$TOPIC_PATH")-none"
  if [ "$lang" = "es" ]; then
    file_md="$dir/ejercicio-$num-$NAME.md"
    file_impl="$dir/ejercicio-$num-$NAME.$EXT"
    file_test="$dir/ejercicio-$num-$NAME.test.$EXT"
    test_cmd="node --test $(basename "$file_test")"
    [ "$EXT" = "py" ] && test_cmd="python3 -m unittest $(basename "$file_test" .py)"
    [ "$EXT" = "go" ] && test_cmd="go test ./..."
  else
    file_md="$dir/exercise-$num-$NAME.md"
    file_impl="$dir/exercise-$num-$NAME.$EXT"
    file_test="$dir/exercise-$num-$NAME.test.$EXT"
    test_cmd="node --test $(basename "$file_test")"
    [ "$EXT" = "py" ] && test_cmd="python3 -m unittest $(basename "$file_test" .py)"
    [ "$EXT" = "go" ] && test_cmd="go test ./..."
  fi
  [ -f "$file_md" ] && { echo "Ya existe: $file_md" >&2; exit 1; }

  if [ "$lang" = "es" ]; then
    cat > "$file_md" <<EOF
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

\`\`\`\`$EXT
/* Escribe aquí el código de la solución */
\`\`\`\`

</details>
EOF
    cat > "$file_impl" <<'EOF'
// TODO: completa esta implementación para que los tests pasen.
module.exports = {
  // TODO: definir las funciones/valores que esperan los tests.
};
EOF
    cat > "$file_test" <<'EOF'
// TODO: escribe los tests que verifican la implementación.
// Ejemplo con node:test:
// const { test } = require("node:test");
// const assert = require("node:assert/strict");
// const impl = require("./<slug>");
EOF
  else
    cat > "$file_md" <<EOF
# Exercise $num — $TITLE

- **Level:** $LEVEL_NUM/5
- **Topic:** $TOPIC_PATH
- **Estimated time:** 15 min

## Statement

Describe what the program should do, inputs and expected output.

## Requirements

- [ ] Requirement 1
- [ ] Tests pass: \`$test_cmd\`

## Hints

<details>
<summary>Show hints</summary>

- Hint 1

</details>

## Solution

<details>
<summary>Show solution</summary>

\`\`\`\`$EXT
/* Write the solution code here */
\`\`\`\`

</details>
EOF
    cat > "$file_impl" <<'EOF'
// TODO: implement this so the tests pass.
module.exports = {
  // TODO: define the functions/values the tests expect.
};
EOF
    cat > "$file_test" <<'EOF'
// TODO: write tests that verify the implementation.
// Example with node:test:
// const { test } = require("node:test");
// const assert = require("node:assert/strict");
// const impl = require("./<slug>");
EOF
  fi

  echo "✔ $file_md"
  echo "✔ $file_impl"
  echo "✔ $file_test"
done