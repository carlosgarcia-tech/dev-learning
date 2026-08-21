# Ejercicio 13 — Build + test + lint

- **Nivel:** 3/5
- **Tema:** pipeline completo con stages, jobs encadenados, checkout, cache
- **Tiempo estimado:** 25 min

## Enunciado

Crea un workflow en `.github/workflows/ci.yml` que implemente un pipeline de CI con **tres jobs**:

1. `lint`: hace checkout, instala Node 20 con cache npm, ejecuta `npm run lint`.
2. `test`: hace checkout, instala Node 20 con cache npm, ejecuta `npm test`. Depende de `lint` con `needs: lint`.
3. `build`: hace checkout, instala Node 20 con cache npm, ejecuta `npm run build`. Depende de `test` con `needs: test`.

> El flujo es lineal: lint → test → build. Si `lint` falla, `test` y `build` no se ejecutan.

## Requisitos

- [ ] El archivo existe en `.github/workflows/ci.yml`.
- [ ] Hay tres jobs: `lint`, `test`, `build`.
- [ ] `test` tiene `needs: lint`.
- [ ] `build` tiene `needs: test`.
- [ ] Cada job usa `actions/checkout@v4` y `actions/setup-node@v4` con `cache: npm`.
- [ ] Cada job ejecuta su comando correspondiente (`npm run lint`, `npm test`, `npm run build`).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Repite el patrón checkout + setup-node en cada job: en GitHub Actions cada job empieza limpio.
- `cache: npm` en `setup-node` cachea `~/.npm` automáticamente.
- El orden se controla con `needs`, no con la posición en el archivo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/ci.yml
name: CI
on: push
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm run lint
  test:
    needs: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm test
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm run build
```

</details>
