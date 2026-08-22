# 05 — Módulos y bundlers

> ES modules, import/export, dynamic import, bundlers (Webpack, Vite, esbuild), tree shaking, code splitting.

## Objetivos

- [ ] Entender qué son los ES modules
- [ ] Usar `import` y `export` correctamente
- [ ] Hacer imports dinámicos (lazy loading)
- [ ] Conocer qué hace un bundler
- [ ] Diferenciar Webpack, Vite y esbuild
- [ ] Aplicar tree shaking y code splitting
- [ ] Configurar un proyecto con Vite

## ES Modules

Los ES modules (ESM) son el sistema de módulos nativo de JavaScript. Permiten dividir el código en archivos y reutilizarlo.

### `export`

```js
// math.js

// Export nombrado
export const PI = 3.14159;

export function sumar(a, b) {
  return a + b;
}

export class Calculadora {
  sumar(a, b) { return a + b; }
}

// Export agrupado
const restar = (a, b) => a - b;
const multiplicar = (a, b) => a * b;
export { restar, multiplicar };

// Renombrar al exportar
export { multiplicar as multi };
```

### `export default`

Un módulo puede tener un export por defecto (único).

```js
// saludo.js
export default function saludar(nombre) {
  return `Hola, ${nombre}`;
}
```

```js
// log.js
const logger = (msg) => console.log(msg);
export default logger;
```

### `import`

```js
// Import nombrado
import { sumar, PI } from './math.js';

// Import default
import saludar from './saludo.js';

// Import default + nombrado
import logger, { sumar } from './utils.js';

// Importar todo con namespace
import * as math from './math.js';
math.sumar(1, 2);
math.PI;

// Renombrar al importar
import { sumar as add } from './math.js';
```

### Re-exportar

```js
// index.js (barrel file)
export { sumar, restar } from './math.js';
export { default as saludar } from './saludo.js';
```

### Usar en el navegador

```html
<!-- type="module" es obligatorio -->
<script type="module" src="app.js"></script>
```

```js
// app.js
import { sumar } from './math.js';
console.log(sumar(2, 3));
```

| Característica de los ES modules |
|---|
| `defer` por defecto (se ejecutan tras parsear el HTML) |
| `strict mode` por defecto |
| Las rutas relativas necesitan extensión (`./math.js`) |
| Cada módulo se evalúa una sola vez (singleton) |
| Live binding: los imports reflejan cambios en el export |

## Dynamic import

Carga un módulo bajo demanda, devolviendo una promesa. Ideal para code splitting.

```js
// Import estático (se carga al inicio)
import { sumar } from './math.js';

// Import dinámico (se carga cuando se necesita)
const modulo = await import('./math.js');
modulo.sumar(2, 3);
```

```js
// Cargar un módulo al hacer clic
boton.addEventListener('click', async () => {
  const { default: editor } = await import('./editor.js');
  editor.abrir();
});

// Cargar solo en escritorio
if (window.innerWidth > 1024) {
  const { initCharts } = await import('./charts.js');
  initCharts();
}
```

> Los imports dinámicos generan chunks separados en el bundler, reduciendo el bundle inicial.

## Bundlers

Un **bundler** combina todos los módulos en uno o varios archivos optimizados para producción.

### ¿Qué hace un bundler?

1. **Resolución de módulos**: sigue los `import` y junta todo.
2. **Transformación**: transpila (Babel/TypeScript) y añade prefijos.
3. **Tree shaking**: elimina código no usado.
4. **Code splitting**: divide el bundle en chunks.
5. **Minificación**: elimina espacios y acorta nombres.
6. **Assets**: procesa CSS, imágenes, fuentes.

### Webpack

El bundler más establecido. Potente pero con configuración compleja.

```js
// webpack.config.js
module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'bundle.[contenthash].js',
    path: __dirname + '/dist'
  },
  module: {
    rules: [
      { test: /\.css$/, use: ['style-loader', 'css-loader'] },
      { test: /\.js$/, exclude: /node_modules/, use: 'babel-loader' }
    ]
  }
};
```

### Vite

Vite usa ES modules nativos en desarrollo (instantáneo) y esbuild/Rollup para producción.

```bash
npm create vite@latest mi-app -- --template vanilla
```

