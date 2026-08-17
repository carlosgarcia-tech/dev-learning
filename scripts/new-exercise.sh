#!/usr/bin/env bash
set -euo pipefail

# new-exercise.sh — Crea un ejercicio nuevo con plantilla (enunciado + requisitos +
# pistas + solución plegable) en es/ y en/.
#
# Uso:
#   scripts/new-exercise.sh <seccion/tema> <nivel> <nombre> [es|en]
#
#   nivel:  1 | 2 | 3 | 4 | 5  (alias)
#           nivel-01-fundamentos | nivel-02-basico | nivel-03-intermedio
#           nivel-04-avanzado | nivel-05-experto
#
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

# Título legible: variables-y-tipos -> Variables y Tipos
TITLE="$(echo "$NAME" | sed -E 's/[-_]/ /g; s/(^| )([a-z])/\U\1\2/g')"

for lang in "${LANGS[@]}"; do
  dir="$ROOT/$lang/$TOPIC_PATH/ejercicios/$LEVEL"
  [ -d "$dir" ] || { echo "No existe: $dir (ejecuta scripts/init.sh)" >&2; exit 1; }

  next=1
  for f in "$dir"/ejercicio-*.md; do
    [ -e "$f" ] || continue
    n="$(basename "$f" | sed -E 's/^ejercicio-([0-9]+)-.*/\1/')"
    [ "$n" -gt "$next" ] && next="$n"
  done
  next=$((next + 1))
  num="$(printf '%02d' "$next")"
  file="$dir/ejercicio-$num-$NAME.md"
  [ -f "$file" ] && { echo "Ya existe: $file" >&2; exit 1; }

  if [ "$lang" = "es" ]; then
    cat > "$file" <<'EOF'
# Ejercicio __NUM__ — __TITLE__

- **Nivel:** __LEVEL__/5
- **Tema:** __TOPIC__
- **Tiempo estimado:** 15 min
- **Cumplido cuando:** [ ] logras el objetivo con criterios claros

## Enunciado

Describe aquí qué debe hacer el programa, qué datos usa y qué salida esperada.

## Requisitos

- [ ] Requisito 1
- [ ] Requisito 2
- [ ] Ejecutarlo localmente y verificar el resultado

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```text
/* Escribe aquí el código o los pasos de la solución */
```

</details>
EOF
  else
    cat > "$file" <<'EOF'
# Exercise __NUM__ — __TITLE__

- **Level:** __LEVEL__/5
- **Topic:** __TOPIC__
- **Estimated time:** 15 min
- **Done when:** [ ] you reach the goal with clear criteria

## Statement

Describe what the program should do, which inputs it uses, and the expected output.

## Requirements

- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Run it locally and verify the result

## Hints

<details>
<summary>Show hints</summary>

- Hint 1

</details>

## Solution

<details>
<summary>Show solution</summary>

```text
/* Write the code or steps of the solution here */
```

</details>
EOF
  fi

  sed -i "s/__NUM__/$num/g; s/__TITLE__/$TITLE/g; s/__LEVEL__/$LEVEL_NUM/g; s|__TOPIC__|$TOPIC_PATH|g" "$file"
  echo "✔ $file"
done