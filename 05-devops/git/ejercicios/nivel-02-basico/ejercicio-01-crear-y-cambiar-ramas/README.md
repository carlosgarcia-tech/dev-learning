# Ejercicio 01 — Crear y cambiar ramas

- **Nivel:** 2/5
- **Tema:** Ramas
- **Tiempo estimado:** 20 minutos

## Enunciado

1. El repo está en la rama `main` con 1 commit.
2. Crea una rama llamada `feature/login`.
3. Cámbiate a ella.
4. Crea un archivo `login.js` y commitea con el mensaje `feat: añade login`.
5. Vuelve a `main` y crea un archivo `home.js` commiteado con `feat: añade home`.

Al acabar: `main` debe tener 2 commits, `feature/login` debe tener 2 commits (distinto el segundo) y estar en rama divergente.

## Requisitos

- [ ] Existe la rama `feature/login`
- [ ] `feature/login` tiene un commit con `login.js` y mensaje `feat: añade login`
- [ ] `main` tiene un commit con `home.js` y mensaje `feat: añade home`
- [ ] Las ramas divergen (el último commit de `main` y `feature/login` son distintos)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `git branch feature/login` crea la rama; `git switch feature/login` (o `git checkout`) cambia a ella.
- `git switch -c feature/login` hace ambas cosas a la vez.
- Recuerda volver a main antes de crear `home.js`: `git switch main`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git switch -c feature/login
echo "function login() {}" > login.js
git add login.js
git commit -q -m "feat: añade login"
git switch main
echo "function home() {}" > home.js
git add home.js
git commit -q -m "feat: añade home"
```

</details>
