# 06 — Migrar de npm a pnpm

## Enunciado

Migra un proyecto de npm a pnpm.

## Requisitos

1. Explica en `respuesta.txt` los pasos para migrar.
2. Incluye qué archivos borrar y qué comandos ejecutar.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
Pasos para migrar de npm a pnpm:
1. Instalar pnpm: npm install -g pnpm
2. Borrar node_modules y package-lock.json: rm -rf node_modules package-lock.json
3. Instalar con pnpm: pnpm install
4. Comitear el nuevo pnpm-lock.yaml
5. Reemplazar npx por pnpm dlx/exec en scripts
6. Si hay dependencias fantasma, declararlas en package.json (pnpm las detectará)
```

</details>
