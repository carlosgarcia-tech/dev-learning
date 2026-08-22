# Workspaces y monorepo

> pnpm workspaces, el protocolo `workspace:*`, filtros con `--filter` y gestión de monorepos.

## Qué es un workspace en pnpm

pnpm soporta **workspaces** de forma nativa, igual que npm, pero con una estructura de `node_modules` más estricta y herramientas de filtrado más potentes. Es una de sus características más valoradas para monorepos.

### Estructura típica

```
mi-monorepo/
├── pnpm-workspace.yaml         <- define los workspaces
├── package.json                <- raíz
├── pnpm-lock.yaml              <- lockfile único
├── node_modules/               <- único, con store compartido
└── packages/
    ├── core/
    │   ├── package.json
    │   └── src/
    ├── ui/
    │   ├── package.json
    │   └── src/
    └── api/
        ├── package.json
        └── src/
```

## Configurar workspaces

A diferencia de npm (que los declara en `package.json`), pnpm usa un archivo **`pnpm-workspace.yaml`** en la raíz:

```yaml
# pnpm-workspace.yaml
packages:
  - "packages/*"
  - "apps/*"
  - "tools/*"
```

Los patrones glob incluyen todas las carpetas que coincidan. También puedes listar rutas explícitas:

```yaml
packages:
  - "packages/core"
  - "packages/ui"
  - "apps/web"
```

### Raíz

El `package.json` raíz suele ser `private: true` y contiene solo `devDependencies` compartidas:

```json
{
  "name": "mi-monorepo",
  "private": true,
  "devDependencies": {
    "typescript": "^5.3.0",
    "eslint": "^8.50.0",
    "prettier": "^3.0.0"
  }
}
```

### Instalar el monorepo

```bash
pnpm install
```

pnpm instala todas las dependencias de todos los paquetes en el `node_modules/` raíz (usando el store global), y crea symlinks para los paquetes internos.

## El protocolo workspace:*

pnpm introduce el protocolo **`workspace:*`** para referenciar paquetes del propio monorepo.

```json
// packages/api/package.json
{
  "name": "@miorg/api",
  "version": "1.0.0",
  "dependencies": {
    "@miorg/core": "workspace:*"
  }
}
```

### Variantes

| Protocolo | Significado |
|-----------|-------------|
| `workspace:*` | Cualquier versión del workspace |
| `workspace:^` | Se resuelve a `^x.y.z` según la versión del workspace |
| `workspace:~` | Se resuelve a `~x.y.z` |
| `workspace:1.0.0` | Debe coincidir exactamente |

### Al publicar

Cuando publicas un paquete que usa `workspace:*`, pnpm reemplaza el protocolo por la versión real antes de enviarlo al registry. Así `@miorg/core` se publica como `"@miorg/core": "^1.0.0"` en lugar de `"workspace:*"`.

```bash
pnpm publish --filter @miorg/api --no-git-checks
```

## Filtros: --filter

El comando **`--filter`** (o `-F`) es la forma de seleccionar paquetes específicos del monorepo para ejecutar comandos.

```bash
pnpm build --filter @miorg/core           # solo en core
pnpm build --filter packages/core         # por ruta
pnpm build --filter @miorg/*               # todos los del scope
pnpm build --filter "./packages/**"       # por patrón de ruta
```

### Filtros por dependencias

```bash
# Paquetes que dependen de core
pnpm build --filter ...@miorg/core

# Paquetes de los que core depende
pnpm build --filter @miorg/core^...

# core y sus dependientes (incluido core)
pnpm build --filter ...@miorg/core...

# core y sus dependencias
pnpm build --filter @miorg/core...
```

| Sintaxis | Selección |
|----------|-----------|
| `--filter pkg` | Solo pkg |
| `--filter ...pkg` | pkg y sus dependientes |
| `--filter pkg...` | pkg y sus dependencias |
| `--filter ...pkg...` | pkg, sus dependencias y dependientes |
| `--filter ./dir` | Paquete en esa ruta |
| `--filter "*"` | Todos los paquetes |
| `--filter "@scope/*"` | Paquetes de un scope |

