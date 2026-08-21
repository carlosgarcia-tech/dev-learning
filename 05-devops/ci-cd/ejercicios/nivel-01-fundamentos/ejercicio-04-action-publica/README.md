# Ejercicio 04 — Usar una action pública

- **Nivel:** 1/5
- **Tema:** actions del Marketplace, `setup-node`, `with`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un workflow en `.github/workflows/action.yml` que:

1. Se dispare en `push`.
2. Tenga un job `node` en `ubuntu-latest`.
3. Use `actions/checkout@v4`.
4. Use `actions/setup-node@v4` con `node-version: 20`.
5. Ejecute `node --version` para imprimir la versión de Node.

## Requisitos

- [ ] El archivo existe en `.github/workflows/action.yml`.
- [ ] Usa `actions/checkout@v4`.
- [ ] Usa `actions/setup-node@v4` con `node-version: 20`.
- [ ] Ejecuta `node --version`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `actions/setup-node@v4` instala Node en el runner. Se configura con `with: node-version: 20`.
- Para pasar parámetros a una action se usa `with:`, no `run:`.
- Las actions se anclan a `@vN` (versión mayor) para estabilidad.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/action.yml
name: Action Publica
on: push
jobs:
  node:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: node --version
```

</details>
