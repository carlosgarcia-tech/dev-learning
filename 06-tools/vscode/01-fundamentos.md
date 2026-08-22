# Fundamentos de VS Code

> La interfaz de VS Code, la paleta de comandos, atajos esenciales y configuración con `settings.json`.

## ¿Qué es VS Code?

**Visual Studio Code** (VS Code) es un editor de código fuente gratuito, open source y multiplataforma, desarrollado por Microsoft. Está construido sobre Electron y ofrece:

- Soporte para decenas de lenguajes.
- Integración con Git.
- Debugging integrado.
- Terminal integrada.
- Un ecosistema enorme de extensiones.
- IntelliSense (autocompletado inteligente).

## La interfaz

```
┌─────────────────────────────────────────────────────────┐
│ Barra de título                                    [─][□][×]│
├──────┬──────────────────────┬──────────────────────────┤
│      │ EXPLORER             │                          │
│ Barra│  > ARCHIVOS          │                          │
│ de   │  - carpeta/          │      EDITOR              │
│ acti-│    - file.js         │   (archivos abiertos)    │
│ vida-│                      │                          │
│ des  │                      │                          │
│      ├──────────────────────┤                          │
│      │ OUTLINE / TIMELINE   │                          │
│      │                      │                          │
├──────┴──────────────────────┴──────────────────────────┤
│ PANEL (Terminal, Problemas, Salida, Debug)              │
├─────────────────────────────────────────────────────────┤
│ Barra de estado (rama git, errores, lenguaje, encoding) │
└─────────────────────────────────────────────────────────┘
```

### Componentes

| Zona | Función |
|------|---------|
| **Barra de actividades** (izquierda) | Cambiar entre vistas: Explorer, Search, Git, Debug, Extensions |
| **Barra lateral** | Muestra la vista activa (archivos, búsqueda, etc.) |
| **Editor** | Donde editas el código; puede dividirse |
| **Panel** (abajo) | Terminal integrada, problemas, salida, debug console |
| **Barra de estado** (abajo) | Info rápida: rama git, errores/warnings, lenguaje, línea/columna, encoding |
| **Paleta de comandos** | Centro de control de VS Code |

## Command Palette

La **paleta de comandos** es la forma más rápida de hacer cualquier cosa en VS Code.

- Abrir: `Ctrl+Shift+P` (Windows/Linux) o `Cmd+Shift+P` (macOS).
- Si escribes `>`, buscas **comandos**.
- Si escribes sin `>`, buscas **archivos** (`Ctrl+P`).

```
> Format Document        (comando)
> Preferences: Open Settings (JSON)
app.js                   (archivo)
```

### Atajos relacionados

| Atajo | Acción |
|-------|--------|
| `Ctrl+Shift+P` | Paleta de comandos |
| `Ctrl+P` | Quick Open (archivos) |
| `Ctrl+Shift+O` | Ir a símbolo en el archivo |
| `Ctrl+T` | Ir a símbolo en el workspace |
| `Ctrl+G` | Ir a línea |

## Atajos esenciales

### Generales

| Atajo | Acción |
|-------|--------|
| `Ctrl+Shift+P` | Paleta de comandos |
| `Ctrl+P` | Abrir archivo rápido |
| `Ctrl+,` | Abrir settings |
| `Ctrl+K Ctrl+S` | Ver atajos de teclado |
| `Ctrl+Shift+N` | Nueva ventana |
| `Ctrl+W` | Cerrar pestaña |

### Edición

| Atajo | Acción |
|-------|--------|
| `Ctrl+C` (sin selección) | Copiar línea |
| `Ctrl+X` (sin selección) | Cortar línea |
| `Ctrl+V` | Pegar |
| `Ctrl+Z` / `Ctrl+Y` | Deshacer / Rehacer |
| `Ctrl+D` | Seleccionar siguiente ocurrencia |
| `Ctrl+Shift+L` | Seleccionar todas las ocurrencias |
| `Ctrl+/` | Comentar/descomentar |
| `Alt+↑` / `Alt+↓` | Mover línea arriba/abajo |
| `Shift+Alt+↓` | Duplicar línea abajo |
| `Ctrl+Shift+K` | Borrar línea |
| `Ctrl+]` / `Ctrl+[` | Indentar / desindentar |

### Navegación

