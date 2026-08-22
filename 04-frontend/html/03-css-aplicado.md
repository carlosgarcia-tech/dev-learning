# 03 — CSS aplicado al HTML

> Estilos inline/internos/externos, selectores, box model, flexbox, grid, responsive design, media queries, animaciones.

## Objetivos

- [ ] Conectar CSS al HTML de tres formas
- [ ] Entender los selectores y la cascada básica
- [ ] Dominar el box model (margin, border, padding, content)
- [ ] Usar flexbox para alinear y distribuir elementos
- [ ] Construir layouts con CSS Grid
- [ ] Hacer diseños responsive con media queries
- [ ] Aplicar transiciones y animaciones básicas

> Esta guía es un repaso de CSS **aplicado desde HTML**. Para profundizar, consulta el tema completo [`../css/`](../css/).

## Formas de aplicar CSS

### 1. Externo (recomendado)

```html
<head>
  <link rel="stylesheet" href="styles.css">
</head>
```

Ventajas: separa estructura y estilo, se cachea, reutilizable en varias páginas.

### 2. Interno

```html
<head>
  <style>
    body { font-family: sans-serif; }
    h1 { color: #3b82f6; }
  </style>
</head>
```

Útil para una sola página o estilos críticos.

### 3. Inline (evitar)

```html
<p style="color: red; font-size: 18px;">Texto</p>
```

Solo para casos puntuales; no se puede reutilizar y mezcla estructura con estilo.

## Selectores básicos

```css
/* De etiqueta */
p { color: #333; }

/* De clase */
.tarjeta { padding: 16px; }

/* De id (único en la página) */
#cabecera { background: #000; }

/* Múltiple */
h1, h2, h3 { font-family: Georgia, serif; }

/* Descendente */
article p { line-height: 1.6; }

/* Hijo directo */
nav > ul { list-style: none; }

/* Hermano adyacente */
h2 + p { margin-top: 0; }

/* Atributo */
input[type="email"] { border-color: blue; }
```

## Box model

Todo elemento es una caja con cuatro capas de dentro a fuera:

```
┌──────────────── margin ─────────────────┐
│  ┌──────────── border ───────────────┐  │
│  │  ┌──────── padding ─────────────┐  │  │
│  │  │  ┌──────── content ────────┐ │  │  │
│  │  │  │                          │ │  │  │
│  │  │  │      texto / imagen      │ │  │  │
│  │  │  │                          │ │  │  │
│  │  │  └──────────────────────────┘ │  │  │
│  │  └────────────────────────────────┘  │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
```

```css
.caja {
  width: 200px;
  padding: 20px;
  border: 2px solid #333;
  margin: 10px;
  /* Por defecto width no incluye padding ni border */
  box-sizing: border-box; /* recomendado: sí los incluye */
}
```

```css
/* Reset universal recomendado */
*, *::before, *::after {
  box-sizing: border-box;
}
```

| Propiedad | Afecta a |
|---|---|
| `width`/`height` | Tamaño del contenido |
| `padding` | Espacio interior |
| `border` | Borde |
| `margin` | Espacio exterior |
| `box-sizing` | Cómo se calcula el tamaño |

## Flexbox

Flexbox alinea y distribuye elementos en **una dimensión** (fila o columna).

```html
<div class="contenedor">
  <div class="item">1</div>
  <div class="item">2</div>
  <div class="item">3</div>
</div>
```

```css
.contenedor {
  display: flex;
  flex-direction: row;       /* row | column | row-reverse | column-reverse */
  justify-content: center;  /* alineación en el eje principal */
  align-items: center;      /* alineación en el eje cruzado */
  gap: 16px;                /* espacio entre items */
  flex-wrap: wrap;          /* permite saltar de línea */
}

.item {
  flex: 1;                  /* crecen a partes iguales */
}
```

### Propiedades del contenedor flex

| Propiedad | Valores | Para qué |
|---|---|---|
| `display` | `flex` | Activa flexbox |
| `flex-direction` | `row`/`column`/`*-reverse` | Eje principal |
| `justify-content` | `flex-start`/`center`/`space-between`/`space-around`/`space-evenly` | Distribución en eje principal |
| `align-items` | `stretch`/`flex-start`/`center`/`flex-end`/`baseline` | Alineación eje cruzado |
| `flex-wrap` | `nowrap`/`wrap`/`wrap-reverse` | Salto de línea |
| `gap` | `px`/`rem` | Espacio entre items |
| `align-content` | igual que justify | Distribución de líneas |

### Propiedades del item flex

| Propiedad | Descripción |
|---|---|
| `flex-grow` | Cuánto crece (0 = no crece) |
| `flex-shrink` | Cuánto se encoge |
| `flex-basis` | Tamaño inicial |
| `flex` | Atajo: `grow shrink basis` |
| `order` | Orden visual |
| `align-self` | Alineación individual |

```css
.item-principal { flex: 2; }
.item-secundario { flex: 1; }
.ultimo { order: 99; }
```

## CSS Grid

