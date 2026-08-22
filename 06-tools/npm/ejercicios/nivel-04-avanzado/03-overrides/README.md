# 03 — Overrides

## Enunciado

Usa `overrides` para forzar una versión segura de una dependencia transitiva.

## Requisitos

1. En `solucion/package.json`, añade `overrides` forzando `lodash` a `^4.17.21`.
2. Verifica que el override está correctamente declarado.

## Pistas

- `overrides` está al nivel raíz de `package.json`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "overrides": {
    "lodash": "^4.17.21"
  }
}
```

</details>
