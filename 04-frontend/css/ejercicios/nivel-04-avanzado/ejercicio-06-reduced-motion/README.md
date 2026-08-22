# Ejercicio 06 — prefers-reduced-motion

## Enunciado

Crea un `index.html` y un `style.css` con animaciones que se desactiven cuando el usuario tiene `prefers-reduced-motion: reduce`.

## Requisitos

- Una animación `@keyframes` activa por defecto.
- Un `@media (prefers-reduced-motion: reduce)` que desactive las animaciones y transiciones.
- El media query debe afectar a `*` con `animation-duration: 0.01ms !important` y `transition-duration: 0.01ms !important`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `@media (prefers-reduced-motion: reduce)` detecta la preferencia del usuario.
- Aplica a `*, *::before, *::after` para cubrir todo.
- Usar `!important` es aceptable aquí para sobreescribir cualquier animación.

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
  <title>Reduced motion</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="caja">Animación que se respeta</div>
</body>
</html>
```

**style.css**:
```css
@keyframes flotar {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

.caja {
  width: 100px;
  height: 100px;
  background: #3b82f6;
  animation: flotar 2s ease-in-out infinite;
}

@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

</details>
