#!/bin/bash
# Solución: bisect automatizado con check.sh; guardar culpable en .bisect-result.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

cat > check.sh <<'EOF'
#!/bin/bash
if grep -q "^BUG$" app.txt; then exit 1; else exit 0; fi
EOF
chmod +x check.sh

git bisect start >/dev/null
git bisect bad HEAD >/dev/null
git bisect good HEAD~7 >/dev/null
git bisect run ./check.sh >/dev/null 2>&1 || true

echo "$(git rev-parse HEAD)" > .bisect-result

git bisect reset >/dev/null
