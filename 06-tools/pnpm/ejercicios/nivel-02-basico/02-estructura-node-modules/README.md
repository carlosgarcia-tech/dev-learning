# 02 — Estructura node_modules

## Enunciado

Inspecciona la estructura de `node_modules` creada por pnpm.

## Requisitos

1. En `solucion/`, instala `express` con pnpm.
2. Verifica que existe `node_modules/.pnpm/`.
3. Guarda en `respuesta.txt` qué diferencia ves respecto al node_modules de npm.

## Pistas

- pnpm crea una carpeta `.pnpm/` con cada paquete versionado.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
pnpm add express
ls node_modules/.pnpm/ | head
```

`respuesta.txt`:
```
pnpm crea node_modules/.pnpm/ con cada paquete en su propia carpeta, y symlinks en la raíz de node_modules/. npm pone todo plano.
```

</details>
