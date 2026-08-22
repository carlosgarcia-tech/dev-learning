# Ejercicio 05 — Loading state

## Enunciado

Crea un `script.js` que muestre un loader mientras hace fetch y lo oculte al terminar (en `finally`).

## Requisitos

- Un `<div id="loader">` y un `<div id="resultado">` en el HTML.
- `script.js` con `defer`.
- Mostrar el loader antes del fetch (`style.display = 'block'`).
- Ocultar el loader en `finally` (`style.display = 'none'`).
- Mostrar el resultado o el error.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `loader.style.display = 'block'` muestra el loader.
- `finally` se ejecuta siempre, éxito o error.
- Es buena práctica vaciar el resultado antes de una nueva carga.

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
  <title>Loading</title>
  <script src="script.js" defer></script>
</head>
<body>
  <button id="cargar">Cargar</button>
  <div id="loader" style="display:none">Cargando...</div>
  <div id="resultado"></div>
</body>
</html>
```

**script.js**:
```js
document.querySelector('#cargar').addEventListener('click', async () => {
  const loader = document.querySelector('#loader');
  const resultado = document.querySelector('#resultado');

  loader.style.display = 'block';
  resultado.textContent = '';

  try {
    const res = await fetch('https://jsonplaceholder.typicode.com/users/1');
    if (!res.ok) throw new Error('Error');
    const usuario = await res.json();
    resultado.textContent = usuario.name;
  } catch (err) {
    resultado.textContent = `Error: ${err.message}`;
  } finally {
    loader.style.display = 'none';
  }
});
```

</details>
