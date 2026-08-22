# Ejercicio 03 — Variables CSS y theming

## Enunciado

Crea un `index.html` y un `style.css` que definan variables CSS en `:root` y cambien el tema con un atributo `data-tema="oscuro"`.

## Requisitos

- Variables en `:root` para `--color-fondo` y `--color-texto`.
- `[data-tema="oscuro"]` que sobreescriba las variables.
- `body` que use `var()` para aplicar las variables.
- El HTML tiene `<body data-tema="claro">`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Define las variables base en `:root`.
- Sobreescribelas en `[data-tema="oscuro"]`.
- Cambiar el atributo en JS cambia todo el tema sin recompilar.

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
  <title>Theming</title>
  <link rel="stylesheet" href="style.css">
</head>
<body data-tema="claro">
  <h1>Theming con variables CSS</h1>
  <p>Cambia el tema:</p>
  <button onclick="document.body.dataset.tema = document.body.dataset.tema === 'claro' ? 'oscuro' : 'claro'">
    Cambiar tema
  </button>
</body>
</html>
```

**style.css**:
```css
:root {
  --color-fondo: #ffffff;
  --color-texto: #1a1a1a;
}

[data-tema="oscuro"] {
  --color-fondo: #1a1a1a;
  --color-texto: #ffffff;
}

body {
  background: var(--color-fondo);
  color: var(--color-texto);
  font-family: sans-serif;
  padding: 24px;
  transition: background 0.3s ease, color 0.3s ease;
}
```

</details>
