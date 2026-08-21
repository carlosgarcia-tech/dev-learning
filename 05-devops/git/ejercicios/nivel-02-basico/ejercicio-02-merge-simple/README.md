# Ejercicio 02 — Merge simple

- **Nivel:** 2/5
- **Tema:** Ramas y merge
- **Tiempo estimado:** 20 minutos

## Enunciado

1. El repo tiene la rama `main` (con `README.md` y `app.js`) y una rama `feature/docs` (con un commit que añade `docs.md`).
2. Cámbiate a `main` y fusiona `feature/docs` con `git merge`.
3. Al ser un merge fast-forward, `main` debe avanzar y contener `docs.md`.

## Requisitos

- [ ] `main` contiene el archivo `docs.md`
- [ ] El último commit de `main` tiene el mensaje `docs: añade docs.md`
- [ ] El merge fue fast-forward (no hay commit de merge con dos padres)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `git switch main` y luego `git merge feature/docs`.
- Si el merge es fast-forward, el último commit de `main` será exactamente el de `feature/docs`.
- Para comprobar que NO hay merge commit, verifica que el último commit tiene un solo padre (`git cat-file -p HEAD | grep -c '^parent'` debe ser 0 o el commit base).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git switch main
git merge feature/docs
```

</details>
