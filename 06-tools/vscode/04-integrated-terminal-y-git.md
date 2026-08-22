# Terminal integrada y git

> La terminal integrada, tareas con `tasks.json`, git integrado, diff y resolución de merge.

## Terminal integrada

VS Code incluye una terminal integrada que abre directamente en la carpeta del workspace. Así no necesitas cambiar de ventana.

### Abrir

| Atajo | Acción |
|-------|--------|
| `Ctrl+\`` (backtick) | Abrir/cerrar terminal |
| `Ctrl+Shift+\`` | Nueva terminal externa |

```bash
# Desde la paleta:
> Terminal: Create New Terminal
> Terminal: Split Terminal     # dividir
> Terminal: Kill Terminal
```

### Múltiples terminales

Puedes tener varias terminales en pestañas o divididas:

- `+` añade una nueva terminal.
- El icono de split divide la actual.
- Cada terminal puede usar un perfil distinto (bash, zsh, PowerShell, cmd).

### Configurar el perfil por defecto

```json
// settings.json
{
  "terminal.integrated.defaultProfile.linux": "zsh",
  "terminal.integrated.defaultProfile.osx": "zsh",
  "terminal.integrated.defaultProfile.windows": "PowerShell",
  "terminal.integrated.profiles.linux": {
    "zsh": { "path": "zsh" },
    "bash": { "path": "bash" }
  },
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.scrollback": 10000
}
```

### Integración con el editor

- **Ctrl+Click** en un error de la terminal abre el archivo en la línea correspondiente.
- Selecciona texto y `Ctrl+Shift+C` copia.
- Arrastra archivos al explorador para ver sus rutas.

### Enviar selección a la terminal

Selecciona código en el editor y:

```bash
> Terminal: Run Selected Text in Active Terminal
```

O con atajo `Shift+Enter` si está configurado.

## Tareas (tasks.json)

Las **tareas** automatizan comandos repetitivos (build, test, lint) y se ejecutan desde VS Code sin escribir el comando en la terminal.

### Crear una tarea

```bash
> Tasks: Configure Task
# O crea .vscode/tasks.json
```

### Estructura

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "build",
      "type": "shell",
      "command": "pnpm run build",
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": ["$tsc"]
    },
    {
      "label": "test",
      "type": "shell",
      "command": "pnpm test",
      "group": {
        "kind": "test",
        "isDefault": true
      }
    },
    {
      "label": "lint",
      "type": "process",
      "command": "pnpm",
      "args": ["run", "lint"]
    }
  ]
}
```

### Ejecutar tareas

```bash
> Tasks: Run Task        # elegir tarea
> Tasks: Run Build Task  # Ctrl+Shift+B (tarea por defecto de build)
> Tasks: Run Test Task   # (tarea por defecto de test)
```

### Tareas compuestas

```json
{
  "tasks": [
    {
      "label": "build-all",
      "dependsOn": ["lint", "build", "test"],
      "group": { "kind": "build", "isDefault": true }
    },
    {
      "label": "lint",
      "type": "shell",
      "command": "pnpm run lint"
    },
    {
      "label": "build",
      "type": "shell",
      "command": "pnpm run build"
    },
    {
      "label": "test",
      "type": "shell",
      "command": "pnpm test"
    }
  ]
}
```

`dependsOn` puede ser secuencial o paralela:

```json
{
  "label": "parallel",
  "dependsOn": ["task-a", "task-b"],
  "dependsOrder": "parallel"
}
```

### problemMatcher

Convierte la salida del comando en problemas que aparecen en el panel de "Problemas" y subrayan el código.

| Matcher | Para |
|---------|------|
| `$tsc` | Compilador de TypeScript |
| `$eslint-stylish` | ESLint |
| `$gulp-tsc` | gulp + tsc |
| Personalizado | Regex para tu propia salida |

```json
{
  "label": "build",
  "command": "tsc",
  "problemMatcher": "$tsc"
}
```

### Variables en tasks

```json
{
  "label": "build",
  "command": "tsc",
  "args": ["${file}"],
  "options": {
    "cwd": "${workspaceFolder}"
  }
}
```

| Variable | Significado |
|----------|-------------|
| `${workspaceFolder}` | Raíz del proyecto |
| `${file}` | Archivo activo |
| `${fileBasename}` | Nombre del archivo |
| `${fileDirname}` | Directorio del archivo |
| `${relativeFile}` | Ruta relativa |
| `${env:USER}` | Variable de entorno |

### Inputs interactivos

Puedes pedir valores al usuario:

```json
{
  "tasks": [
    {
      "label": "deploy",
      "command": "deploy.sh",
      "args": ["${input:env}"]
    }
  ],
  "inputs": [
    {
      "id": "env",
      "type": "pickString",
      "description": "¿A qué entorno desplegar?",
      "options": ["dev", "staging", "prod"],
      "default": "dev"
    }
  ]
}
```

## Git integrado

VS Code integra Git de forma nativa. No necesitas la terminal para lo básico.

### La vista de Source Control

`Ctrl+Shift+G` abre la vista de control de código fuente. Muestra:

- Archivos **modificados** (M), **añadidos** (U/A), **borrados** (D).
- Diferencias al hover.
- Botones para **stage** (`+`), **unstage** (`-`), **commit**.

### Staging y commit

| Acción | Cómo |
|--------|------|
| Stage un archivo | Click en `+` junto al archivo |
| Stage todos | Click en `+` junto a "Changes" |
| Unstage | Click en `-` |
| Commit | Escribe mensaje y `Ctrl+Enter` |
| Descartar cambios | Click en el icono de revertir |

```bash
# Equivalente en terminal:
git add archivo.js
git commit -m "mensaje"
```

### Commit con descripción

En el cuadro de mensaje puedes usar multi-línea:

```
feat: añadir login de usuario

