# 05 — Hook preToolUse

## Enunciado

Configura un hook que se ejecute antes de cada herramienta.

## Requisitos

1. En `solucion/opencode.json`, configura `preToolUse` que ejecute `pnpm run format`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "hooks": {
    "preToolUse": ["pnpm run format"]
  }
}
```

</details>
