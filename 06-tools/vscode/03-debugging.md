# Debugging

> Breakpoints, watch, call stack, `launch.json` y cómo depurar Node.js, Python y el navegador.

## Por qué usar el debugger

Muchos desarrolladores debuguean con `console.log`. El debugger integrado es mucho más potente:

- Pausar la ejecución en un punto.
- Inspeccionar variables en ese momento.
- Ver la pila de llamadas (call stack).
- Evaluar expresiones en el contexto.
- Avanzar línea a línea.

## Conceptos

### Breakpoints

Un **breakpoint** marca una línea donde la ejecución se pausa. Se pone haciendo click en el margen izquierdo del editor o con `F9`.

| Tipo | Descripción |
|------|-------------|
| Breakpoint estándar | Se para siempre en esa línea |
| Condicional | Se para solo si se cumple una condición |
| Logpoint | Escribe un mensaje sin pausar (reemplaza a `console.log`) |
| Function breakpoint | Se para cuando se llama a una función por nombre |

**Breakpoint condicional:** click derecho en el margen > "Add Conditional Breakpoint":

```js
// se para solo si user es null
user === null
// o cada N veces
count % 10 === 0
```

### Watch

La sección **Watch** permite seguir el valor de expresiones a lo largo del debug.

- Añade expresiones como `user.name`, `items.length`, `total > 100`.
- Se recalculan en cada paso.

### Call stack

Muestra la pila de llamadas: qué función llamó a cuál hasta llegar al punto de pausa. Click en cualquier frame para situarse en ese contexto.

```
> calculateTotal (orders.js:45)
> processOrder (orders.js:78)
> handleRequest (server.js:12)
> <anonymous> (server.js:30)
```

### Variables

La sección **Variables** muestra:

- **Local:** variables locales de la función actual.
- **Closure:** variables capturadas por closures.
- **Global:** variables globales.
- **This:** el valor de `this`.

### Step controls

| Atajo | Acción | Qué hace |
|-------|--------|----------|
| `F5` | Continue | Sigue hasta el siguiente breakpoint |
| `F10` | Step over | Ejecuta la línea sin entrar en funciones |
| `F11` | Step into | Entra dentro de la función |
| `Shift+F11` | Step out | Sale de la función actual |
| `Shift+F5` | Stop | Detiene el debug |
| `Ctrl+Shift+F5` | Restart | Reinicia |

## launch.json

La configuración de debug se define en **`.vscode/launch.json`**. Describe cómo lanzar el programa o attacharse a un proceso.

### Crearlo

```bash
# Paleta de comandos:
> Debug: Add Configuration...
# o ve a la vista de Debug (Ctrl+Shift+D) y click en "create a launch.json file"
```

### Ejemplo para Node.js

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Debug app",
      "program": "${workspaceFolder}/src/index.js",
      "skipFiles": ["<node_internals>/**"]
    }
  ]
}
```

### Variables útiles

| Variable | Significado |
|----------|-------------|
| `${workspaceFolder}` | Carpeta raíz del workspace |
| `${file}` | Archivo activo |
| `${fileDirname}` | Directorio del archivo activo |
| `${relativeFile}` | Ruta relativa del archivo |
| `${env:VAR}` | Variable de entorno |

### request: launch vs attach

| Tipo | Cuándo |
|------|--------|
| `launch` | VS Code arranca el proceso |
| `attach` | El proceso ya está corriendo; VS Code se conecta |

## Debug Node.js

### Básico

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Debug Node",
      "program": "${workspaceFolder}/src/index.js",
      "console": "integratedTerminal",
      "env": {
        "NODE_ENV": "development"
      }
    }
  ]
}
```

### Con Nodemon / watch

```json
{
  "type": "node",
  "request": "launch",
  "name": "Debug con watch",
  "runtimeExecutable": "nodemon",
  "program": "${workspaceFolder}/src/index.js",
  "restart": true,
  "console": "integratedTerminal"
}
```

### Debug de tests

```json
{
  "type": "node",
  "request": "launch",
  "name": "Debug tests",
  "program": "${workspaceFolder}/node_modules/.bin/jest",
  "args": ["--runInBand"],
  "console": "integratedTerminal"
}
```

### Attach a un proceso

1. Arranca Node con `--inspect`:

```bash
node --inspect-brk src/index.js
# o en el script del package.json:
"dev": "node --inspect-brk src/index.js"
```

2. Configura attach:

```json
{
  "type": "node",
  "request": "attach",
  "name": "Attach a Node",
  "port": 9229,
  "restart": true
}
```

## Debug TypeScript

Para TypeScript, VS Code lo transpila en memoria automáticamente:

