# Ejercicio 02 — Squash commits

- **Nivel:** 3/5
- **Tema:** Reescritura de historial
- **Tiempo estimado:** 25 minutos

## Enunciado

1. El repo está en la rama `feature` con **3 commits WIP** sobre `README.md` además del commit inicial.
2. Agrupa (squash) esos 3 commits en uno solo con el mensaje `feat: completa documentación`.
3. El resultado: la rama `feature` debe tener exactamente 2 commits (el inicial + el consolidado).

## Requisitos

- [ ] La rama actual tiene exactamente 2 commits
- [ ] El último commit tiene el mensaje `feat: completa documentación`
- [ ] El archivo `README.md` contiene el contenido final acumulado
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Hay varias formas de hacer squash. La más simple sin editor: `git reset --soft HEAD~3` seguido de `git commit -m "..."`.
- `git reset --soft HEAD~3` mueve HEAD 3 commits atrás dejando todos los cambios en staging.
- Luego un único `git commit` agrupa todo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git reset --soft HEAD~3
git commit -q -m "feat: completa documentación"
```

</details>
