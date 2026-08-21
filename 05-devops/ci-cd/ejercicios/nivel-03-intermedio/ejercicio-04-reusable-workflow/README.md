# Ejercicio 16 — Reusable workflow

- **Nivel:** 3/5
- **Tema:** `workflow_call`, `inputs`, reutilización entre workflows
- **Tiempo estimado:** 25 min

## Enunciado

Crea **dos archivos**:

1. `.github/workflows/build-reusable.yml` — un workflow **reutilizable** que:
   - Se activa con `on: workflow_call`.
   - Acepta un `input` llamado `node-version` (tipo `string`, requerido).
   - Tiene un job `build` en `ubuntu-latest` que hace checkout, instala Node con la versión del input, y ejecuta `npm ci && npm run build`.

2. `.github/workflows/caller.yml` — un workflow **caller** que:
   - Se dispara en `push`.
   - Llama al workflow reutilizable con `uses: ./.github/workflows/build-reusable.yml`.
   - Pasa el input `node-version: "20"`.

## Requisitos

- [ ] Existe `.github/workflows/build-reusable.yml` con `on: workflow_call`.
- [ ] El workflow reutilizable acepta el input `node-version`.
- [ ] El reutilizable usa `${{ inputs.node-version }}` en `setup-node`.
- [ ] Existe `.github/workflows/caller.yml` que llama al reutilizable con `uses:`.
- [ ] El caller pasa `node-version: "20"`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `workflow_call` convierte un workflow en reutilizable. Solo se ejecuta cuando otro workflow lo llama.
- Los `inputs` se declaran bajo `on: workflow_call: inputs:` y se leen con `${{ inputs.nombre }}`.
- El caller usa `uses:` a nivel de job, no `run:`. La ruta es relativa al repo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/build-reusable.yml
name: Build Reusable
on:
  workflow_call:
    inputs:
      node-version:
        required: true
        type: string

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ inputs.node-version }}
          cache: npm
      - run: npm ci
      - run: npm run build
```

```yaml
# .github/workflows/caller.yml
name: Caller
on: push
jobs:
  build:
    uses: ./.github/workflows/build-reusable.yml
    with:
      node-version: "20"
```

</details>
