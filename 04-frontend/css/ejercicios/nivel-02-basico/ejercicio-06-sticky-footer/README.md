# Ejercicio 06 — Sticky footer con flexbox

## Enunciado

Crea un `index.html` y un `style.css` con un layout donde el footer quede pegado abajo aunque el contenido sea poco, usando flexbox con `flex-direction: column` y `flex: 1` en el main.

## Requisitos

- `body` con `display: flex` y `flex-direction: column`.
- `body` con `min-height: 100vh`.
- `<main>` con `flex: 1` para empujar el footer abajo.
- Un `<header>`, `<main>` y `<footer>`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `flex-direction: column` apila los elementos verticalmente.
- `flex: 1` en el main hace que crezca y ocupe el espacio disponible.
- `min-height: 100vh` asegura que el body ocupe toda la pantalla.

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
  <title>Sticky footer</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header class="header">Cabecera</header>
  <main class="main">Contenido</main>
  <footer class="footer">Pie de página</footer>
</body>
</html>
```

**style.css**:
```css
body {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  margin: 0;
}

.header {
  background: #1a1a1a;
  color: white;
  padding: 16px;
}

.main {
  flex: 1;
  padding: 24px;
  background: #f0f0f0;
}

.footer {
  background: #3b82f6;
  color: white;
  padding: 16px;
}
```

</details>
