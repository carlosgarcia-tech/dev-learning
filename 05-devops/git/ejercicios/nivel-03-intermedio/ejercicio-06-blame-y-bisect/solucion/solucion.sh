#!/bin/bash
# Solución: usar bisect con un script de comprobación y guardar el culpable.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

# Script de comprobación: 0 = bueno (sin BUG), 1 = malo (con BUG)
cat > check.sh <<'EOF'
#!/bin/bash
if grep -q "^BUG$" bug.txt; then exit 1; else exit 0; fi
EOF
chmod +x check.sh

git bisect start >/dev/null
git bisect bad HEAD >/dev/null
git bisect good HEAD~5 >/dev/null
git bisect run ./check.sh >/dev/null 2>&1 || true

# En este punto HEAD está en el commit culpable (bisect deja ahí antes de reset)
echo "$(git rev-parse HEAD)" > .bisect-result

git bisect reset >/dev/null
