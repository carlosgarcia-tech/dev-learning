# Ejercicio 03 — Flexbox: centrado perfecto

## Enunciado

Crea un `index.html` y un `style.css` con un contenedor que centre perfectamente su contenido (horizontal y vertical) usando flexbox.

## Requisitos

- Un contenedor con `display: flex`.
- `justify-content: center`.
- `align-items: center`.
- El contenedor con `min-height: 100vh`.
- Un elemento hijo centrado.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `justify-content` alinea en el eje principal (horizontal en `row`).
- `align-items` alinea en el eje cruzado (vertical en `row`).
- `min-height: 100vh` hace que el contenedor ocupe toda la pantalla.

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
  <title>Centrado</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="contenedor">
    <div class="hijo">Centrado</div>
  </div>
</body>
</html>
```

**style.css**:
```css
.contenedor {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: #f0f0f0;
}

.hijo {
  padding: 24px;
  background: #3b82f6;
  color: white;
  border-radius: 8px;
}
```

</details>
