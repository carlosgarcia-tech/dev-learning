# Ejercicio 03 — Cherry-pick

- **Nivel:** 3/5
- **Tema:** Mover commits entre ramas
- **Tiempo estimado:** 25 minutos

## Enunciado

1. El repo tiene `main` y `feature`. En `feature` existe un commit que añade el archivo `hotfix.js` con el mensaje `fix: corrige bug crítico`.
2. Sin fusionar toda la rama, lleva **solo ese commit** a `main` usando `git cherry-pick`.
3. El test comprobará que `main` contiene `hotfix.js` y su último commit es el del fix.

## Requisitos

- [ ] `main` contiene el archivo `hotfix.js`
- [ ] El último commit de `main` tiene el mensaje `fix: corrige bug crítico`
- [ ] El cherry-pick no introdujo otros commits de `feature`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Identifica el hash del commit que añade `hotfix.js` en `feature`: `git log feature --oneline`.
- Cámbiate a `main` y ejecuta `git cherry-pick <hash>`.
- No uses `git merge feature` (eso traería toda la rama).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git switch main
# Buscar el commit que añade hotfix.js en feature
HASH=$(git log feature --oneline -- hotfix.js | head -1 | awk '{print $1}')
git cherry-pick "$HASH"
```

</details>
