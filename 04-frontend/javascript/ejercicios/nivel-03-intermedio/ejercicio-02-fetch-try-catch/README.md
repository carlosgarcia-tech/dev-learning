# Ejercicio 02 — Fetch con try/catch

## Enunciado

Crea un `script.js` que haga un fetch con manejo de errores usando `try/catch` y compruebe `res.ok`.

## Requisitos

- `script.js` con `defer`.
- Uso de `try/catch`.
- Comprobación de `!res.ok` con `throw new Error`.
- Mensaje de error en consola en el `catch`.
- Un `finally` que oculte un loader.
- Un `<div id="loader">` y un `<div id="error">` en el HTML.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `if (!res.ok) throw new Error('...')` lanza un error si el status no es 200-299.
- `catch (err)` captura errores de red y los lanzados manualmente.
- `finally` se ejecuta siempre, haya error o no.

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
  <title>Try/catch</title>
  <script src="script.js" defer></script>
</head>
<body>
  <div id="loader">Cargando...</div>
  <div id="error"></div>
  <div id="resultado"></div>
</body>
</html>
```

**script.js**:
```js
async function cargar() {
  const loader = document.querySelector('#loader');
  const errorDiv = document.querySelector('#error');
  const resultado = document.querySelector('#resultado');

  try {
    const res = await fetch('https://jsonplaceholder.typicode.com/users/1');
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const usuario = await res.json();
    resultado.textContent = usuario.name;
  } catch (err) {
    errorDiv.textContent = `Error: ${err.message}`;
  } finally {
    loader.style.display = 'none';
  }
}

cargar();
```

</details>
