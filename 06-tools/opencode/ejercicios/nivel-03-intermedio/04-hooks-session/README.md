# 04 — Hooks onSessionStart

## Enunciado

Configura un hook que se ejecute al iniciar sesión.

## Requisitos

1. En `solucion/opencode.json`, configura un hook `onSessionStart` que ejecute `git status --short`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "hooks": {
    "onSessionStart": ["git status --short"]
  }
}
```

</details>
