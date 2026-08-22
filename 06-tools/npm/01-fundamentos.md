# Fundamentos de npm

> Qué es npm, cómo funciona `package.json`, tipos de dependencias, semver y scripts.

## ¿Qué es npm?

**npm** (Node Package Manager) es el gestor de paquetes de Node.js. Tiene tres partes:

1. **El CLI** (`npm`): el programa que ejecutas en la terminal.
2. **El registro** (registry): un repositorio público con millones de paquetes en `registry.npmjs.org`.
3. **El sitio web** (npmjs.com): para buscar y gestionar paquetes.

npm se instala automáticamente junto con Node.js.

```bash
node -v        # versión de Node
npm -v         # versión de npm
```

## El archivo package.json

Es el archivo central de cualquier proyecto Node.js. Describe el proyecto, sus dependencias y sus scripts.

### Crear uno desde cero

```bash
npm init            # asistente interactivo
npm init -y         # genera con valores por defecto
```

### Estructura típica

```json
{
  "name": "mi-proyecto",
  "version": "1.0.0",
  "description": "Una breve descripción",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "test": "node --test"
  },
  "keywords": ["node", "aprendizaje"],
  "author": "Tu Nombre <tu@email.com>",
  "license": "MIT",
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "jest": "^29.7.0"
  }
}
```

### Campos importantes

| Campo | Para qué sirve |
|-------|----------------|
| `name` | Nombre del paquete (minúsculas, sin espacios) |
| `version` | Versión semver |
| `main` | Punto de entrada (al hacer `require`) |
| `scripts` | Comandos personalizados |
| `dependencies` | Paquetes necesarios en producción |
| `devDependencies` | Paquetes solo para desarrollo |
| `engines` | Versiones de Node compatibles |
| `type` | `"module"` para ESM, o ausente para CommonJS |
| `license` | Licencia del código |

## dependencies vs devDependencies

| Tipo | Cuándo | Ejemplos |
|------|--------|----------|
| `dependencies` | Necesarios para que el proyecto funcione en producción | express, lodash, axios |
| `devDependencies` | Solo para desarrollo, tests, build | jest, eslint, typescript, @types/* |

Al instalar un paquete de terceros, **no** se instalan sus `devDependencies`, solo sus `dependencies`.

```bash
npm install express              # lo añade a dependencies
npm install --save-dev jest      # lo añade a devDependencies
npm install -D eslint            # abreviatura de --save-dev
npm install --production         # ignora devDependencies
```

## El archivo package-lock.json

Cuando instalas, npm genera `package-lock.json`, que congela las versiones exactas de cada dependencia (incluidas las anidadas).

- **package.json**: declara rangos de versiones (`^4.18.2`).
- **package-lock.json**: registra la versión exacta instalada (`4.18.2`) y su árbol completo.

Cometer siempre `package-lock.json` al repositorio. Así todos los desarrolladores y el CI instalan exactamente las mismas versiones.

## node_modules

Es la carpeta donde npm coloca el código de las dependencias. Es enorme y se puede regenerar, así que **no se commitea**: debe estar en `.gitignore`.

```gitignore
node_modules/
```

## Semver (Versionado Semántico)

npm usa **Semantic Versioning** (SemVer): `MAYOR.MENOR.PARCHE` (ej: `4.18.2`).

| Cambio | Cuándo rompe | Versión | Ejemplo |
|--------|--------------|---------|---------|
| MAJOR | API incompatible | 4.18.2 → 5.0.0 | Se elimina o cambia una función |
| MINOR | Nueva funcionalidad compatible | 4.18.2 → 4.19.0 | Se añade una función nueva |
| PATCH | Corrección de bugs compatible | 4.18.2 → 4.18.3 | Se arregla un bug |

### Prefijos en package.json

| Prefijo | Significado | Acepta |
|---------|-------------|--------|
| `^1.2.3` | Caret (compatible) | 1.2.3 a <2.0.0 (mismo major) |
| `~1.2.3` | Tilde (cerca) | 1.2.3 a <1.3.0 (mismo minor) |
| `1.2.3` | Exacta | solo 1.2.3 |
| `>=1.2.3` | Mayor o igual | cualquier versión >= 1.2.3 |
| `*` o `latest` | Cualquiera | la última |

El prefijo por defecto de `npm install` es `^` (caret).

### Versiones especiales

| Tag | Significado |
|-----|-------------|
| `latest` | Última versión estable (por defecto) |
| `next` | Siguiente release (puede ser inestable) |
| `beta`, `alpha` | Versiones de prueba |

```bash
npm install express@latest
npm install express@4.18.2
npm install express@^4.0.0
npm install express@beta
```

## Scripts de npm

La sección `scripts` de `package.json` define comandos personalizados que ejecutas con `npm run`.

```json
{
  "scripts": {
    "start": "node index.js",
    "dev": "node --watch index.js",
    "test": "node --test",
    "lint": "eslint ."
  }
}
```

```bash
npm start          # atajo (no hace falta run)
npm test           # atajo (no hace falta run)
npm run dev        # requiere run si no es start/test
npm run lint
```

### Scripts por defecto

Algunos scripts tienen atajos especiales y se ejecutan automáticamente en ciertas fases:

| Script | Atajo | Se ejecuta al... |
|--------|-------|-------------------|
| `start` | `npm start` | — |
| `test` | `npm test` | — |
| `install` | — | `npm install` |
| `publish` | — | `npm publish` |
| `restart` | `npm restart` | — |

## Comandos básicos

```bash
npm install                    # instala todo lo de package.json
npm install <paquete>          # instala un paquete
npm uninstall <paquete>        # desinstala
npm update                     # actualiza dentro del rango semver
npm outdated                   # muestra paquetes desactualizados
npm ls                         # lista dependencias (árbol)
npm ls --depth=0               # solo las directas
npm list                       # alias de ls
npm run                        # lista los scripts disponibles
npm info <paquete>             # info del paquete en el registry
npm view <paquete> versions    # todas las versiones publicadas
```

## Archivos y carpetas relevantes

| Ruta | Para qué |
|------|----------|
| `package.json` | Manifiesto del proyecto |
| `package-lock.json` | Versiones exactas congeladas |
| `node_modules/` | Código instalado (no commitear) |
| `.npmrc` | Configuración de npm |
| `~/.npmrc` | Configuración global (tokens, registry) |

## .gitignore típico

```gitignore
node_modules/
npm-debug.log
.npm
dist/
build/
.env
```

## Buenas prácticas

1. **Committea el lockfile** para reproducibilidad.
2. **Usa `^`** por defecto, pero fija versiones en librerías críticas.
3. **Separa** `dependencies` de `devDependencies`.
4. **No commitees** `node_modules`.
5. **Usa scripts** para automatizar tareas repetitivas.
6. **Revisa `npm outdated`** y `npm audit` con regularidad.

---

> Siguiente: [Dependencias y scripts](02-dependencias-y-scripts.md)
