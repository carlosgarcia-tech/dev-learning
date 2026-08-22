# 05 — Arquitectura y producción

> Metodologías (BEM, SMACSS, ITCSS), CSS Modules, Tailwind, Sass/SCSS, PostCSS, variables CSS, theming, performance.

## Objetivos

- [ ] Organizar CSS a gran escala con metodologías
- [ ] Aplicar BEM para nombrar clases de forma predecible
- [ ] Entender SMACSS e ITCSS
- [ ] Usar CSS Modules para encapsulamiento
- [ ] Conocer Tailwind CSS y el enfoque utility-first
- [ ] Escribir Sass/SCSS con variables, anidamiento y mixins
- [ ] Procesar CSS con PostCSS
- [ ] Crear temas con variables CSS
- [ ] Optimizar CSS para producción

## El problema del CSS a escala

Sin metodología, el CSS se vuelve:
- Difícil de mantener (estilos duplicados).
- Frágil (cambios rompen otras partes).
- Específico en exceso (`!important` por todas partes).

Las metodologías dan **reglas de nombrado y organización** para evitarlo.

## BEM (Block Element Modifier)

BEM divide la interfaz en bloques, elementos y modificadores.

```
.bloque               /* entidad independiente */
.bloque__elemento     /* parte del bloque */
.bloque--modificador  /* variación del bloque o elemento */
```

```html
<!-- Bloque -->
<div class="tarjeta">
  <!-- Elemento -->
  <img class="tarjeta__imagen" src="..." alt="...">
  <h3 class="tarjeta__titulo">Título</h3>
  <p class="tarjeta__texto">Texto</p>
  <!-- Modificador -->
  <button class="tarjeta__boton tarjeta__boton--destacado">Comprar</button>
</div>

<!-- Modificador del bloque -->
<div class="tarjeta tarjeta--oscuro">...</div>
```

```css
.tarjeta { border: 1px solid #ddd; padding: 16px; border-radius: 8px; }
.tarjeta__imagen { width: 100%; }
.tarjeta__titulo { font-size: 1.2rem; }
.tarjeta__boton { background: #3b82f6; color: white; }
.tarjeta__boton--destacado { background: #ef4444; }
.tarjeta--oscuro { background: #1a1a1a; color: white; }
```

| Ventaja | Por qué |
|---|---|
| Predecible | El nombre describe qué es |
| Reutilizable | Los bloques son independientes |
| Sin conflictos | Baja especificidad |
| Fácil de mantener | Sabes dónde está cada estilo |

## SMACSS

SMACSS (Scalable and Modular Architecture for CSS) categoriza el CSS en cinco tipos:

| Categoría | Qué contiene | Ejemplo |
|---|---|---|
| **Base** | Reset y estilos de etiqueta | `body`, `a`, `h1` |
| **Layout** | Estructura de la página | `.header`, `.sidebar`, `.grid` |
| **Module** | Componentes reutilizables | `.tarjeta`, `.boton`, `.navbar` |
| **State** | Estados (prefijo `is-`) | `.is-active`, `.is-hidden`, `.is-loading` |
| **Theme** | Temas visuales | `.tema-oscuro` |

```css
/* Base */
body { margin: 0; font-family: sans-serif; }
a { color: #3b82f6; }

/* Layout */
.header { display: flex; }
.sidebar { width: 250px; }

/* Module */
.tarjeta { border: 1px solid #ddd; padding: 16px; }

/* State */
.tarjeta.is-active { border-color: #3b82f6; }
.is-hidden { display: none; }
```

## ITCSS

ITCSS (Inverted Triangle CSS) organiza el CSS por niveles de especificidad, de lo más genérico a lo más específico:

```
1. Settings   (variables)
2. Tools      (mixins, funciones)
3. Generic    (reset, normalize)
4. Elements   (etiquetas: h1, a, body)
5. Objects    (patrones abstractos: .container, .media)
6. Components (.tarjeta, .navbar, .boton)
7. Utilities  (.text-center, .mt-4)
```

