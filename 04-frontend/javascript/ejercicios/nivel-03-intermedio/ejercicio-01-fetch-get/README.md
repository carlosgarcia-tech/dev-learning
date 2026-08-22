# Ejercicio 01 — Fetch GET básico

## Enunciado

Crea un `index.html` y un `script.js` que use `fetch` para obtener datos de una API y mostrarlos en el DOM.

## Requisitos

- Un `<div id="resultado">`.
- `script.js` con `defer`.
- Uso de `fetch` para obtener datos de `https://jsonplaceholder.typicode.com/users/1`.
- Uso de `async/await`.
- Mostrar el nombre del usuario en el div.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `async function` permite usar `await` dentro.
- `await res.json()` convierte la respuesta a objeto.
- `jsonplaceholder.typicode.com` es una API de prueba gratuita.

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
  <title>Fetch GET</title>
  <script src="script.js" defer></script>
</head>
<body>
  <div id="resultado">Cargando...</div>
</body>
</html>
```

**script.js**:
```js
async function cargarUsuario() {
  const res = await fetch('https://jsonplaceholder.typicode.com/users/1');
  const usuario = await res.json();
  document.querySelector('#resultado').textContent = usuario.name;
}

cargarUsuario();
```

</details>
