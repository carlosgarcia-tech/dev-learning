# Ejercicio 01 — Monorepo con path filters
- **Nivel:** 4/5
- **Tema:** Monorepo, path filters y jobs condicionales por paquete
- **Tiempo estimado:** 45 min

## Enunciado

Tienes un **monorepo** con dos paquetes (`frontend` y `backend`) bajo `packages/`. El problema de tu CI actual: cada `push` ejecuta el pipeline completo aunque solo haya cambiado un paquete, desperdiciando runners y tiempo.

Diseña un workflow de GitHub Actions en `.github/workflows/monorepo.yml` que:

1. Se dispare en `push` a `main` **solo cuando cambien** archivos bajo `packages/**` o `.github/workflows/**`.
2. Detecte qué paquetes cambiaron usando **path filters** (bien `on.push.paths`, bien la action `dorny/paths-filter`).
3. Lance un job `test-frontend` **solo si** cambió `packages/frontend/**`, y un job `test-backend` **solo si** cambió `packages/backend/**`.

> Consejo: el job detector debe exponer `outputs` y los jobs de test deben consumirlos con `if` y `needs`.

## Requisitos
- [ ] El workflow se disporta con path filters (`on.push.paths` o `dorny/paths-filter`).
- [ ] Hay al menos un job con un campo `if` condicional que dependa de los cambios detectados.
- [ ] Los jobs de test dependen (`needs`) del job detector.
- [ ] Los tests pasan: `bash test.sh`

## Pistas
<details><summary>Mostrar pistas</summary>

- `on.push.paths` decide **si** se dispara el workflow, pero no te dice **qué paquete** cambió. Para distinguir paquetes necesitas `dorny/paths-filter` (o un `git diff` manual).
- `dorny/paths-filter` define filtros con nombre y devuelve `steps.<id>.outputs.<filtro>` con valor `'true'`/`'false'`.
- El job detector debe declarar `outputs:` y mapearlos a los del step. Los jobs consumidores usan `if: needs.detector.outputs.frontend == 'true'`.
- No olvides `needs: detector` en los jobs que lean sus outputs; sin `needs` no puedes acceder a `needs.detector.outputs.*`.

</details>

## Solución
<details><summary>Mostrar solución</summary>

```yaml
name: Monorepo por paquetes
on:
  push:
    branches: [main]
    paths:
      - "packages/**"
      - ".github/workflows/**"

jobs:
  detector:
    runs-on: ubuntu-latest
    outputs:
      frontend: ${{ steps.filtro.outputs.frontend }}
      backend: ${{ steps.filtro.outputs.backend }}
    steps:
      - uses: actions/checkout@v4
      - uses: dorny/paths-filter@v3
        id: filtro
        with:
          filters: |
            frontend:
              - 'packages/frontend/**'
            backend:
              - 'packages/backend/**'

  test-frontend:
    needs: detector
    if: needs.detector.outputs.frontend == 'true'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Test frontend (carpeta packages/frontend)"

  test-backend:
    needs: detector
    if: needs.detector.outputs.backend == 'true'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Test backend (carpeta packages/backend)"
```

</details>
