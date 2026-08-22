# 02 — tasks.json

## Enunciado

Crea una tarea de build.

## Requisitos

1. Crea `solucion/.vscode/tasks.json` con una tarea `build` que ejecute `pnpm run build`.
2. Debe ser la tarea por defecto de build.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "build",
      "type": "shell",
      "command": "pnpm run build",
      "group": { "kind": "build", "isDefault": true }
    }
  ]
}
```

</details>
