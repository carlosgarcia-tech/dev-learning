# Ejercicio 06 — Estado de archivos

- **Nivel:** 1/5
- **Tema:** Fundamentos de Git
- **Tiempo estimado:** 20 minutos

## Enunciado

El repo tiene 2 commits. El objetivo es dejar el repositorio en un estado determinado y que el test verifique ese estado con `git status`.

1. Modifica `README.md` (añade la línea `## Licencia`) pero **no** lo añadas al staging (que quede *modified/unstaged*).
2. Crea un archivo nuevo `notas.txt` con cualquier contenido y **no** lo añadas al staging (que quede *untracked*).
3. Modifica `app.js` y **sí** añádelo al staging (que quede *staged*), pero no lo commitees.

Al acabar el working tree debe tener:
- `README.md` → modificado, no staged
- `notas.txt` → untracked
- `app.js` → modificado y staged

## Requisitos

- [ ] `README.md` aparece como modificado sin stagin (` M README.md`)
- [ ] `notas.txt` aparece como untracked (`?? notas.txt`)
- [ ] `app.js` aparece como staged (`M  app.js`)
- [ ] No se crean commits nuevos (sigue habiendo 2 commits)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `echo "## Licencia" >> README.md` para modificarlo sin staginar.
- `echo "notas" > notas.txt` para crearlo sin staginar.
- Para `app.js`: modifícalo y luego `git add app.js` para que quede staged.
- `git status -s` (formato corto) muestra `XY archivo` donde X=staged, Y=working.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
echo "## Licencia" >> README.md        # modified, unstaged
echo "notas" > notas.txt               # untracked
echo "// nuevo" >> app.js              # modified
git add app.js                         # staged (sin commitear)
```

</details>
