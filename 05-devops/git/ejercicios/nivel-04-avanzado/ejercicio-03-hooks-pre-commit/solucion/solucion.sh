#!/bin/bash
# Solución: crear hook pre-commit, configurar hooksPath, intentar commitear secrets (falla), commitear permitido.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

mkdir -p .githooks
cat > .githooks/pre-commit <<'EOF'
#!/bin/bash
if git diff --cached --name-only | grep -q "secrets.env"; then
    echo "detectado secrets.env"
    exit 1
fi
exit 0
EOF
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks

git add .githooks
git commit -q -m "chore: añade hook pre-commit"

# Intentar commitear secrets.env (debe fallar por el hook)
echo "SECRET=123" > secrets.env
git add secrets.env
git commit -m "feat: sube secrets" 2>/dev/null || true   # falla esperado

# Quitar del staging y commitear algo permitido
git restore --staged secrets.env
echo "hola" > app.txt
git add app.txt
git commit -q -m "feat: commit permitido"
