#!/usr/bin/env bash
set -euo pipefail

# new-guide.sh — Crea una guía de estudio nueva con plantilla en es/ y en/.
#
# Uso:
#   scripts/new-guide.sh <seccion/tema> <nombre> [es|en]
#
#   ejemplo: scripts/new-guide.sh 01-programming/javascript arrays-y-objetos

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

[ $# -ge 2 ] || { echo "Uso: scripts/new-guide.sh <seccion/tema> <nombre> [es|en]" >&2; exit 1; }

TOPIC_PATH="$1"
NAME="$2"

LANGS=()
for arg in "$@"; do
  case "$arg" in
    es|en) LANGS+=("$arg") ;;
  esac
done
[ ${#LANGS[@]} -eq 0 ] && LANGS=(es en)

TITLE="$(echo "$NAME" | sed -E 's/[-_]/ /g; s/(^| )([a-z])/\U\1\2/g')"
TODAY="$(date +%Y-%m-%d)"

for lang in "${LANGS[@]}"; do
  dir="$ROOT/$lang/$TOPIC_PATH"
  [ -d "$dir" ] || { echo "No existe: $dir (ejecuta scripts/init.sh)" >&2; exit 1; }
  file="$dir/$NAME.md"
  [ -f "$file" ] && { echo "Ya existe: $file" >&2; exit 1; }

  if [ "$lang" = "es" ]; then
    cat > "$file" <<EOF
# ${TITLE}

- **Tema:** ${TOPIC_PATH}
- **Creada:** ${TODAY}
- **Estado:** 📝 en progreso

## Objetivos

- [ ] Objetivo 1

## Apuntes

### Conceptos clave

## Ejemplos de código

## Ejercicios relacionados

Ver [ejercicios/](ejercicios/)

## Errores comunes

Ver [10-errors](../../10-errors/)

## Recursos
EOF
  else
    cat > "$file" <<EOF
# ${TITLE}

- **Topic:** ${TOPIC_PATH}
- **Created:** ${TODAY}
- **Status:** 📝 in progress

## Goals

- [ ] Goal 1

## Notes

### Key concepts

## Code examples

## Related exercises

See [exercises/](ejercicios/)

## Common mistakes

See [10-errors](../../10-errors/)

## Resources
EOF
  fi
  echo "✔ $file"
done