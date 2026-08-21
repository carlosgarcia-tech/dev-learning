# Ejercicio 02 — Conventional commits y changelog

- **Nivel:** 5/5
- **Tema:** Conventional Commits y changelog
- **Tiempo estimado:** 40 minutos

## Enunciado

1. El repo está en `main` con 1 commit inicial.
2. Crea 4 commits siguiendo **Conventional Commits**:
   - `feat: añade página de inicio`
   - `fix: corrige error de login`
   - `docs: actualiza README`
   - `feat!: cambia API de autenticación` (breaking change)
3. Genera un `CHANGELOG.md` agrupando los commits por tipo:
   - Features: "añade página de inicio", "cambia API de autenticación"
   - Bug Fixes: "corrige error de login"
   - BREAKING CHANGES: "cambia API de autenticación"
4. Commitea el changelog con `docs: genera changelog`.

## Requisitos

- [ ] El historial contiene los 4 commits con los mensajes exactos
- [ ] Existe `CHANGELOG.md` commiteado
- [ ] `CHANGELOG.md` contiene una sección "Features" con "añade página de inicio"
- [ ] `CHANGELOG.md` contiene una sección "Bug Fixes" con "corrige error de login"
- [ ] `CHANGELOG.md` menciona el breaking change "cambia API de autenticación"
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Cada commit debe tener un archivo asociado para que no esté vacío: `echo ... > archivo`.
- El `!` en `feat!:` indica breaking change.
- El changelog lo generas a mano (o con un script) agrupando por tipo. No necesitas una herramienta externa.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
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
```

</details>
