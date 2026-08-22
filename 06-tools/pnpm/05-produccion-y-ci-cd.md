# Producción y CI/CD

> pnpm en CI, caché de dependencias, deploy, Docker con pnpm y comparativa con npm y yarn.

## pnpm en CI/CD

pnpm es especialmente adecuado para CI porque es rápido y reutiliza el store global. Sin embargo, en CI cada job suele empezar "limpio", así que hay que configurar bien la caché.

### Configuración base

```bash
# 1. Activar pnpm con Corepack
corepack enable
corepack prepare pnpm@9.0.0 --activate

# 2. Fijar versión en package.json (packageManager)
# 3. Instalar en modo estricto
pnpm install --frozen-lockfile
```

`--frozen-lockfile` es clave: no modifica el lockfile y falla si `package.json` y `pnpm-lock.yaml` no coinciden, garantizando reproducibilidad.

### GitHub Actions

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: pnpm/action-setup@v3
        with:
          version: 9

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'

      - run: pnpm install --frozen-lockfile
      - run: pnpm run lint
      - run: pnpm run test
      - run: pnpm run build
```

### Caché del store

El store de pnpm está en `~/.local/share/pnpm/store` (Linux). Para cachearlo en CI:

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.local/share/pnpm/store
    key: pnpm-${{ runner.os }}-${{ hashFiles('pnpm-lock.yaml') }}
    restore-keys: |
      pnpm-${{ runner.os }}-
```

La acción `actions/setup-node` con `cache: 'pnpm'` ya configura automáticamente esta caché.

### GitLab CI

```yaml
# .gitlab-ci.yml
image: node:20

cache:
  key:
    files:
      - pnpm-lock.yaml
  paths:
    - .pnpm-store/

before_script:
  - corepack enable
  - corepack prepare pnpm@9.0.0 --activate
  - pnpm config set store-dir .pnpm-store
  - pnpm install --frozen-lockfile

test:
  script:
    - pnpm run test
```

## Caché de dependencias

### Por qué importa

Sin caché, cada job descarga todos los paquetes desde el registry, lo que tarda. Con la caché del store, los paquetes ya están en disco y la instalación es casi instantánea (solo symlinks/hardlinks).

### Estrategia de clave de caché

Usa como clave el hash del lockfile para cachear solo cuando las dependencias cambian:

```yaml
key: pnpm-${{ runner.os }}-${{ hashFiles('pnpm-lock.yaml') }}
```

Si el lockfile no cambia, se restaura la caché y `pnpm install` es muy rápido.

### Tamaño del store

```bash
pnpm store path
du -sh $(pnpm store path)    # tamaño del store
```

En CI no suele ser problema, pero en desarrollos largos ejecuta `pnpm store prune` para limpiar.

## Deploy y producción

### Qué instalar en producción

```bash
pnpm install --frozen-lockfile --prod
```

`--prod` instala solo `dependencies`, no `devDependencies`. Esto reduce el tamaño y la superficie de ataque.

### Prune de dependencias

Tras instalar, puedes limpiar el store del proyecto:

```bash
pnpm prune --prod          # elimina paquetes no necesarios en producción
```

### Bundle vs node_modules

Para producción hay dos enfoques:

1. **Instalar dependencias** en el servidor/imagen y ejecutar Node directamente.
2. **Hacer bundle** del código (esbuild, webpack, Vite) e incluir solo el resultado, sin `node_modules`.

El bundle suele ser más eficiente: una sola imagen pequeña, sin reinstalar.

## Docker con pnpm

### Dockerfile básico

```dockerfile
# stage 1: build
FROM node:20-slim AS builder

RUN corepack enable

WORKDIR /app

# Copiar solo los manifiestos para aprovechar la caché de Docker
COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

COPY . .
RUN pnpm run build

# stage 2: producción
FROM node:20-slim AS production

RUN corepack enable

WORKDIR /app

COPY --from=builder /app/package.json /app/pnpm-lock.yaml ./
COPY --from=builder /app/dist ./dist

RUN pnpm install --frozen-lockfile --prod

CMD ["pnpm", "start"]
```

