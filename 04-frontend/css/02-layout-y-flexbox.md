# 02 — Layout y Flexbox

> Display, position, float, flexbox, align, justify, wrap, order.

## Objetivos

- [ ] Entender el modelo de formato visual: `display`
- [ ] Dominar `position` (static, relative, absolute, fixed, sticky)
- [ ] Conocer `float` y por qué ya no se usa para layouts
- [ ] Usar flexbox para alinear y distribuir elementos
- [ ] Controlar el eje principal y el cruzado
- [ ] Reordenar elementos con `order`
- [ ] Crear patrones comunes con flexbox (navbar, centrado, sticky footer)

## La propiedad `display`

`display` define cómo se comporta un elemento en el flujo del documento.

```css
div { display: block; }
span { display: inline; }
img { display: inline-block; }
.container { display: flex; }
.grid { display: grid; }
```

| Valor | Comportamiento |
|---|---|
| `block` | Ocupa todo el ancho, salto de línea (div, p, h1) |
| `inline` | Solo el contenido, sin saltos (span, a, strong) |
| `inline-block` | Inline pero admite width/height |
| `flex` | Contenedor flex |
| `grid` | Contenedor grid |
| `none` | Oculto (no ocupa espacio) |
| `contents` | El elemento desaparece, sus hijos se comportan como del padre |

### Diferencias clave

```html
<!-- block: ocupa todo el ancho -->
<div style="display:block; background:red;">Block</div>

<!-- inline: solo su contenido -->
<span style="display:inline; background:blue;">Inline</span>

<!-- inline-block: como inline pero con width/height -->
<span style="display:inline-block; width:100px; height:50px; background:green;">Inline-block</span>
```

> `inline` **no** respeta `width`, `height`, `margin-top` ni `margin-bottom`. Si los necesitas, usa `inline-block` o `flex`.

## `position`

Controla cómo se posiciona un elemento en el flujo.

| Valor | Comportamiento |
|---|---|
| `static` (default) | Flujo normal |
| `relative` | Relativo a su posición normal |
| `absolute` | Relativo al ancestro posicionado más cercano |
| `fixed` | Relativo al viewport (no se mueve al hacer scroll) |
| `sticky` | Híbrido: normal hasta un punto, luego fijo |

```css
/* Relative: se mueve desde su posición original */
.caja { position: relative; top: 10px; left: 20px; }

/* Absolute: sale del flujo, se定位 relativo al ancestro posicionado */
.padre { position: relative; }
.hijo { position: absolute; top: 0; right: 0; }

/* Fixed: fijo respecto al viewport */
.boton-flotante { position: fixed; bottom: 20px; right: 20px; }

/* Sticky: normal hasta llegar al top, luego se queda pegado */
.cabecera { position: sticky; top: 0; z-index: 10; }
```

### `z-index`

Controla el orden de apilamiento de elementos posicionados.

```css
.modal { position: fixed; z-index: 1000; }
.overlay { position: fixed; z-index: 999; }
```

> `z-index` solo funciona con `position` distinto de `static`.

## `float`

Históricamente se usaba para layouts. Hoy se prefiere flexbox y grid, pero sigue siendo útil para que el texto rodee una imagen.

```css
.imagen { float: left; margin-right: 16px; }
.texto { overflow: hidden; } /* limpia el float */
```

```css
/* Limpiar floats */
.clearfix::after {
  content: "";
  display: table;
  clear: both;
}
```

> **No uses `float` para layouts**: usa flexbox o grid. `float` es para envolver texto alrededor de un elemento.

## Flexbox

Flexbox (Flexible Box Layout) alinea y distribuye elementos en **una dimensión** (fila o columna). Es ideal para componentes, navbars, centrado y barras de herramientas.

### Conceptos

- **Contenedor flex**: el elemento con `display: flex`.
- **Items flex**: los hijos directos.
- **Eje principal**: dirección del flujo (fila o columna).
- **Eje cruzado**: perpendicular al principal.

```
justify-content → eje principal
align-items     → eje cruzado
```

