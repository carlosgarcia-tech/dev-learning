# 04 — pnpm config

## Enunciado

Usa `pnpm config` para ver y modificar la configuración.

## Requisitos

1. Ejecuta `pnpm config get registry` y guarda la salida en `solucion/registry.txt`.
2. Explica en `respuesta.txt` la diferencia entre `--location=project` y `--location=user`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
pnpm config get registry > solucion/registry.txt
```

`respuesta.txt`:
```
--location=project guarda en .npmrc del proyecto (se commitea).
--location=user guarda en ~/.npmrc (personal, no se commitea).
```

</details>
