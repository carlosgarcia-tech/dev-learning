# Estructura y content-addressable

> El store global de pnpm, hardlinks, symlinks y por qué su `node_modules` evita dependencias fantasma.

## El problema del node_modules clásico

En npm (y yarn clásico), `node_modules` es **plano**: todas las dependencias, incluidas las transitivas, se colocan en la raíz de `node_modules/`.

```
node_modules/
├── express/
├── accepts/      <- dependencia de express, accesible por accidente
├── qs/           <- dependencia de express, accesible por accidente
└── ...
```

Esto causa dos problemas:

1. **Dependencias fantasma (phantom dependencies):** puedes `import` un paquete que no declaraste, porque está ahí por ser subdependencia de otra. Si esa subdependencia desaparece al actualizar, tu código se rompe.
2. **Dependencias falsas (illegitimate):** un paquete puede acceder a otro que no declaró, solo por estar en el mismo `node_modules`.

## El store global

pnpm mantiene un **store** central donde cada paquete se guarda **una sola vez** en todo el sistema, indexado por su contenido (content-addressable).

### Ubicación

```bash
pnpm store path       # ruta del store
# Linux:   ~/.local/share/pnpm/store
# macOS:   ~/Library/pnpm/store
# Windows: %LOCALAPPDATA%\pnpm\store
```

### Content-addressable

Cada paquete se guarda en una ruta basada en un **hash** de su contenido. Dos proyectos que dependan de la misma versión de `express` compartirán el mismo ejemplar en el store. Si dos paquetes tienen el mismo `package.json` y archivos idénticos, ocupan el mismo slot.

```
store/v3/files/00/0c3f...   <- fragmentos indexados por hash
```

Esto significa que:

- La primera instalación descarga los paquetes.
- Las siguientes instalaciones de los mismos paquetes **no descargan nada**.
- Los proyectos no duplican datos.

## Hardlinks

Un **hardlink** es una entrada en el sistema de archivos que apunta a los mismos datos en disco que otro archivo, sin duplicarlos.

```
store/express-4.18.2/package.json   (archivo real)
        ^
        |-- hardlink
        |
proyecto/node_modules/.pnpm/express@4.18.2/node_modules/express/package.json
```

- Editar uno no afecta al otro (los hardlinks son referencias independientes a los mismos datos).
- Ocupan cero bytes extra.
- pnpm los usa para "instalar" paquetes sin copiarlos.

### Limitaciones de hardlinks

- Solo funcionan **dentro del mismo sistema de archivos** (partición/mount).
- Si tu proyecto está en otra partición que el store, pnpm hace **copy** o usa **reflinks** (CoW) si el filesystem lo soporta (ej: Btrfs, APFS).

## Symlinks

Un **symlink** (symbolic link o enlace simbólico) es un archivo especial que apunta a otra ruta. pnpm los usa para estructurar `node_modules`.

```
node_modules/express  ->  .pnpm/express@4.18.2/node_modules/express
                      (symlink)
```

Node.js resuelve los symlinks al hacer `require`/`import`, así que el código funciona normalmente.

## La estructura virtual de node_modules

pnpm crea una estructura en `.pnpm/` donde cada paquete tiene su propia carpeta con **exactamente** sus dependencias declaradas, como symlinks a otras carpetas de `.pnpm/`.

```
node_modules/
├── .pnpm/
│   ├── express@4.18.2/
│   │   └── node_modules/
│   │       ├── express/                    <- hardlink al store
│   │       ├── accepts -> ../../accepts@1.3.8/node_modules/accepts
│   │       ├── body-parser -> ../../body-parser@1.20.1/...
│   │       └── ...
│   ├── accepts@1.3.8/
│   │   └── node_modules/
│   │       ├── accepts/                    <- hardlink al store
│   │       └── mime-types -> ../../mime-types@2.1.35/...
│   └── ...
├── express -> .pnpm/express@4.18.2/node_modules/express   (symlink)
└── lodash -> .pnpm/lodash@4.17.21/node_modules/lodash     (symlink)
```