### Ejemplo base

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
  flex-direction: row;
  justify-content: center;
  align-items: center;
  gap: 16px;
}
```

### Propiedades del contenedor

| Propiedad | Valores | Para qué |
|---|---|---|
| `display` | `flex` / `inline-flex` | Activa flexbox |
| `flex-direction` | `row` / `column` / `row-reverse` / `column-reverse` | Eje principal |
| `justify-content` | `flex-start` / `center` / `flex-end` / `space-between` / `space-around` / `space-evenly` | Distribución eje principal |
| `align-items` | `stretch` / `flex-start` / `center` / `flex-end` / `baseline` | Alineación eje cruzado |
| `flex-wrap` | `nowrap` / `wrap` / `wrap-reverse` | Permite saltar de línea |
| `gap` | `px` / `rem` | Espacio entre items |
| `align-content` | igual que justify | Distribución de múltiples líneas |
| `flex-flow` | Atajo `direction wrap` | — |

```css
/* Patrones comunes de justify-content */
.space-between { justify-content: space-between; }
.space-around  { justify-content: space-around; }
.space-evenly  { justify-content: space-evenly; }
.center        { justify-content: center; }
```

Visualización de `justify-content`:

```
flex-start:    [1 2 3        ]
center:        [   1 2 3     ]
flex-end:      [        1 2 3]
space-between: [1    2    3 ]
space-around:  [ 1   2   3  ]
space-evenly:  [  1   2   3  ]
```

### Propiedades del item flex

| Propiedad | Descripción |
|---|---|
| `flex-grow` | Cuánto crece (0 = no crece) |
| `flex-shrink` | Cuánto se encoge |
| `flex-basis` | Tamaño inicial |
| `flex` | Atajo: `grow shrink basis` |
| `order` | Orden visual (default 0) |
| `align-self` | Alineación individual |

```css
.item-1 { flex: 2; }     /* crece el doble */
.item-2 { flex: 1; }    /* crece normal */
.item-3 { flex: 0 0 200px; } /* no crece, 200px fijo */

.ultimo { order: 99; }
.primero { order: -1; }

.excepcion { align-self: flex-end; }
```

### Atajo `flex`

```css
flex: 1;        /* = 1 1 0%   crece y encoge */
flex: 2;        /* = 2 1 0%   crece el doble */
flex: 0 0 auto; /* no crece ni encoge, tamaño natural */
flex: 1 0 200px;/* base 200px, crece */
```

## Patrones comunes con flexbox

### Centrado perfecto

```css
.contenedor {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}
```

### Navbar con logo y enlaces

```css
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
}
.enlaces {
  display: flex;
  gap: 16px;
}
```

### Sticky footer

```css
body {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
main { flex: 1; }    /* empuja el footer abajo */
footer { flex: 0; }
```

### Cards de igual altura

```css
.cards {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
}
.card { flex: 1; min-width: 250px; }
```

### Columna con sidebar

```css
.layout {
  display: flex;
  gap: 24px;
}
.sidebar { flex: 0 0 250px; }
.contenido { flex: 1; }
```

## `gap`

`gap` define el espacio entre items flex (o grid). Reemplaza a los antiguos márgenes negativos.

```css
.contenedor {
  display: flex;
  gap: 16px;           /* entre filas y columnas */
  row-gap: 8px;        /* solo filas */
  column-gap: 16px;    /* solo columnas */
}
```

## Alineación vertical histórica

Antes de flexbox, centrar verticalmente era difícil. Ahora:

```css
/* Antes: hacks complicados */
.padre { display: table; }
.hijo { display: table-cell; vertical-align: middle; }

/* Ahora: una línea */
.padre { display: flex; align-items: center; }
```

## `order` y accesibilidad

`order` cambia el orden **visual**, pero no el del DOM. El lector de pantalla sigue el orden del DOM.

```css
.sidebar { order: 2; }
.main { order: 1; }
```

> **Aviso**: cambiar el orden visual con `order` puede desorientar a quien navega con teclado si no coincide con el orden del DOM.

## Conceptos clave

- `display` define el comportamiento en el flujo.
- `position: sticky` es ideal para cabeceras que se quedan pegadas.
- Flexbox es para una dimensión (fila o columna); grid para dos.
- `justify-content` alinea en el eje principal; `align-items` en el cruzado.
- `gap` reemplaza a márgenes negativos.
- `flex: 1` hace que un item crezca para llenar el espacio.
- `order` cambia el orden visual pero no el del DOM.
- `z-index` solo funciona con `position` no static.

## Errores comunes

- **Usar `float` para layouts**: hoy se usa flexbox o grid.
- **Olvidar `flex-wrap`**: los items se comprimen en vez de saltar de línea.
- **Confundir `justify-content` con `align-items`**: depende del eje principal.
- **`flex: 1` sin `min-width`**: los items pueden hacerse demasiado pequeños.
- **No limpiar floats**: elementos desbordados o superpuestos.
- **`position: absolute` sin padre posicionado**: se定位 respecto al viewport.
- **Abusar de `z-index` muy alto** (`9999`): crea guerras de z-index.
- **Cambiar `order` sin pensar en accesibilidad**: el foco por teclado se desordena.
- **Olvidar `align-items`**: los items se estiran (`stretch`) por defecto.
- **`inline` con `width`/`height`**: no se respeta, usar `inline-block` o `flex`.
