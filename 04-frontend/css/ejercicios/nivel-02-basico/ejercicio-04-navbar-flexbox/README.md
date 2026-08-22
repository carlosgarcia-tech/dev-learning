# Ejercicio 04 — Navbar con flexbox y space-between

## Enunciado

Crea un `index.html` y un `style.css` con una navbar que tenga un logo a la izquierda y los enlaces a la derecha, usando flexbox con `justify-content: space-between`.

## Requisitos

- Un `<nav>` con `display: flex`.
- `justify-content: space-between`.
- `align-items: center`.
- Un logo (texto o imagen) a la izquierda.
- Los enlaces dentro de un contenedor también flex con `gap`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `space-between` empuja el primer y último elemento a los extremos.
- Los enlaces pueden ir en un `<div>` o `<ul>` con `display: flex` y `gap`.
- `align-items: center` alinea verticalmente.

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
  <title>Navbar</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <nav class="navbar">
    <div class="navbar__logo">MiLogo</div>
    <div class="navbar__links">
      <a href="#">Inicio</a>
      <a href="#">Productos</a>
      <a href="#">Contacto</a>
    </div>
  </nav>
</body>
</html>
```

**style.css**:
```css
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 24px;
  background: #1a1a1a;
}

.navbar__logo {
  color: white;
  font-weight: bold;
  font-size: 1.2rem;
}

.navbar__links {
  display: flex;
  gap: 24px;
}

.navbar__links a {
  color: white;
  text-decoration: none;
}
```

</details>
