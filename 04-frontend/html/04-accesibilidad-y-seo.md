# 04 — Accesibilidad y SEO

> ARIA, roles, landmarks, alt text, semántica, meta tags, Open Graph, structured data, performance, Core Web Vitals.

## Objetivos

- [ ] Entender qué es la accesibilidad (a11y) y por qué importa
- [ ] Usar roles y landmarks de ARIA correctamente
- [ ] Escribir texto alternativo útil
- [ ] Aplicar atributos y estados ARIA (`aria-label`, `aria-hidden`, `aria-expanded`)
- [ ] Optimizar el SEO con meta tags y datos estructurados
- [ ] Configurar Open Graph y Twitter Cards
- [ ] Medir y mejorar las Core Web Vitals
- [ ] Conocer los principios WCAG

## ¿Qué es la accesibilidad (a11y)?

La accesibilidad web garantiza que las personas con discapacidad (visual, motora, auditiva, cognitiva) puedan **percibir, entender, navegar e interactuar** con un sitio. El estándar es **WCAG** (Web Content Accessibility Guidelines), con tres niveles: A, AA, AAA.

> "a11y" es una abreviatura: "accessibility" tiene 11 letras entre la "a" y la "y".

Los **cinco principios** de WCAG (POUR):

| Principio | Significado |
|---|---|
| **Perceptible** | El contenido debe poder verse/escucharse |
| **Operable** | Se puede navegar e interactuar |
| **Comprensible** | El contenido y la interfaz son legibles |
| **Robusto** | Funciona con distintas tecnologías de apoyo |
| (Conformancia) | Cumple los niveles A/AA/AAA |

## La regla de oro: usar HTML semántico

La accesibilidad empieza por usar el HTML correcto. Un `<button>` ya es enfocable, se activa con Enter/Espacio y anuncia su rol a los lectores de pantalla. Un `<div onclick>` no.

```html
<!-- Bien: accesible por defecto -->
<button type="button" onclick="abrir()">Abrir menú</button>

<!-- Mal: pierde foco, rol y activación por teclado -->
<div onclick="abrir()">Abrir menú</div>
```

## Landmarks (puntos de referencia)

Los landmarks son regiones semánticas que los lectores de pantalla usan para navegar.

| Etiqueta HTML | Rol ARIA equivalente |
|---|---|
| `<header>` | `banner` |
| `<nav>` | `navigation` |
| `<main>` | `main` |
| `<aside>` | `complementary` |
| `<footer>` | `contentinfo` |
| `<section>` | `region` (si tiene nombre accesible) |
| `<form>` | `form` (si tiene nombre accesible) |
| `<search>` | `search` |

```html
<body>
  <header><!-- banner --></header>
  <nav aria-label="Principal"><!-- navegación --></nav>
  <main>
    <article>...</article>
    <aside aria-label="Relacionados">...</aside>
  </main>
  <footer><!-- contentinfo --></footer>
</body>
```

> Si ya usas la etiqueta semántica, **no añadas el rol ARIA equivalente**: es redundante.

## ARIA: roles, estados y propiedades

ARIA (Accessible Rich Internet Applications) añade semántica cuando el HTML no basta. Tiene tres tipos:

| Tipo | Ejemplo | Para qué |
|---|---|---|
| **Rol** | `role="tab"` | Qué es el elemento |
| **Estado** | `aria-expanded="false"` | Estado dinámico |
| **Propiedad** | `aria-label="Cerrar"` | Información extra |

### Atributos ARIA comunes

| Atributo | Uso |
|---|---|
| `aria-label` | Etiqueta de texto cuando no hay visible |
| `aria-labelledby` | ID de otro elemento que lo etiqueta |
| `aria-describedby` | ID de elemento con descripción ampliada |
| `aria-hidden="true"` | Oculta al lector de pantalla |
| `aria-expanded` | `true`/`false` (acordeones, menús) |
| `aria-disabled` | `true`/`false` |
| `aria-checked` | `true`/`false`/`mixed` |
| `aria-selected` | `true`/`false` |
| `aria-live="polite"` | Anuncia cambios sin interrumpir |
| `aria-current="page"` | Marca la página actual |

