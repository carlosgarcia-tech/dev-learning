# 06 — Dev Container

## Enunciado

Crea un devcontainer para tu proyecto.

## Requisitos

1. Crea `solucion/.devcontainer/devcontainer.json` con una imagen de Node 20.
2. Incluye `postCreateCommand: pnpm install`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "name": "Mi Proyecto",
  "image": "mcr.microsoft.com/devcontainers/typescript-node:20",
  "postCreateCommand": "pnpm install",
  "customizations": {
    "vscode": {
      "extensions": ["dbaeumer.vscode-eslint"]
    }
  }
}
```

</details>
