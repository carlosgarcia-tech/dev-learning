# Extensiones y snippets

> Extensiones esenciales, custom snippets, Emmet y format on save.

## Extensiones

Las **extensiones** añaden lenguajes, herramientas, temas y funcionalidades a VS Code. Se instalan desde el Marketplace (icono de Extensiones en la barra de actividades o `Ctrl+Shift+X`).

### Gestionar extensiones

```bash
# Desde la UI:
Ctrl+Shift+X              # abrir vista de extensiones
# Buscar por nombre e instalar

# Desde la línea de comandos:
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --list-extensions                   # listar instaladas
code --uninstall-extension <id>          # desinstalar
```

### Extensiones esenciales por categoría

#### Lenguajes

| Extensión | Para qué |
|-----------|----------|
| Python (`ms-python.python`) | Soporte Python, IntelliSense, debugging |
| Pylance (`ms-python.vscode-pylance`) | Type checking avanzado para Python |
| C/C++ (`ms-vscode.cpptools`) | Soporte C/C++ |
| Java Extension Pack (`vscjava.vscode-java-pack`) | Java completo |
| Go (`golang.go`) | Go |
| Rust-analyzer (`rust-lang.rust-analyzer`) | Rust moderno |
| C# (`ms-dotnettools.csharp`) | C# y .NET |

#### JavaScript / TypeScript / Web

| Extensión | Para qué |
|-----------|----------|
| ESLint (`dbaeumer.vscode-eslint`) | Linting JS/TS |
| Prettier (`esbenp.prettier-vscode`) | Formateo de código |
| Tailwind CSS IntelliSense | Autocompletado Tailwind |
| ES7+ React/Redux snippets | Snippets para React |
| Vite | Soporte Vite |
| Vue - Official (`Vue.volar`) | Vue 3 |

#### Productividad

| Extensión | Para qué |
|-----------|----------|
| GitLens | Blame, historial, comparación en línea |
| Git Graph | Visualización del grafo de git |
| indent-rainbow | Colorea la indentación |
| Error Lens | Muestra errores inline |
| Code Spell Checker | Corrector ortográfico |
| Path Intellisense | Autocompletado de rutas de import |
| Material Icon Theme | Iconos bonitos de archivos |
| Live Server | Servidor local con recarga para HTML |

#### DevOps / Cloud

| Extensión | Para qué |
|-----------|----------|
| Docker (`ms-azuretools.vscode-docker`) | Gestión de contenedores |
| Remote - SSH (`ms-vscode-remote.remote-ssh`) | Editar en remoto por SSH |
| Dev Containers | Abrir el proyecto dentro de un contenedor |
| GitHub Pull Requests | Gestionar PRs desde el editor |
| Kubernetes | Soporte k8s |

### extensions.json

Recomienda extensiones a tu equipo mediante `.vscode/extensions.json`:

```json
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "ms-python.python",
    "ms-azuretools.vscode-docker"
  ],
  "unwantedRecommendations": [
    "ms-vscode.vscode-typescript-tslint-plugin"
  ]
}
```

Al abrir el proyecto, VS Code sugiere instalar las que faltan.

## Snippets personalizados

Los **snippets** son plantillas de código que se insertan con un disparador y tabulación. Los creas tú mismo para automatizar código repetitivo.

### Crear un snippet

```bash
# Paleta de comandos:
> Preferences: Configure Snippets
# Elige el lenguaje (ej: javascript)
```

Esto crea un archivo `javascript.json` en `~/.config/Code/User/snippets/`.

### Estructura

```json
{
  "Console log": {
    "prefix": "clg",
    "body": ["console.log('$1', $1);"],
    "description": "Log rápido con variable"
  },
  "Función flecha": {
    "prefix": "fn",
    "body": ["const ${1:name} = (${2:params}) => {", "  $0", "};"],
    "description": "Función flecha"
  },
  "Componente React": {
    "prefix": "rfc",
    "body": [
      "import React from 'react';",
      "",
      "export default function ${1:Component}() {",
      "  return (",
      "    <div>",
      "      $0",
      "    </div>",
      "  );",
      "}"
    ],
    "description": "Componente funcional React"
  }
}
```

### Placeholders

