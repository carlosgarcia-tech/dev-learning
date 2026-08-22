# Ejercicio 06 — Herencia y cascade

## Enunciado

Crea un `index.html` y un `style.css` que demuestren la herencia (font-family y color heredados desde `body`) y la cascada (dos reglas para `p`, la última gana).

## Requisitos

- `body` con `font-family` y `color` definidos.
- Un `p` que herede (sin redefinir) font-family y color.
- Dos reglas para `p` con `color` distinto (la última gana).
- Un elemento que use `inherit`, `initial` o `unset`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `color` y `font-*` se heredan por defecto.
- Si dos reglas tienen la misma especificidad, gana la última.
- `color: inherit` fuerza la herencia explícita.

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
  <title>Herencia</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <p>Párrafo que hereda.</p>
  <div class="forzado">Elemento con inherit.</div>
</body>
</html>
```

**style.css**:
```css
body {
  font-family: system-ui, sans-serif;
  color: #333;
}

/* Cascada: dos reglas para p, gana la última */
p { color: red; }
p { color: blue; }  /* gana */

.forzado {
  color: inherit;  /* hereda explícitamente de body */
}
```

</details>
