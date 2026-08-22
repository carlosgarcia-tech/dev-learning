# Productividad y personalización

> Keybindings, multi-cursor, split editor, zen mode, profiles y remote development.

## Keybindings

VS Code es totalmente personalizable. Puedes reasignar cualquier atajo.

### Ver y editar atajos

```bash
> Preferences: Open Keyboard Shortcuts      # Ctrl+K Ctrl+S
```

Desde ahí buscas la acción y haces doble click para asignar nueva combinación.

### keybindings.json

Para atajos avanzados, edita el JSON:

```bash
> Preferences: Open Keyboard Shortcuts (JSON)
```

```json
[
  {
    "key": "ctrl+shift+a",
    "command": "editor.action.commentLine",
    "when": "editorTextFocus"
  },
  {
    "key": "ctrl+d",
    "command": "editor.action.addSelectionToNextFindMatch",
    "when": "editorFocus"
  },
  {
    "key": "f5",
    "command": "workbench.action.debug.start",
    "when": "!inDebugMode"
  },
  {
    "key": "ctrl+alt+l",
    "command": "editor.action.formatDocument"
  }
]
```

### Cláusula when

La condición `when` indica cuándo aplica el atajo:

| Condición | Significado |
|-----------|-------------|
| `editorTextFocus` | El foco está en el editor |
| `editorHasSelection` | Hay texto seleccionado |
| `inDebugMode` | Está en debug |
| `resourceLangId == 'python'` | Solo para archivos Python |

## Multi-cursor

El **multi-cursor** permite editar en varios sitios a la vez.

### Formas de crear múltiples cursores

| Atajo | Acción |
|-------|--------|
| `Alt+Click` | Añadir cursor donde clickes |
| `Ctrl+Alt+↑/↓` | Añadir cursor arriba/abajo |
| `Ctrl+D` | Seleccionar siguiente ocurrencia |
| `Ctrl+Shift+L` | Seleccionar todas las ocurrencias |
| `Shift+Alt+I` | Insertar cursor al final de cada línea seleccionada |
| `Ctrl+U` | Deshacer última selección |

### Ejemplo

Si tienes tres líneas similares:

```js
const user = await getUser();
const product = await getProduct();
const order = await getOrder();
```

Selecciona la primera `await`, pulsa `Ctrl+D` dos veces para seleccionar las otras, y ahora lo que escribas afecta a las tres a la vez.

### Selección en columna

`Shift+Alt` + arrastrar para seleccionar un bloque rectangular.

## Split editor

Puedes dividir el editor para ver varios archivos a la vez.

| Atajo | Acción |
|-------|--------|
| `Ctrl+\` | Dividir a la derecha |
| `Ctrl+K Ctrl+\` | Dividir en dirección |
| `Ctrl+1/2/3` | Mover el foco al grupo 1/2/3 |
| `Ctrl+W` | Cerrar grupo |
| Arrastrar pestaña | Moverla a otro grupo |

### Layouts

```bash
> View: Editor Layout: Two Columns
> View: Editor Layout: Two Rows
> View: Editor Layout: Grid (2x2)
```

### Mover archivos entre grupos

Arrastra la pestaña al grupo destino, o:

```bash
> View: Move Editor into Next Group
```

## Zen mode

El **zen mode** oculta todo (barra lateral, panel, barra de actividades) para concentrarte.

| Atajo | Acción |
|-------|--------|
| `Ctrl+K Z` | Activar/Desactivar Zen mode |
| `Esc Esc` | Salir de Zen mode |

```json
// settings.json
{
  "zenMode.fullScreen": true,
  "zenMode.hideTabs": false,
  "zenMode.centerLayout": true
}
```

## View modes

### Minimap

El minimapa a la derecha muestra una vista global del archivo.

```json
{
  "editor.minimap.enabled": true,
  "editor.minimap.renderCharacters": false
}
```

### Breadcrumbs

Muestra la ruta del archivo y jerarquía de símbolos arriba del editor.

```json
{
  "breadcrumbs.enabled": true
}
```

### Side bar / panel

- `Ctrl+B` toggle barra lateral.
- `Ctrl+J` toggle panel inferior.

## Profiles

Los **profiles** guardan configuración, atajos, snippets y extensiones como un conjunto. Útil para separar contextos (Python, frontend, escritura de docs, etc.).

### Crear un profile

```bash
> Profiles: Create Profile
# Elige: nombre, qué exportar (settings, keybindings, snippets, extensions)
# Base: vacío, copiar del actual, o un template
```

### Cambiar de profile

```bash
> Profiles: Switch Profile
```

O en la barra de actividades, click en el icono de perfil (avatar) abajo.

### Tipos de profiles

| Tipo | Ámbito |
|------|--------|
| Default | Configuración base |
| Workspace | Asociado a un proyecto |
| Template | Plantilla reutilizable |

### Exportar / importar

```bash
> Profiles: Export Profile     # genera un .code-profile
> Profiles: Import Profile     # importa un .code-profile
```

Útil para compartir configuración con compañeros o sincronizar entre máquinas.

## Settings Sync

**Settings Sync** sincroniza tu configuración, atajos, snippets, extensiones y UI state entre máquinas usando GitHub o Microsoft account.

```bash
> Settings Sync: Turn On...
# Elige GitHub o Microsoft
# Selecciona qué sincronizar
```

Al iniciar sesión en otra máquina:

```bash
> Settings Sync: Turn On...
# Inicia sesión y se descarga todo
```

### Qué sincroniza

- Settings (settings.json)
- Keybindings (keybindings.json)
- Snippets
- Extensions
- UI state (vistas abiertas, layout)
- Profiles

## Remote Development

VS Code puede editar código que **no está en tu máquina local**, sin cambiar el flujo de trabajo. Son las extensiones Remote:

| Extensión | Para qué |
|-----------|----------|
| Remote - SSH (`ms-vscode-remote.remote-ssh`) | Editar en un servidor por SSH |
| Dev Containers (`ms-vscode-remote.remote-containers`) | Abrir el proyecto en un contenedor Docker |
| WSL (`ms-vscode-remote.remote-wsl`) | Editar en el Subsistema Linux de Windows |
| Remote - Tunnels | Conexión mediante túneles seguros |
| Codespaces | Editar en un entorno en la nube de GitHub |

### Remote - SSH

1. Instala la extensión.
2. `Ctrl+Shift+P` > `Remote-SSH: Connect to Host...`.
3. Introduce `usuario@servidor`.
4. VS Code se conecta: abre carpetas del servidor, edita, ejecuta, debuga como si fuera local.

Configuración en `~/.ssh/config`:

```
Host mi-servidor
  HostName 192.168.1.50
  User ada
  IdentityFile ~/.ssh/id_ed25519
