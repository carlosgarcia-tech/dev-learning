#!/usr/bin/env bash
set -euo pipefail

# new-topic.sh — Crea un tema nuevo (README + ejercicios de 5 niveles).
#
# El contenido vive directamente en la raíz del repo (la capa es/ se aplanó).
#
# Uso:
#   scripts/new-topic.sh <seccion/tema>
#   scripts/new-topic.sh 02-databases/dynamodb
#   scripts/new-topic.sh 04-frontend/svelte

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

[ $# -ge 1 ] || { echo "Uso: scripts/new-topic.sh <seccion/tema>" >&2; exit 1; }

TOPIC_PATH="$1"
case "$TOPIC_PATH" in
  */*) ;;
  *) echo "Ruta inválida: usa formato seccion/tema (ej: 02-databases/dynamodb)" >&2; exit 1 ;;
esac

SECTION="$(dirname "$TOPIC_PATH")"
TOPIC="$(basename "$TOPIC_PATH")"

base="$ROOT/$SECTION/$TOPIC"
mkdir -p "$base/ejercicios"
for lvl in nivel-01-fundamentos nivel-02-basico nivel-03-intermedio nivel-04-avanzado nivel-05-experto; do
  mkdir -p "$base/ejercicios/$lvl"
  touch "$base/ejercicios/$lvl/.gitkeep"
done
mkdir -p "$base/ejercicios/proyectos"
touch "$base/ejercicios/proyectos/.gitkeep"

title="$(echo "$TOPIC" | sed -E 's/[-_]/ /g')"
if [ ! -f "$base/README.md" ]; then
  cat > "$base/README.md" <<EOF
# ${title}

> Guía de estudio + ejercicios por niveles.

## Guías

_Pendientes por escribir._

## Ejercicios

Ver [ejercicios/](ejercicios/)

| Nivel | Estado |
|---|---|
| [nivel-01-fundamentos](ejercicios/nivel-01-fundamentos/) | ⬜ |
| [nivel-02-basico](ejercicios/nivel-02-basico/) | ⬜ |
| [nivel-03-intermedio](ejercicios/nivel-03-intermedio/) | ⬜ |
| [nivel-04-avanzado](ejercicios/nivel-04-avanzado/) | ⬜ |
| [nivel-05-experto](ejercicios/nivel-05-experto/) | ⬜ |
| [proyectos](ejercicios/proyectos/) | ⬜ |
EOF
fi

echo "✔ $SECTION/$TOPIC"
