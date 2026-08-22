# 06 — problemMatcher

## Enunciado

Configura un problemMatcher en una tarea.

## Requisitos

1. En `solucion/.vscode/tasks.json`, añade una tarea de build TypeScript con `problemMatcher: "$tsc"`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "build-ts",
      "type": "shell",
      "command": "tsc",
      "problemMatcher": ["$tsc"]
    }
  ]
}
```

</details>