```css
/* 1. Settings */
:root { --color-primario: #3b82f6; }

/* 4. Elements */
h1 { font-size: 2rem; }

/* 5. Objects */
.container { max-width: 1200px; margin: 0 auto; }

/* 6. Components */
.boton { padding: 12px 24px; border-radius: 8px; }

/* 7. Utilities */
.text-center { text-align: center; }
.mt-4 { margin-top: 16px; }
```

## CSS Modules

CSS Modules genera clases únicas automáticamente, evitando colisiones. Se usa con bundlers (Webpack, Vite).

```css
/* Boton.module.css */
.boton {
  background: #3b82f6;
  padding: 12px 24px;
}
.destacado {
  background: #ef4444;
}
```

```jsx
import styles from './Boton.module.css';

function Boton() {
  return <button className={`${styles.boton} ${styles.destacado}`}>Comprar</button>;
}
```

> El bundler renombra `.boton` a algo como `Boton_boton__a3f2x`, único y sin colisiones.

## Tailwind CSS

Tailwind es un framework **utility-first**: en vez de componentes predefinidos, ofrece clases de utilidad pequeñas que se combinan.

```html
<button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
  Botón
</button>

<div class="grid grid-cols-1 md:grid-cols-3 gap-4">
  <div class="p-6 bg-white rounded-lg shadow">Card 1</div>
  <div class="p-6 bg-white rounded-lg shadow">Card 2</div>
  <div class="p-6 bg-white rounded-lg shadow">Card 3</div>
</div>
```

```css
/* tailwind.config.js para personalizar */
module.exports = {
  theme: {
    extend: {
      colors: {
        primario: '#3b82f6',
      }
    }
  }
}
```

| Ventaja | Desventaja |
|---|---|
| Desarrollo rápido | HTML con muchas clases |
| Sin colisiones | Curva de aprendizaje |
| Bundle pequeño (purge) | Difícil de leer para principiantes |
| Consistencia | Hay que aprender las utilidades |

### `@apply` para extraer componentes

```css
/* En Tailwind se pueden combinar utilidades en una clase */
@layer components {
  .btn-primario {
    @apply bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded;
  }
}
```

## Sass / SCSS

Sass es un preprocesador que añade variables, anidamiento, mixins y funciones al CSS. SCSS es su sintaxis (compatible con CSS).

```scss
// Variables
$color-primario: #3b82f6;
$espaciado: 16px;

// Anidamiento
.tarjeta {
  background: white;
  padding: $espaciado;
  border-radius: 8px;

  &__titulo {          // .tarjeta__titulo
    font-size: 1.2rem;
  }

  &--destacado {       // .tarjeta--destacado
    border-color: $color-primario;
  }

  &:hover {            // .tarjeta:hover
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  }
}

// Mixins
@mixin flex-center {
  display: flex;
  justify-content: center;
  align-items: center;
}

.hero {
  @include flex-center;
  min-height: 100vh;
}

// Bucles y condicionales
@for $i from 1 through 3 {
  .col-#{$i} {
    width: 100% / $i;
  }
}

// Partials (_variables.scss, _mixins.scss)
@import 'variables';
@import 'mixins';
```

### Variables en Sass vs CSS

```scss
// Sass: compiladas, no cambian en runtime
$color: #3b82f6;

// CSS: dinámicas, se pueden cambiar con JS
:root { --color: #3b82f6; }
```

> Hoy muchas variables de Sass se pueden sustituir por variables CSS, que además permiten theming dinámico.

## PostCSS

PostCSS transforma CSS con plugins. Puede añadir autoprefijos, variables anidadas, etc.

```json
// postcss.config.js
module.exports = {
  plugins: [
    require('autoprefixer'),          // añade -webkit-, -moz-
    require('postcss-nested'),        // anidamiento nativo
    require('cssnano')                 // minificación
  ]
}
```

```css
/* input */
.tarjeta {
  &__titulo { font-size: 1.2rem; }
  display: flex;
}

/* output tras PostCSS */
.tarjeta__titulo { font-size: 1.2rem; }
.tarjeta { display: -webkit-box; display: -ms-flexbox; display: flex; }
```

