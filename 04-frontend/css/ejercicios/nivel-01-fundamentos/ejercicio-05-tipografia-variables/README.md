# Ejercicio 05 — Tipografía y variables CSS

## Enunciado

Crea un `index.html` y un `style.css` que definan variables CSS en `:root` y las usen para tipografía (font-family, font-size, line-height, font-weight).

## Requisitos

- Variables en `:root` para `--fuente`, `--tamano-base`, `--line-height`.
- `body` usa `var()` para aplicar las variables.
- Un `h1` con font-size distinto (en `rem`).
- Uso de `line-height` sin unidades (ej: `1.6`).
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Define las variables en `:root { --nombre: valor; }`.
- Úsalas con `var(--nombre)`.
- `line-height: 1.6` (sin unidad) es un multiplicador del font-size.

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
  <title>Tipografía</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Título principal</h1>
  <p>Párrafo con tipografía configurada mediante variables CSS.</p>
</body>
</html>
```

**style.css**:
```css
:root {
  --fuente: 'Inter', system-ui, sans-serif;
  --tamano-base: 1rem;
  --line-height: 1.6;
}

body {
  font-family: var(--fuente);
  font-size: var(--tamano-base);
  line-height: var(--line-height);
}

h1 {
  font-size: 2.5rem;
  font-weight: 700;
  line-height: 1.2;
}
```

</details>
