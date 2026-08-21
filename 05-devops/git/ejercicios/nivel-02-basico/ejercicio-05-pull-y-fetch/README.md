# Ejercicio 05 — Pull y fetch

- **Nivel:** 2/5
- **Tema:** Repositorios remotos
- **Tiempo estimado:** 25 minutos

## Enunciado

1. `setup.sh` crea un remoto `origin` (bare) y dos clones: `clon-a` (con un commit extra) y `clon-b` (sin ese commit).
2. Desde `clon-a`, sube el commit extra al remoto (ya hecho por el setup).
3. Desde `clon-b`, descarga los cambios del remoto e intégralos en tu rama `main` con `git pull`.
4. El test comprobará que `clon-b` ahora tiene el archivo `nuevo.txt`.

## Requisitos

- [ ] `clon-b` contiene el archivo `nuevo.txt`
- [ ] El historial de `clon-b` tiene 2 commits
- [ ] El último commit de `clon-b` es `feat: añade nuevo.txt`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El setup ya hizo el push desde clon-a. Solo debes hacer pull en clon-b.
- `git pull` = `git fetch` + `git merge`.
- Recuerda que el repositorio activo es clon-b (su ruta es `$1`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$CLON_B"
git pull -q origin main
```

</details>