### Filtros por git

```bash
# Paquetes modificados desde main
pnpm build --filter "...[origin/main]"

# Paquetes modificados en los últimos 2 commits
pnpm test --filter "[HEAD~2..HEAD]"
```

Esto es muy útil en CI para ejecutar tareas solo en lo que cambió.

### Ejecutar en paralelo

```bash
pnpm -r run build          # -r = recursivo, en todos
pnpm -r --parallel run build
```

## pnpm -r (recursivo)

`pnpm -r` ejecuta un comando en todos los paquetes del workspace de forma recursiva.

```bash
pnpm -r run build           # build en todos
pnpm -r run test             # test en todos
pnpm -r run lint             # lint en todos
pnpm -r --filter @miorg/* run build   # en los del scope
```

### Orden de ejecución

Por defecto, pnpm ejecuta en orden de dependencias (topológico): primero las dependencias, luego los que dependen de ellas. Así `build` de `core` va antes que `build` de `api` que lo usa.

```bash
pnpm -r run build          # respeta topología
pnpm -r --no-sort run build # no respetar orden topológico
```

## Añadir dependencias en un workspace

```bash
# A un paquete concreto
pnpm add express --filter @miorg/api
pnpm add -D jest --filter @miorg/core

# A la raíz (compartido)
pnpm add -D -w typescript
pnpm add -D -w eslint
```

`-w` (`--workspace-root`) instala en la raíz.

### Dependencias entre paquetes

```bash
pnpm add @miorg/core --filter @miorg/api
# añade @miorg/core a api como workspace:*
```

## Configuración avanzada

### catálogo (catalogs)

pnpm soporta **catálogos** para unificar versiones de dependencias comunes en todo el monorepo:

```yaml
# pnpm-workspace.yaml
packages:
  - "packages/*"

catalogs:
  react:
    react: 18.2.0
    react-dom: 18.2.0
```

```json
// packages/ui/package.json
{
  "dependencies": {
    "react": "catalog:react"
  }
}
```

Así todas las referencias a `react` apuntan a la versión del catálogo y se actualizan en un solo lugar.

### overrides

Forzar versiones de dependencias transitivas en todo el monorepo:

```json
// package.json raíz
{
  "pnpm": {
    "overrides": {
      "lodash": "^4.17.21"
    }
  }
}
```

O en `pnpm-workspace.yaml`:

```yaml
overrides:
  lodash: "^4.17.21"
```

### patchedDependencies

Aplicar parches a dependencias sin hacer fork:

```json
{
  "pnpm": {
    "patchedDependencies": {
      "express@4.18.2": "patches/express@4.18.2.patch"
    }
  }
}
```

```bash
pnpm patch express@4.18.2        # crea copia temporal
# edita los archivos en el path indicado
pnpm patch-commit <path>         # genera el .patch y lo registra
```

## Publicación en monorepo

### Versionado con changesets

```bash
npx changeset                     # registrar cambio
npx changeset version             # bump versiones
pnpm -r publish --filter @miorg/* # publicar
```

### Publicar un paquete

```bash
pnpm publish --filter @miorg/api --access public
pnpm publish --filter @miorg/api --no-git-checks  # si hay cambios sin commitear
```

`--no-git-checks` omite la verificación de estado limpio y branch (útil en CI).

## Buenas prácticas

1. Define `pnpm-workspace.yaml` y mantén la raíz como `private: true`.
2. Usa `workspace:*` para referenciar paquetes internos.
3. Usa `--filter` para ejecutar tareas en paquetes concretos o por git diff.
4. Ejecuta con `-r` para tareas recursivas respetando topología.
5. Unifica versiones con catálogos u `overrides`.
6. Publica con changesets para coordinar versiones y changelogs.
7. Comitea un único `pnpm-lock.yaml` en la raíz.

---

> Anterior: [Estructura y content-addressable](02-estructura-y-content-addressable.md) · Siguiente: [Scripts y configuración](04-scripts-y-configuracion.md)
