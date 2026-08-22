# 01 — Fundamentos de HTML

> Estructura, etiquetas, atributos, texto, encabezados, párrafos, listas, enlaces, imágenes, tablas, formularios, HTML semántico, accesibilidad y SEO básico.

## Objetivos

- [ ] Comprender qué es HTML y cómo el navegador lo interpreta
- [ ] Escribir la estructura base de un documento HTML válido
- [ ] Usar correctamente etiquetas, atributos y anidamiento
- [ ] Crear contenido con encabezados, párrafos, listas y citas
- [ ] Enlazar páginas con enlaces absolutos y relativos
- [ ] Insertar imágenes con texto alternativo correcto
- [ ] Construir tablas accesibles
- [ ] Conocer las etiquetas semánticas de HTML5
- [ ] Aplicar accesibilidad y SEO básico desde el primer documento

## ¿Qué es HTML?

HTML (HyperText Markup Language) es un **lenguaje de marcado** (no de programación) que describe la estructura y el significado del contenido de una página web. El navegador lee el HTML, construye el **DOM** (Document Object Model) y lo renderiza.

HTML se basa en **etiquetas** (tags) que delimitan elementos. Un elemento suele tener etiqueta de apertura, contenido y etiqueta de cierre:

```html
<p>Este es un párrafo.</p>
```

Algunos elementos son **vacíos** (self-closing), no llevan contenido ni cierre:

```html
<img src="foto.jpg" alt="Descripción">
<br>
<hr>
<input type="text">
```

## Anatomía de un elemento

```html
<a href="https://example.com" target="_blank" class="enlace">Texto del enlace</a>
│ │       │                      │                │            │
│ │       └── atributo="valor" ──┘                │            │
│ └── nombre de etiqueta                          │            └── contenido
└── < apertura                                    └── > cierre
```

- **Etiqueta**: el nombre del elemento (`a`, `p`, `h1`, `div`).
- **Atributo**: pares `nombre="valor"` que configuran el elemento.
- **Contenido**: lo que va entre apertura y cierre.
- **Elemento**: la unidad completa (etiqueta + atributos + contenido).

## Estructura base de un documento

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Título de la página</title>
  <meta name="description" content="Descripción de la página para SEO">
</head>
<body>
  <header>
    <h1>Mi sitio web</h1>
    <nav><!-- navegación --></nav>
  </header>
  <main>
    <p>Contenido principal.</p>
  </main>
  <footer>
    <p>&copy; 2026 Mi sitio</p>
  </footer>
