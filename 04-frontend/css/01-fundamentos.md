# 01 — Fundamentos de CSS

> Selectores, especificidad, cascada, herencia, box model, colores, unidades, tipografía.

## Objetivos

- [ ] Entender cómo se conecta el CSS al HTML
- [ ] Dominar los selectores y combinarlos
- [ ] Calcular la especificidad y entender la cascada
- [ ] Saber qué se hereda y qué no
- [ ] Comprender el box model y `box-sizing`
- [ ] Usar colores en distintos formatos
- [ ] Elegir la unidad correcta para cada caso
- [ ] Configurar tipografía de forma legible

## ¿Qué es CSS?

CSS (Cascading Style Sheets) describe **cómo se presenta** el HTML: colores, tamaños, espaciados, layout y animaciones. Funciona con reglas compuestas por **selectores** y **declaraciones**.

```css
/* Regla CSS */
selector {
  propiedad: valor;   /* declaración */
}
```

```css
p {
  color: #333;
  font-size: 16px;
  line-height: 1.6;
}
```

## Formas de incluir CSS

```html
<!-- Externo (recomendado) -->
<link rel="stylesheet" href="styles.css">

<!-- Interno -->
<style>
  body { margin: 0; }
</style>

<!-- Inline (evitar) -->
<p style="color: red;">Texto</p>
```

## Selectores

### Básicos

```css
/* De etiqueta */
p { color: #333; }

/* De clase */
.boton { padding: 8px; }

/* De id (único) */
#cabecera { background: #000; }

/* Universal */
* { box-sizing: border-box; }

/* Agrupados */
h1, h2, h3 { font-family: Georgia; }
```

### Combinadores

```css
/* Descendiente (cualquier nivel) */
article p { line-height: 1.6; }

/* Hijo directo */
nav > ul { list-style: none; }

/* Hermano adyacente */
h2 + p { margin-top: 0; }

/* Hermano general (todos los siguientes) */
h2 ~ p { color: gray; }
```

### Pseudo-clases

Estado dinámico de un elemento:

```css
a:link { color: blue; }
a:visited { color: purple; }
a:hover { color: red; }
a:focus { outline: 2px solid blue; }
a:active { color: orange; }

input:focus { border-color: blue; }
li:first-child { font-weight: bold; }
li:last-child { border: none; }
li:nth-child(odd) { background: #f5f5f5; }
li:nth-child(3n) { color: red; }
input:checked + label { font-weight: bold; }
```

| Pseudo-clase | Descripción |
|---|---|
| `:hover` | Ratón encima |
| `:focus` | Tiene el foco |
| `:active` | Mientras se pulsa |
| `:checked` | Input marcado |
| `:disabled` | Input deshabilitado |
| `:first-child` | Primer hijo |
| `:last-child` | Último hijo |
| `:nth-child(n)` | Enésimo hijo |
| `:not(selector)` | Negación |
| `:empty` | Sin hijos |

### Pseudo-elementos

Permiten estilizar partes específicas de un elemento:

```css
p::first-letter { font-size: 2em; }
p::first-line { font-weight: bold; }

/* Contenido generado */
.aviso::before { content: "⚠️ "; }
.enlace::after { content: " →"; }

/* Placeholder de input */
input::placeholder { color: #999; }

/* Selección de texto */
::selection { background: yellow; }
```

### Selectores de atributo

```css
input[type="email"] { border-color: blue; }
a[href^="https"] { color: green; }      /* empieza por */
a[href$=".pdf"] { color: red; }          /* termina por */
a[href*="docs"] { font-weight: bold; }   /* contiene */
[class|="btn"] { padding: 4px; }         /* igual o con guion */
```

## Especificidad

La especificidad determina qué regla gana cuando hay conflictos. Se calcula con cuatro niveles:

| Nivel | Ejemplo | Valor |
|---|---|---|
| Inline | `style="..."` | 1000 |
| ID | `#cabecera` | 100 |
| Clase/pseudo-clase/atributo | `.boton`, `:hover`, `[type]` | 10 |
| Etiqueta/pseudo-elemento | `div`, `::before` | 1 |

