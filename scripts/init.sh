#!/usr/bin/env bash
set -euo pipefail

# init.sh — Crea el esqueleto completo del repositorio dev-learning (idempotente).
# No sobrescribe archivos existentes.
#
# Uso:
#   scripts/init.sh [es] [en]   (por defecto crea ambos idiomas)
#   scripts/init.sh es          (solo español)

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LANGS=()
for arg in "$@"; do
  case "$arg" in
    es|en) LANGS+=("$arg") ;;
    *) echo "Ignorando argumento desconocido: $arg" >&2 ;;
  esac
done
[ ${#LANGS[@]} -eq 0 ] && LANGS=(es en)

LEVELS="nivel-01-fundamentos nivel-02-basico nivel-03-intermedio nivel-04-avanzado nivel-05-experto"

PROGRAMMING="javascript typescript python java rust go cpp csharp php ruby kotlin swift"
DATABASES="sql postgresql mysql mongodb redis"
BACKEND="http rest graphql authentication architecture"
FRONTEND="html css javascript react nextjs"
DEVOPS="linux git docker kubernetes nginx ci-cd"
TOOLS="npm pnpm vscode opencode terminal"

create_topic_tree() {
  local section="$1" topic="$2" lang="$3"
  local base="$ROOT/$lang/$section/$topic"
  mkdir -p "$base/ejercicios"
  for lvl in $LEVELS; do
    mkdir -p "$base/ejercicios/$lvl"
    touch "$base/ejercicios/$lvl/.gitkeep"
  done
  mkdir -p "$base/ejercicios/proyectos"
  touch "$base/ejercicios/proyectos/.gitkeep"

  if [ ! -f "$base/README.md" ]; then
    topic_title="$(echo "$topic" | sed -E 's/[-_]/ /g')"
    if [ "$lang" = "es" ]; then
      cat > "$base/README.md" <<EOF
# ${topic_title}

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
    else
      cat > "$base/README.md" <<EOF
# ${topic_title}

> Study guide + leveled exercises.

## Guides

_Pending._

## Exercises

See [exercises/](ejercicios/)

| Level | Status |
|---|---|
| [level-01-fundamentals](ejercicios/nivel-01-fundamentos/) | ⬜ |
| [level-02-basic](ejercicios/nivel-02-basico/) | ⬜ |
| [level-03-intermediate](ejercicios/nivel-03-intermedio/) | ⬜ |
| [level-04-advanced](ejercicios/nivel-04-avanzado/) | ⬜ |
| [level-05-expert](ejercicios/nivel-05-experto/) | ⬜ |
| [projects](ejercicios/proyectos/) | ⬜ |
EOF
    fi
  fi

  if [ ! -f "$base/ejercicios/README.md" ]; then
    topic_title="$(echo "$topic" | sed -E 's/[-_]/ /g')"
    if [ "$lang" = "es" ]; then
      cat > "$base/ejercicios/README.md" <<EOF
# Ejercicios — ${topic_title}

Cada ejercicio tiene enunciado, requisitos, pistas y solución al final (plegable).

| Nivel | Qué cubre | Estado |
|---|---|---|
| [nivel-01-fundamentos](nivel-01-fundamentos/) | Sintaxis, tipos, variables | ⬜ |
| [nivel-02-basico](nivel-02-basico/) | Control de flujo, funciones | ⬜ |
| [nivel-03-intermedio](nivel-03-intermedio/) | Composición, errores, patrones | ⬜ |
| [nivel-04-avanzado](nivel-04-avanzado/) | Asincronía, optimización, integración | ⬜ |
| [nivel-05-experto](nivel-05-experto/) | Diseño y mini-proyectos | ⬜ |
| [proyectos](proyectos/) | Retos integradores | ⬜ |
EOF
    else
      cat > "$base/ejercicios/README.md" <<EOF
# Exercises — ${topic_title}

Each exercise has a statement, requirements, hints, and a solution at the end (collapsible).

| Level | Covers | Status |
|---|---|---|
| [level-01-fundamentals](nivel-01-fundamentos/) | Syntax, types, variables | ⬜ |
| [level-02-basic](nivel-02-basico/) | Control flow, functions | ⬜ |
| [level-03-intermediate](nivel-03-intermedio/) | Composition, errors, patterns | ⬜ |
| [level-04-advanced](nivel-04-avanzado/) | Async, optimization, integration | ⬜ |
| [level-05-expert](nivel-05-experto/) | Design and mini-projects | ⬜ |
| [projects](proyectos/) | Capstone challenges | ⬜ |
EOF
    fi
  fi
}

create_single_file() {
  local section="$1" file="$2" lang="$3"
  local base="$ROOT/$lang/$section"
  mkdir -p "$base"
  local title
  title="$(basename "$file" .md | sed -E 's/[-_]/ /g')"
  if [ ! -f "$base/$file" ]; then
    if [ "$lang" = "es" ]; then
      cat > "$base/$file" <<EOF
# ${title}

_Pendiente de escribir._
EOF
    else
      cat > "$base/$file" <<EOF
# ${title}

_Pending._
EOF
    fi
  fi
}

for lang in "${LANGS[@]}"; do
  echo "==> Generando estructura en: $lang"

  mkdir -p "$ROOT/$lang/00-roadmap"
  create_single_file "00-roadmap" "roadmap.md" "$lang"

  for topic in $PROGRAMMING; do
    create_topic_tree "01-programming" "$topic" "$lang"
  done
  for topic in $DATABASES; do
    create_topic_tree "02-databases" "$topic" "$lang"
  done
  for topic in $BACKEND; do
    create_topic_tree "03-backend" "$topic" "$lang"
  done
  for topic in $FRONTEND; do
    create_topic_tree "04-frontend" "$topic" "$lang"
  done
  for topic in $DEVOPS; do
    create_topic_tree "05-devops" "$topic" "$lang"
  done
  for topic in $TOOLS; do
    create_topic_tree "06-tools" "$topic" "$lang"
  done

  for file in networking.md operating-systems.md data-structures.md algorithms.md system-design.md; do
    create_single_file "07-concepts" "$file" "$lang"
  done

  for i in 1 2 3; do
    mkdir -p "$ROOT/$lang/08-projects/project-0$i"
    touch "$ROOT/$lang/08-projects/project-0$i/.gitkeep"
  done

  for file in git.md linux.md sql.md docker.md javascript.md; do
    create_single_file "09-cheatsheets" "$file" "$lang"
  done

  for file in npm-permissions.md linux-path.md docker-permissions.md; do
    create_single_file "10-errors" "$file" "$lang"
  done

  for file in books.md courses.md websites.md useful-repositories.md; do
    create_single_file "resources" "$file" "$lang"
  done

done

echo "✔ Estructura creada."