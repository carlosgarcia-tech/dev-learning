# Ejercicio 01 — Transiciones en hover

## Enunciado

Crea un `index.html` y un `style.css` con un botón que cambie su color y se eleve al hacer hover, usando `transition`.

## Requisitos

- Un botón con `transition` (al menos `background` y `transform`).
- En `:hover`, cambia el `background` y aplica `transform: translateY(-4px)`.
- Duración y timing function definidos.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `transition: background 0.3s ease, transform 0.2s ease;`
- `transform: translateY(-4px)` eleva el elemento.
- Define el `transition` en el estado base, no en el hover.

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
  <title>Transiciones</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <button class="boton">Pásame el ratón</button>
</body>
</html>
```

**style.css**:
```css
.boton {
  background: #3b82f6;
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.3s ease, transform 0.2s ease;
}

.boton:hover {
  background: #2563eb;
  transform: translateY(-4px);
}
```

</details>
