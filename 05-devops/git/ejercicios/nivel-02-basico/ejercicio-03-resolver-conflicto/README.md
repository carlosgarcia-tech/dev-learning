# Ejercicio 03 — Resolver conflicto

- **Nivel:** 2/5
- **Tema:** Conflictos de merge
- **Tiempo estimado:** 25 minutos

## Enunciado

1. El repo tiene `main` y `feature` que **modifican la misma línea** de `README.md`, por lo que al fusionar habrá un conflicto.
2. Fusiona `feature` en `main`.
3. Resuelve el conflicto dejando la versión de `feature` (la línea `Línea feature`).
4. Completa el merge commit con el mensaje `merge: integra feature`.

## Requisitos

- [ ] El merge se completó (no hay conflicto pendiente)
- [ ] `README.md` contiene la línea `Línea feature` (no la de main ni los marcadores `<<<<<<<`)
- [ ] Existe un commit de merge con el mensaje `merge: integra feature`
- [ ] El último commit tiene 2 padres (es un merge commit)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Al hacer `git merge feature`, Git marcará el conflicto en `README.md`.
- Edita `README.md` para dejar solo la línea correcta (`Línea feature`) y quita los `<<<<<<<`, `=======`, `>>>>>>>`.
- `git add README.md` marca el conflicto como resuelto.
- `git commit` (sin `-m`, Git ya prellena el mensaje de merge) o `git commit -m "merge: integra feature"`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git switch main
git merge feature || true
# Resolver conflicto dejando la versión de feature
printf "Línea feature\n" > README.md
git add README.md
git commit -q -m "merge: integra feature"
```

</details>
