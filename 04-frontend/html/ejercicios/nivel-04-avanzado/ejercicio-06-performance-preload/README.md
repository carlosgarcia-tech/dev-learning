# Ejercicio 06 — Performance: preload, preconnect y lazy

## Enunciado

Crea un `index.html` con un `<head>` optimizado para performance: `preload` de una imagen crítica, `preconnect` a un dominio externo, fuentes con `display=swap`, e imágenes con `loading` y `decoding`.

## Requisitos

- Un `<link rel="preload" as="image">`.
- Un `<link rel="preconnect">` con `crossorigin`.
- Un `<link>` a Google Fonts con `display=swap` en la URL.
- Una imagen con `loading="lazy"` y `decoding="async"`.
- Una imagen con `fetchpriority="high"` y `loading="eager"`.
- Una imagen con `width` y `height` (evitar CLS).
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `preload` carga recursos críticos antes de que el navegador los descubra.
- `preconnect` establece la conexión temprana a un dominio (fonts, CDN).
- `display=swap` evita texto invisible mientras carga la fuente.
- `width`/`height` evita el layout shift (CLS).

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
  <title>Performance</title>

  <link rel="preload" href="hero.jpg" as="image" fetchpriority="high">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter&display=swap" rel="stylesheet">
</head>
<body>
  <h1>Performance</h1>

  <img src="hero.jpg" alt="Imagen principal" width="1200" height="630" fetchpriority="high" loading="eager">

  <img src="galeria-1.jpg" alt="Galería 1" loading="lazy" decoding="async" width="400" height="300">
  <img src="galeria-2.jpg" alt="Galería 2" loading="lazy" decoding="async" width="400" height="300">
</body>
</html>
```

</details>
