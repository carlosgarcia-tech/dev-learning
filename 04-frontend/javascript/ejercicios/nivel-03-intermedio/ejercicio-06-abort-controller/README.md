# Ejercicio 06 — AbortController (cancelar fetch)

## Enunciado

Crea un `script.js` que use `AbortController` para cancelar una petición fetch en curso.

## Requisitos

- `script.js` con `defer`.
- Uso de `new AbortController()`.
- Uso de `controller.signal` en el `fetch`.
- Uso de `controller.abort()`.
- Comprobación de `err.name === 'AbortError'` en el catch.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `controller.signal` se pasa como opción a `fetch`.
- `controller.abort()` cancela la petición.
- Al abortar, el `catch` recibe un error con `name === 'AbortError'`.

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
  <title>AbortController</title>
  <script src="script.js" defer></script>
</head>
<body>
  <button id="cargar">Cargar</button>
  <button id="cancelar">Cancelar</button>
  <div id="resultado"></div>
</body>
</html>
```

**script.js**:
```js
let controller;

document.querySelector('#cargar').addEventListener('click', async () => {
  if (controller) controller.abort();

  controller = new AbortController();

  try {
    const res = await fetch('https://jsonplaceholder.typicode.com/users/1', {
      signal: controller.signal
    });
    const usuario = await res.json();
    document.querySelector('#resultado').textContent = usuario.name;
  } catch (err) {
    if (err.name === 'AbortError') {
      console.log('Petición cancelada');
    } else {
      console.error('Error:', err.message);
    }
  }
});

document.querySelector('#cancelar').addEventListener('click', () => {
  if (controller) controller.abort();
});
```

</details>