Grid organiza elementos en **dos dimensiones** (filas y columnas).

```css
.grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: auto auto;
  gap: 20px;
}
```

### Grid con áreas

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

### Propiedades de Grid

| Propiedad | Descripción |
|---|---|
| `grid-template-columns` | Tamaño de columnas (`1fr`, `200px`, `repeat(3,1fr)`) |
| `grid-template-rows` | Tamaño de filas |
| `grid-template-areas` | Nombres de áreas |
| `gap` / `column-gap` / `row-gap` | Separación |
| `grid-column` / `grid-row` | Posición del item (`span 2`) |
| `justify-items` / `align-items` | Alineación items |

```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 16px;
}
```

> `repeat(auto-fit, minmax(250px, 1fr))` crea columnas responsivas automáticas sin media queries.

## Responsive design y media queries

```css
/* Mobile-first: estilos base para móvil */
body { font-size: 16px; }

/* A partir de 768px (tablet) */
@media (min-width: 768px) {
  body { font-size: 18px; }
}

/* A partir de 1024px (escritorio) */
@media (min-width: 1024px) {
  body { font-size: 20px; }
}
```

| Punto de ruptura | Dispositivo |
|---|---|
| `min-width: 640px` | Móvil grande |
| `min-width: 768px` | Tablet |
| `min-width: 1024px` | Escritorio |
| `min-width: 1280px` | Escritorio grande |

```html
<!-- El meta viewport es indispensable -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

### Unidades relativas

| Unidad | Referencia |
|---|---|
| `rem` | Tamaño de fuente raíz (16px por defecto) |
| `em` | Tamaño de fuente del padre |
| `%` | Relativo al contenedor |
| `vw`/`vh` | 1% del ancho/alto del viewport |
| `vmin`/`vmax` | El menor/mayor de vw/vh |
| `ch` | Ancho del carácter "0" |

```css
h1 { font-size: 2.5rem; }      /* 40px si raíz es 16px */
.hero { height: 100vh; }       /* toda la pantalla */
.caja { max-width: 60ch; }    /* ancho cómodo de lectura */
```

## Transiciones

```css
.boton {
  background: #3b82f6;
  transition: background 0.3s ease, transform 0.2s ease;
}
.boton:hover {
  background: #2563eb;
  transform: translateY(-2px);
}
```

| Propiedad de transition | Descripción |
|---|---|
| `transition-property` | Qué propiedades animar |
| `transition-duration` | Duración |
| `transition-timing-function` | `ease`, `linear`, `ease-in`, `ease-out`, `cubic-bezier(...)` |
| `transition-delay` | Retardo |

## Animaciones y keyframes

```css
@keyframes rebote {
  0%   { transform: translateY(0); }
  50%  { transform: translateY(-20px); }
  100% { transform: translateY(0); }
}

.pelota {
  animation: rebote 1s ease-in-out infinite;
}
```

```css
@keyframes aparecer {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}

.modal {
  animation: aparecer 0.4s ease-out;
}
```

| Propiedad | Descripción |
|---|---|
| `animation-name` | Nombre del `@keyframes` |
| `animation-duration` | Duración |
| `animation-timing-function` | Curva de tiempo |
| `animation-delay` | Retardo |
| `animation-iteration-count` | `infinite` o número |
| `animation-direction` | `normal`, `reverse`, `alternate` |
| `animation-fill-mode` | `forwards`, `backwards`, `both` |

## Transformaciones

```css
.caja {
  transform: translate(10px, 20px);
  transform: rotate(45deg);
  transform: scale(1.5);
  transform: skew(10deg, 5deg);
}
```

## Variables CSS

```css
:root {
  --color-primario: #3b82f6;
  --espaciado: 16px;
}

.boton {
  background: var(--color-primario);
  padding: var(--espaciado);
}

/* Override por contexto */
.oscuro {
  --color-primario: #60a5fa;
}
```

## Conceptos clave

- El CSS externo separa estructura y estilo y se cachea.
- El box model se controla con `box-sizing: border-box`.
- Flexbox es para una dimensión; Grid para dos.
- `gap` reemplaza a los antiguos márgenes negativos.
- Mobile-first: estilos base para móvil y se amplían con `min-width`.
- El `viewport` meta es obligatorio para responsive.
- `rem` y `vh`/`vw` son más escalables que `px`.
- Las transiciones interpolan cambios; las animaciones definen fotogramas.

## Errores comunes

- **Olvidar `box-sizing: border-box`**: los tamaños no cuadran con padding/border.
- **No poner el meta viewport**: la web no se adapta al móvil.
- **Abusar de `!important`**: rompe la cascada y el mantenimiento.
- **Usar `float` para layouts**: hoy se usa flexbox o grid.
- **Pensar en `px` fijos**: mejor `rem`/`em`/`%` para escalabilidad.
- **Media queries sin estrategia mobile-first**: estilos duplicados y conflictos.
- **Animar propiedades costosas** (`width`, `top`): preferir `transform` y `opacity`.
- **Selectores demasiado largos**: frágiles y lentos.
