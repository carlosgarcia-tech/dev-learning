# 03 — Workspace settings

## Enunciado

Crea configuración específica de proyecto.

## Requisitos

1. Crea `solucion/.vscode/settings.json` con `editor.defaultFormatter` y `files.exclude`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "files.exclude": {
    "**/node_modules": true,
    "**/.git": true
  }
}
```

</details>
