# Ejercicio 05 — Reset y revert

- **Nivel:** 3/5
- **Tema:** Deshacer cambios
- **Tiempo estimado:** 25 minutos

## Enunciado

1. El repo está en `main` con 3 commits: inicial, `feat: añade a.txt` y `feat: añade b.txt`.
2. **Parte A (reset):** Usa `git reset` para deshacer el último commit (`b.txt`) dejando los cambios en el working tree (modo soft). No crees commits.
3. **Parte B (revert):** Luego, desde ese estado, crea un commit `revert` que deshaga el commit `feat: añade a.txt` sin reescribir el historial.

El estado final esperado:
- El historial tiene el commit inicial, el de `a.txt` revertido con un nuevo commit `revert: deshace a.txt`, y los cambios de `b.txt` siguen en el working tree sin commitear.

## Requisitos

- [ ] El último commit del historial es `revert: deshace a.txt`
- [ ] `a.txt` ya no está tracked en el último commit (fue revertido)
- [ ] `b.txt` existe en el working tree pero no está commiteado (cambios sin commitear)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `git reset --soft HEAD~1` deshace el último commit dejando los cambios staged.
- Luego puedes `git restore --staged .` para unstaged los cambios de b.txt (opcional).
- Para revertir el commit de a.txt: busca su hash con `git log` y haz `git revert --no-commit <hash>` seguido de `git commit -m "revert: deshace a.txt"`.
- `git revert` crea un commit nuevo; `git reset` reescribe.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
# Parte A: deshacer el commit de b.txt dejando cambios en working tree
git reset --soft HEAD~1
git restore --staged b.txt
# Parte B: revertir el commit de a.txt sin reescribir historial
HASH_A=$(git log --oneline -- a.txt | head -1 | awk '{print $1}')
git revert --no-commit "$HASH_A"
git commit -q -m "revert: deshace a.txt"
```

</details>
