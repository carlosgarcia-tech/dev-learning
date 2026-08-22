# 06 — pnpm vs npm

## Enunciado

Compara los comandos equivalentes de pnpm y npm.

## Requisitos

1. Crea `solucion/respuesta.txt` con una tabla de equivalencias.
2. Incluye al menos: install, add, run, y ejecutar binario (npx vs dlx/exec).

## Pistas

- `npm install` → `pnpm install`
- `npx` → `pnpm dlx` o `pnpm exec`

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
npm install      -> pnpm install
npm install pkg -> pnpm add pkg
npm run dev     -> pnpm dev (o pnpm run dev)
npx comando      -> pnpm dlx comando (descargar) o pnpm exec comando (local)
npm ci           -> pnpm install --frozen-lockfile
npm uninstall    -> pnpm remove
```

</details>
