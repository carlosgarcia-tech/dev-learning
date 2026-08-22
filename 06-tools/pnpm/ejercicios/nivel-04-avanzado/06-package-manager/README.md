# 06 — packageManager

## Enunciado

Fija la versión de pnpm con `packageManager` para reproducibilidad.

## Requisitos

1. En `solucion/package.json`, añade `"packageManager": "pnpm@9.0.0"`.
2. Explica en `respuesta.txt` para qué sirve este campo.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{ "packageManager": "pnpm@9.0.0" }
```

`respuesta.txt`:
```
packageManager fija la versión exacta de pnpm que debe usar el proyecto. Con Corepack, cualquier persona que clone el repo usará esa versión automáticamente.
```

</details>
