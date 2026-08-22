# 02 — MCP server de GitHub

## Enunciado

Configura un MCP server de GitHub.

## Requisitos

1. En `solucion/opencode.json`, configura un MCP server `github` con el comando `npx -y @modelcontextprotocol/server-github`.
2. Usa `${GITHUB_TOKEN}` como variable de entorno.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_TOKEN": "${GITHUB_TOKEN}" }
    }
  }
}
```

</details>
