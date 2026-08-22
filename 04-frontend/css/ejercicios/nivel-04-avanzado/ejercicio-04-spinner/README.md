# Ejercicio 04 — Spinner de carga

## Enunciado

Crea un `index.html` y un `style.css` con un spinner de carga que rote indefinidamente usando `@keyframes` y `animation: infinite`.

## Requisitos

- Un `@keyframes spin` que rote de `0deg` a `360deg`.
- Un elemento con `animation: spin 0.8s linear infinite`.
- El spinner con `border` y `border-radius: 50%`.
- `border-top-color` distinto para crear el efecto.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `border: 4px solid #e5e7eb` crea el círculo base.
- `border-top-color: #3b82f6` colorea solo la parte superior.
- `linear` mantiene velocidad constante.

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
  <title>Spinner</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="spinner"></div>
</body>
</html>
```

**style.css**:
```css
@keyframes spin {
  to { transform: rotate(360deg); }
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #e5e7eb;
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
```

</details>
