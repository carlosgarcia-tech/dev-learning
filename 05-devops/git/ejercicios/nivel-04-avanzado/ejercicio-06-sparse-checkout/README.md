# Ejercicio 06 — Sparse-checkout

- **Nivel:** 4/5
- **Tema:** Sparse-checkout
- **Tiempo estimado:** 25 minutos

## Enunciado

1. `setup.sh` crea un repositorio "origen" con la estructura `apps/web.txt`, `apps/api.txt` y `docs/leame.txt` (varios commits), e imprime su ruta.
2. Clona el origen en un directorio `clon` con `--no-checkout` (sin descargar archivos todavía).
3. Configura **sparse-checkout** en modo **cone** para que solo tengas `apps/web.txt` en el working dir.
4. Haz `git checkout main`.
5. El test comprobará que `apps/web.txt` existe en disco pero `apps/api.txt` y `docs/leame.txt` **no**.

## Requisitos

- [ ] Existe el directorio `clon/` con un repositorio git
- [ ] `clon/apps/web.txt` existe en disco
- [ ] `clon/apps/api.txt` NO existe en disco (excluido por sparse-checkout)
- [ ] `clon/docs/leame.txt` NO existe en disco
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `git clone --no-checkout "$ORIGIN" clon` descarga el repo sin sacar archivos.
- `cd clon && git sparse-checkout init --cone` activa modo cone.
- `git sparse-checkout set apps/web.txt` selecciona qué tener. En modo cone, los patrones son directorios; para un archivo concreto usa su path.
- `git checkout main` materializa el checkout respetando sparse-checkout.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
ORIGIN="$1"
cd "$(dirname "$ORIGIN")"
git clone -q --no-checkout "$ORIGIN" clon
cd clon
git sparse-checkout init --cone
git sparse-checkout set apps/web.txt
git checkout main
```

</details>
