# Fundamentos de opencode

> Qué es opencode, cómo instalarlo, configurarlo y usar su CLI.

## ¿Qué es opencode?

**opencode** es un agente de programación para la terminal, de código abierto, que se ejecuta en tu máquina local. A diferencia de los asistentes de chat web, opencode:

- **Vive en la terminal**: se lanza desde la línea de comandos y trabaja sobre tu proyecto real.
- **Lee y escribe archivos** de tu repositorio directamente.
- **Ejecuta comandos** (build, tests, git) y observa su resultado.
- **Mantiene el contexto** de la sesión: recuerda lo que se ha hecho en esa sesión.
- **Es extensible**: soporta MCP servers, hooks y configuración personalizada.

Es decir, opencode es un agente que opera en tu entorno de desarrollo, no un chat genérico.

## Conceptos clave

| Concepto | Significado |
|----------|-------------|
| **Sesión** | Una conversación con contexto y memoria |
| **Prompt** | La instrucción que le das al agente |
| **Contexto** | Archivos, comandos y datos que el agente puede usar |
| **MCP server** | Servidor que expone herramientas adicionales al agente |
| **Hook** | Script que se ejecuta en ciertos eventos |
| **Permiso** | Autorización para una acción sensible (escribir, ejecutar) |

## Instalación

### Requisitos

- Una terminal (bash, zsh, PowerShell).
- Conexión a internet para descargar e interactuar con el modelo.
- Acceso a un proveedor de modelo (clave API o autenticación).

### Métodos de instalación

```bash
# Script oficial
curl -fsSL https://opencode.ai/install | bash

# Con npm
npm install -g opencode-ai

# Con pnpm
pnpm add -g opencode-ai

# Con Homebrew (macOS)
brew install opencode-ai

# Binario directo desde releases de GitHub
```

Verifica la instalación:

```bash
opencode --version
```

## Comandos del CLI

### Lanzar el modo interactivo

```bash
opencode          # abre la interfaz TUI en el directorio actual
```

La interfaz TUI (Terminal User Interface) es donde escribes prompts, ves respuestas y apruebas acciones.

### Ejecutar sin TUI (headless)

Para integrar opencode en scripts o CI, se puede ejecutar sin interfaz:

```bash
opencode run "Crea un test para src/auth.js"
opencode run --prompt "Refactoriza la función X" --auto
```

### Subcomandos comunes

```bash
opencode --version              # versión
opencode --help                 # ayuda
opencode auth login             # autenticarse con el proveedor
opencode auth status            # ver sesión activa
opencode auth logout            # cerrar sesión
opencode config get <key>       # ver una configuración
opencode config set <key> <v>   # modificar configuración
opencode mcp list               # listar MCP servers
opencode session list           # listar sesiones
opencode session show <id>      # ver una sesión pasada
```

## Configuración inicial

opencode busca configuración en varios sitios, de menor a mayor prioridad:

1. Defaults internos.
2. `~/.config/opencode/config.json` (config global del usuario).
3. `opencode.json` en la raíz del proyecto.
4. Variables de entorno.

### Autenticación

Antes de usarlo, hay que autenticarse con el proveedor del modelo:

```bash
opencode auth login
# abre el flujo de autenticación (OAuth o API key)
```

Para entornos CI, suele usarse una variable de entorno:

```bash
export OPENCODE_API_KEY=sk-...
```

## Primer uso

```bash
cd mi-proyecto
opencode
```

Esto abre la TUI en el contexto de `mi-proyecto`. El agente puede leer archivos, ejecutar comandos y proponer cambios.

### Ejemplo de prompt

```
> Lee package.json y dime qué dependencias están desactualizadas.
> Añade un test para src/users.js usando la librería que ya usa el proyecto.
> Corrige el error de lint que aparece en src/api.js línea 42.
```

## Archivos que crea o usa opencode

| Archivo/Carpeta | Para qué |
|-----------------|----------|
| `opencode.json` | Configuración del proyecto |
| `.opencode/` | Carpeta local (sesiones, caché) |
| `~/.config/opencode/` | Configuración global del usuario |

Añade `.opencode/` al `.gitignore` si contiene datos de sesión sensibles.

## Modelos y proveedores

opencode soporta varios proveedores de modelos. La elección afecta a la calidad, velocidad y coste.

```json
// opencode.json
{
  "model": "anthropic/claude-sonnet-4",
  "smallModel": "anthropic/claude-haiku-3"
}
```

- `model`: el modelo principal usado para razonar y editar.
- `smallModel`: modelo más barato para tareas ligeras (resúmenes, títulos).

## Ámbito del proyecto

opencode trabaja **dentro del directorio** desde donde se lanza. No accede a archivos fuera de él salvo que se le autorice. Esto es una medida de seguridad.

```bash
cd /home/usuario/mi-proyecto
opencode    # el agente solo ve lo que hay en mi-proyecto
```

## Cómo se diferencia de un chat

| Aspecto | Chat web (ChatGPT, Claude) | opencode |
|---------|---------------------------|----------|
| Dónde | Navegador | Terminal sobre tu repo |
| Archivos | Copias/pegas manualmente | Lee/escribe directamente |
| Ejecución | No | Ejecuta comandos |
| Contexto | Lo que pegues | El proyecto entero |
| Reproducibilidad | Baja | Alta (sesión guardada) |
| Integración | Ninguna | Git, CI, MCP, hooks |

## Buenas prácticas iniciales

1. **Lanza opencode desde la raíz del proyecto** para que vea todo el contexto.
2. **Revisa siempre los cambios propuestos** antes de aceptar.
3. **Usa prompts concretos**: especifica archivos, funciones y comportamiento esperado.
4. **Aprovecha el contexto del repo**: pídele que lea antes de proponer.
5. **Configura permisos** según tu nivel de confianza (ver guía 03).

---

> Siguiente: [Flujo de trabajo](02-flujo-de-trabajo.md)