### Multi-stage con pnpm deploy

pnpm tiene el comando `pnpm deploy` para extraer un paquete del workspace con sus dependencias, listo para producción:

```bash
pnpm deploy --filter=@miorg/api --prod ./dist/api
```

Esto genera una carpeta `./dist/api` con el paquete y sus dependencias instaladas, sin devDependencies ni código de otros paquetes.

```dockerfile
FROM node:20-slim AS builder
RUN corepack enable
WORKDIR /app
COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm --filter @miorg/api deploy --prod /tmp/api

FROM node:20-slim
WORKDIR /app
COPY --from=builder /tmp/api ./
CMD ["node", "dist/index.js"]
```

### Caché de Docker con BuildKit

```dockerfile
# syntax=docker/dockerfile:1.6
FROM node:20-slim
RUN corepack enable

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
    pnpm install --frozen-lockfile
```

El `--mount=type=cache` reutiliza el store entre builds, acelerando mucho las construcciones.

## Comparativa: npm vs yarn vs pnpm

| Característica | npm | yarn (classic) | yarn (berry/PnP) | pnpm |
|----------------|-----|----------------|------------------|------|
| Store global | No | No | No (PnP) | Sí |
| Hardlinks | No | No | No | Sí |
| node_modules plano | Sí | Sí | No (PnP) | No (estricto) |
| Phantom deps | Posibles | Posibles | No | No |
| Workspaces | Sí | Sí | Sí | Sí |
| Filtros `--filter` | Limitados | No nativo | Limitados | Potentes |
| Velocidad | Media | Media | Rápida | Rápida |
| Uso de disco | Alto | Alto | Bajo (PnP) | Bajo |
| Lockfile | `package-lock.json` | `yarn.lock` | `yarn.lock` | `pnpm-lock.yaml` |
| CI estricto | `npm ci` | `yarn install --immutable` | `yarn install --immutable` | `pnpm install --frozen-lockfile` |
| Compatibilidad | 100% | 100% | Requiere PnP | 100% |

### Cuándo elegir cada uno

- **npm:** es el estándar, viene con Node, máxima compatibilidad. Apto para proyectos simples.
- **yarn classic:** ya en mantenimiento, migra a berry o pnpm.
- **yarn berry (PnP):** excelente para monorepos grandes, pero el PnP rompe herramientas que esperan `node_modules`.
- **pnpm:** rápido, eficiente, estricto. Muy bueno para monorepos y proyectos donde importa el uso de disco y la reproducibilidad.

## Migrar de npm a pnpm

```bash
# 1. Instalar pnpm
npm install -g pnpm

# 2. Borrar node_modules y lockfile de npm
rm -rf node_modules package-lock.json

# 3. Instalar con pnpm
pnpm install

# 4. Comitea el nuevo pnpm-lock.yaml
```

### Diferencias a tener en cuenta

- Los scripts que usaban `npm run` pueden seguir funcionando, pero pnpm permite `pnpm <script>` directo.
- Reemplaza `npx` por `pnpm dlx` (descargar) o `pnpm exec` (local).
- Si tu código usaba dependencias fantasma, pnpm fallará (lo cual es bueno: arregla declarando lo que faltaba).
- En monorepo, añade `pnpm-workspace.yaml` y usa `workspace:*`.

## Buenas prácticas

1. Usa `--frozen-lockfile` en todos los jobs de CI.
2. Cachea el store con clave basada en el hash del lockfile.
3. En Docker, copia primero los manifiestos para aprovechar la caché de capas.
4. Usa multi-stage builds para no llevar devDependencies a producción.
5. Considera `pnpm deploy` para extraer paquetes del monorepo.
6. Activa Corepack y fija `packageManager` para reproducibilidad.

---

> Anterior: [Scripts y configuración](04-scripts-y-configuracion.md) · Volver al [índice](README.md)