</body>
</html>
```

- `<!DOCTYPE html>`: indica al navegador que use HTML5.
- `<html lang="es">`: raíz del documento; `lang` ayuda a lectores de pantalla y SEO.
- `<head>`: metadatos (no visibles): charset, viewport, title, links a CSS.
- `<body>`: contenido visible.

### Tabla de elementos del `<head>`

| Elemento | Para qué sirve |
|---|---|
| `<meta charset="UTF-8">` | Codificación de caracteres |
| `<meta name="viewport" ...>` | Escalado en móviles |
| `<title>` | Título de la pestaña (clave para SEO) |
| `<meta name="description" ...>` | Resumen para buscadores |
| `<link rel="stylesheet" href="...">` | Conectar CSS externo |
| `<link rel="icon" href="...">` | Favicon |
| `<script src="..." defer>` | Cargar JavaScript |

## Comentarios

```html
<!-- Esto es un comentario, no se renderiza -->
```

## Texto: encabezados y párrafos

### Encabezados

Hay seis niveles, de `h1` (más importante) a `h6` (menos). Solo debe haber **un solo `h1`** por página y se respeta la jerarquía sin saltarse niveles.

```html
<h1>Título principal de la página</h1>
<h2>Sección importante</h2>
<h3>Subsección</h3>
<h4>Sub-subsección</h4>
<h5>Apartado</h5>
<h6>Detalle mínimo</h6>
```

### Párrafos y texto

```html
<p>Un párrafo normal.</p>
<p>Esto es <strong>importante</strong> y esto es <em>énfasis</em>.</p>
<p>Línea uno<br>Línea dos (salto de línea).</p>
<p>Fórmula: H<sub>2</sub>O y E=mc<sup>2</sup>.</p>
```

### Tabla de etiquetas de texto

| Etiqueta | Uso | Ejemplo |
|---|---|---|
| `<strong>` | Importancia (negrita semántica) | `<strong>crítico</strong>` |
| `<em>` | Énfasis (cursiva semántica) | `<em>ojo</em>` |
| `<b>` | Negrita sin significado extra | `<b>texto</b>` |
| `<i>` | Cursiva sin significado extra | `<i>término</i>` |
| `<u>` | Subrayado | `<u>texto</u>` |
| `<br>` | Salto de línea | `línea1<br>línea2` |
| `<hr>` | Separador temático | `<hr>` |
| `<mark>` | Texto resaltado | `<mark>hallado</mark>` |
| `<small>` | Letra pequeña (legal) | `<small>© 2026</small>` |
| `<sub>` | Subíndice | `H<sub>2</sub>O` |
| `<sup>` | Superíndice | `m<sup>2</sup>` |
| `<blockquote>` | Cita en bloque | `<blockquote>...</blockquote>` |
| `<q>` | Cita en línea | `<q>hola</q>` |
| `<code>` | Código | `<code>console.log()</code>` |
| `<pre>` | Texto preformateado | `<pre>...</pre>` |

## Listas

### Lista no ordenada

```html
<ul>
  <li>Manzana</li>
  <li>Pera</li>
  <li>Plátano</li>
</ul>
```

### Lista ordenada

```html
<ol>
  <li>Encender el horno</li>
  <li>Meter la pizza</li>
  <li>Esperar 15 minutos</li>
</ol>
```

### Lista de descripción

```html
<dl>
  <dt>HTML</dt>
  <dd>Lenguaje de marcado de hipertexto.</dd>
  <dt>CSS</dt>
  <dd>Hojas de estilo en cascada.</dd>
</dl>
```

Las listas se pueden **anidar**:

```html
<ul>
  <li>Frutas
    <ul>
      <li>Manzana</li>
      <li>Pera</li>
    </ul>
  </li>
  <li>Verduras</li>
</ul>
```

## Enlaces

El elemento `<a>` (anchor) crea hipervínculos. El atributo `href` indica el destino.

```html
<!-- Enlace absoluto (URL completa) -->
<a href="https://example.com">Ir a Example</a>

<!-- Enlace relativo (dentro del mismo sitio) -->
<a href="/contacto.html">Contacto</a>
<a href="../blog/post.html">Post del blog</a>

<!-- Abrir en nueva pestaña -->
<a href="https://example.com" target="_blank" rel="noopener noreferrer">Abrir en nueva pestaña</a>

<!-- Enlace a sección interna -->
<a href="#seccion-2">Ir a la sección 2</a>

<!-- Enlace de email y teléfono -->
<a href="mailto:hola@ejemplo.com">Escribir email</a>
<a href="tel:+34600123456">Llamar</a>

<!-- Descarga -->
<a href="/pdf/informe.pdf" download>Descargar PDF</a>
```

> **Seguridad**: al usar `target="_blank"` añade siempre `rel="noopener noreferrer"` para evitar que la página destino acceda a `window.opener`.

### Tabla de atributos de `<a>`

| Atributo | Descripción |
|---|---|
| `href` | URL de destino |
| `target` | Dónde abrir (`_self`, `_blank`, `_parent`, `_top`) |
| `rel` | Relación (`noopener`, `noreferrer`, `next`, `prev`) |
| `download` | Fuerza la descarga |
| `hreflang` | Idioma del destino |
| `type` | Tipo MIME del destino |

## Imágenes

```html
<img src="gato.jpg" alt="Un gato naranja durmiendo en el sofá" width="400" height="300">

