# Ejercicio 03 — SEO con meta tags y Open Graph

## Enunciado

Crea un `index.html` con un `<head>` optimizado para SEO que incluya title, description, canonical, robots, y etiquetas Open Graph completas.

## Requisitos

- `<title>` (entre 10 y 60 caracteres de texto interno).
- `<meta name="description">` con `content` de al menos 50 caracteres.
- `<link rel="canonical">`.
- `<meta name="robots" content="index, follow">`.
- Al menos 4 etiquetas `property="og:..."`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `og:title`, `og:description`, `og:image` y `og:url` son las mínimas.
- `canonical` evita que Google indexe duplicados.
- `robots` controla indexación y seguimiento de enlaces.

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
  <title>Recetas de cocina casera y fácil</title>
  <meta name="description" content="Más de 500 recetas caseras fáciles y rápidas, organizadas por categoría. Aprende a cocinar platos deliciosos.">
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="https://micocina.com/recetas">

  <meta property="og:type" content="website">
  <meta property="og:title" content="Recetas de cocina casera y fácil">
  <meta property="og:description" content="Más de 500 recetas caseras.">
  <meta property="og:image" content="https://micocina.com/og.jpg">
  <meta property="og:url" content="https://micocina.com/recetas">
</head>
<body>
  <h1>Recetas de cocina casera</h1>
  <p>Bienvenido a nuestro recetario.</p>
</body>
</html>
```

</details>
