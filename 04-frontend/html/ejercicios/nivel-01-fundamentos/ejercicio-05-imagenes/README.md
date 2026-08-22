# Ejercicio 05 — Imágenes con alt y dimensiones

## Enunciado

Crea un `index.html` con tres imágenes: una con texto alternativo descriptivo, una decorativa (alt vacío) y una con `loading="lazy"` y dimensiones.

## Requisitos

- Al menos 3 etiquetas `<img>`.
- Una imagen con `alt` descriptivo (no vacío, no "imagen").
- Una imagen decorativa con `alt=""`.
- Una imagen con `loading="lazy"`.
- Al menos una imagen con `width` y `height`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `alt=""` (vacío) indica que la imagen es decorativa y el lector de pantalla la ignora.
- `width` y `height` evitan el cambio de layout (CLS).
- `loading="lazy"` retrasa la carga de imágenes fuera de pantalla.

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
  <title>Imágenes</title>
</head>
<body>
  <h1>Galería</h1>

  <img src="paisaje.jpg" alt="Valle montañoso al atardecer con un río" width="800" height="600">

  <img src="decorativa.png" alt="">

  <img src="foto-grande.jpg" alt="Retrato en blanco y negro" loading="lazy" width="400" height="400">
</body>
</html>
```

</details>
