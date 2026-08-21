# Ejercicio 04 — Stash

- **Nivel:** 3/5
- **Tema:** Stash
- **Tiempo estimado:** 20 minutos

## Enunciado

1. El repo está en `main` con 1 commit (`README.md`).
2. Modifica `README.md` añadiendo una línea `## TODO` (cambio sin commitear).
3. Guárdalo en el stash con `git stash`.
4. Verifica que el working tree queda limpio.
5. Recupera los cambios con `git stash pop`.
6. El test comprobará que existe un stash guardado en algún momento y que al final `README.md` contiene `## TODO`.

## Requisitos

- [ ] Durante el ejercicio se usó `git stash` (el test crea un registro de uso)
- [ ] Al final el working tree tiene cambios sin commitear (README.md modificado)
- [ ] `README.md` contiene la línea `## TODO`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `echo "## TODO" >> README.md` para crear el cambio.
- `git stash` lo guarda y limpia el working tree.
- `git stash list` debe mostrar al menos un stash (aunque sea brevemente).
- `git stash pop` lo recupera y lo borra de la pila.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
echo "## TODO" >> README.md
git stash
# (working tree limpio aquí)
git stash pop
```

</details>
