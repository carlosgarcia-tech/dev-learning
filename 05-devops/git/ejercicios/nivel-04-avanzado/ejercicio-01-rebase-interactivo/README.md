# Ejercicio 01 — Rebase interactivo

- **Nivel:** 4/5
- **Tema:** Reescritura avanzada
- **Tiempo estimado:** 30 minutos

## Enunciado

1. El repo está en `feature` con 4 commits encima del inicial: `wip 1`, `wip 2`, `wip 3`, `wip 4`.
2. Usando **rebase interactivo**, reorganiza los commits para:
   - Reordenar de modo que queden `wip 4`, `wip 3`, `wip 2`, `wip 1` (orden inverso).
   - Cambiar el mensaje de `wip 1` (que ahora será el último) a `feat: commit final`.

Como el rebase interactivo requiere un editor, el test verificará el resultado final mediante los mensajes del historial en orden.

## Requisitos

- [ ] Hay 5 commits en total (el inicial + 4)
- [ ] El orden de los mensajes (del más reciente al más antiguo) es: `feat: commit final`, `wip 2`, `wip 3`, `wip 4`, `Commit inicial`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `GIT_SEQUENCE_EDITOR` permite automatizar el editor del rebase sin intervención.
- Puedes usar `git rebase -i HEAD~4` con un editor de secuencia que reordene las líneas.
- Alternativa más fiable: usar varios `git rebase --onto` o `git cherry-pick` para reconstruir el orden. El test solo verifica el resultado.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
# Reescribir el historial con orden inverso y renombrar el último mensaje.
# Recuperar los hashes de los 4 commits en orden (del más antiguo al más reciente).
HASHES=$(git log --reverse --format="%H" HEAD~4..HEAD)
# Crear una rama temporal y reconstruir
BASE=$(git rev-parse HEAD~4)
git reset --hard "$BASE"
for h in $HASHES; do :; done  # noop
# Aplicar en orden inverso
set -- $HASHES
git cherry-pick "$4" "$3" "$2" "$1"
# Reescribir el mensaje del último commit
git commit --amend -q -m "feat: commit final"
```

</details>
