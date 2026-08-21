# Ejercicio 01 — Rebase

- **Nivel:** 3/5
- **Tema:** Rebase
- **Tiempo estimado:** 25 minutos

## Enunciado

1. El repo tiene `main` y `feature`. Ambas ramas divergen: `main` tiene un commit que `feature` no tiene, y `feature` tiene un commit que `main` no tiene.
2. Rebasa `feature` sobre `main` para que la historia quede lineal (los commits de `feature` quedan encima de `main`).
3. El test comprobará que `feature` contiene el archivo de `main` (`home.js`) y que su último commit es `feat: añade feature.js`.

## Requisitos

- [ ] `feature` contiene `home.js` (el commit de main)
- [ ] El último commit de `feature` es `feat: añade feature.js`
- [ ] La historia de `feature` es lineal (no hay merge commit)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Cámbiate a `feature` y ejecuta `git rebase main`.
- Tras el rebase, `feature` estará encima de `main` (historia lineal).
- `git log --oneline feature` debe mostrar los commits de main seguidos de los de feature.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git switch feature
git rebase main
```

</details>
