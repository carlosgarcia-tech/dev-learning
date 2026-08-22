# Fundamentos de pnpm

> Qué es pnpm, por qué es más rápido que npm, instalación y comandos básicos (`pnpm add`, `pnpm install`).

## ¿Qué es pnpm?

**pnpm** (performant npm) es un gestor de paquetes para Node.js, alternativo a npm y yarn. Es **compatible** con el registro de npm: cualquier paquete que instales con npm se puede instalar con pnpm.

Sus grandes ventajas:

1. **Rápido:** reutiliza paquetes ya descargados gracias a un store global.
2. **Eficiente en disco:** cada versión de un paquete se guarda una sola vez en el sistema.
3. **Estricto:** crea una estructura de `node_modules` que evita dependencias fantasma.
4. **Determinista:** usa un lockfile estricto y un store content-addressable.

## ¿Por qué es más rápido?

### Store global content-addressable

pnpm mantiene un **store global** en `~/.local/share/pnpm/store` (o `~/Library/pnpm/store` en macOS) donde cada paquete se guarda **una sola vez** en el sistema, indexado por su hash.

Cuando instalas un paquete en un proyecto:

1. Si ya está en el store, **no se descarga** de nuevo.
2. Se crean **hardlinks** desde el store a tu `node_modules`.
3. Como los hardlinks no copian datos, la instalación es casi instantánea y ocupa cero bytes extra.

```
Store global (~/.local/share/pnpm/store)
├── express@4.18.2/
├── lodash@4.17.21/
└── react@18.2.0/

Proyecto A: node_modules/.pnpm/express@4.18.2/  --hardlink-->  store
Proyecto B: node_modules/.pnpm/express@4.18.2/  --hardlink-->  store (mismo archivo)
```

### Comparación con npm

| Característica | npm | pnpm |
|----------------|-----|------|
| Store global | No (copia en cada proyecto) | Sí (un solo ejemplar) |
| node_modules | Plano (todo en la raíz) | Estructurado con symlinks |
| Dependencias fantasma | Posibles | Imposibles |
| Velocidad | Media | Rápida (especialmente en reinstalaciones) |
| Uso de disco | Alto (duplica paquetes por proyecto) | Bajo (un ejemplar global) |

Un proyecto con 500 dependencias que ocupa 400 MB con npm puede ocupar solo unos MB adicionales con pnpm si los paquetes ya están en el store.

## Instalación de pnpm

### Requisitos

- Node.js 16.14 o superior.

### Métodos de instalación

```bash
# Con npm (si ya lo tienes)
npm install -g pnpm

# Con Corepack (recomendado, viene con Node)
corepack enable
corepack prepare pnpm@latest --activate

# Independiente (sin Node previo)
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Con Homebrew (macOS)
brew install pnpm

# Con Scoop (Windows)
scoop install pnpm
```

### Verificar

```bash
pnpm -v
pnpm --version
```

## Corepack

**Corepack** es una herramienta que viene con Node.js y gestiona versiones de pnpm/yarn sin instalarlos globalmente. Es la forma recomendada porque permite **fijar la versión** de pnpm por proyecto.

```bash
corepack enable                   # activa corepack
corepack prepare pnpm@9.0.0 --activate
```

### Fijar versión por proyecto

En el `package.json`:

```json
{
  "packageManager": "pnpm@9.0.0"
}
```

Con esto, cualquier persona que use Corepack usará esa versión exacta de pnpm en el proyecto, garantizando reproducibilidad.

## Comandos básicos

### pnpm install

Instala todas las dependencias declaradas en `package.json`.

```bash
pnpm install                # instala todo
pnpm install --frozen-lockfile   # instalación estricta (CI/CD)
pnpm install --prod          # solo dependencies (no devDependencies)
pnpm i                       # abreviatura
```

`--frozen-lockfile` es el equivalente a `npm ci`: no modifica el lockfile y falla si no está sincronizado.

### pnpm add

Añade una dependencia.

```bash
pnpm add express                # dependencies
pnpm add -D jest                # devDependencies
pnpm add -D eslint @types/node  # varios a la vez
pnpm add -O eslint              # optionalDependencies
pnpm add -g typescript          # global
pnpm add express@4.18.2         # versión concreta
pnpm add github:usuario/repo    # desde git
```

### pnpm remove

Desinstala un paquete.

```bash
pnpm remove express
pnpm remove jest -D
pnpm rm express                # abreviatura
```

### pnpm update

Actualiza dependencias dentro del rango semver.

```bash
pnpm update                    # todas
pnpm update --latest           # actualiza a las últimas (ignora el rango)
pnpm update express            # solo express
pnpm update express --latest
```

### Otros comandos

```bash
pnpm list                      # lista dependencias
pnpm list --depth 0            # solo directas
pnpm why express               # por qué está express instalado
pnpm outdated                  # paquetes desactualizados
pnpm prune                     # limpiar paquetes no referenciados
pnpm store prune               # limpiar store global de paquetes no usados
pnpm info express              # info del paquete
```

## El archivo pnpm-lock.yaml

pnpm genera `pnpm-lock.yaml`, su lockfile. Es más detallado que el de npm porque registra también la estructura del store. **Debe commitearse**.

```yaml
lockfileVersion: '6.0'

dependencies:
  express:
    specifier: ^4.18.2
    version: 4.18.2

packages:
  /express@4.18.2:
    dependencies:
      accepts: 1.3.8
      body-parser: 1.20.1
      ...
```

## Diferencias con npm

| Acción | npm | pnpm |
|--------|-----|------|
| Instalar todo | `npm install` | `pnpm install` |
| Añadir paquete | `npm install pkg` | `pnpm add pkg` |
| Añadir devDep | `npm i -D pkg` | `pnpm add -D pkg` |
| Ejecutar script | `npm run dev` | `pnpm dev` o `pnpm run dev` |
| Ejecutar binario | `npx comando` | `pnpm dlx comando` o `pnpm exec` |
| Instalación estricta | `npm ci` | `pnpm install --frozen-lockfile` |
| Desinstalar | `npm uninstall pkg` | `pnpm remove pkg` |
| Listar | `npm ls` | `pnpm list` |
| Por qué | `npm why pkg` | `pnpm why pkg` |

## node_modules con pnpm

pnpm crea una carpeta `node_modules/.pnpm/` que contiene cada paquete en su propia carpeta versionada con sus dependencias exactas. La raíz de `node_modules/` contiene solo **symlinks** a los paquetes que declaraste directamente.

```
node_modules/
├── express -> .pnpm/express@4.18.2/node_modules/express    (symlink)
├── .pnpm/
│   ├── express@4.18.2/
│   │   └── node_modules/
│   │       ├── express/         (hardlink al store)
│   │       ├── accepts -> ../../accepts@1.3.8/node_modules/accepts  (symlink)
│   │       └── ...
│   └── accepts@1.3.8/
│       └── node_modules/
│           └── accepts/        (hardlink al store)
```

Esta estructura garantiza que **solo puedes importar lo que declaraste**.

## Buenas prácticas

1. Usa **Corepack** y fija `packageManager` en cada proyecto.
2. Comitea `pnpm-lock.yaml`.
3. Usa `--frozen-lockfile` en CI/CD.
4. Ejecuta `pnpm store prune` de vez en cuando para limpiar el store.
5. Declara siempre todas las dependencias (pnpm te obliga a hacerlo, lo que es bueno).

---

> Siguiente: [Estructura y content-addressable](02-estructura-y-content-addressable.md)
