#!/bin/bash
# Solución de referencia: implementa Git Flow completo, hooks, changelog, tags y remote.
set -euo pipefail
REPO="$1"
REMOTE="$2"
cd "$REPO"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

# Los hooks y starter ya están copiados por setup.sh.
# Commit de los hooks (ya commiteado el main.js en setup; ahora añadimos hooks + scripts).
git add .githooks scripts ci.sh
git commit -q -m "chore: añade hooks, scripts y CI" || true

# ---- Fase 2: Feature ----
git switch -c develop
git switch -c feature/auth
echo "function auth() { return true; }" > app/auth.js
git add app/auth.js
git commit -q -m "feat(auth): añade autenticación"
git switch develop
git merge --no-ff feature/auth -m "merge: integra feature/auth"

# ---- Fase 3: Release 1.0.0 ----
git switch -c release/1.0.0
bash scripts/generate-changelog.sh
git add CHANGELOG.md
git commit -q -m "docs: genera changelog 1.0.0"
git switch main
git merge --no-ff release/1.0.0 -m "merge: integra release/1.0.0"
git switch develop
git merge --no-ff release/1.0.0 -m "merge: integra release/1.0.0 en develop"
git switch main
git tag -a v1.0.0 -m "Release 1.0.0"

# ---- Fase 4: Hotfix 1.0.1 ----
git switch -c hotfix/1.0.1 main
printf "function main() {\n    console.log('App iniciada');\n}\nmain();\n" > app/main.js
git add app/main.js
git commit -q -m "fix(app): corrige bug crítico"
git switch main
git merge --no-ff hotfix/1.0.1 -m "merge: integra hotfix/1.0.1"
git switch develop
git merge --no-ff hotfix/1.0.1 -m "merge: integra hotfix/1.0.1 en develop"
git switch main
# Regenerar changelog para incluir el fix del hotfix
bash scripts/generate-changelog.sh
git add CHANGELOG.md
git commit -q -m "docs: actualiza changelog con hotfix 1.0.1"
git tag -a v1.0.1 -m "Release 1.0.1"

# ---- Fase 5: Remote y CI ----
git push -q origin main
git push -q origin develop
git push -q origin --tags
