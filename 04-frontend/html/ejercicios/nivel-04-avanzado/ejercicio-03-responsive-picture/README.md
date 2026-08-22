# Ejercicio 03 — Responsive con picture y srcset

## Enunciado

Crea un `index.html` con un `<picture>` que sirva diferentes formatos (avif, webp, jpg) y un `<img>` con `srcset` y `sizes` para imágenes responsivas.

## Requisitos

- Un `<picture>` con al menos 2 `<source>` (avif y webp) y un `<img>` fallback.
- El `<img>` dentro de `<picture>` con `alt`.
- Un `<img>` (fuera del picture) con `srcset` (al menos 2 tamaños) y `sizes`.
- Ambas imágenes con `loading="lazy"`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `<source>` usa `srcset` y `type` para el formato.
- `srcset="img-400.jpg 400w, img-800.jpg 800w"` lista tamaños.
- `sizes="(max-width: 600px) 400px, 800px"` indica qué tamaño usar.

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
  <title>Imágenes responsivas</title>
</head>
<body>
  <h1>Imágenes responsivas</h1>

  <picture>
    <source srcset="logo.avif" type="image/avif">
    <source srcset="logo.webp" type="image/webp">
    <img src="logo.jpg" alt="Logo de la empresa" loading="lazy">
  </picture>

  <img
    srcset="foto-400.jpg 400w, foto-800.jpg 800w, foto-1200.jpg 1200w"
    sizes="(max-width: 600px) 400px, (max-width: 1200px) 800px, 1200px"
    src="foto-800.jpg"
    alt="Foto responsiva"
    loading="lazy"
  >
</body>
</html>
```

</details>
