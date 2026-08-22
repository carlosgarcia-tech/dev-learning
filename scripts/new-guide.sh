#!/usr/bin/env bash
set -euo pipefail

# new-guide.sh — Crea una guía de estudio nueva con plantilla.
#
# El contenido vive directamente en la raíz del repo (la capa es/ se aplanó).
#
# Uso:
#   scripts/new-guide.sh <seccion/tema> <nombre>
#
#   ejemplo: scripts/new-guide.sh 01-programming/javascript arrays-y-objetos

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

[ $# -ge 2 ] || { echo "Uso: scripts/new-guide.sh <seccion/tema> <nombre>" >&2; exit 1; }

TOPIC_PATH="$1"
NAME="$2"

TITLE="$(echo "$NAME" | sed -E 's/[-_]/ /g; s/(^| )([a-z])/\U\1\2/g')"
TODAY="$(date +%Y-%m-%d)"

dir="$ROOT/$TOPIC_PATH"
[ -d "$dir" ] || { echo "No existe: $dir (ejecuta scripts/init.sh)" >&2; exit 1; }
file="$dir/$NAME.md"
[ -f "$file" ] && { echo "Ya existe: $file" >&2; exit 1; }

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

echo "✔ $file"
