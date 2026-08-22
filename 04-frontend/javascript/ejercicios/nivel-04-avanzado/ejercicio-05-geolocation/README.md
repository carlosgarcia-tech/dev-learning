# Ejercicio 05 — Geolocation

## Enunciado

Crea un `script.js` que obtenga la ubicación del usuario con `navigator.geolocation` y muestre latitud y longitud.

## Requisitos

- `script.js` con `defer`.
- Comprobación de `'geolocation' in navigator`.
- Uso de `navigator.geolocation.getCurrentPosition`.
- Mostrar `pos.coords.latitude` y `pos.coords.longitude`.
- Manejo de errores en el segundo callback.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `getCurrentPosition(exito, error)` recibe dos callbacks.
- `pos.coords.latitude` y `pos.coords.longitude` tienen las coordenadas.
- `err.code` indica el tipo de error (1=denegado, 2=no disponible, 3=timeout).

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
  <title>Geolocation</title>
  <script src="script.js" defer></script>
</head>
<body>
  <button id="localizar">Mi ubicación</button>
  <div id="resultado"></div>
</body>
</html>
```

**script.js**:
```js
const boton = document.querySelector('#localizar');
const resultado = document.querySelector('#resultado');

boton.addEventListener('click', () => {
  if ('geolocation' in navigator) {
    navigator.geolocation.getCurrentPosition(
      (pos) => {
        resultado.textContent = `Lat: ${pos.coords.latitude}, Lng: ${pos.coords.longitude}`;
      },
      (err) => {
        resultado.textContent = `Error: ${err.message}`;
      }
    );
  } else {
    resultado.textContent = 'Geolocalización no disponible';
  }
});
```

</details>