### Qué consigue esto

1. **Solo lo declarado es accesible:** en la raíz de `node_modules/` solo hay symlinks a los paquetes que tu `package.json` declara directamente. No puedes importar subdependencias por accidente.
2. **Cada paquete ve exactamente sus dependencias:** `express` solo puede importar `accepts` si lo declaró en su `package.json`.
3. **Reproducibilidad:** el árbol es determinista y fiel al lockfile.

## Ventajas de esta estructura

### Sin dependencias fantasma

Si intentas `import 'accepts'` sin haberlo declarado, pnpm lanza un error porque `accepts` no está en tu `node_modules/` raíz (solo está dentro de `express`).

Esto fuerza a declarar todas las dependencias y hace el proyecto más robusto.

### Detección de paquetes no usados

```bash
pnpm why accepts       # quién depende de accepts
```

### Versiones múltiples

Si dos paquetes requieren versiones distintas de `qs` (ej: `qs@6.11.0` y `qs@6.5.0`), pnpm instala **ambas** en `.pnpm/` y cada una enlaza a la que le corresponde. No hay conflictos.

```
.pnpm/
├── express@4.18.2/node_modules/qs -> ../../qs@6.11.0/...
└── old-lib@1.0.0/node_modules/qs -> ../../qs@6.5.0/...
```

## peerDependencies

Las **peer dependencies** son paquetes que tu paquete espera que consuma el proyecto final (ej: un plugin de React pide `react` como peer, no lo instala él mismo).

pnpm tiene una postura estricta: por defecto, si un paquete tiene una peer dependency no satisfecha, pnpm da **warning** o error.

### Auto-install peers

Desde pnpm v7, por defecto instala automáticamente las peer dependencies:

```ini
# .npmrc
auto-install-peers=true   # por defecto true desde v7
```

### peerDependenciesMeta

Puedes marcar una peer como opcional:

```json
{
  "peerDependencies": {
    "react": ">=16"
  },
  "peerDependenciesMeta": {
    "react": { "optional": true }
  }
}
```

## Hoisting en pnpm

Aunque pnpm es estricto por defecto, a veces necesitas relajarlo porque un paquete asume que está en un `node_modules` plano (como en npm).

### .npmrc

```ini
# Relajar el aislamiento (simular npm)
node-linker=hoisted
# o
shamefully-hoist=true
```

| Opción | Efecto |
|--------|--------|
| `shamefully-hoist=true` | Sube todo a la raíz como npm (evita errores pero pierde el aislamiento) |
| `hoist=true` | Sube subdeps a `.pnpm/node_modules/` (no a la raíz) |
| `hoist-pattern[]=*eslint*` | Sube solo los paquetes que coincidan |
| `public-hoist-pattern[]=*types*` | Expone tipos en la raíz |

### Cuando usar shamefully-hoist

- Herramientas antiguas que escanean `node_modules` plano (algunos bundlers, herramientas de test).
- Paquetes que usan `require.resolve` con rutas asumidas.
- Como solución temporal mientras migras a un manejo más estricto.

> El objetivo a largo plazo es **no necesitar shamefully-hoist**. Si lo activas, es señal de que algo asume una estructura plana.

## Inspeccionar el store

```bash
pnpm store path              # ruta
pnpm store status            # verificar integridad
pnpm store prune             # eliminar paquetes no referenciados por ningún proyecto
pnpm store add <pkg>         # añadir manualmente un paquete al store
```

## Buenas prácticas

1. Confía en la estructura estricta: declara todas tus dependencias.
2. Usa `pnpm why` para entender por qué algo está instalado.
3. Limpia el store periódicamente con `pnpm store prune`.
4. Solo activa `shamefully-hoist` si una herramienta antigua lo exige.
5. Verifica que el store está en la misma partición que tus proyectos para aprovechar hardlinks.

---

> Anterior: [Fundamentos](01-fundamentos.md) · Siguiente: [Workspaces y monorepo](03-workspaces-y-monorepo.md)
