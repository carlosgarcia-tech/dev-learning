# Ejercicio 04 — Web Worker básico

## Enunciado

Crea un `script.js` y un `worker.js` que usen Web Workers para sumar un array de números en un hilo separado.

## Requisitos

- Un archivo `worker.js` aparte.
- `script.js` con `defer`.
- Uso de `new Worker('worker.js')`.
- `worker.postMessage` para enviar datos.
- `worker.onmessage` para recibir el resultado.
- En `worker.js`, uso de `self.onmessage` y `self.postMessage`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los workers se comunican por mensajes: `postMessage` y `onmessage`.
- Dentro del worker, `self` es el scope global (como `window` en el hilo principal).
- Los workers no pueden acceder al DOM.

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
  <title>Web Worker</title>
  <script src="script.js" defer></script>
</head>
<body>
  <button id="calcular">Calcular suma</button>
  <div id="resultado"></div>
</body>
</html>
```

**script.js**:
```js
const worker = new Worker('worker.js');

worker.onmessage = (e) => {
  document.querySelector('#resultado').textContent = `Suma: ${e.data}`;
};

document.querySelector('#calcular').addEventListener('click', () => {
  worker.postMessage([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
});
```

**worker.js**:
```js
self.onmessage = (e) => {
  const suma = e.data.reduce((a, b) => a + b, 0);
  self.postMessage(suma);
};
```

</details>