```html
<!-- Botón con icono y sin texto visible -->
<button type="button" aria-label="Cerrar" onclick="cerrar()">
  <svg aria-hidden="true">...</svg>
</button>

<!-- Acordeón con estado -->
<button type="button" aria-expanded="false" aria-controls="panel-1">
  Sección 1
</button>
<div id="panel-1" role="region" aria-labelledby="titulo-1" hidden>
  <h3 id="titulo-1">Sección 1</h3>
  <p>Contenido...</p>
</div>

<!-- Navegación actual -->
<a href="/inicio" aria-current="page">Inicio</a>

<!-- Región con anuncios -->
<div aria-live="polite" id="estado"></div>
```

## Texto alternativo (alt)

El `alt` describe la imagen para quienes no la ven (lectores de pantalla, conexiones lentas, indexadores).

```html
<!-- Imagen con contenido: alt descriptivo -->
<img src="grafico-ventas.png" alt="Gráfico de barras: ventas trimestrales de 10k a 25k €">

<!-- Imagen decorativa: alt vacío -->
<img src="linea-decorativa.png" alt="">

<!-- Evitar -->
<img src="gato.jpg" alt="imagen">  <!-- no describe nada -->
<img src="gato.jpg" alt="Imagen de un gato muy bonito que está durmiendo plácidamente encima de un sofá de color gris">  <!-- demasiado -->
```

Reglas:
- Describe el **propósito** de la imagen, no sus píxeles.
- Si es decorativa, usa `alt=""`.
- Si la imagen transmite datos, resume la información.
- No empieces con "Imagen de...".

## SEO básico y avanzado

### Meta tags esenciales

```html
<head>
  <title>Recetas vegetarianas fáciles | Cocina Verde</title>
  <meta name="description" content="Más de 200 recetas vegetarianas fáciles y rápidas, con ingredientes accesibles y paso a paso.">
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="https://cocinaverde.com/recetas">
  <meta name="author" content="Cocina Verde">
</head>
```

| Meta | Para qué | Longitud |
|---|---|---|
| `<title>` | Título de la pestaña y resultado de búsqueda | 50-60 caracteres |
| `description` | Resumen en resultados de búsqueda | 150-160 caracteres |
| `robots` | `index`/`noindex`, `follow`/`nofollow` | — |
| `canonical` | URL canónica (evita duplicados) | URL |

### Jerarquía de encabezados

- Un único `<h1>` con el título principal.
- Usa `<h2>` para secciones, `<h3>` para subsecciones.
- No saltes niveles (de `h2` a `h4`).

### URL amigables y enlaces

- URL legibles: `/recetas/pasta-pesto` mejor que `/p?id=42`.
- Usa texto de enlace descriptivo (no "haz clic aquí").

```html
<!-- Bien -->
<a href="/recetas/pasta-pesto">Ver receta de pasta al pesto</a>

<!-- Mal -->
<a href="/recetas/pasta-pesto">Haz clic aquí</a>
```

## Open Graph y Twitter Cards

Controlan cómo se ve tu página al compartirla en redes sociales.

```html
<head>
  <!-- Open Graph (Facebook, WhatsApp, LinkedIn) -->
  <meta property="og:type" content="website">
  <meta property="og:title" content="Recetas vegetarianas fáciles">
  <meta property="og:description" content="Más de 200 recetas vegetarianas.">
  <meta property="og:image" content="https://cocinaverde.com/og.jpg">
  <meta property="og:url" content="https://cocinaverde.com">
  <meta property="og:site_name" content="Cocina Verde">
  <meta property="og:locale" content="es_ES">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Recetas vegetarianas fáciles">
  <meta name="twitter:description" content="Más de 200 recetas vegetarianas.">
  <meta name="twitter:image" content="https://cocinaverde.com/og.jpg">
  <meta name="twitter:site" content="@cocinaverde">
</head>
```

| Propiedad OG | Descripción |
|---|---|
| `og:type` | Tipo (`website`, `article`) |
| `og:title` | Título al compartir |
| `og:description` | Descripción |
| `og:image` | Imagen previsualizada (1200×630) |
| `og:url` | URL canónica |
| `og:site_name` | Nombre del sitio |

## Datos estructurados (Structured Data / JSON-LD)

