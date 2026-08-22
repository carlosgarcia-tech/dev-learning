# Ejercicio 01 — Estructura base de un documento HTML

## Enunciado

Crea un archivo `index.html` con la estructura mínima y válida de un documento HTML5: doctype, idioma español, head con charset, viewport, title y description; y un body con un encabezado `h1` y un párrafo.

## Requisitos

- `<!DOCTYPE html>` en la primera línea.
- `<html lang="es">`.
- `<meta charset="UTF-8">`.
- `<meta name="viewport" content="width=device-width, initial-scale=1.0">`.
- `<title>` con un título descriptivo.
- `<meta name="description" content="...">`.
- Un `<h1>` y un `<p>` dentro del `<body>`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El doctype se escribe siempre en minúsculas: `<!DOCTYPE html>`.
- El `lang` va en la etiqueta `<html>`, no en `<body>`.
- La descripción debe tener entre 50 y 160 caracteres para SEO.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mi primera página</title>
  <meta name="description" content="Página de ejemplo para aprender la estructura base de HTML5.">
</head>
<body>
  <h1>Hola mundo</h1>
  <p>Esta es mi primera página web.</p>
</body>
</html>
```

</details>
