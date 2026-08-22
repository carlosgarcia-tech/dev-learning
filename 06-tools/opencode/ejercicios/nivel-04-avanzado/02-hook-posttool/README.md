# 02 — Hook postToolUse

## Enunciado

Configura un hook que formatee tras cada edición.

## Requisitos

1. En `solucion/opencode.json`, configura un hook `postToolUse` que ejecute `pnpm run lint --fix`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "hooks": {
    "postToolUse": ["pnpm run lint --fix"]
  }
}
```

</details>
