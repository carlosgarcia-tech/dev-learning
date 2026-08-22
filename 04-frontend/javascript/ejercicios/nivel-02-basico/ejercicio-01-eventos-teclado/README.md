# Ejercicio 01 — Eventos de teclado

## Enunciado

Crea un `index.html` con un div y un `script.js` que escuche `keydown` y muestre la tecla pulsada y si se usó Ctrl/Cmd.

## Requisitos

- Un `<div id="salida">`.
- `script.js` con `defer`.
- `addEventListener('keydown', ...)` en `document`.
- Mostrar `e.key` en el div.
- Comprobar `e.ctrlKey` o `e.metaKey`.
- Detectar Ctrl+S (preventDefault) y Escape.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `e.key` devuelve el nombre de la tecla ('Enter', 'Escape', 'a').
- `e.ctrlKey` y `e.metaKey` son true si están pulsados.
- `e.preventDefault()` evita la acción por defecto (ej: guardar del navegador).

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
  <title>Teclado</title>
  <script src="script.js" defer></script>
</head>
<body>
  <div id="salida">Pulsa una tecla</div>
</body>
</html>
```

**script.js**:
```js
const salida = document.querySelector('#salida');

document.addEventListener('keydown', (e) => {
  salida.textContent = `Tecla: ${e.key} | Ctrl: ${e.ctrlKey}`;

  if ((e.ctrlKey || e.metaKey) && e.key === 's') {
    e.preventDefault();
    salida.textContent = 'Guardado';
  }

  if (e.key === 'Escape') {
    salida.textContent = 'Cancelado';
  }
});
```

</details>