```css
#menu .item { color: red; }        /* 1 ID + 1 clase = 110 */
.menu .item { color: blue; }       /* 2 clases = 20 */
div.menu a { color: green; }       /* 2 etiquetas + 1 clase = 12 */
```

Gana `#menu .item` (110).

> `!important` rompe la cascada y gana sobre todo. **Evítalo** salvo excepciones justificadas.

### Tabla de ejemplos

| Selector | Especificidad |
|---|---|
| `*` | 0 |
| `p` | 1 |
| `.clase` | 10 |
| `p.clase` | 11 |
| `#id` | 100 |
| `p#id` | 101 |
| `#id .clase` | 110 |
| `style="color:red"` | 1000 |

## Cascada

El orden de las reglas importa cuando la especificidad es igual: **gana la última**.

```css
p { color: red; }
p { color: blue; }  /* gana: blue */
```

Orden de prioridad:
1. `!important` (usuario)
2. Inline
3. Especificidad
4. Orden de aparición

## Herencia

Algunas propiedades se **heredan** de padre a hijo automáticamente:

| Se heredan | No se heredan |
|---|---|
| `color` | `margin`, `padding`, `border` |
| `font-*` | `width`, `height` |
| `line-height` | `background` |
| `text-align` | `display`, `position` |
| `visibility` | `top`, `left`, `right`, `bottom` |

```css
body {
  font-family: sans-serif;
  color: #333;
}

/* Todos los elementos herdan font-family y color de body */
```

Controlar la herencia:

```css
.hijo {
  color: inherit;    /* hereda explícitamente */
  color: initial;    /* valor inicial de la propiedad */
  color: unset;      /* inherit si hereda, initial si no */
  all: revert;       /* deshacer todos los cambios */
}
```

## Box model

Cada elemento es una caja con cuatro capas:

```
┌────────── margin ──────────┐
│  ┌──────── border ───────┐  │
│  │  ┌──── padding ────┐  │  │
│  │  │  ┌─ content ─┐  │  │  │
│  │  │  │            │  │  │  │
│  │  │  │   texto    │  │  │  │
│  │  │  │            │  │  │  │
│  │  │  └────────────┘  │  │  │
│  │  └──────────────────┘  │  │
│  └────────────────────────┘  │
└──────────────────────────────┘
```

```css
.caja {
  width: 200px;
  height: 100px;
  padding: 20px;
  border: 2px solid #333;
  margin: 16px;
}
```

### `box-sizing`

Por defecto, `width` es solo el contenido, y `padding` y `border` se suman al tamaño total.

```css
/* Por defecto: width = contenido */
.caja { box-sizing: content-box; }

/* Recomendado: width incluye padding y border */
.caja { box-sizing: border-box; }
```

```css
/* Reset universal estándar */
*, *::before, *::after {
  box-sizing: border-box;
}
```

| Valor | `width` incluye |
|---|---|
| `content-box` (default) | Solo contenido |
| `border-box` | Contenido + padding + border |

## Colores

```css
.caja1 { color: #3b82f6; }                  /* Hex */
.caja2 { color: #3b82f680; }                /* Hex con alpha (50%) */
.caja3 { color: rgb(59, 130, 246); }        /* RGB */
.caja4 { color: rgba(59, 130, 246, 0.5); }  /* RGBA con alpha */
.caja5 { color: hsl(217, 91%, 60%); }       /* HSL: matiz, saturación, luz */
.caja6 { color: hsla(217, 91%, 60%, 0.5); } /* HSLA con alpha */
.caja7 { color: currentColor; }             /* hereda el color actual */
.caja8 { color: transparent; }
```

| Formato | Ventaja |
|---|---|
| Hex (`#3b82f6`) | Compacto, habitual |
| `rgb()`/`rgba()` | Intuitivo, con alpha |
| `hsl()`/`hsla()` | Fácil de ajustar tonos |
| `oklch()` | Moderno, perceptualmente uniforme |

## Unidades

### Absolutas

```css
.caja { width: 200px; font-size: 16pt; }
```

`px` es la más común, pero no se escala con preferencias del usuario.

