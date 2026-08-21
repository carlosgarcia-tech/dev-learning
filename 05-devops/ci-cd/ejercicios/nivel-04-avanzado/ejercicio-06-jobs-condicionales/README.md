# Ejercicio 06 — Jobs condicionales avanzados
- **Nivel:** 4/5
- **Tema:** Jobs condicionales avanzados con `if` y expresiones de contexto
- **Tiempo estimado:** 45 min

## Enunciado

En un pipeline real necesitas ejecutar distintos jobs según el **contexto**: la rama, el tipo de evento, el mensaje del commit, si es un tag… Diseña un workflow en `.github/workflows/condicionales.yml` que tenga **al menos 3 jobs** con condiciones `if` distintas, cubriendo:

1. Un job `deploy-prod` que solo corra en `main` (usa `github.ref`).
2. Un job `deploy-staging` que solo corra en `develop` (usa `github.ref` o `github.head_ref`).
3. Un job `notificar` que se omita si el mensaje del commit contiene `[skip-ci]` (usa `contains(github.event.head_commit.message, ...)`).
4. Un job `publicar-tag` que solo corra cuando se suba un tag `v*` (usa `startsWith(github.ref, ...)`).

> Usa expresiones variadas: `github.ref`, `github.event_name`, `contains`, `startsWith`.

## Requisitos
- [ ] El workflow tiene al menos 2 jobs con campo `if` (recomendado 4).
- [ ] Las condiciones usan `github.*`, `contains` o `startsWith`.
- [ ] Al menos una condición usa `contains` o `startsWith`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas
<details><summary>Mostrar pistas</summary>

- `github.ref` para una rama incluye el prefijo: `refs/heads/main`. Compáralo completo o usa `endsWith`/`contains`.
- `github.event_name` puede ser `push`, `pull_request`, `workflow_dispatch`, `release`, etc.
- `contains(github.event.head_commit.message, '[skip-ci]')` devuelve `true` si el mensaje incluye ese texto. Négalo con `!`.
- `startsWith(github.ref, 'refs/tags/v')` detecta tags de versión.
- Puedes combinar varias condiciones con `&&` y `||`, y usar `|` para un `if` multilínea.

</details>

## Solución
<details><summary>Mostrar solución</summary>

```yaml
name: Jobs condicionales avanzados
on:
  push:
    branches: [main, develop]
    tags: ["v*"]

jobs:
  deploy-prod:
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Desplegando a producción (main)"

  deploy-staging:
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Desplegando a staging (develop)"

  notificar:
    if: ${{ !contains(github.event.head_commit.message, '[skip-ci]') }}
    runs-on: ubuntu-latest
    steps:
      - run: echo "Enviando notificación"

  publicar-tag:
    if: ${{ startsWith(github.ref, 'refs/tags/v') }}
    runs-on: ubuntu-latest
    steps:
      - run: echo "Publicando tag ${{ github.ref_name }}"
```

</details>