```

### Dev Containers

Abre el proyecto dentro de un contenedor con el runtime y dependencias definidos en un archivo `.devcontainer/devcontainer.json`:

```json
{
  "name": "Mi Proyecto",
  "image": "mcr.microsoft.com/devcontainers/typescript-node:20",
  "forwardPorts": [3000],
  "postCreateCommand": "pnpm install",
  "customizations": {
    "vscode": {
      "extensions": ["dbaeumer.vscode-eslint", "esbenp.prettier-vscode"]
    }
  }
}
```

Ventajas:

- Mismo entorno para todo el equipo.
- Sin "en mi máquina funciona".
- Aislar dependencias del sistema.

### WSL

En Windows, instala WSL (Windows Subsystem for Linux) y abre VS Code en ese entorno:

```bash
# En la terminal WSL
code .
```

VS Code se conecta a WSL y trabaja con archivos Linux a velocidad nativa.

## Atajos de productividad

### Búsqueda global

| Atajo | Acción |
|-------|--------|
| `Ctrl+Shift+F` | Buscar en todo el workspace |
| `Ctrl+Shift+H` | Buscar y reemplazar en todo el workspace |

### Búsqueda con regex

Activa el icono `.*` en el cuadro de búsqueda y usa regex:

```
console\.(log|error)\((.+)\)
```

### Go to symbol

| Atajo | Acción |
|-------|--------|
| `Ctrl+Shift+O` | Símbolos del archivo actual |
| `Ctrl+T` | Símbolos de todo el workspace |

### Reabrir cerrado

```bash
> View: Reopen Closed Editor     # Ctrl+Shift+T
```

### Command palette avanzada

En la paleta de comandos (`Ctrl+P` para archivos):

| Prefijo | Acción |
|---------|--------|
| `:` | Ir a línea |
| `@` | Símbolos del archivo |
| `#` | Símbolos del workspace |
| `>` | Comandos |

### Peek

| Atajo | Acción |
|-------|--------|
| `Alt+F12` | Peek definition (vista previa inline) |
| `Shift+F12` | Peek references |

## Snippets de teclado útiles

- `Ctrl+K Ctrl+T`: cambiar tema de color.
- `Ctrl+K Ctrl+M`: cambiar de perfil.
- `Ctrl+K Ctrl+O`: abrir carpeta.
- `Ctrl+K Ctrl+C`: comentar línea.
- `Ctrl+K Ctrl+U`: descomentar línea.

## Extensiones de productividad

| Extensión | Para qué |
|-----------|----------|
| Error Lens | Muestra errores inline en el editor |
| indent-rainbow | Colorea la indentación |
| TODO Highlight | Resalta TODOs y FIXMEs |
| Bookmarks | Marcar líneas para volver a ellas |
| Project Manager | Cambiar entre proyectos rápidamente |
| Live Share | Edición colaborativa en tiempo real |

## Live Share

**Live Share** permite que varias personas editen el mismo proyecto en tiempo real, como Google Docs para código.

```bash
> Live Share: Start Collaboration Session
# Comparte el link con tu compañero
```

- Cada uno ve su cursor.
- Pueden seguir al líder (follow mode).
- Funciona con debugging y terminal compartida.

## Terminal

### Multiplexación

Aunque VS Code no es un multiplexor como tmux, puedes:

- Dividir terminales.
- Tener varias en pestañas.
- Renombrarlas.

### Integración con shell

```bash
> Terminal: Run Active File in Active Terminal
> Terminal: Run Selected Text
```

## Buenas prácticas

1. **Personaliza tus atajos**: asigna lo que uses mucho a combinaciones cómodas.
2. **Usa multi-cursor** y selección de columna: ahorran muchísimo tiempo.
3. **Crea profiles** para separar contextos de trabajo.
4. **Activa Settings Sync** para no perder tu config al cambiar de máquina.
5. **Prueba Dev Containers**: eliminan el "works on my machine".
6. **Usa Live Share** para pair programming sin fricción.
7. **Aprende un atajo nuevo cada día** durante un mes: multiplica tu velocidad.

---

> Anterior: [Terminal integrada y git](04-integrated-terminal-y-git.md) · Volver al [índice](README.md)
