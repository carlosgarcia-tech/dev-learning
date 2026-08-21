# Ejercicio 02 — Trigger on push

- **Nivel:** 1/5
- **Tema:** triggers, `on: push`, filtros de rama, `branches`
- **Tiempo estimado:** 15 min

## Enunciado

Crea un workflow en `.github/workflows/trigger.yml` que se dispare **solo** en push a las ramas `main` y `develop`.

1. Nombre del workflow: `Trigger Push`.
2. Trigger: `push` filtrado a las ramas `main` y `develop`.
3. Un job `verificar` que corre en `ubuntu-latest` y ejecuta `echo "Rama: ${{ github.ref }}"`.

## Requisitos

- [ ] El archivo existe en `.github/workflows/trigger.yml`.
- [ ] El trigger `push` filtra por `branches: [main, develop]`.
- [ ] Hay un job `verificar` con `runs-on: ubuntu-latest`.
- [ ] El step usa `github.ref` en el echo.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El filtro de ramas va bajo `on: push: branches: [...]`.
- `github.ref` contiene la referencia completa (p. ej. `refs/heads/main`).
- Las listas en YAML usan `- item` o `[item1, item2]`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/trigger.yml
name: Trigger Push
on:
  push:
    branches: [main, develop]
jobs:
  verificar:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Rama: ${{ github.ref }}"
```

</details>
