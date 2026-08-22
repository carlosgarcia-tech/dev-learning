# Ejercicio 03 — Fetch POST con JSON

## Enunciado

Crea un `script.js` que envíe datos a una API con `fetch` POST y `JSON.stringify`.

## Requisitos

- `script.js` con `defer`.
- Uso de `fetch` con `method: 'POST'`.
- `headers` con `'Content-Type': 'application/json'`.
- `body: JSON.stringify(datos)`.
- Uso de `async/await`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `body` de un POST con JSON debe ir como string (`JSON.stringify`).
- El `Content-Type` debe ser `application/json`.
- `jsonplaceholder` acepta POST de prueba y devuelve el objeto creado con un id.

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
  <title>POST</title>
  <script src="script.js" defer></script>
</head>
<body>
  <button id="enviar">Crear usuario</button>
  <div id="resultado"></div>
</body>
</html>
```

**script.js**:
```js
const boton = document.querySelector('#enviar');

boton.addEventListener('click', async () => {
  const datos = { nombre: 'Ana', email: 'ana@ejemplo.com' };

  const res = await fetch('https://jsonplaceholder.typicode.com/users', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(datos)
  });

  const resultado = await res.json();
  document.querySelector('#resultado').textContent = `Creado con id: ${resultado.id}`;
});
```

</details>
