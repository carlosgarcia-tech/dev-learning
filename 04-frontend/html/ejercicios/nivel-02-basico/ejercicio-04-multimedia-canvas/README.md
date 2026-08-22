# Ejercicio 04 — Multimedia: audio, video y canvas

## Enunciado

Crea un `index.html` que incruste un `<audio>` con controles, un `<video>` con poster y un `<canvas>` con un script que dibuje un rectángulo.

## Requisitos

- Un `<audio controls>` con al menos un `<source>`.
- Un `<video controls>` con `poster` y al menos un `<source>`.
- Un `<canvas>` con `id`, `width` y `height`.
- Un `<script>` que obtenga el canvas y dibuje un `fillRect`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa `getElementById` para obtener el canvas y `getContext('2d')`.
- `fillRect(x, y, ancho, alto)` dibuja un rectángulo relleno.
- `poster` es la imagen previa del video antes de reproducirlo.

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
  <title>Multimedia</title>
</head>
<body>
  <h1>Multimedia</h1>

  <h2>Audio</h2>
  <audio controls>
    <source src="cancion.mp3" type="audio/mpeg">
    Tu navegador no soporta audio.
  </audio>

  <h2>Video</h2>
  <video controls width="640" poster="portada.jpg">
    <source src="video.mp4" type="video/mp4">
    Tu navegador no soporta video.
  </video>

  <h2>Canvas</h2>
  <canvas id="lienzo" width="400" height="300"></canvas>

  <script>
    const canvas = document.getElementById('lienzo');
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = '#3b82f6';
    ctx.fillRect(50, 50, 200, 100);
  </script>
</body>
</html>
```

</details>
