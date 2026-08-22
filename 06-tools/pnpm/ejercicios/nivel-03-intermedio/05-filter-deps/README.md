# 05 — Filtros por dependencias

## Enunciado

Usa filtros que seleccionan paquetes por su grafo de dependencias.

## Requisitos

1. Explica en `respuesta.txt` la diferencia entre `--filter ...pkg` y `--filter pkg...`.
2. Da un ejemplo de cada uno.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
--filter ...pkg: selecciona pkg y sus DEPENDIENTES (quien depende de pkg).
--filter pkg...: selecciona pkg y sus DEPENDENCIAS (de lo que pkg depende).
Ej: pnpm build --filter ...@miorg/core (core y quienes lo usan)
Ej: pnpm build --filter @miorg/ui... (ui y lo que ui usa)
```

</details>
