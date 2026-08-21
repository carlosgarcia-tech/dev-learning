# Ejercicio 05 — Reflog y recuperación

- **Nivel:** 4/5
- **Tema:** Reflog y recuperación
- **Tiempo estimado:** 25 minutos

## Enunciado

1. El repo está en `main` con 3 commits: inicial, `feat: segundo` y `feat: tercero`.
2. Borra los 2 últimos commits con `git reset --hard HEAD~2`.
3. Ahora **recupera** el commit `feat: tercero` usando el reflog: vuelve a dejar `main` apuntando a ese commit.
4. El test comprobará que `main` vuelve a tener 3 commits y el último es `feat: tercero`.

## Requisitos

- [ ] `main` tiene 3 commits al final
- [ ] El último commit de `main` es `feat: tercero`
- [ ] El archivo del commit `feat: tercero` (`c.txt`) está presente
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Tras el `reset --hard HEAD~2`, el commit `feat: tercero` "desapareció" de la rama, pero sigue en el reflog.
- `git reflog` o `git reflog show main` muestra los movimientos.
- Busca el hash del commit `feat: tercero` y haz `git reset --hard <hash>` para recuperarlo.
- También puedes usar `HEAD@{1}` (la posición anterior) si el reset fue el último movimiento.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
# Borrar los 2 últimos commits
git reset --hard HEAD~2
# Recuperar el commit feat: tercero desde el reflog
HASH=$(git reflog | grep -m1 "feat: tercero" | awk '{print $1}')
git reset --hard "$HASH"
```

</details>
