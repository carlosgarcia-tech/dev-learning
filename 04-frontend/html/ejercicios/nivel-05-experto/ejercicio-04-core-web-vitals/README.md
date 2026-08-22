# Ejercicio 04 — Performance: Core Web Vitals

## Enunciado

Crea un `index.html` optimizado para Core Web Vitals: LCP (preload de imagen hero), CLS (dimensiones en imágenes y min-height en slots) e INP (script con `defer`).

## Requisitos

- `<link rel="preload" as="image" fetchpriority="high">` para la imagen hero.
- Imagen hero con `width`, `height`, `fetchpriority="high"` y `loading="eager"`.
- Un `<div>` con `style="min-height: 250px"` para reservar espacio (evitar CLS).
- Un `<script src="app.js" defer>`.
- Al menos 2 imágenes adicionales con `loading="lazy"`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- LCP mejora pre-cargando la imagen más grande (hero) con `fetchpriority="high"`.
- CLS se evita dando `width`/`height` a imágenes y `min-height` a contenedores dinámicos.
- `defer` retrasa la ejecución del JS hasta parsear el HTML, mejorando INP.

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
  <title>Core Web Vitals</title>

  <link rel="preload" href="hero.jpg" as="image" fetchpriority="high">
</head>
<body>
  <h1>Core Web Vitals</h1>

  <img src="hero.jpg" alt="Imagen hero" width="1200" height="630" fetchpriority="high" loading="eager">

  <div style="min-height: 250px;" id="ad-slot">
    <!-- Espacio reservado para un anuncio/widget -->
  </div>

  <img src="foto-1.jpg" alt="Foto 1" loading="lazy" decoding="async" width="400" height="300">
  <img src="foto-2.jpg" alt="Foto 2" loading="lazy" decoding="async" width="400" height="300">

  <script src="app.js" defer></script>
</body>
</html>
```

</details>
