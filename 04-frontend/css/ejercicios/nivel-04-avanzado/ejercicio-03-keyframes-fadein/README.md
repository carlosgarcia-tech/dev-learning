# Ejercicio 03 — Animación con @keyframes (fadeIn)

## Enunciado

Crea un `index.html` y un `style.css` con una animación `@keyframes` llamada `fadeIn` que haga aparecer un elemento cambiando `opacity` y `transform`.

## Requisitos

- Un `@keyframes fadeIn` con `from` y `to`.
- `from` con `opacity: 0` y `transform: translateY(20px)`.
- `to` con `opacity: 1` y `transform: translateY(0)`.
- Un elemento que use `animation: fadeIn 0.6s ease forwards`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `@keyframes nombre { from { ... } to { ... } }`
- `animation-fill-mode: forwards` mantiene el estado final.
- `translateY(20px)` empieza desplazado hacia abajo.

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
  <title>FadeIn</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="modal">Aparecí con animación</div>
</body>
</html>
```

**style.css**:
```css
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modal {
  padding: 24px;
  background: #3b82f6;
  color: white;
  border-radius: 8px;
  animation: fadeIn 0.6s ease forwards;
}
```

</details>
