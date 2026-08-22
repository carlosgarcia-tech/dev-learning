# Ejercicio 01 — Selectores y especificidad

## Enunciado

Crea un `index.html` y un `style.css` donde demuestres el uso de selectores de etiqueta, clase, id, atributo y pseudo-clases (`:hover`, `:first-child`, `nth-child`).

## Requisitos

- Un `style.css` enlazado desde el HTML.
- Selector de etiqueta (`p` o `h1`).
- Selector de clase (`.destacado`).
- Selector de id (`#cabecera`).
- Selector de atributo (`[type="email"]`).
- Pseudo-clase `:hover` en un enlace.
- Pseudo-clase `:first-child` en una lista.
- Pseudo-clase `:nth-child` para alternar colores.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Enlaza el CSS con `<link rel="stylesheet" href="style.css">`.
- `:nth-child(odd)` alterna elementos impares.
- Los selectores de atributo usan corchetes: `[type="email"]`.

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
  <title>Selectores</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header id="cabecera">
    <h1>Selectores CSS</h1>
  </header>
  <p class="destacado">Párrafo destacado</p>
  <p>Párrafo normal</p>
  <input type="email" placeholder="Email">
  <a href="#">Enlace con hover</a>
  <ul>
    <li>Primero</li>
    <li>Segundo</li>
    <li>Tercero</li>
  </ul>
</body>
</html>
```

**style.css**:
```css
h1 { color: #3b82f6; }
.destacado { font-weight: bold; background: yellow; }
#cabecera { background: #f0f0f0; padding: 16px; }
[type="email"] { border: 2px solid green; }
a:hover { color: red; }
li:first-child { font-weight: bold; }
li:nth-child(odd) { background: #eee; }
```

</details>