```js
// vite.config.js
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [],
  build: {
    outDir: 'dist',
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom']
        }
      }
    }
  }
});
```

| Ventaja de Vite | Por qué |
|---|---|
| Dev server instantáneo | Sirve módulos sin bundlear |
| HMR rápido | Recarga solo lo cambiado |
| Build optimizado | Rollup + esbuild |
| Config sencilla | Cero config por defecto |

### esbuild

esbuild es un bundler/transpilador escrito en Go, extremadamente rápido.

```bash
# Transpilar un archivo
esbuild app.js --bundle --outfile=dist/app.js --minify

# Servidor de desarrollo
esbuild app.js --bundle --served
```

| Bundler | Velocidad | Config | Mejor para |
|---|---|---|---|
| Webpack | Media | Compleja | Proyectos grandes legacy |
| Vite | Muy rápida | Simple | Proyectos modernos |
| esbuild | Extrema | Mínima | Builds rápidos y librerías |
| Rollup | Rápida | Media | Librerías (output limpio) |

## Tree shaking

Elimina el código que no se usa del bundle final.

```js
// utils.js
export function usar(a) { return a; }
export function noUsar(a) { return a * 2; }  // esta no se usa
```

```js
// app.js
import { usar } from './utils.js';
console.log(usar(5));
// noUsar no se incluye en el bundle
```

> Para que el tree shaking funcione, usa `import`/`export` (ESM) y evita efectos secundarios en los módulos. Marca `"sideEffects": false` en `package.json`.

```json
{
  "name": "mi-lib",
  "sideEffects": false
}
```

## Code splitting

Divide el bundle en chunks más pequeños que se cargan bajo demanda.

### Por rutas

```js
// Cargar la página de contacto solo cuando se navega
const contacto = await import('./paginas/contacto.js');
```

### Manual chunks

```js
// vite.config.js / rollup
export default {
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          react: ['react', 'react-dom'],
          utils: ['lodash', 'date-fns']
        }
      }
    }
  }
};
```

### Dynamic import con React.lazy

```jsx
const Contacto = lazy(() => import('./Contacto'));

<Suspense fallback={<Spinner />}>
  <Contacto />
</Suspense>
```

## Cargar JavaScript en el HTML

```html
<!-- Normal: bloquea el parseo -->
<script src="app.js"></script>

<!-- Defer: se ejecuta tras parsear el HTML (recomendado para módulos) -->
<script src="app.js" defer></script>

<!-- Async: se ejecuta en cuanto carga (no garantiza orden) -->
<script src="analytics.js" async></script>

<!-- Módulo (defer por defecto) -->
<script type="module" src="app.js"></script>
```

| Atributo | Cuándo se ejecuta | Orden | Para qué |
|---|---|---|---|
| (nada) | Inmediatamente | Aparición | — |
| `defer` | Tras parsear HTML | Orden | Scripts principales |
| `async` | Al cargar | Cualquiera | Analytics, ads |
| `type="module"` | Tras parsear HTML | Orden | ES modules |

## Conceptos clave

- Los ES modules son nativos: `import`/`export` en archivos `.js`.
- `export default` es uno por módulo; los nombrados pueden ser varios.
- Dynamic import (`await import(...)`) carga módulos bajo demanda.
- Vite usa ESM nativo en dev (instantáneo) y Rollup para producción.
- Tree shaking elimina código no usado (requiere ESM y sin side effects).
- Code splitting divide el bundle en chunks cargables bajo demanda.
- `defer` y `type="module"` no bloquean el render del HTML.

## Errores comunes

- **Olvidar `type="module"`**: los `import` no funcionan en el navegador.
- **Rutas sin extensión**: en ESM del navegador hace falta `.js`.
- **Importar todo** (`import * as`): imposibilita el tree shaking.
- **Side effects en módulos**: el bundler no puede eliminar código.
- **Bundle único enorme**: sin code splitting, todo se carga al inicio.
- **Usar `require`**: es CommonJS, no ESM (no funciona en navegador directamente).
- **No minificar en producción**: bundle grande y lento.
- **`async` en scripts con dependencias**: el orden no está garantizado.
- **Cargar polyfills sin necesidad**: navegadores modernos no los necesitan.
