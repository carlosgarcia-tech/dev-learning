# Publicación y scoping

> Cómo publicar paquetes en el registro de npm, scoped packages, `.npmrc`, accesibilidad y versionado de publicaciones.

## El registro de npm

El **registry** de npm es el repositorio público donde se publican y consumen los paquetes. La URL por defecto es `https://registry.npmjs.org/`.

```bash
npm config get registry     # ver el registry actual
npm config set registry https://registry.npmjs.org/
```

También existen **registries privados**: GitHub Packages, Verdaccio, Artifactory, Nexus. Cada uno con su URL.

## Crear una cuenta y autenticarse

```bash
npm adduser                 # crea cuenta o inicia sesión (interactivo)
npm login                   # alias moderno
npm whoami                  # ¿qué usuario estoy autenticado?
npm logout
```

Al iniciar sesión, npm guarda un **token** en `~/.npmrc`:

```
//registry.npmjs.org/:_authToken=npm_xxxxxxxxxxxxx
```

> ⚠️ Nunca commitees un token. Si usas CI/CD, guárdalo como secret.

## Preparar el package.json para publicar

```json
{
  "name": "@miusuario/mipaquete",
  "version": "1.0.0",
  "description": "Qué hace el paquete",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "files": ["dist"],
  "keywords": ["utilidad", "cli"],
  "author": "Tu Nombre <tu@email.com>",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/usuario/mipaquete.git"
  },
  "homepage": "https://github.com/usuario/mipaquete#readme",
  "bugs": {
    "url": "https://github.com/usuario/mipaquete/issues"
  },
  "engines": {
    "node": ">=18"
  },
  "publishConfig": {
    "access": "public"
  }
}
```

### Campos clave para publicación

| Campo | Para qué |
|-------|----------|
| `name` | Nombre único en el registry (scoped o no) |
| `version` | Debe ser mayor que la última publicada |
| `main` | Punto de entrada (CommonJS) |
| `module` / `exports` | Puntos de entrada modernos (ESM) |
| `types` | Definiciones TypeScript |
| `files` | Qué carpetas/archivos incluir en el paquete |
| `bin` | Binarios instalables (para CLIs) |
| `publishConfig` | Configuración al publicar (registry, access) |

## Scoped packages

Un **scope** es un prefijo `@usuario/` que agrupa tus paquetes. Útil para evitar colisiones de nombres y para paquetes privados.

```json
{ "name": "@miproyecto/utils" }
```

- El scope coincide con tu nombre de usuario u organización en npm.
- Los paquetes scoped **sin cuenta Pro** son públicos por defecto (npm ya no requiere cuenta de pago para públicos scoped).
- Los paquetes **privados** (no accesibles públicamente) requieren una cuenta de pago u organización.

### Instalar scoped

```bash
npm install @miproyecto/utils
npm install @miproyecto/utils@1.2.0
```

## npm publish

Publica la versión actual del `package.json` en el registry.

```bash
npm publish                # publica en el registry por defecto
npm publish --access public   # forzar público para un scoped
npm publish --access restricted  # paquete privado
```

### Qué se publica

- Lo que diga el campo `files` (si existe).
- Si no hay `files`, se incluye casi todo salvo lo que ignore `.npmignore` o `.gitignore`.
- Siempre se incluyen: `package.json`, `README`, `LICENSE`, `CHANGELOG`.

### Ver antes de publicar

```bash
npm pack                    # genera el .tgz exacto que se publicaría
npm pack --dry-run          # lista qué archivos se incluirían, sin crear el tgz
tar -tzf mipaquete-1.0.0.tgz   # inspeccionar el contenido del tarball
```

### Versionado de publicaciones

Cada publicación debe tener una versión **mayor** que la última publicada. No se puede republicar la misma versión.

```bash
npm version patch           # 1.0.0 -> 1.0.1  (crea commit y tag)
npm version minor           # 1.0.1 -> 1.1.0
npm version major           # 1.1.0 -> 2.0.0
npm version prerelease      # 2.0.0 -> 2.0.0-0
```

`npm version` actualiza `package.json`, crea un commit de git y una etiqueta (tag) con la nueva versión (si estás en un repo git).

## Ciclo de publicación típico

```bash
# 1. Asegurar versión nueva
npm version patch            # sube de 1.0.0 a 1.0.1

# 2. Ver qué se va a publicar
npm pack --dry-run

# 3. Publicar
npm publish

# 4. (opcional) publicar con un tag distinto
npm publish --tag beta
```

### Dist-tags

Las **distribution tags** permiten publicar versiones bajo etiquetas que no sean `latest`.

```bash
npm publish --tag next       # publica como "next" en vez de "latest"
npm publish --tag beta
npm dist-tag ls              # listar tags
npm dist-tag add mipaquete@1.2.0 latest    # mover latest
```

```bash
npm install mipaquete@next    # instalar la versión etiquetada "next"
```

## .npmrc

Archivo de configuración de npm. Puede estar en tres niveles:

| Ubicación | Ámbito |
|-----------|--------|
| `./.npmrc` (proyecto) | Solo ese proyecto |
| `~/.npmrc` (usuario) | Todos tus proyectos |
| `/etc/npmrc` (global) | Todo el sistema |

### Directivas comunes

```ini
# Usar otro registry
registry=https://registry.npmjs.org/

# Autenticación con token
//registry.npmjs.org/:_authToken=npm_xxxxxxxxxxxxx

# Autenticación para GitHub Packages
@miorg:registry=https://npm.pkg.github.com/
//npm.pkg.github.com/:_authToken=ghp_xxxxxxxxxxxxx

# Acceso por defecto para scoped
access=public

# Ignorar scripts de postinstall (seguridad)
ignore-scripts=false

# Guardar exacto por defecto
save-exact=true

# Prefijo de instalación global
prefix=${HOME}/.npm-global
```

### Configuración por scope

```ini
@miorg:registry=https://npm.pkg.github.com/
//npm.pkg.github.com/:_authToken=${GITHUB_TOKEN}
```

Esto hace que los paquetes `@miorg/*` se busquen en GitHub Packages y el resto en el registry público.

## Despublicar

```bash
npm unpublish <paquete> --force     # dentro de las 72h tras publicar
```

- Solo puedes despublicar en las primeras **72 horas** o si ningún otro paquete depende de él.
- Pasado ese tiempo, por políticas de seguridad del ecosistema, no se permite.
- Alternativa: `npm deprecate <paquete> "mensaje"` marca el paquete como obsoleto sin borrarlo.

```bash
npm deprecate mipaquete "Usa mipaquete-v2 en su lugar"
npm deprecate mipaquete@1.0.0 "Esta versión tiene un bug crítico"
```

## Buenas prácticas

1. Usa `npm pack --dry-run` antes de publicar para ver qué se incluye.
2. Define `files` para publicar solo lo necesario (evita subir tests, configs, etc.).
3. Incluye `README.md`, `LICENSE` y `CHANGELOG.md`.
4. Versiona con `npm version` para mantener semver y tags de git.
5. Usa `dist-tags` para publicar previews (`next`, `beta`).
6. Protege tus tokens: nunca los commitees.
7. Considera `provenance` (firmas de procedencia) para dar confianza.

---

> Anterior: [Dependencias y scripts](02-dependencias-y-scripts.md) · Siguiente: [Auditoría y seguridad](04-auditoria-y-seguridad.md)
