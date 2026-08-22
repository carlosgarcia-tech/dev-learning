# Ejercicio 06 — Iframes con sandbox seguro

## Enunciado

Crea un `index.html` que incruste dos iframes: uno básico con `title` y `loading="lazy"`, y otro con `sandbox` restrictivo.

## Requisitos

- Al menos 2 `<iframe>`.
- Cada iframe con `title` descriptivo.
- Al menos un iframe con `loading="lazy"`.
- Al menos un iframe con `sandbox`.
- Al menos un iframe con `width` y `height`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `title` es esencial para accesibilidad del iframe.
- `sandbox` sin valor aplica todas las restricciones; `sandbox="allow-scripts"` permite scripts.
- `loading="lazy"` retrasa la carga hasta que el iframe entra en pantalla.

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
  <title>Iframes</title>
</head>
<body>
  <h1>Iframes</h1>

  <iframe
    src="https://www.youtube.com/embed/dQw4w9WgXcQ"
    title="Video tutorial de HTML"
    width="560"
    height="315"
    loading="lazy"
    allowfullscreen>
  </iframe>

  <iframe
    src="widget.html"
    title="Widget externo"
    width="300"
    height="200"
    sandbox="allow-scripts">
  </iframe>
</body>
</html>
```

</details>
