# Ejercicio 03 — Log y diff

- **Nivel:** 1/5
- **Tema:** Fundamentos de Git
- **Tiempo estimado:** 20 minutos

## Enunciado

1. El repo ya tiene 2 commits.
2. Modifica `README.md` añadiendo una línea `## Instalación` pero **no lo commitees** todavía.
3. El test comprobará que: el working tree tiene cambios sin commitear (dirty), el `git diff` muestra la línea añadida y el historial sigue teniendo 2 commits.

## Requisitos

- [ ] `README.md` contiene la línea `## Instalación`
- [ ] El cambio está **sin commitear** (working tree modificado)
- [ ] El historial sigue teniendo 2 commits
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Solo necesitas modificar el archivo y guardar; **no** hagas `git add` ni `git commit`.
- Puedes usar `echo "## Instalación" >> README.md` para añadir la línea.
- `git status` debe mostrar "Changes not staged for commit".

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
echo "## Instalación" >> README.md
```

</details>
