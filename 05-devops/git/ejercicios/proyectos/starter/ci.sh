#!/bin/bash
# CI simulado: ejecuta lint + tests. Exit 0 si todo OK.
set -euo pipefail

REPO_DIR="${1:-$(git rev-parse --show-toplevel 2>/dev/null || echo .)}"
cd "$REPO_DIR"

echo "[CI] Ejecutando lint..."
# Lint simple: no debe haber TODO en archivos JS
if grep -rn "TODO" app/ 2>/dev/null; then
    echo "[CI] FAIL: se encontró TODO en app/"
    exit 1
fi

echo "[CI] Ejecutando tests..."
# Test simple: main.js existe y no está vacío
if [ -f app/main.js ]; then
    if ! grep -q "main" app/main.js; then
        echo "[CI] FAIL: app/main.js no contiene la función main"
        exit 1
    fi
else
    echo "[CI] FAIL: no existe app/main.js"
    exit 1
fi

echo "[CI] OK: lint y tests pasaron"
exit 0
