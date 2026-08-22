# Scripts y configuración

> `pnpm run`, `pnpm exec`, `pnpm dlx`, configuración con `.npmrc`, `pnpm config` y hooks.

## Ejecutar scripts

pnpm, igual que npm, ejecuta los scripts definidos en la sección `scripts` de `package.json`.

```json
{
  "scripts": {
    "dev": "node --watch src/index.js",
    "build": "tsc",
    "test": "node --test",
    "lint": "eslint ."
  }
}
```

### Comando

```bash
pnpm run dev           # ejecuta el script "dev"
pnpm dev               # abreviatura (equivale a pnpm run dev)
pnpm run build
pnpm test              # atajo para run test
pnpm start             # atajo para run start
```

> A diferencia de npm, en pnpm **no hace falta** `run` para scripts personalizados: `pnpm dev` funciona directamente. Esto evita el típico `npm run dev`.

### Listar scripts disponibles

```bash
pnpm run               # lista todos los scripts
```

### Pasar argumentos

```bash
pnpm run lint -- --fix
# ejecuta: eslint . --fix
```

El `--` separa los argumentos de pnpm de los del script subyacente.

## Pre y post hooks

pnpm ejecuta automáticamente `pre<script>` y `post<script>` si existen, igual que npm.

```json
{
  "scripts": {
    "prebuild": "rimraf dist",
    "build": "tsc",
    "postbuild": "npm run copy"
  }
}
```

```bash
pnpm build
# 1. prebuild -> rimraf dist
# 2. build    -> tsc
# 3. postbuild -> npm run copy
```

> Por seguridad, pnpm permite desactivar los scripts de instalación (lifecycle scripts de dependencias) con `--ignore-scripts` o `ignore-scripts=true` en `.npmrc`. Los `pre`/`post` de tus propios scripts sí se ejecutan.

## pnpm exec

`pnpm exec` ejecuta un binario instalado en el proyecto, dentro del entorno de pnpm.

```bash
pnpm exec eslint .          # ejecuta el eslint local
pnpm exec tsc --noEmit      # ejecuta el tsc local
pnpm exec prettier --write .
```

Es equivalente a `npx` de npm cuando el paquete ya está instalado localmente.

### Cuándo usar exec vs run

- `pnpm run <script>`: ejecuta un **script** definido en `package.json`.
- `pnpm exec <bin>`: ejecuta un **binario** de `node_modules/.bin/` directamente.

## pnpm dlx

`pnpm dlx` (download and execute) ejecuta un paquete **sin instalarlo** previamente, descargándolo en una carpeta temporal.

```bash
pnpm dlx create-vite mi-app        # scaffolding sin instalar
pnpm dlx cowsay "hola"             # ejecuta un comando puntual
pnpm dlx prettier --write .        # si no está en el proyecto
```

Es el equivalente a `npx <paquete>` cuando el paquete **no** está instalado localmente.

### exec vs dlx

| Comando | Cuándo |
|---------|--------|
| `pnpm exec <bin>` | El binario ya está en `node_modules/.bin/` |
| `pnpm dlx <pkg>` | El paquete no está instalado; se descarga temporalmente |

## Binarios locales

Cuando un paquete instala un binario, va a `node_modules/.bin/`. Durante la ejecución de scripts, pnpm añade esa carpeta al `PATH`, así que puedes usarlo directamente:

```json
{
  "scripts": {
    "lint": "eslint ."
  }
}
```

`eslint` se resuelve a `node_modules/.bin/eslint` sin escribir la ruta completa.

## .npmrc

pnpm usa `.npmrc` para configuración, igual que npm, pero con directivas adicionales propias.

### Ubicaciones

| Archivo | Ámbito |
|---------|--------|
| `./.npmrc` | Proyecto |
| `~/.npmrc` | Usuario |
| `/etc/npmrc` | Global |

### Directivas pnpm específicas

