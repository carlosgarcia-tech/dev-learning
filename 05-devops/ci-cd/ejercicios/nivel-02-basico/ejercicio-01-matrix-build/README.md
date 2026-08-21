# Ejercicio 07 — Matrix build

- **Nivel:** 2/5
- **Tema:** `strategy.matrix`, ejecución en paralelo, `matrix.node`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un workflow en `.github/workflows/matrix.yml` que:

1. Se dispare en `push`.
2. Tenga un job `test` en `ubuntu-latest`.
3. Use una `strategy.matrix` con dos versiones de Node: `18` y `20`.
4. En cada combinación, use `actions/setup-node@v4` con `node-version: ${{ matrix.node }}`.
5. Ejecute `node --version` para imprimir la versión activa.

> La matrix genera un job por cada combinación. Aquí serán 2 jobs en paralelo.

## Requisitos

- [ ] El archivo existe en `.github/workflows/matrix.yml`.
- [ ] El job `test` tiene `strategy.matrix` con `node: [18, 20]`.
- [ ] `setup-node` usa `${{ matrix.node }}` como `node-version`.
- [ ] Ejecuta `node --version`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La matrix se declara bajo `strategy:` → `matrix:` → clave con lista de valores.
- Cada combinación genera un job cuyo nombre incluye los valores de la matrix.
- Dentro de un step, `${{ matrix.node }}` referencia el valor actual.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/matrix.yml
name: Matrix
on: push
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: [18, 20]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
      - run: node --version
```

</details>
