# Configuración y personalización

> Configuración de opencode, MCP servers, permisos y modos de operación.

## Configuración

opencode se configura con archivos JSON. Hay varios niveles:

| Nivel | Archivo | Ámbito |
|-------|---------|--------|
| Global | `~/.config/opencode/config.json` | Todas las sesiones del usuario |
| Proyecto | `opencode.json` | Solo ese proyecto |
| Entorno | Variables de entorno | Override puntual |

La configuración del proyecto **sobrescribe** a la global.

### Estructura de opencode.json

```json
{
  "model": "anthropic/claude-sonnet-4",
  "smallModel": "anthropic/claude-haiku-3",
  "permissions": {
    "edit": "ask",
    "bash": "ask"
  },
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  },
  "hooks": {
    "onSessionStart": "echo 'Sesión iniciada'"
  }
}
```

### Cambios con el CLI

```bash
opencode config get model
opencode config set model anthropic/claude-sonnet-4
opencode config list
```

## Modelos

### Proveedores

opencode soporta múltiples proveedores. Cada uno requiere su autenticación:

| Proveedor | Ejemplo de modelo | Autenticación |
|-----------|-------------------|---------------|
| Anthropic | `anthropic/claude-sonnet-4` | API key u OAuth |
| OpenAI | `openai/gpt-4o` | API key |
| Google | `google/gemini-2.5-pro` | API key |
| OpenRouter | `openrouter/auto` | API key de OpenRouter |
| Local (Ollama) | `ollama/llama3` | Sin clave, modelo local |

### Elegir modelo

- **Tareas complejas (refactors, arquitectura):** modelo grande (Sonnet, Opus, GPT-4).
- **Tareas ligeras (resúmenes, títulos):** modelo pequeño/cheap (Haiku, mini).
- **Privacidad total:** modelo local con Ollama.

```json
{
  "model": "anthropic/claude-sonnet-4",
  "smallModel": "anthropic/claude-haiku-3"
}
```

### Cambiar modelo en caliente

Dentro de la sesión se puede cambiar de modelo sin reiniciar:

```
/model anthropic/claude-opus-4
```

## MCP servers

**MCP** (Model Context Protocol) es un protocolo que permite a opencode conectar con herramientas externas. Un MCP server expone **herramientas** (functions) y **recursos** (data) que el agente puede usar.

### Para qué sirve

| MCP server | Qué aporta |
|------------|------------|
| GitHub | Crear PRs, leer issues, gestionar repos |
| Filesystem | Acceso controlado a archivos fuera del proyecto |
| Postgres | Consultar y modificar una base de datos |
| Slack | Leer y enviar mensajes |
 Puppeteer | Controlar un navegador |
| Fetch | Obtener contenido de URLs |

### Configurar un MCP server

```json
// opencode.json
{
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "postgres": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-postgres"],
      "args": ["postgresql://localhost/mydb"]
    }
  }
}
```

### Tipos de MCP

| Tipo | Descripción |
|------|-------------|
| `local` | Se ejecuta como proceso local (stdio) |
| `remote` | Conecta a un servidor remoto por URL |

### Gestionar MCP servers

```bash
opencode mcp list              # listar configurados
opencode mcp add <name> -- <command>   # añadir
opencode mcp remove <name>     # eliminar
```

### Seguridad de los MCP

- Un MCP server puede exponer acceso a datos sensibles (BD, GitHub, etc.).
- Revisa qué permisos tiene cada server.
- Usa variables de entorno para tokens, nunca hardcodeados.
- Limita los servers a lo necesario.

## Permisos

opencode clasifica las acciones en categorías y pide autorización según el modo configurado.

### Categorías

| Categoría | Qué controla |
|-----------|--------------|
| `edit` | Escribir/modificar archivos del proyecto |
| `bash` | Ejecutar comandos shell |
| `webfetch` | Obtener contenido de URLs externas |
| `mcp` | Usar herramientas de MCP servers |
| `diff` | Aplicar diffs |

