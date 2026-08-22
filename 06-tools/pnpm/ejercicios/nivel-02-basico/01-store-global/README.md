# 01 — El store global

## Enunciado

Localiza y entiende el store global de pnpm.

## Requisitos

1. Ejecuta `pnpm store path` y guarda la salida en `solucion/store-path.txt`.
2. Ejecuta `pnpm store status` y guarda la salida en `solucion/store-status.txt`.

## Pistas

- El store es donde pnpm guarda cada paquete una sola vez.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
pnpm store path > solucion/store-path.txt
pnpm store status > solucion/store-status.txt 2>&1
```

</details>
