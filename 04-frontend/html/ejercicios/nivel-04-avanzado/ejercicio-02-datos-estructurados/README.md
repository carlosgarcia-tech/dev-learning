# Ejercicio 02 — Datos estructurados JSON-LD

## Enunciado

Crea un `index.html` que incluya dos bloques de datos estructurados en JSON-LD: uno de tipo `Article` y otro de tipo `BreadcrumbList`.

## Requisitos

- Un `<script type="application/ld+json">` con `@type": "Article"`.
- Debe incluir `headline`, `author`, `datePublished`.
- Otro `<script type="application/ld+json">` con `@type": "BreadcrumbList"`.
- Debe incluir `itemListElement` con al menos 2 elementos.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- JSON-LD va dentro de `<script type="application/ld+json">`.
- `BreadcrumbList` muestra la ruta de navegación en Google.
- Cada elemento de `itemListElement` tiene `@type: "ListItem"`, `position` y `name`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Artículo con structured data</title>

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Article",
    "headline": "Cómo aprender HTML",
    "author": {
      "@type": "Person",
      "name": "Ada Lovelace"
    },
    "datePublished": "2026-08-22"
  }
  </script>

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "Inicio",
        "item": "https://midominio.com"
      },
      {
        "@type": "ListItem",
        "position": 2,
        "name": "Artículo",
        "item": "https://midominio.com/articulo"
      }
    ]
  }
  </script>
</head>
<body>
  <h1>Cómo aprender HTML</h1>
  <p>Artículo sobre HTML.</p>
</body>
</html>
```

</details>
