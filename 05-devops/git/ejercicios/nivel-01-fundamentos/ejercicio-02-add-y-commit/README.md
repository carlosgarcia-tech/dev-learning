# Ejercicio 02 — Add y commit

- **Nivel:** 1/5
- **Tema:** Fundamentos de Git
- **Tiempo estimado:** 15 minutos

## Enunciado

1. El repositorio ya está inicializado y tiene un commit con `README.md`.
2. Crea un archivo `app.js` con el contenido indicado.
3. Añade `app.js` al staging area y créalo en un commit con mensaje `feat: añade app.js`.
4. Verifica que el historial tiene ahora 2 commits.

## Requisitos

- [ ] `app.js` existe con el contenido correcto
- [ ] `app.js` está commiteado
- [ ] El historial tiene exactamente 2 commits
- [ ] El mensaje del segundo commit es `feat: añade app.js`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `echo 'console.log("hola");' > app.js` crea el archivo con su contenido.
- `git add app.js` lo pasa al staging.
- `git commit -m "..."` crea el commit.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
echo 'console.log("hola");' > app.js
git add app.js
git commit -q -m "feat: añade app.js"
```

</details>