### Relativas (recomendadas)

| Unidad | Referencia |
|---|---|
| `rem` | Tamaño raíz (16px por defecto) |
| `em` | Tamaño de fuente del padre |
| `%` | Contenedor padre |
| `vw` | 1% del ancho del viewport |
| `vh` | 1% del alto del viewport |
| `vmin`/`vmax` | Menor/mayor de vw/vh |
| `ch` | Ancho del "0" de la fuente |
| `dvh`/`dvw` | Viewport dinámico (móvil) |

```css
h1 { font-size: 2rem; }       /* 32px */
p { font-size: 1rem; }
section { padding: 2em; }     /* relativo al font-size del padre */
.hero { height: 100vh; }      /* toda la pantalla */
.lectura { max-width: 65ch; } /* ancho cómodo de lectura */
```

> **Recomendación**: usa `rem` para tipografía y espaciados, `%` para anchos de contenedor, `vw`/`vh` para secciones a pantalla completa.

## Tipografía

```css
body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  font-size: 1rem;        /* 16px */
  line-height: 1.6;
  font-weight: 400;
  letter-spacing: 0.02em;
}

h1 {
  font-size: 2.5rem;
  font-weight: 700;
  line-height: 1.2;
}

.codigo {
  font-family: 'Fira Code', monospace;
}
```

### Propiedades tipográficas

| Propiedad | Descripción | Ejemplo |
|---|------|---|
| `font-family` | Familia tipográfica | `'Inter', sans-serif` |
| `font-size` | Tamaño | `1.2rem` |
| `font-weight` | Grosor | `400` (normal), `700` (bold) |
| `font-style` | Estilo | `italic`, `normal` |
| `line-height` | Altura de línea | `1.6` |
| `letter-spacing` | Espacio entre letras | `0.05em` |
| `word-spacing` | Espacio entre palabras | `0.1em` |
| `text-align` | Alineación | `left`, `center`, `right`, `justify` |
| `text-decoration` | Subrayado/tachado | `underline`, `none` |
| `text-transform` | Mayúsculas/minúsculas | `uppercase`, `capitalize` |
| `text-indent` | Sangría | `2em` |

### Escala modular con clamp

```css
h1 { font-size: clamp(2rem, 5vw, 3.5rem); }
```

`clamp(mínimo, preferido, máximo)` escala fluidamente entre dos límites.

## Reset CSS

Normalizar los estilos por defecto de los navegadores:

```css
/* Reset minimalista */
*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: system-ui, sans-serif;
  line-height: 1.6;
}

img, picture, video {
  max-width: 100%;
  display: block;
}
```

## Variables CSS

```css
:root {
  --color-primario: #3b82f6;
  --espaciado-base: 16px;
}

.boton {
  background: var(--color-primario);
  padding: var(--espaciado-base);
}

/* Override por contexto */
.oscuro {
  --color-primario: #60a5fa;
}
```

## Conceptos clave

- El selector más específico gana; ante empate, gana el último.
- `!important` rompe la cascada: úsalo solo como último recurso.
- Las propiedades de texto se heredan; las de caja no.
- `box-sizing: border-box` evita sorpresas con padding y border.
- `rem` es más escalable que `px` (respeta preferencias del usuario).
- `clamp()` crea tipografía fluida sin media queries.
- Las variables CSS habilitan theming sin preprocesador.

## Errores comunes

- **Usar `!important` para todo**: rompe la cascada y el mantenimiento.
- **No resetear el box model**: los tamaños no cuadran.
- **Pensar todo en `px`**: no escala con preferencias de usuario.
- **Selectores de id en CSS**: muy específicos, difíciles de sobreescribir.
- **Anidar selectores largos** (`.header nav ul li a`): frágiles y lentos.
- **Olvidar `line-height`**: texto apretado o demasiado suelto.
- **No usar fallback en `font-family`**: si no carga la fuente, se rompe.
- **Confundir `em` (padre) con `rem` (raíz)**: comportamientos distintos.
- **Poner unidades a `line-height`**: `line-height: 1.6` es mejor que `1.6rem`.
