# Ejercicio 04 — Tema oscuro con prefers-color-scheme

## Enunciado

Crea un `index.html` y un `style.css` que apliquen tema oscuro automáticamente cuando el usuario lo tenga configurado en el sistema, usando `prefers-color-scheme`.

## Requisitos

- Variables CSS en `:root` para fondo y texto (tema claro por defecto).
- `@media (prefers-color-scheme: dark)` que sobreescriba las variables.
- `body` que use `var()`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `@media (prefers-color-scheme: dark)` detecta el tema del sistema.
- Solo necesitas sobreescribir las variables dentro del media query.
- El resto del CSS no cambia: usa `var()` en todas partes.

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
  <title>Tema oscuro</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Tema automático</h1>
  <p>El tema cambia según tu configuración del sistema.</p>
</body>
</html>
```

**style.css**:
```css
:root {
  --color-fondo: #ffffff;
  --color-texto: #1a1a1a;
}

@media (prefers-color-scheme: dark) {
  :root {
    --color-fondo: #1a1a1a;
    --color-texto: #ffffff;
  }
}

body {
  background: var(--color-fondo);
  color: var(--color-texto);
  font-family: sans-serif;
  padding: 24px;
}
```

</details>
