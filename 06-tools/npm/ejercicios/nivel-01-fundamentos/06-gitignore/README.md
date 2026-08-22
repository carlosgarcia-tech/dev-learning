# 06 — .gitignore para Node

## Enunciado

Configura correctamente el `.gitignore` de un proyecto Node.

## Requisitos

1. Crea `solucion/.gitignore` que ignore:
   - `node_modules/`
   - `npm-debug.log`
   - `.env`
   - `dist/`
2. Asegúrate de que `package.json` y `package-lock.json` **NO** estén ignorados.

## Pistas

- Cada patrón va en una línea.
- `node_modules/` ignora la carpeta completa.

## Solución

<details>
<summary>Mostrar solución</summary>

```gitignore
node_modules/
npm-debug.log
.env
dist/
```

</details>
