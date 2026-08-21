# Ejercicio 09 — Job condicional (if)

- **Nivel:** 2/5
- **Tema:** `if`, `github.ref`, expresiones condicionales
- **Tiempo estimado:** 20 min

## Enunciado

Crea un workflow en `.github/workflows/condicional.yml` que:

1. Se dispare en `push`.
2. Tenga un job `build` que siempre se ejecuta y hace `echo "Build"`.
3. Tenga un job `deploy` que **solo se ejecuta si el push es a `main`**, usando `if: github.ref == 'refs/heads/main'`.
4. El job `deploy` depende de `build` con `needs: build`.
5. `deploy` ejecuta `echo "Desplegando a producción"`.

## Requisitos

- [ ] El archivo existe en `.github/workflows/condicional.yml`.
- [ ] El job `deploy` tiene `if: github.ref == 'refs/heads/main'`.
- [ ] El job `deploy` tiene `needs: build`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `github.ref` incluye el prefijo completo: `refs/heads/main`, no solo `main`.
- La condición `if` se evalúa como expresión de GitHub Actions. No necesita `${{ }}` si es la única cosa en la línea.
- `needs: build` hace que `deploy` espere a `build`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/condicional.yml
name: Condicional
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Build"
  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Desplegando a producción"
```

</details>
