# Ejercicio 01 — Open Graph y Twitter Cards

## Enunciado

Crea un `index.html` con un `<head>` que incluya etiquetas Open Graph completas y Twitter Cards para que la página se vea bien al compartirla.

## Requisitos

- `og:type`, `og:title`, `og:description`, `og:image`, `og:url`, `og:site_name`.
- `twitter:card`, `twitter:title`, `twitter:description`, `twitter:image`.
- Un `<title>` y `<meta name="description">`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `twitter:card="summary_large_image"` muestra una tarjeta con imagen grande.
- `og:image` idealmente 1200×630 px.
- Todos los `og:` y `twitter:` van en el `<head>`.

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
  <title>Curso de HTML desde cero</title>
  <meta name="description" content="Aprende HTML desde cero hasta nivel avanzado con ejercicios prácticos.">

  <meta property="og:type" content="website">
  <meta property="og:title" content="Curso de HTML desde cero">
  <meta property="og:description" content="Aprende HTML con ejercicios prácticos.">
  <meta property="og:image" content="https://midominio.com/og.jpg">
  <meta property="og:url" content="https://midominio.com/html">
  <meta property="og:site_name" content="Mi Curso">

  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Curso de HTML desde cero">
  <meta name="twitter:description" content="Aprende HTML con ejercicios prácticos.">
  <meta name="twitter:image" content="https://midominio.com/og.jpg">
</head>
<body>
  <h1>Curso de HTML</h1>
</body>
</html>
```

</details>