Implementa JWT y refresh tokens.
Closes #123
```

### Quick staging

- Stage archivo: click en `+` al lado del archivo.
- Stage trozo: al abrir el diff, click en `+` junto a un bloque concreto.

## Diff

VS Code muestra diffs de forma muy visual: lado a lado o inline.

- Al hacer click en un archivo modificado, abre el diff.
- Líneas verdes = añadidas, rojas = eliminadas.
- Toggle entre side-by-side e inline con el icono superior.

### Comparar dos archivos

Click derecho en un archivo > "Select for Compare". Luego click derecho en otro > "Compare with Selected".

### Comparar con una rama/commit

```bash
> Git: Compare with Branch...
> Git: Compare with Commit...
> Git: Compare with HEAD
```

## Merge y conflictos

Cuando hay un merge conflict, VS Code detecta los conflictos (`<<<<<<<`, `=======`, `>>>>>>>`) y ofrece botones para resolver:

```
<<<<<<< HEAD
versión actual
=======
versión entrante
>>>>>>> feature/login
```

Para cada conflicto aparecen opciones encima:

- **Accept Current Change** — quedarte con la versión HEAD.
- **Accept Incoming Change** — quedarte con la entrante.
- **Accept Both Changes** — combinar ambas.
- **Compare Changes** — ver el diff.

Resueltos los conflictos, stagea y haz commit.

### Vista de 3 vías

```bash
> Merge Conflict: Accept Current
> Merge Conflict: Accept Incoming
> Merge Conflict: Accept Both
```

## Ramas y historial

### Cambiar de rama

```bash
> Git: Checkout to...
```

O en la barra de estado (abajo a la izquierda), click en el nombre de la rama.

### Crear rama

```bash
> Git: Create Branch...
```

### Historial

Instala la extensión **GitLens** o **Git Graph** para ver el historial visual, commits por archivo, blame en línea, etc.

### Blame

Con GitLens, al hover sobre una línea ves quién la cambió y en qué commit.

### Stash

```bash
> Git: Stash           # guardar cambios temporalmente
> Git: Pop Stash       # recuperar
> Git: Apply Stash
```

## Integración con GitHub

La extensión **GitHub Pull Requests and Issues** (`GitHub.vscode-pull-request-github`) permite:

- Ver y gestionar PRs desde VS Code.
- Hacer reviews con comentarios inline.
- Crear PRs sin salir del editor.
- Ver issues asignados.

### Crear un PR

```bash
> GitHub Pull Requests: Create Pull Request
```

### Hacer review

Abre un PR desde la vista, navega por los archivos cambiados y añade comentarios directamente en el código.

## Flujos comunes

### Flujo de feature

1. Crea una rama: `> Git: Create Branch`.
2. Edita código, haz commits desde la vista de Source Control.
3. Push: `> Git: Push` o el botón de sincronizar.
4. Crea el PR con la extensión de GitHub.

### Revisar un PR

1. Abre la vista de Pull Requests.
2. Click en un PR.
3. Navega por los cambios, comenta, aprueba o pide cambios.
4. Merge desde VS Code o desde GitHub.

## Buenas prácticas

1. Haz **commits pequeños y frecuentes** desde la UI.
2. Configura `launch.json` y `tasks.json` para estandarizar build/test/debug.
3. Usa **GitLens** para entender el historial sin salir del editor.
4. Resuelve conflictos con las opciones de VS Code, no a mano.
5. Comitea `.vscode/tasks.json` y `.vscode/settings.json` para que el equipo use los mismos comandos.

---

> Anterior: [Debugging](03-debugging.md) · Siguiente: [Productividad y personalización](05-productividad-y-customizacion.md)
