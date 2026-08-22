# 01 — pnpm exec

## Enunciado

Usa `pnpm exec` para ejecutar un binario local.

## Requisitos

1. En `solucion/`, instala `eslint` como devDependency.
2. Ejecuta `pnpm exec eslint --version` y guarda la salida en `version.txt`.

## Pistas

- `pnpm exec` ejecuta binarios de `node_modules/.bin/`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
pnpm add -D eslint
pnpm exec eslint --version > version.txt
```

</details>