<!-- Imagen responsiva con diferentes tamaños -->
<img
  srcset="gato-400.jpg 400w, gato-800.jpg 800w, gato-1200.jpg 1200w"
  sizes="(max-width: 600px) 400px, 800px"
  src="gato-800.jpg"
  alt="Un gato naranja durmiendo"
  loading="lazy"
  decoding="async"
>
```

- `alt` es **obligatorio** para accesibilidad y SEO. Si la imagen es decorativa, usa `alt=""`.
- `width` y `height` evitan el cambio de layout (CLS).
- `loading="lazy"` retrasa la carga hasta que la imagen entra en pantalla.

## Tablas

```html
<table>
  <caption>Ventas por trimestre</caption>
  <thead>
    <tr>
      <th scope="col">Trimestre</th>
      <th scope="col">Ventas</th>
      <th scope="col">Beneficio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Q1</th>
      <td>10.000 €</td>
      <td>2.000 €</td>
    </tr>
    <tr>
      <th scope="row">Q2</th>
      <td>15.000 €</td>
      <td>3.500 €</td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <th scope="row">Total</th>
      <td>25.000 €</td>
      <td>5.500 €</td>
    </tr>
  </tfoot>
</table>
```

- `<caption>` describe la tabla (accesibilidad).
- `scope="col"` / `scope="row"` asocia celdas de encabezado con sus datos.
- `colspan` y `rowspan` combinan celdas: `<td colspan="2">`.

## Formularios (introducción)

```html
<form action="/registro" method="POST">
  <label for="nombre">Nombre:</label>
  <input type="text" id="nombre" name="nombre" required>

  <label for="email">Email:</label>
  <input type="email" id="email" name="email" required>

  <button type="submit">Enviar</button>
</form>
```

- `action`: URL a la que se envían los datos.
- `method`: `GET` o `POST`.
- `<label for="id">` asocia la etiqueta al input (accesibilidad esencial).
- `name` identifica el dato que se envía al servidor.
- `required` marca el campo como obligatorio.

> Los formularios se tratan en profundidad en la guía [02 — Formularios y multimedia](02-formularios-y-multimedia.md).

## HTML semántico

Antes de HTML5 todo se construía con `<div>` genéricos. HTML5 introdujo etiquetas semánticas que describen su significado, mejorando accesibilidad y SEO.

```html
<body>
  <header>
    <h1>Mi Blog</h1>
    <nav>
      <a href="/">Inicio</a>
      <a href="/blog">Blog</a>
    </nav>
  </header>
  <main>
    <article>
      <h2>Título del post</h2>
      <p>Contenido del artículo...</p>
      <section>
        <h3>Una sección</h3>
        <p>...</p>
      </section>
    </article>
    <aside>
      <p>Barra lateral con enlaces relacionados.</p>
    </aside>
  </main>
  <footer>
    <p>&copy; 2026 Mi Blog</p>
  </footer>
</body>
```

### Tabla de etiquetas semánticas

| Etiqueta | Significado |
|---|---|
| `<header>` | Cabecera de página o sección |
| `<nav>` | Bloque de navegación principal |
| `<main>` | Contenido principal (único por página) |
| `<article>` | Contenido autónomo y reutilizable |
| `<section>` | Agrupación temática con encabezado |
| `<aside>` | Contenido relacionado (barra lateral) |
| `<footer>` | Pie de página o sección |
| `<figure>` | Contenido ilustrativo (imagen, código) |
| `<figcaption>` | Descripción de un `<figure>` |
| `<time>` | Fecha/hora legible por máquinas |
| `<address>` | Información de contacto |

## Atributos globales

Aplican a casi todos los elementos:

| Atributo | Uso |
|---|---|
| `id` | Identificador único |
| `class` | Clases CSS (varias separadas por espacio) |
| `style` | Estilos inline |
| `title` | Tooltip |
| `lang` | Idioma del contenido |
| `dir` | Dirección del texto (`ltr`, `rtl`) |
| `tabindex` | Orden de foco por teclado |
| `hidden` | Oculta el elemento |
| `data-*` | Atributos de datos personalizados |

```html
<div id="caja" class="tarjeta resaltada" data-id="42" data-categoria="libro">
  Contenido