### Modos de permiso

| Modo | Comportamiento |
|------|----------------|
| `ask` | Pregunta al usuario antes de cada acción |
| `auto` | Acepta automáticamente acciones consideradas seguras |
| `yolo` | Acepta todo sin preguntar (peligroso) |
| `deny` | Deniega la categoría por completo |

### Configuración

```json
{
  "permissions": {
    "edit": "ask",
    "bash": "ask",
    "webfetch": "auto",
    "mcp": "ask"
  }
}
```

### Cambiar modo en la sesión

```
/permissions edit auto
/permissions bash yolo
```

### Cuándo usar cada modo

- **ask (recomendado):** para uso normal, revisas cada acción.
- **auto:** para tareas repetitivas donde confías en el agente.
- **yolo:** solo en entornos desechables (contenedores, sandboxes).
- **deny:** para bloquear categorías que no quieres que use nunca.

## Modos de operación

### Modo interactivo (TUI)

```bash
opencode
```

Abre la interfaz de terminal. Es el modo normal para desarrollo.

### Modo headless (no interactivo)

```bash
opencode run "Prompt aquí"
```

Ejecuta una tarea sin TUI. Útil para:

- Scripts de automatización.
- CI/CD.
- Tareas batch.

```bash
opencode run --prompt "Ejecuta los tests y arregla los que fallen" --auto
```

### Modo de una sola tarea

```bash
opencode run "Añade un README al proyecto" --yes
```

`--yes` aprueba automáticamente (equivalente a yolo).

## Hooks

Los **hooks** son scripts que se ejecutan en ciertos eventos del ciclo de vida de opencode.

### Eventos disponibles

| Hook | Cuándo se ejecuta |
|------|-------------------|
| `onSessionStart` | Al iniciar una sesión |
| `onSessionEnd` | Al cerrar una sesión |
| `preToolUse` | Antes de ejecutar una herramienta |
| `postToolUse` | Después de ejecutar una herramienta |
| `onPromptSubmit` | Al enviar un prompt |
| `onStop` | Cuando el agente termina de responder |

### Configurar hooks

```json
{
  "hooks": {
    "onSessionStart": [
      "echo 'Sesión iniciada en $(date)'",
      "git status --short"
    ],
    "postToolUse": [
      "pnpm run lint --fix"
    ]
  }
}
```

### Casos de uso

- **preToolUse:** formatear archivos antes de que el agente los lea.
- **postToolUse:** ejecutar lint o tests después de cada edición.
- **onSessionStart:** cargar variables de entorno o mostrar el estado del repo.
- **onStop:** notificar al usuario (sonido, notificación).

## Variables de entorno

| Variable | Para qué |
|----------|----------|
| `OPENCODE_API_KEY` | Clave API del proveedor |
| `GITHUB_TOKEN` | Token para MCP de GitHub |
| `OPENCODE_MODEL` | Override del modelo |
| `OPENCODE_CONFIG` | Ruta alternativa de configuración |

## Perfiles de configuración

Puedes tener varios archivos de configuración y elegir cuál usar:

```bash
opencode --config opencode.testing.json
```

Útil para separar configuración de desarrollo, testing, producción, etc.

## Buenas prácticas

1. **Comitea `opencode.json`** con la configuración del proyecto para que el equipo use la misma.
2. **Usa variables de entorno** para secretos: nunca hardcodees tokens en el JSON.
3. **Empieza en modo `ask`** y pasa a `auto` solo cuando confíes.
3. **Configura solo los MCP servers que necesites**: cada uno es una superficie de ataque.
4. **Usa hooks** para automatizar formato y lint tras cada edición.
5. **Elige el modelo adecuado** a cada tarea: no hace falta un modelo caro para tareas simples.

---

> Anterior: [Flujo de trabajo](02-flujo-de-trabajo.md) · Siguiente: [Automatización e integración](04-automatizacion-y-integracion.md)
