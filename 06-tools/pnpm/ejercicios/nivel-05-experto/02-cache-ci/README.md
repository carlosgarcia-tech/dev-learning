# 02 — Caché en GitHub Actions

## Enunciado

Configura la caché del store de pnpm en CI.

## Requisitos

1. Crea `solucion/ci.yml` (un workflow de GitHub Actions).
2. Usa `pnpm/action-setup` y `actions/setup-node` con `cache: 'pnpm'`.
3. Instala con `--frozen-lockfile`.

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
name: CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v3
        with:
          version: 9
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm test
```

</details>