```ini
# Usar otro registry
registry=https://registry.npmjs.org/

# Store en otra ubicación
store-dir=/path/al/store

# Auto-instalar peers
auto-install-peers=true

# Hoisting
shamefully-hoist=false
hoist-pattern[]=*eslint*

# Instalación estricta
frozen-lockfile=false

# Ignorar scripts de postinstall (seguridad)
ignore-scripts=false

# Guardar exacto
save-exact=false

# Verificar store
verify-store-integrity=true

# Solo dependencies en producción
prod=false

# Usar enlaces simbólicos para node_modules
node-linker=isolated          # por defecto (estricto)
# node-linker=hoisted         # simular npm
# node-linker=pnp             # Yarn PnP

# Profundidad de symlink
symlinks=true
```

### Configuración por scope

```ini
@miorg:registry=https://npm.pkg.github.com/
//npm.pkg.github.com/:_authToken=${GITHUB_TOKEN}
```

## pnpm config

```bash
pnpm config list               # toda la configuración
pnpm config get registry       # ver un valor
pnpm config set registry https://registry.npmjs.org/
pnpm config set store-dir /custom/path
pnpm config delete save-exact
pnpm config set //registry.npmjs.org/:_authToken npm_xxx   # autenticación
```

### Niveles de configuración

```bash
pnpm config set key value --location=project   # .npmrc del proyecto
pnpm config set key value --location=user      # ~/.npmrc
pnpm config set key value --location=global    # /etc/npmrc
```

## Hooks y lifecycle

### Scripts de instalación de paquetes

Las dependencias pueden tener scripts `preinstall`, `install`, `postinstall` que se ejecutan al instalarlas. Por seguridad, pnpm permite bloquearlos:

```bash
pnpm install --ignore-scripts
```

```ini
# .npmrc
ignore-scripts=true
```

### pnpm.beforeInstall y pnpm.afterInstall

pnpm no expone hooks globales de pre/post install propios del proyecto como npm. Para automatizar, se usan los scripts `preinstall` y `postinstall` del `package.json` raíz:

```json
{
  "scripts": {
    "preinstall": "echo 'Instalando...'",
    "postinstall": "pnpm run build"
  }
}
```

## Solo-dependencies y producción

```bash
pnpm install --prod           # solo dependencies
pnpm install --no-optional    # ignorar optionalDependencies
pnpm install --frozen-lockfile  # CI estricto
```

```ini
# .npmrc
prod=true
```

## Configurar el entorno

### Node version

pnpm respeta `engines` y `packageManager`:

```json
{
  "engines": {
    "node": ">=18"
  },
  "packageManager": "pnpm@9.0.0"
}
```

```bash
pnpm config set use-node-version 20.10.0   # usar una versión específica
```

### .nvmrc

pnpm no gestiona versiones de Node. Usa `nvm`, `fnm` o `volta` para eso, con un archivo `.nvmrc`:

```
20.10.0
```

## Variables de entorno útiles

| Variable | Para qué |
|----------|----------|
| `npm_config_registry` | Override del registry |
| `PNPM_HOME` | Directorio de binarios globales |
| `CI=true` | Detecta entorno CI |
| `NODE_ENV=production` | Modo producción |

```bash
export PNPM_HOME=/home/user/.local/share/pnpm
export PATH=$PNPM_HOME:$PATH
```

## Buenas prácticas

1. Define scripts claros (`dev`, `build`, `test`, `lint`, `format`).
2. Usa `pnpm exec` para binarios locales y `pnpm dlx` para comandos de un solo uso.
3. Configura `ignore-scripts=true` si no necesitas scripts de instalación (más seguro).
4. Fija `packageManager` para reproducibilidad con Corepack.
5. Usa `--frozen-lockfile` en CI/CD.
6. Documenta en el README los scripts disponibles.

---

> Anterior: [Workspaces y monorepo](03-workspaces-y-monorepo.md) · Siguiente: [Producción y CI/CD](05-produccion-y-ci-cd.md)