</div>
```

## Entidades HTML

Caracteres reservados que se escriben con entidades:

| Carácter | Entidad | Cuándo usar |
|---|---|---|
| `<` | `&lt;` | Mostrar un `<` literal |
| `>` | `&gt;` | Mostrar un `>` literal |
| `&` | `&amp;` | Mostrar un `&` literal |
| `"` | `&quot;` | Comillas en atributos |
| `©` | `&copy;` | Copyright |
| `€` | `&euro;` | Euro |
| `espacio` | `&nbsp;` | Espacio no separable |

```html
<p>En HTML, &lt;p&gt; define un párrafo.</p>
```

## Accesibilidad básica

- Usa HTML semántico: un `<button>` es más accesible que un `<div onclick>`.
- Todo `<img>` necesita `alt` descriptivo.
- Asocia `<label>` con `<input>` mediante `for`/`id`.
- Usa `lang` correcto en `<html>`.
- Mantén un orden lógico de encabezados.
- Todo lo interactivo debe ser usable con teclado.

```html
<!-- Bien -->
<button type="button">Enviar</button>

<!-- Evitar: no es accesible ni semántico -->
<div onclick="enviar()">Enviar</div>
```

## SEO básico

```html
<head>
  <title>Recetas de cocina casera | Mi Cocina</title>
  <meta name="description" content="Más de 500 recetas caseras fáciles y rápidas, organizadas por categoría.">
  <meta name="keywords" content="recetas, cocina, casera, fácil">
  <link rel="canonical" href="https://micocina.com/recetas">
  <meta property="og:title" content="Recetas de cocina casera">
  <meta property="og:description" content="Más de 500 recetas caseras.">
  <meta property="og:image" content="https://micocina.com/og.jpg">
</head>
```

- `<title>`: 50-60 caracteres, incluye la palabra clave principal.
- `description`: 150-160 caracteres, describe el contenido.
- `canonical`: evita contenido duplicado.
- Usa un solo `<h1>` con el título principal.
- Estructura jerárquica de encabezados.

## Anidamiento correcto

Los elementos deben anidarse sin solaparse:

```html
<!-- Bien -->
<p>Esto es <strong>correcto</strong>.</p>

<!-- Mal: etiquetas solapadas -->
<p>Esto es <strong>incorrecto</p></strong>

<!-- Mal: un párrafo dentro de otro -->
<p>Texto <p>otro</p></p>
```

## Conceptos clave

- **HTML** describe estructura y significado, no apariencia.
- **DOM**: árbol que el navegador construye a partir del HTML.
- **Semántica**: elegir la etiqueta por su significado, no por su aspecto.
- **Accesibilidad**: el HTML correcto ya da mucha accesibilidad gratis.
- **SEO**: el título, la descripción y la jerarquía de encabezados son lo primero.
- **`alt`** no es "para que aparezca si no carga", sino para usuarios de lectores de pantalla.

## Errores comunes

- **Usar `<div>` para todo** en vez de etiquetas semánticas (`<nav>`, `<main>`, `<article>`).
- **Olvidar el `alt`** en las imágenes (o poner `alt="imagen.jpg"`).
- **Varios `<h1>`** sin jerarquía o saltarse niveles de encabezado.
- **No asociar `<label>` con `<input>`** (`for`/`id`).
- **`target="_blank"` sin `rel="noopener"`**: agujero de seguridad.
- **Anidamiento incorrecto**: etiquetas solapadas o bloque dentro de inline incorrecto.
- **Olvidar `lang`** en `<html>`: afecta a lectores de pantalla y SEO.
- **No usar `viewport`**: la página no se ve bien en móviles.
- **Usar `<br>` para separar párrafos**: para eso está `<p>`.
- **Construir botones con `<div onclick>`**: pierden foco por teclado y rol.
