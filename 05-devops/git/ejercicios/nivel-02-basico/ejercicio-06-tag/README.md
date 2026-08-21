# Ejercicio 06 — Tag

- **Nivel:** 2/5
- **Tema:** Tags
- **Tiempo estimado:** 20 minutos

## Enunciado

1. El repo está en `main` con 2 commits.
2. Crea un **tag anotado** llamado `v1.0.0` sobre el commit actual con el mensaje `Release 1.0.0`.
3. Crea un **tag ligero** llamado `v1.0.1` también sobre el commit actual.

## Requisitos

- [ ] Existe el tag anotado `v1.0.0` con el mensaje `Release 1.0.0`
- [ ] Existe el tag ligero `v1.0.1`
- [ ] `v1.0.0` es de tipo anotado (es un objeto tag, no solo un puntero)
- [ ] `v1.0.1` es de tipo ligero (apunta directamente a un commit)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Tag anotado: `git tag -a v1.0.0 -m "Release 1.0.0"`.
- Tag ligero: `git tag v1.0.1` (sin `-a` ni `-m`).
- Para distinguirlos: `git cat-file -t v1.0.0` devuelve `tag` (anotado) mientras que `v1.0.1` devuelve `commit` (ligero).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git tag -a v1.0.0 -m "Release 1.0.0"
git tag v1.0.1
```

</details>
