# 03 — --filter

## Enunciado

Usa `--filter` para ejecutar un comando en un paquete concreto.

## Requisitos

1. Añade un script `build` a `packages/core/package.json`.
2. Ejecuta `pnpm build --filter @miorg/core`.
3. Guarda la salida en `solucion/build-output.txt`.

## Pistas

- `--filter` selecciona paquetes por nombre o ruta.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
pnpm build --filter @miorg/core > solucion/build-output.txt 2>&1 || true
```

</details>
