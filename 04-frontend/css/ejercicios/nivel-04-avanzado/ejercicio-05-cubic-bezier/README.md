# Ejercicio 05 — cubic-bezier personalizado

## Enunciado

Crea un `index.html` y un `style.css` con un elemento que use `cubic-bezier` como timing function para crear un efecto de rebote.

## Requisitos

- Un elemento con `transition` que use `cubic-bezier(...)`.
- El `cubic-bezier` debe tener un valor negativo o mayor a 1 (efecto rebote).
- En hover, el elemento se transforma (scale o translate).
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `cubic-bezier(0.68, -0.55, 0.27, 1.55)` crea un rebote.
- Los valores fuera de [0,1] en y crean sobreimpulso.
- [cubic-bezier.com](https://cubic-bezier.com/) ayuda a visualizar.

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
  <title>Cubic-bezier</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="caja">Pásame el ratón</div>
</body>
</html>
```

**style.css**:
```css
.caja {
  width: 150px;
  height: 150px;
  background: #3b82f6;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.4s cubic-bezier(0.68, -0.55, 0.27, 1.55);
}

.caja:hover {
  transform: scale(1.3);
}
```

</details>
