# 04 — pnpm -r (recursivo)

## Enunciado

Ejecuta un script en todos los paquetes del workspace.

## Requisitos

1. Añade un script `test` a ambos paquetes (core y ui).
2. Ejecuta `pnpm -r run test`.
3. Explica en `respuesta.txt` qué hace `-r`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
pnpm -r run test
```

`respuesta.txt`:
```
-r ejecuta el comando recursivamente en todos los paquetes del workspace, respetando el orden de dependencias (topológico).
```

</details>
