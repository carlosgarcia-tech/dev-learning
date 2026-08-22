# Dependencias y scripts

> Instalación y guardado de dependencias, `npm ci`, scripts personalizados, hooks pre/post y `npx`.

## Instalación de dependencias

### npm install

```bash
npm install                     # instala todo lo declarado en package.json
npm install <pkg>               # instala y añade a dependencies
npm install <pkg>@<version>     # versión concreta
npm install <pkg>@latest        # última versión
npm install -g <pkg>            # instalación global
```

### Banderas de guardado

| Bandera | Efecto |
|---------|--------|
| `-S`, `--save` | Añade a `dependencies` (por defecto) |
| `-D`, `--save-dev` | Añade a `devDependencies` |
| `-O`, `--save-optional` | Añade a `optionalDependencies` |
| `-E`, `--save-exact` | Guarda versión exacta sin `^` |
| `--no-save` | Instala sin tocar package.json |

```bash
npm install express -S            # dependencies
npm install jest -D               # devDependencies
npm install lodash --save-exact   # "lodash": "4.17.21" (sin ^)
```

### Instalación global

Los paquetes globales quedan accesibles desde cualquier directorio y suelen ser herramientas CLI.

```bash
npm install -g typescript
npm ls -g --depth=0              # lista globales
npm uninstall -g typescript
```

## npm ci

`npm ci` (Clean Install) está diseñado para **CI/CD y entornos reproducibles**. Es más rápido y estricto que `npm install`.

| Característica | `npm install` | `npm ci` |
|----------------|---------------|----------|
| Lee | package.json | package-lock.json |
| Modifica lockfile | Puede | Nunca |
| Requiere lockfile | No | Sí |
| Borra node_modules | No | Sí (instalación limpia) |
| Velocidad | Más lento | Más rápido |
| Uso típico | Desarrollo | CI/CD |

```bash
npm ci              # instala exactamente lo del lockfile
```

Si `package.json` y `package-lock.json` no coinciden, `npm ci` falla. Esto es deliberado: evita instalaciones inconsistentes en CI.

## Scripts personalizados

Cualquier comando puede ponerse en `scripts` y ejecutarse con `npm run <nombre>`.

```json
{
  "scripts": {
    "build": "tsc",
    "dev": "node --watch src/index.js",
    "start": "node dist/index.js",
    "test": "node --test",
    "lint": "eslint . --ext .js",
    "format": "prettier --write ."
  }
}
```

```bash
npm run build
npm run dev
npm run lint
```

### Pasar argumentos

Para pasar argumentos al comando subyacente, usa `--`:

```bash
npm run lint -- --fix
# ejecuta: eslint . --ext .js --fix
```

### Scripts encadenados

Puedes encadenar comandos con `&&` (o `;`):

```json
"ci:all": "npm run lint && npm run test && npm run build"
```

Para ejecutar el mismo script en paralelo (o varios a la vez) se suele usar `npm-run-all` o `concurrently`:

```json
"dev:all": "concurrently \"npm:dev:server\" \"npm:dev:client\""
```

## Pre y post hooks

npm ejecuta automáticamente `pre<script>` antes de `<script>` y `post<script>` después, si existen.

```json
{
  "scripts": {
    "prebuild": "npm run clean",
    "build": "tsc",
    "postbuild": "npm run copy-assets",
    "clean": "rm -rf dist",
    "copy-assets": "cp -r public dist/"
  }
}
```

Al ejecutar `npm run build`:

1. Se ejecuta `prebuild` (limpiar `dist/`).
2. Se ejecuta `build` (compilar TypeScript).
3. Se ejecuta `postbuild` (copiar assets).

> En npm v9+ se puede desactivar este comportamiento con `--ignore-scripts` o en `.npmrc` con `ignore-scripts=true` por seguridad.

## Variables de entorno de npm en scripts

npm expone varias variables dentro de los scripts mediante `npm_config_*` y el objeto `process.env.npm_*`. También hay variables de paquete:

```bash
# En un script:
echo $npm_package_name        # el nombre del paquete
echo $npm_package_version     # la versión
echo $npm_lifecycle_event     # el script que se está ejecutando
```

En Node.js:

```js
console.log(process.env.npm_package_name);
console.log(process.env.npm_lifecycle_event);
```

## npx

`npx` ejecuta binarios de paquetes sin instalarlos globalmente.

```bash
npx create-react-app mi-app      # ejecuta el CLI sin instalarlo antes
npx cowsay "hola"                 # ejecuta un comando puntual
npx prettier --write .            # ejecuta prettier del proyecto
npx eslint --version              # comprueba la versión local
```

### Cuándo usar npx

- Ejecutar un generador o scaffolding una sola vez (`create-react-app`, `create-next-app`).
- Ejecutar el binario local de una dependencia sin escribir la ruta completa `./node_modules/.bin/...`.
- Probar una herramienta sin instalarla.

### npx y versiones

```bash
npx -p typescript@4 tsc --version   # usa una versión concreta
npx -p pkg-a -p pkg-b comando         # varios paquetes
```

## Resolución de binarios locales

Cuando un paquete instala un binario, va a `node_modules/.bin/`. npm añade esa carpeta al `PATH` durante la ejecución de scripts, así que puedes usarlo directamente:

```json
"scripts": {
  "lint": "eslint ."        // eslint está en node_modules/.bin/eslint
}
```

## Gestión de versiones instaladas

```bash
npm ls                      # árbol completo de dependencias
npm ls --depth=0            # solo directas
npm ls express             # ¿dónde está express y qué versión?
npm outdated               # qué paquetes tienen versión nueva
npm update                 # actualiza dentro del rango semver
npm update express         # actualiza solo express
npm install express@latest # actualiza a la última
```

## Buenas prácticas

1. Usa `npm ci` en CI/CD para instalaciones reproducibles.
2. Define scripts para todas las tareas repetitivas.
3. Usa `pre`/`post` hooks para automatizar limpieza y copias.
4. Prefiere `npx` sobre instalaciones globales para herramientas de un solo uso.
5. Comprueba `npm outdated` periódicamente, pero actualiza con cuidado (sobre todo majors).

---

> Anterior: [Fundamentos](01-fundamentos.md) · Siguiente: [Publicación y scoping](03-publicacion-y-scoping.md)
