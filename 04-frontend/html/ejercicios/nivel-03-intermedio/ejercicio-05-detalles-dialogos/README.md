# Ejercicio 05 — Detalles y diálogos interactivos

## Enunciado

Crea un `index.html` con dos elementos `<details>`/`<summary>` para contenido plegable y un `<dialog>` con JavaScript para abrirlo y cerrarlo.

## Requisitos

- Al menos 2 `<details>` cada uno con su `<summary>`.
- Un `<dialog>` con `id`.
- Un botón con `onclick` que abra el diálogo con `showModal()`.
- Un botón dentro del diálogo que lo cierre con `close()`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `<details open>` aparece abierto por defecto.
- `dialog.showModal()` abre el diálogo modal (con backdrop).
- `dialog.close()` lo cierra.

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
  <title>Interactivo</title>
</head>
<body>
  <h1>Contenido plegable y diálogos</h1>

  <details>
    <summary>¿Qué es HTML?</summary>
    <p>Es un lenguaje de marcado para la web.</p>
  </details>

  <details>
    <summary>¿Qué es CSS?</summary>
    <p>Es un lenguaje de estilos en cascada.</p>
  </details>

  <button onclick="document.getElementById('modal').showModal()">Abrir diálogo</button>

  <dialog id="modal">
    <h2>Hola</h2>
    <p>Este es un diálogo modal nativo.</p>
    <button onclick="document.getElementById('modal').close()">Cerrar</button>
  </dialog>
</body>
</html>
```

</details>