| Sintaxis | Significado |
|----------|-------------|
| `$1`, `$2`... | Tabuladores: saltas con Tab |
| `$0` | Cursor final |
| `${1:default}` | Con valor por defecto |
| `${1|opt1,opt2,opt3|}` | Elección entre opciones |

### Snippets por proyecto

Para snippets compartidos por el proyecto, crea el archivo en `.vscode/`:

```
.vscode/
└── <lenguaje>.code-snippets   # ej: javascript.code-snippets
```

### Ejemplo Python

```json
{
  "main guard": {
    "prefix": "main",
    "body": [
      "if __name__ == '__main__':",
      "    $0"
    ]
  },
  "test function": {
    "prefix": "tdef",
    "body": [
      "def test_${1:name}():",
      "    $0"
    ]
  }
}
```

## Emmet

**Emmet** es un sistema de abreviaturas para escribir HTML y CSS rápidamente. Viene integrado en VS Code.

### HTML

Escribe la abreviatura y pulsa Tab:

```html
div.container
<div class="container"></div>

ul>li*5
<ul>
  <li></li>
  <li></li>
  <li></li>
  <li></li>
  <li></li>
</ul>

nav>ul>li*3>a[href="#"]{Item $}
<nav>
  <ul>
    <li><a href="#">Item 1</a></li>
    <li><a href="#">Item 2</a></li>
    <li><a href="#">Item 3</a></li>
  </ul>
</nav>
```

### Sintaxis Emmet

| Operador | Acción | Ejemplo |
|----------|--------|---------|
| `>` | Hijo | `ul>li` |
| `+` | Hermano | `div+p` |
| `*` | Multiplicar | `li*3` |
| `#` | id | `div#main` |
| `.` | Clase | `div.card` |
| `{text}` | Texto | `a{Click}` |
| `()` | Agrupar | `(div>p)+(div>span)` |
| `$` | Numerar | `li.item$*3` |

### CSS

```css
m10        -> margin: 10px;
p20-30     -> padding: 20px 30px;
w100p      -> width: 100%;
bg#fff     -> background: #fff;
```

### Wrap with abbreviation

`Ctrl+Shift+P` > `Emmet: Wrap with Abbreviation` para envolver la selección en una etiqueta.

## Format on save

El formateo automático al guardar mantiene un estilo consistente sin esfuerzo.

### Activarlo

```json
// settings.json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

### Formateador por lenguaje

```json
{
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter"
  },
  "[html]": {
    "editor.defaultFormatter": "vscode.html-language-features"
  },
  "[rust]": {
    "editor.defaultFormatter": "rust-lang.rust-analyzer"
  }
}
```

### Prettier

[Prettier](https://prettier.io) es el formateador más usado para JS/TS/CSS/HTML/JSON. Funciona con VS Code:

1. Instala la extensión `esbenp.prettier-vscode`.
2. Instala el paquete en el proyecto: `pnpm add -D prettier`.
3. Configura VS Code para que sea el formateador por defecto.
4. Crea un `.prettierrc` con tu configuración:

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "all",
  "printWidth": 100
}
```

### ESLint + Prettier

ESLint detecta errores y malas prácticas; Prettier formatea. Se pueden combinar:

```bash
pnpm add -D eslint prettier eslint-config-prettier
```

```json
// .eslintrc.json
{
  "extends": ["eslint:recommended", "prettier"]
}
```

`eslint-config-prettier` desactiva las reglas de ESLint que entrarían en conflicto con Prettier.

### Format on type / paste

```json
{
  "editor.formatOnType": false,
  "editor.formatOnPaste": true
}
```

## Organizar imports

```bash
> Organize Imports      # Shift+Alt+O (en JS/TS)
```

```json
{
  "editor.codeActionsOnSave": {
    "source.organizeImports": "explicit"
  }
}
```

## Buenas prácticas

1. **Instala solo lo necesario**: demasiadas extensiones ralentizan el editor.
2. **Comparte recomendaciones** con `.vscode/extensions.json`.
3. **Crea snippets** para patrones repetitivos de tu proyecto.
4. **Aprende Emmet**: ahorra muchísimo tiempo en HTML/CSS.
5. **Activa format on save** y configura un formateador.
6. **Mide el rendimiento** con `> Developer: Show Running Extensions`.

---

> Anterior: [Fundamentos](01-fundamentos.md) · Siguiente: [Debugging](03-debugging.md)
