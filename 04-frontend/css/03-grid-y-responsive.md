# 03 — Grid y Responsive

> CSS Grid, grid-template, áreas, responsive, media queries, mobile-first, container queries.

## Objetivos

- [ ] Crear layouts de dos dimensiones con CSS Grid
- [ ] Usar `grid-template-columns`, `grid-template-rows` y `gap`
- [ ] Definir y colocar áreas con `grid-template-areas`
- [ ] Hacer diseños responsive con media queries
- [ ] Aplicar la estrategia mobile-first
- [ ] Usar `auto-fit`, `minmax` y `clamp`
- [ ] Conocer las container queries

## CSS Grid

Grid organiza elementos en **dos dimensiones** (filas y columnas). Es ideal para layouts de página completos, galerías y dashboards.

```css
.grid {
  display: grid;
  grid-template-columns: 200px 1fr 200px;
  grid-template-rows: auto 1fr auto;
  gap: 16px;
  min-height: 100vh;
}
```

### Conceptos

- **Contenedor grid**: el elemento con `display: grid`.
- **Items grid**: los hijos directos.
- **Líneas**: las líneas que separan columnas y filas.
- **Celdas**: la intersección de fila y columna.
- **Áreas**: regiones con nombre.

## `grid-template-columns` y `rows`

```css
.grid {
  display: grid;
  grid-template-columns: 200px 1fr 1fr;   /* 3 columnas */
  grid-template-rows: 100px 1fr 50px;     /* 3 filas */
  gap: 16px;
}
```

### Unidades en grid

| Unidad | Descripción |
|---|---|
| `px` | Tamaño fijo |
| `fr` | Fracción del espacio disponible |
| `auto` | Se ajusta al contenido |
| `min-content` | Tamaño mínimo del contenido |
| `max-content` | Tamaño máximo del contenido |
| `minmax(min, max)` | Rango entre dos valores |

```css
/* 3 columnas iguales */
.grid { grid-template-columns: 1fr 1fr 1fr; }
/* o */
.grid { grid-template-columns: repeat(3, 1fr); }

/* Sidebar fija + contenido */
.grid { grid-template-columns: 250px 1fr; }

/* Columnas responsivas automáticas */
.grid { grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); }
```

> `repeat(auto-fit, minmax(250px, 1fr))` crea columnas que se ajustan solas: tantas como quepan de mínimo 250px y se reparten el espacio. No necesita media queries.

## `gap`

```css
.grid {
  display: grid;
  gap: 20px;          /* filas y columnas */
  row-gap: 16px;      /* solo filas */
  column-gap: 24px;   /* solo columnas */
}
```

## `grid-template-areas`

Permite nombrar regiones del layout, muy visual y legible.

```css
.layout {
  display: grid;
  grid-template-columns: 200px 1fr;
  grid-template-rows: auto 1fr auto;
  grid-template-areas:
    "header header"
    "nav    main"
    "footer footer";
  min-height: 100vh;
  gap: 12px;
}

.cabecera { grid-area: header; }
.navegacion { grid-area: nav; }
.contenido { grid-area: main; }
.pie { grid-area: footer; }
```

```html
<div class="layout">
  <header class="cabecera">Header</header>
  <nav class="navegacion">Nav</nav>
  <main class="contenido">Main</main>
  <footer class="pie">Footer</footer>
</div>
```

- Un punto (`.`) indica una celda vacía.
- Un área puede ocupar varias celdas repitiendo el nombre.
- Cada fila va entre comillas.

```css
grid-template-areas:
  "header header header"
  "nav    main   aside"
  "footer footer footer";
```

## Colocar items por líneas

```css
.item {
  grid-column: 1 / 3;    /* de la línea 1 a la 3 */
  grid-row: 1 / 2;       /* de la línea 1 a la 2 */
}

/* O con span */
.item {
  grid-column: span 2;   /* ocupa 2 columnas */
}
```

## Alineación en grid

| Propiedad | Afecta a | Valores |
|---|---|---|
| `justify-items` | Items en columna | `start`, `center`, `end`, `stretch` |
| `align-items` | Items en fila | `start`, `center`, `end`, `stretch` |
| `justify-content` | Todo el grid horizontal | `start`, `center`, `space-between` |
| `align-content` | Todo el grid vertical | `start`, `center`, `space-between` |

```css
.grid {
  justify-items: center;
  align-items: stretch;
}
```

## Responsive design

Diseño que se adapta a distintos tamaños de pantalla.

### Meta viewport

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

### Media queries

