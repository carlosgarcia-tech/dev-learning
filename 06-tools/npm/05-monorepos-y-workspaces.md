# Monorepos y workspaces

> npm workspaces, estructura de monorepo, hoisting, publicación en monorepo y gestión de cambios.

## Qué es un monorepo

Un **monorepo** es un único repositorio que contiene varios paquetes o proyectos relacionados. Permite compartir código, configuración y dependencias, y coordinar cambios entre paquetes.

### Monorepo vs polyrepo

| Aspecto | Monorepo | Polyrepo |
|---------|----------|----------|
| Repositorios | Uno para todo | Uno por paquete |
| Compartir código | Fácil (paquetes internos) | Publicar o usar git submodule |
| Versionado | Coordinado o independiente | Independiente |
| CI | Puede ser un reto escalarlo | Simple por repo |
| Refactors cross-pkg | Una sola PR | Múltiples PRs coordinados |

### Cuándo usar un monorepo

- Varios paquetes que cambian juntos (frontend + backend + lib compartida).
- Equipos que colaboran estrechamente.
- Quieres compartir config, tests y tooling.
- Librería dividida en varios subpaquetes (como Babel, React, Next.js).

## npm workspaces

npm incluye soporte nativo para monorepos desde la v7 con la feature **workspaces**. No requiere herramientas externas.

### Estructura típica