## Variables CSS y theming

```css
:root {
  --color-fondo: #ffffff;
  --color-texto: #1a1a1a;
  --color-primario: #3b82f6;
  --espaciado-base: 16px;
  --fuente: 'Inter', sans-serif;
}

body {
  background: var(--color-fondo);
  color: var(--color-texto);
  font-family: var(--fuente);
}

/* Tema oscuro */
[data-tema="oscuro"] {
  --color-fondo: #1a1a1a;
  --color-texto: #ffffff;
  --color-primario: #60a5fa;
}
```

```html
<body data-tema="claro">
  <button onclick="document.body.dataset.tema = 'oscuro'">🌙</button>
</body>
```

```js
// Cambiar tema con JS
document.documentElement.style.setProperty('--color-primario', '#ef4444');
```

### Theming con `prefers-color-scheme`

```css
:root {
  --bg: white;
  --texto: #1a1a1a;
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg: #1a1a1a;
    --texto: white;
  }
}

body { background: var(--bg); color: var(--texto); }
```

## Performance de CSS

### Minificación

Herramientas como `cssnano`, `esbuild` o `lightningcss` eliminan espacios, comentarios y simplifican valores.

```css
/* Antes */
.caja {
  margin-top: 10px;
  margin-right: 10px;
  margin-bottom: 10px;
  margin-left: 10px;
}

/* Después */
.caja { margin: 10px; }
```

### Critical CSS

Extraer el CSS "above the fold" (visible al cargar) e inlinedarlo en el `<head>` para mejorar LCP.

```html
<head>
  <style>
    /* CSS crítico inline */
    body { margin: 0; }
    .hero { height: 100vh; background: #3b82f6; }
  </style>
  <link rel="stylesheet" href="resto.css" media="print" onload="this.media='all'">
</head>
```

### Reducir selectores

```css
/* Mal: demasiado específico */
.header nav ul li a { color: blue; }

/* Bien: directo */
.nav-link { color: blue; }
```

### Evitar `@import`

```css
/* Lento: bloquea la carga */
@import url('reset.css');
@import url('layout.css');

/* Mejor: combinar en un solo archivo en build */
```

## Tabla comparativa de enfoques

| Enfoque | Escalabilidad | Curva | Mejor para |
|---|---|---|---|
| BEM | Alta | Baja | Equipos que quieren convenciones simples |
| SMACSS | Alta | Media | Proyectos medianos/grandes |
| ITCSS | Muy alta | Alta | Proyectos muy grandes |
| CSS Modules | Alta | Baja | Apps con bundler |
| Tailwind | Alta | Media | Prototipado y equipos que gustan de utility-first |
| Sass/SCSS | Alta | Media | Variables, mixins y anidamiento |

## Conceptos clave

- BEM nombra por bloque, elemento y modificador: predecible y reutilizable.
- SMACSS categoriza en base, layout, module, state y theme.
- ITCSS organiza por niveles de especificidad creciente.
- CSS Modules encapsula clases generando nombres únicos.
- Tailwind usa utilidades pequeñas y combinables.
- Sass añade variables, anidamiento y mixins al CSS.
- Las variables CSS permiten theming dinámico sin recompilar.
- PostCSS transforma el CSS con plugins (autoprefixer, minificación).

## Errores comunes

- **Anidamiento excesivo en Sass** (`& > div > span > a`): CSS frágil y muy específico.
- **Abusar de `!important`**: señal de problemas de especificidad.
- **No usar BEM en proyectos grandes**: clases colisionan y se duplican.
- **Variables Sass para temas dinámicos**: no cambian en runtime, usar CSS vars.
- **`@import` en CSS de producción**: bloquea la carga.
- **Selectores largos** (`.header .nav ul li a`): lentos y frágiles.
- **No purgar CSS no usado**: el bundle final es grande.
- **Olvidar autoprefixer**: estilos no funcionan en navegadores antiguos.
- **CSS Modules y clases dinámicas mal**: se rompen los nombres.
- **Tailwind sin configurar purge**: el bundle es enorme.