| Atajo | Acción |
|-------|--------|
| `Ctrl+P` | Quick open |
| `Ctrl+Shift+O` | Símbolos del archivo |
| `Ctrl+Tab` | Cambiar entre pestañas |
| `Ctrl+G` | Ir a línea |
| `F12` | Ir a definición |
| `Alt+F12` | Peek definition (vista previa) |
| `Ctrl+Click` | Ir a definición |
| `Shift+F12` | Ver todas las referencias |
| `Ctrl+Shift+\` | Ir al bracket contrario |

### Ventana y paneles

| Atajo | Acción |
|-------|--------|
| `Ctrl+B` | Mostrar/ocultar barra lateral |
| `Ctrl+J` | Mostrar/ocultar panel inferior |
| `Ctrl+\` | Dividir editor |
| `Ctrl+1/2/3` | Cambiar el foco entre grupos de editores |
| `Ctrl+W` | Cerrar editor |

> En macOS sustituye `Ctrl` por `Cmd` en la mayoría de los atajos.

## settings.json

Toda la configuración de VS Code se guarda en `settings.json`. Puedes editarlo en JSON directamente o desde la UI (`Ctrl+,`).

### Abrirlo

```bash
# Desde la paleta de comandos:
> Preferences: Open User Settings (JSON)

# O desde la UI:
> Preferences: Open Settings (UI)
```

### Ubicaciones

| Ámbito | Archivo |
|--------|---------|
| Usuario | `~/.config/Code/User/settings.json` (Linux) |
| Usuario | `~/Library/Application Support/Code/User/settings.json` (macOS) |
| Workspace | `.vscode/settings.json` (en el proyecto) |

### Ejemplo de settings.json

```json
{
  "editor.fontSize": 14,
  "editor.tabSize": 2,
  "editor.formatOnSave": true,
  "editor.minimap.enabled": false,
  "editor.wordWrap": "on",
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "terminal.integrated.fontSize": 13,
  "workbench.colorTheme": "Default Dark+",
  "workbench.iconTheme": "material-icon-theme",
  "editor.fontFamily": "'Fira Code', 'Cascadia Code', monospace",
  "editor.fontLigatures": true,
  "editor.bracketPairColorization.enabled": true,
  "git.autofetch": true,
  "git.confirmSync": false,
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[python]": {
    "editor.defaultFormatter": "ms-python.python"
  },
  "python.defaultInterpreterPath": "./venv/bin/python",
  "eslint.format.enable": true,
  "eslint.workingDirectories": ["./"]
}
```

### Configuración por lenguaje

Puedes tener configuración específica por lenguaje usando el nombre entre corchetes:

```json
{
  "[python]": {
    "editor.tabSize": 4,
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "ms-python.black-formatter"
  },
  "[rust]": {
    "editor.defaultFormatter": "rust-lang.rust-analyzer"
  }
}
```

## Workspace settings

Los **workspace settings** viven en `.vscode/settings.json` dentro del proyecto y **sobrescriben** los del usuario. Son ideales para configuración específica del proyecto que se commitea al repo.

```
mi-proyecto/
└── .vscode/
    ├── settings.json      <- configuración del proyecto
    ├── launch.json         <- debugging
    ├── tasks.json          <- tareas
    └── extensions.json     <- extensiones recomendadas
```

### Ejemplo de workspace settings

```json
// .vscode/settings.json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "typescript.tsdk": "node_modules/typescript/lib",
  "python.venvPath": ".",
  "files.exclude": {
    "**/node_modules": true,
    "**/.git": true,
    "**/dist": true
  }
}
```

### extensions.json: recomendaciones

```json
// .vscode/extensions.json
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "ms-python.python",
    "ms-azuretools.vscode-docker"
  ]
}
```

Al abrir el proyecto, VS Code sugiere instalar las extensiones que faltan.

## IntelliSense

VS Code ofrece **IntelliSense**: autocompletado inteligente basado en tipos y análisis del código.

- **Suggestions:** lista de completado mientras escribes.
- **Parameter hints:** firma de la función al escribir argumentos.
- **Quick info:** tooltip al hover sobre un símbolo.

Para lenguajes con tipos (TypeScript, Python con type hints), es muy potente. Para JavaScript plano, se apoya en análisis de flujo y JSDoc.

```js
/**
 * Suma dos números.
 * @param {number} a
 * @param {number} b
 * @returns {number}
 */
function sumar(a, b) {
  return a + b;
}
```

## Temas y apariencia

```bash
> Preferences: Color Theme       # elegir tema
> Preferences: File Icon Theme   # iconos de archivos
```

```json
{
  "workbench.colorTheme": "Default Dark+",
  "workbench.iconTheme": "material-icon-theme",
  "workbench.productIconTheme": "material-product-icons"
}
```

## Buenas prácticas

1. **Usa la paleta de comandos** para todo lo que no recuerdes el atajo.
2. **Comitea `.vscode/`** con la configuración compartida del equipo.
3. **Aprende 5-10 atajos nuevos** cada semana; multiplican tu velocidad.
4. **Activa format on save** para mantener el código consistente.
5. **Usa snippets** para plantillas repetitivas.

---

> Siguiente: [Extensiones y snippets](02-extensions-y-snippets.md)
