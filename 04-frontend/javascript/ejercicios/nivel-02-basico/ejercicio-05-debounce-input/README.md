# Ejercicio 05 — Input en tiempo real con debounce

## Enunciado

Crea un `index.html` con un input de búsqueda y un `script.js` que escuche `input` y aplique debounce (esperar 300ms sin escribir) antes de mostrar el valor.

## Requisitos

- Un `<input id="busqueda">` y un `<div id="resultado">`.
- `script.js` con `defer`.
- `addEventListener('input', ...)` en el input.
- Una función `debounce` que use `setTimeout` y `clearTimeout`.
- Mostrar el valor en el div tras 300ms de inactividad.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `debounce(fn, delay)` devuelve una función que espera `delay` ms antes de ejecutar `fn`.
- `clearTimeout(timer)` cancela el timer anterior.
- `setTimeout` devuelve un ID para poder cancelarlo.

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
  <title>Debounce</title>
  <script src="script.js" defer></script>
</head>
<body>
  <input type="text" id="busqueda" placeholder="Buscar...">
  <div id="resultado">Escribe algo</div>
</body>
</html>
```

**script.js**:
```js
const input = document.querySelector('#busqueda');
const resultado = document.querySelector('#resultado');

function debounce(fn, delay) {
  let timer;
  return function(...args) {
    clearTimeout(timer);
    timer = setTimeout(() => fn.apply(this, args), delay);
  };
}

input.addEventListener('input', debounce((e) => {
  resultado.textContent = `Buscando: ${e.target.value}`;
}, 300));
```

</details>
