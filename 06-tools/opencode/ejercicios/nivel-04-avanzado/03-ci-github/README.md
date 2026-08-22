# 03 — CI con GitHub Actions

## Enunciado

Crea un workflow de CI con opencode.

## Requisitos

1. Crea `solucion/ci.yml` (GitHub Actions) que instale opencode y ejecute auto-fix de lint.

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
name: Auto-fix
on: [pull_request]
jobs:
  fix:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm install -g opencode-ai
      - run: opencode run "Ejecuta pnpm run lint --fix" --auto
        env:
          OPENCODE_API_KEY: ${{ secrets.OPENCODE_API_KEY }}
```

</details>
