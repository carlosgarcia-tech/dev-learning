# Ejercicio 04 — .gitignore

- **Nivel:** 1/5
- **Tema:** Fundamentos de Git
- **Tiempo estimado:** 20 minutos

## Enunciado

1. El repo tiene 1 commit con `README.md`.
2. Crea un archivo `.gitignore` que ignore todos los archivos `.log` y el directorio `node_modules/`.
3. Crea un archivo `debug.log` y un directorio `node_modules/` con un archivo dentro.
4. Commitea el `.gitignore` con el mensaje `chore: añade .gitignore`.
5. El test comprobará que `debug.log` y `node_modules/` **no** aparecen como untracked en `git status`.

## Requisitos

- [ ] Existe `.gitignore` con las reglas `*.log` y `node_modules/`
- [ ] `.gitignore` está commiteado con el mensaje `chore: añade .gitignore`
- [ ] `debug.log` existe en disco pero Git lo ignora (no aparece como untracked)
- [ ] `node_modules/` existe en disco pero Git lo ignora
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El contenido de `.gitignore` puede ser:
  ```
  *.log
  node_modules/
  ```
- Recuerda crear físicamente `debug.log` y `node_modules/` (con un archivo dentro) para que el test pueda comprobar que se ignoran.
- `git status --porcelain --ignored` muestra los archivos ignorados.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
printf "*.log\nnode_modules/\n" > .gitignore
echo "debug" > debug.log
mkdir -p node_modules
echo "{}" > node_modules/paquete.json
git add .gitignore
git commit -q -m "chore: añade .gitignore"
```

</details>