```json
{
  "type": "node",
  "request": "launch",
  "name": "Debug TS",
  "program": "${workspaceFolder}/src/index.ts",
  "preLaunchTask": "tsc: build - tsconfig.json",
  "outFiles": ["${workspaceFolder}/dist/**/*.js"]
}
```

O usando `ts-node`:

```json
{
  "type": "node",
  "request": "launch",
  "name": "Debug TS con ts-node",
  "runtimeArgs": ["-r", "ts-node/register"],
  "program": "${workspaceFolder}/src/index.ts"
}
```

## Debug Python

Necesitas la extensión `ms-python.python`.

### Ejemplo

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Current File",
      "type": "debugpy",
      "request": "launch",
      "program": "${file}",
      "console": "integratedTerminal",
      "justMyCode": true
    },
    {
      "name": "Python: Flask",
      "type": "debugpy",
      "request": "launch",
      "module": "flask",
      "env": {
        "FLASK_APP": "app.py",
        "FLASK_DEBUG": "1"
      },
      "args": ["run", "--no-debugger", "--no-reload"],
      "jinja": true
    },
    {
      "name": "Python: pytest",
      "type": "debugpy",
      "request": "launch",
      "module": "pytest",
      "args": ["-v"],
      "console": "integratedTerminal"
    }
  ]
}
```

### justMyCode

`justMyCode: true` (por defecto) evita entrar en código de librerías de terceros. Ponlo en `false` si quieres depurar dentro de dependencias.

## Debug en el navegador

### JavaScript (Chrome)

Necesitas la extensión "Debugger for Chrome" (o usa el debugger integrado):

```json
{
  "type": "chrome",
  "request": "launch",
  "name": "Debug en Chrome",
  "url": "http://localhost:3000",
  "webRoot": "${workspaceFolder}/src"
}
```

1. Arranca tu servidor de dev (`pnpm dev`).
2. Pulsa F5: VS Code abre Chrome controlado y puedes poner breakpoints en tu código fuente.

### Edge

```json
{
  "type": "msedge",
  "request": "launch",
  "name": "Debug en Edge",
  "url": "http://localhost:3000",
  "webRoot": "${workspaceFolder}/src"
}
```

### Firefox

```json
{
  "type": "firefox",
  "request": "launch",
  "name": "Debug en Firefox",
  "url": "http://localhost:3000",
  "webRoot": "${workspaceFolder}/src"
}
```

## Debug console

Mientras el debug está pausado, puedes escribir expresiones en la **Debug Console** para evaluarlas en el contexto actual.

```
> user
{ name: 'Ada', age: 36 }
> user.age + 1
37
> getUsers().length
42
```

## Source maps

Si usas TypeScript, Babel, webpack o Vite, el código ejecutado no es el que escribes. Los **source maps** mapean el código compilado al original, y VS Code los usa para poner breakpoints en el fuente.

- TypeScript: activa `"sourceMap": true` en `tsconfig.json`.
- Vite/Webpack: activan source maps en dev por defecto.

```json
// launch.json
{
  "outFiles": ["${workspaceFolder}/dist/**/*.js"],
  "sourceMaps": true
}
```

## Remote debugging

### Remote - SSH

Con la extensión "Remote - SSH" puedes debugar código que corre en otra máquina: VS Code se conecta por SSH y el debugger funciona como si fuera local.

### Dev Containers

Abre el proyecto dentro de un contenedor y debuga directamente en ese entorno, con el runtime y dependencias del contenedor.

## Consejos avanzados

### Conditional breakpoints avanzados

- **Hit count:** se para cada N veces o en la iteración K (`== 5`, `> 10`, `% 2 === 0`).
- **Condición + log:** combina para depurar bucles sin saturar la consola.

### Logpoints

Un **logpoint** es un breakpoint que no pausa, solo imprime. Útil para añadir logs sin tocar el código ni recompilar.

Click derecho en el margen > "Add Logpoint":

```
Procesando usuario ${user.id} con edad ${user.age}
```

### Debug de microservicios

Para depurar varios servicios a la vez, usa **compounds**:

```json
{
  "compounds": [
    {
      "name": "Server + Client",
      "configurations": ["Debug Node", "Debug en Chrome"],
      "stopAll": true
    }
  ]
}
```

## Buenas prácticas

1. Aprende los atajos: `F5`, `F10`, `F11`, `F9` son esenciales.
2. Usa **conditional breakpoints** en bucles para no parar en cada iteración.
3. Usa **logpoints** en lugar de esparcir `console.log` por el código.
4. Inspecciona el **call stack** para entender cómo llegaste ahí.
5. Configura `launch.json` por proyecto y compártelo con el equipo.
6. Aprovecha los **source maps** para debug en código transpilado.

---

> Anterior: [Extensiones y snippets](02-extensions-y-snippets.md) · Siguiente: [Terminal integrada y git](04-integrated-terminal-y-git.md)