```css
/* Mobile-first: estilos base para móvil */
body {
  font-size: 16px;
  padding: 12px;
}

/* Tablet */
@media (min-width: 768px) {
  body {
    font-size: 18px;
    padding: 24px;
  }
}

/* Escritorio */
@media (min-width: 1024px) {
  body {
    font-size: 20px;
    padding: 40px;
  }
}
```

### Breakpoints habituales

| Breakpoint | Dispositivo |
|---|---|
| `min-width: 640px` | Móvil grande |
| `min-width: 768px` | Tablet |
| `min-width: 1024px` | Escritorio |
| `min-width: 1280px` | Escritorio grande |

### Estrategia mobile-first

Se empieza con los estilos para móvil (base) y se añaden `min-width` para pantallas mayores. Esto da CSS más pequeño y performante.

```css
/* Mal: desktop-first (sobreescribe mucho) */
.grid { grid-template-columns: repeat(4, 1fr); }
@media (max-width: 768px) { .grid { grid-template-columns: 1fr; } }

/* Bien: mobile-first */
.grid { grid-template-columns: 1fr; }
@media (min-width: 768px) { .grid { grid-template-columns: repeat(2, 1fr); } }
@media (min-width: 1024px) { .grid { grid-template-columns: repeat(4, 1fr); } }
```

### Media queries por características

```css
/* Oscuro */
@media (prefers-color-scheme: dark) {
  body { background: #1a1a1a; color: #fff; }
}

/* Movimiento reducido */
@media (prefers-reduced-motion: reduce) {
  * { animation: none !important; transition: none !important; }
}

/* Orientación */
@media (orientation: landscape) { ... }

/* Puntero fino (ratón) vs grueso (táctil) */
@media (hover: hover) and (pointer: fine) {
  .menu:hover { display: block; }
}
```

## Unidades fluidas

```css
/* Tipografía fluida con clamp */
h1 { font-size: clamp(1.5rem, 5vw, 3rem); }

/* Ancho fluido */
.contenedor { width: clamp(280px, 90%, 1200px); }
```

## Container queries

Las container queries permiten estilar elementos según el tamaño de su **contenedor**, no del viewport. Útil para componentes reutilizables.

```css
/* El contenedor debe declarar containment */
.card-wrapper {
  container-type: inline-size;
}

/* El hijo responde al tamaño del contenedor */
@container (min-width: 400px) {
  .card {
    display: grid;
    grid-template-columns: 120px 1fr;
  }
}
```

```html
<div class="sidebar">
  <div class="card-wrapper">
    <article class="card">...</article>
  </div>
</div>

<div class="main">
  <div class="card-wrapper">
    <article class="card">...</article>
  </div>
</div>
```

> La misma `.card` se adapta de forma distinta en la sidebar (estrecha) y en el main (ancha) sin duplicar media queries.

## Imágenes responsive

```css
img {
  max-width: 100%;
  height: auto;
  display: block;
}
```

```html
<picture>
  <source srcset="hero-mobile.jpg" media="(max-width: 768px)">
  <source srcset="hero-desktop.jpg" media="(min-width: 769px)">
  <img src="hero.jpg" alt="Hero">
</picture>
```

## Patrones responsive con grid

### Layout completo adaptativo

```css
.layout {
  display: grid;
  grid-template-areas:
    "header"
    "nav"
    "main"
    "footer";
  min-height: 100vh;
}

@media (min-width: 768px) {
  .layout {
    grid-template-columns: 200px 1fr;
    grid-template-areas:
      "header header"
      "nav    main"
      "footer footer";
  }
}
```

### Galería de tarjetas responsiva

```css
.galeria {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
}
```

## Conceptos clave

- Grid es para dos dimensiones; flexbox para una.
- `fr` reparte el espacio disponible proporcionalmente.
- `repeat(auto-fit, minmax(...))` crea grids responsivas sin media queries.
- `grid-template-areas` hace el layout visual y legible.
- Mobile-first da CSS más pequeño y fácil de mantener.
- `clamp()` crea valores fluidos entre dos límites.
- Las container queries adaptan componentes según su contenedor, no el viewport.
- `prefers-reduced-motion` respeta a usuarios sensibles al movimiento.

## Errores comunes

- **Usar `px` fijos en columnas**: mejor `fr` o `minmax`.
- **Olvidar el meta viewport**: la web no se adapta al móvil.
- **Desktop-first**: genera CSS sobrante y conflictos.
- **No usar `auto-fit`/`minmax`**: grids que no se adaptan.
- **Olvidar `container-type`**: las container queries no funcionan.
- **Anidar grids innecesariamente**: complica el layout.
- **No respetar `prefers-reduced-motion`**: molesta a usuarios sensibles.
- **`grid-column` con líneas mal numeradas**: los items se descolocan.
- **Olvidar `min-height: 0`** en items grid con overflow: el contenido desborda.
