#!/bin/bash
# Solución: crear 4 commits conventional + generar CHANGELOG.md agrupado.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

echo "home" > home.js
git add home.js
git commit -q -m "feat: añade página de inicio"

echo "login fix" > login.js
git add login.js
git commit -q -m "fix: corrige error de login"

echo "# Actualizado" >> README.md
git add README.md
git commit -q -m "docs: actualiza README"

echo "nueva api" > auth.js
git add auth.js
git commit -q -m "feat!: cambia API de autenticación"

cat > CHANGELOG.md <<'EOF'
# Changelog

## [Unreleased]

### Features
- añade página de inicio
- cambia API de autenticación

### Bug Fixes
- corrige error de login

### BREAKING CHANGES
- cambia API de autenticación
EOF
git add CHANGELOG.md
git commit -q -m "docs: genera changelog"