```
mi-monorepo/
├── package.json            <- raíz (define workspaces)
├── package-lock.json       <- lockfile único
├── node_modules/           <- único, con hoisting
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

### Configurar workspaces en la raíz

```json
{
  "name": "mi-monorepo",
  "private": true,
  "workspaces": [
    "packages/*"
  ]
}
```

El patrón `packages/*` incluye todas las carpetas dentro de `packages/`. También puedes listar rutas explícitas:

```json
{
  "workspaces": ["packages/core", "packages/ui", "packages/api"]
}
```

### Instalar el monorepo

```bash
npm install              # instala todo, crea symlinks entre paquetes
```

npm:

1. Lee todos los `package.json` de los workspaces.
2. Instala las dependencias en el `node_modules/` raíz (hoisting).
3. Crea **symlinks** para que los paquetes internos se resuelvan entre sí.

## Referencias entre paquetes del monorepo

Si `packages/api` depende de `packages/core`, lo declaras en su `package.json`:

```json
{
  "name": "@miorg/api",
  "version": "1.0.0",
  "dependencies": {
    "@miorg/core": "1.0.0"
  }
}
```

Al hacer `npm install` en la raíz, npm detecta que `@miorg/core` es otro workspace y crea un **symlink** en `packages/api/node_modules/@miorg/core` que apunta a `packages/core`. Así los cambios en `core` se ven al instante en `api` sin necesidad de publicar.

> Alternativa: usar el protocolo `workspace:*` (estilo pnpm/yarn), aunque npm requiere que las versiones coincidan con las declaradas.

## Comandos en workspaces

### Ejecutar scripts en un workspace concreto

```bash
npm run build -w packages/core        # ejecuta build solo en core
npm run build --workspace=packages/ui
npm run test -w @miorg/api            # por nombre de paquete
```

### Ejecutar en todos los workspaces

```bash
npm run build --workspaces            # en todos los workspaces
npm run build -ws                     # abreviatura
npm run build -ws --if-present        # solo los que tengan ese script
```

### Añadir dependencias a un workspace

```bash
npm install express -w packages/api          # dependency de api
npm install -D jest -w packages/core         # devDependency de core
```

### Crear un workspace nuevo

```bash
npm init -w packages/nuevo-paquete           # crea la carpeta y la registra
```

## Hoisting

El **hoisting** sube las dependencias comunes al `node_modules/` raíz para evitar duplicarlas y resolver conflictos de versiones.

```
Sin hoisting:                     Con hoisting:
node_modules/                     node_modules/
└── packages/                     ├── express/   <- compartido
    ├── core/node_modules/        └── packages/
    │   └── lodash/                   ├── core/
    ├── ui/node_modules/              ├── ui/
    │   └── lodash/ (duplicado)       └── api/
    └── api/node_modules/
        └── lodash/ (duplicado)
```

### Pros y contras del hoisting

| Ventajas | Desventajas |
|----------|-------------|
| Ahorra espacio y tiempo | Un paquete puede acceder a deps que no declaró ("phantom deps") |
| Resuelve una sola versión | Conflictos si dos paquetes necesitan versiones distintas |
| Build más simple | Dependencia implícita del orden de instalación |

### Phantom dependencies

Si `packages/ui` usa `lodash` pero no lo declara, y `lodash` está en el `node_modules/` raíz por otra dependencia, `ui` podrá usarlo "por accidente". Esto es frágil: si la otra dependencia desaparece, `ui` se rompe.

Solución: siempre declarar todas las dependencias en cada `package.json`, aunque parezcan obvias.

## Versiones y publicación en monorepo

### Versionado independiente

Cada paquete tiene su propia versión y se publica por separado. Es lo más común en npm workspaces.

```bash
npm version patch -w packages/core
npm publish -w packages/core --access public
```

### Versionado unificado

Todos los paquetes comparten la misma versión (ej: Babel, React). Se actualiza todo a la vez con un script personalizado o herramientas como **changesets**.

### Changesets

[Changesets](https://github.com/changesets/changesets) es la herramienta más popular para gestionar versiones y publicaciones en monorepos npm:

- Cada contribución añade un "changeset" que describe el cambio y su impacto.
- Al publicar, calcula qué paquetes deben subir de versión y en cuánto.
- Genera automáticamente el `CHANGELOG.md` de cada paquete.
- Publica solo los paquetes que cambiaron.

```bash
npx changeset                  # registrar un cambio
npx changeset version          # aplicar changesets y subir versiones
npx changeset publish          # publicar al registry
```

### Flujo de publicación con changesets

1. El desarrollador hace cambios y ejecuta `npx changeset` para describirlos.
2. Se commitea el archivo `.changeset/*.md`.
3. En CI, una acción crea o actualiza una PR "Version Packages" con los bumps calculados.
4. Al mergear esa PR, otra acción ejecuta `changeset publish` y publica al registry.

## Otros patrones de monorepo

### Lerna

[Lerna](https://lerna.js.org) fue la herramienta original para monorepos JS. Hoy se apoya en npm/yarn/pnpm workspaces y añade comandos de alto nivel. Sigue siendo útil para publicaciones y versionado coordinado.

### Turborepo / Nx

Herramientas de build caching y orquestación de tareas en monorepos:

- Ejecutan tareas (build, test, lint) en paralelo y con caché.
- Detectan qué paquetes cambiaron para no reconstruir todo.
- `turbo run build` construye en orden de dependencias.

### pnpm workspaces

pnpm tiene su propio soporte de workspaces con una estructura de `node_modules` más estricta (sin hoisting automático) que evita las phantom dependencies. Es una alternativa muy popular a npm workspaces.

## Estrategia de dependencias

### Dependencias compartidas

Si todos los paquetes usan la misma versión de una librería (ej: TypeScript), conviene declarar `devDependencies` en la raíz:

```json
// package.json raíz
{
  "devDependencies": {
    "typescript": "^5.3.0"
  }
}
```

### Dependencias específicas

Las dependencias propias de un paquete se declaran en su `package.json`:

```json
// packages/api/package.json
{
  "dependencies": {
    "express": "^4.18.2",
    "@miorg/core": "1.0.0"
  }
}
```

## Buenas prácticas

1. Declara `workspaces` en la raíz y mantén la raíz como `private: true`.
2. Comitea un único `package-lock.json` en la raíz.
3. Declara siempre todas las dependencias en cada paquete (evita phantom deps).
4. Usa `npm run -w` para ejecutar scripts por paquete.
5. Publica con **changesets** para coordinar versiones y changelogs.
6. Considera herramientas de build caching (Turborepo, Nx) si el monorepo crece.
7. Estandariza config (eslint, prettier, tsconfig) en la raíz y extiéndela en cada paquete.

---

> Anterior: [Auditoría y seguridad](04-auditoria-y-seguridad.md) · Volver al [índice](README.md)
