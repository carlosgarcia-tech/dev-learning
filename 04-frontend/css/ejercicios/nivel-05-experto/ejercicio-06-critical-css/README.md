# Ejercicio 06 — Performance: critical CSS y optimización

## Enunciado

Crea un `index.html` con CSS crítico inline en el `<head>` y el resto del CSS cargado de forma no bloqueante.

## Requisitos

- Un `<style>` en el `<head>` con CSS crítico (body, hero).
- Un `<link rel="stylesheet">` con `media="print"` y `onload="this.media='all'"` para cargar el resto sin bloquear.
- Un `<noscript>` con el `<link>` normal como fallback.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El CSS crítico es el mínimo para pintar el "above the fold".
- `media="print"` + `onload` carga el CSS sin bloquear el render.
- `<noscript>` asegura que el CSS carga si no hay JS.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**index.html**:
```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Critical CSS</title>

  <!-- CSS crítico inline -->
  <style>
    body { margin: 0; font-family: sans-serif; }
    .hero { height: 100vh; background: #3b82f6; color: white;
            display: flex; align-items: center; justify-content: center; }
  </style>

  <!-- CSS no crítico cargado sin bloquear -->
  <link rel="stylesheet" href="resto.css" media="print" onload="this.media='all'">

  <!-- Fallback sin JS -->
  <noscript>
    <link rel="stylesheet" href="resto.css">
  </noscript>
</head>
<body>
  <section class="hero">
    <h1>Critical CSS</h1>
  </section>
  <p>Resto del contenido.</p>
</body>
</html>
```

</details>
