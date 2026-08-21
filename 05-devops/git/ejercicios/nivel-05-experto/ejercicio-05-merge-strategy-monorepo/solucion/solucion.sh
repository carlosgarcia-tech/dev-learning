#!/bin/bash
# Solución: fusionar feature/api-v2 en main y añadir CODEOWNERS.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git switch main
git merge --no-ff feature/api-v2 -m "merge: integra api v2"

mkdir -p .github
cat > .github/CODEOWNERS <<'EOF'
/apps/web/   @equipo-frontend
/apps/api/   @equipo-backend
EOF
git add .github/CODEOWNERS
git commit -q -m "chore: añade CODEOWNERS"
