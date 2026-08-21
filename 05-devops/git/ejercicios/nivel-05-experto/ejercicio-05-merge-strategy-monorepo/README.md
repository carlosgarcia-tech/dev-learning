# Ejercicio 05 — Merge strategy para monorepo

- **Nivel:** 5/5
- **Tema:** Merge strategies en monorepo
- **Tiempo estimado:** 40 minutos

## Enunciado

1. El repo es un monorepo con `apps/web/`, `apps/api/` y `packages/shared/`. Cada paquete tiene su propio archivo.
2. Existe una rama `feature/api-v2` que reescribe `apps/api/handler.js` y añade `apps/api/v2.js`.
3. Fusiona `feature/api-v2` en `main` usando la estrategia `-X ours` **no** para ignorar conflictos, sino usando merge normal pero asegurando que los cambios de `apps/web/` no se vean afectados.
4. Crea un `CODEOWNERS` que asigne `apps/web/` al equipo frontend y `apps/api/` al equipo backend.
5. Commitea el `CODEOWNERS`.

El objetivo es demostrar que un merge en monorepo solo afecta al paquete tocado por la rama, sin romper el resto.

## Requisitos

- [ ] `main` contiene `apps/api/v2.js` (traído por el merge)
- [ ] `apps/api/handler.js` en main tiene el contenido de la feature (v2)
- [ ] `apps/web/` sigue intacto en main (su archivo no fue modificado por el merge)
- [ ] Existe `.github/CODEOWNERS` commiteado con las asignaciones correctas
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Como la feature solo toca `apps/api/`, un `git merge` normal no afectará a `apps/web/`. No necesitas `-X ours`.
- `mkdir -p .github && echo "..." > .github/CODEOWNERS`.
- Formato CODEOWNERS: `<path> @equipo`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git switch main
git merge --no-ff feature/api-v2 -m "merge: integra api v2"

mkdir -p .github
cat > .github/CODEOWNERS <<'EOF'
/apps/web/   @equipo-frontend
/apps/api/   @equipo-backend
EOF
git add .github/CODEOWNERS
git commit -q -m "chore: añade CODEOWNERS"
```

</details>
