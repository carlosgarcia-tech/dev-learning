# Ejercicio 01 — Git Flow completo

- **Nivel:** 5/5
- **Tema:** Git Flow
- **Tiempo estimado:** 45 minutos

## Enunciado

Implementa un flujo Git Flow completo partiendo de un repo con `main` inicializado.

1. Crea la rama `develop` desde `main`.
2. Crea `feature/login` desde `develop`, añade `login.js`, commitea `feat: añade login` y fusiona en `develop` (merge --no-ff).
3. Crea `release/1.0.0` desde `develop`, añade `CHANGELOG.md` con "## 1.0.0", commitea `chore: prepara release 1.0.0`. Fusiona release en `main` (--no-ff) y de vuelta en `develop`.
4. Crea `hotfix/1.0.1` desde `main`, corrige `login.js` añadiendo "fix", commitea `fix: corrige bug en login`. Fusiona hotfix en `main` y en `develop`.
5. Crea un tag anotado `v1.0.1` en `main` con mensaje `Release 1.0.1`.

## Requisitos

- [ ] Existen las ramas `main`, `develop`, `feature/login`, `release/1.0.0`, `hotfix/1.0.1`
- [ ] `main` contiene `login.js` (con la corrección del hotfix), `CHANGELOG.md`
- [ ] `develop` contiene los mismos cambios que `main` (incluido el hotfix)
- [ ] Existe el tag anotado `v1.0.1` con mensaje `Release 1.0.1`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Orden: develop → feature → develop → release → main+develop → hotfix → main+develop → tag.
- `git merge --no-ff` crea merge commits (preserva el contexto de cada rama).
- Tras fusionar una rama de soporte en main y develop, puedes borrarla.
- El tag se crea sobre el último commit de `main`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git switch -c develop
git switch -c feature/login
echo "function login() {}" > login.js
git add login.js
git commit -q -m "feat: añade login"
git switch develop
git merge --no-ff feature/login -m "merge: integra feature/login"

git switch -c release/1.0.0
echo "## 1.0.0" > CHANGELOG.md
git add CHANGELOG.md
git commit -q -m "chore: prepara release 1.0.0"
git switch main
git merge --no-ff release/1.0.0 -m "merge: integra release/1.0.0"
git switch develop
git merge --no-ff release/1.0.0 -m "merge: integra release/1.0.0 en develop"

git switch -c hotfix/1.0.1 main
echo "fix" >> login.js
git commit -q -am "fix: corrige bug en login"
git switch main
git merge --no-ff hotfix/1.0.1 -m "merge: integra hotfix/1.0.1"
git switch develop
git merge --no-ff hotfix/1.0.1 -m "merge: integra hotfix/1.0.1 en develop"

git switch main
git tag -a v1.0.1 -m "Release 1.0.1"
```

</details>
