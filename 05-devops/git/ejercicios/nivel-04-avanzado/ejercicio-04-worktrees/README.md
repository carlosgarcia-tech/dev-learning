# Ejercicio 04 — Worktrees

- **Nivel:** 4/5
- **Tema:** Worktrees
- **Tiempo estimado:** 25 minutos

## Enunciado

1. El repo está en `main` con 1 commit, y existe una rama `feature`.
2. Crea un worktree en `../wt-feature` apuntando a la rama `feature`.
3. Dentro de ese worktree, crea un archivo `feature.txt` y commitea con `feat: añade feature.txt`.
4. El test comprobará que el worktree existe y que la rama `feature` avanzó (tiene el commit).

## Requisitos

- [ ] Existe el worktree `../wt-feature` (aparece en `git worktree list`)
- [ ] La rama `feature` contiene `feature.txt`
- [ ] El último commit de `feature` es `feat: añade feature.txt`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `git worktree add ../wt-feature feature` crea el worktree en esa ruta con la rama `feature`.
- Recuerda `cd ../wt-feature` para operar dentro del worktree.
- `git worktree list` muestra todos los worktrees.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git worktree add -q ../wt-feature feature
cd ../wt-feature
echo "feature content" > feature.txt
git add feature.txt
git commit -q -m "feat: añade feature.txt"
```

</details>