Son datos en formato JSON que los buscadores usan para mostrar **rich snippets** (estrellas, eventos, recetas, FAQ).

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Recipe",
  "name": "Pasta al pesto",
  "description": "Receta clásica de pasta al pesto genovés.",
  "image": "https://cocinaverde.com/pesto.jpg",
  "author": {
    "@type": "Organization",
    "name": "Cocina Verde"
  },
  "prepTime": "PT15M",
  "cookTime": "PT10M",
  "recipeYield": "4 personas",
  "recipeIngredient": [
    "400g pasta",
    "50g albahaca",
    "30g piñones",
    "50g parmesano"
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "reviewCount": "127"
  }
}
</script>
```

### Tipos comunes de Schema.org

| `@type` | Uso |
|---|---|
| `WebSite` | Sitio web |
| `Article` | Artículo/blog |
| `Recipe` | Receta de cocina |
| `Product` | Producto |
| `Event` | Evento |
| `Organization` | Organización |
| `Person` | Persona |
| `BreadcrumbList` | Migas de pan |
| `FAQPage` | Preguntas frecuentes |
| `HowTo` | Tutorial paso a paso |

```html
<!-- FAQ Page -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [{
    "@type": "Question",
    "name": "¿Cuánto dura la pasta cocida?",
    "acceptedAnswer": {
      "@type": "Answer",
      "text": "3-5 días en nevera."
    }
  }]
}
</script>
```

## Performance y Core Web Vitals

Google mide la experiencia de usuario con tres métricas clave:

| Métrica | Mide | Bueno | Mejorar |
|---|---|---|---|
| **LCP** (Largest Contentful Paint) | Velocidad de carga del contenido principal | < 2.5s | > 4s |
| **INP** (Interaction to Next Paint) | Respuesta a interacciones | < 200ms | > 500ms |
| **CLS** (Cumulative Layout Shift) | Estabilidad visual | < 0.1 | > 0.25 |

### Mejorar LCP

```html
<!-- Preload de recursos críticos -->
<link rel="preload" href="hero.jpg" as="image" fetchpriority="high">

<!-- Imágenes optimizadas -->
<img src="hero.webp" alt="..." width="1200" height="630" loading="eager" fetchpriority="high">

<!-- Fuentes con display swap -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter&display=swap" rel="stylesheet">
```

### Mejorar CLS

```html
<!-- Dimensiones siempre definidas -->
<img src="foto.jpg" width="800" height="600" alt="...">

<!-- Reservar espacio para anuncios/widgets -->
<div style="min-height: 250px;" id="ad-slot"></div>
```

### Mejorar INP

- Minimiza el JavaScript de bloqueo.
- Divide tareas largas.
- Usa `content-visibility: auto` para contenido fuera de pantalla.

```css
.card-larga {
  content-visibility: auto;
  contain-intrinsic-size: 0 500px;
}
```

## Otras técnicas de performance

```html
<!-- Lazy loading de imágenes -->
<img src="foto.jpg" loading="lazy" decoding="async" alt="...">

<!-- Preconnect a dominios externos -->
<link rel="preconnect" href="https://api.midominio.com">

<!-- Prefetch de la siguiente página -->
<link rel="prefetch" href="/siguiente-pagina.html">

<!-- Diferir JavaScript -->
<script src="app.js" defer></script>
```

| Recurso | Cuándo usarlo |
|---|---|
| `preload` | Recurso crítico de la página actual |
| `prefetch` | Recurso de una página futura probable |
| `preconnect` | Conexión temprana a un dominio |
| `dns-prefetch` | Solo resolver DNS de un dominio |
| `defer` | Ejecutar JS tras parsear HTML |

## Conceptos clave

- El HTML semántico es la base de la accesibilidad: no hay que reinventarlo con ARIA.
- ARIA **añade** semántica cuando no hay etiqueta adecuada; no la sustituye.
- El `alt` describe la función de la imagen, no lo que se ve literalmente.
- WCAG define cuatro principios: perceptible, operable, comprensible, robusto.
- Los datos estructurados (JSON-LD) mejoran cómo aparece tu página en Google.
- Las Core Web Vitals (LCP, INP, CLS) miden la experiencia real del usuario.
- `aria-live` anuncia cambios dinámicos a lectores de pantalla.

## Errores comunes

- **Añadir roles ARIA redundantes** (`role="button"` a un `<button>`).
- **`alt="imagen"` o `alt="foto.jpg"`**: no describe nada.
- **Iconos sin `aria-label` ni texto**: no son accesibles.
- **`display:none` vs `aria-hidden`**: `display:none` ya oculta a lectores de pantalla; no dupliques.
- **No marcar la página actual** con `aria-current="page"`.
- **`title` o `description` fuera de rango** de longitud.
- **Olvidar `og:image`**: la tarjeta al compartir sale sin imagen.
- **No medir las Core Web Vitals**: se optimiza a ciegas.
- **`alt` repetitivo en imágenes decorativas**: debería ser `alt=""`.
- **JSON-LD mal formado**: inválido y Google lo ignora.
