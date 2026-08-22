# Ejercicio 06 — Service Worker básico

## Enunciado

Crea un `index.html`, un `script.js` que registre un service worker y un `sw.js` que escuche `install` y `fetch`.

## Requisitos

- `index.html` con `<script src="script.js" defer>`.
- `script.js` con `navigator.serviceWorker.register('/sw.js')`.
- Comprobación de `'serviceWorker' in navigator`.
- `sw.js` con `addEventListener('install', ...)`.
- `sw.js` con `addEventListener('fetch', ...)`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El registro va dentro de `window.addEventListener('load', ...)`.
- `caches.open()` crea/abre un cache en el `install`.
- En `fetch`, `caches.match()` busca en el cache.

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
  <title>Service Worker</title>
  <script src="script.js" defer></script>
</head>
<body>
  <h1>PWA básica</h1>
</body>
</html>
```

**script.js**:
```js
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js')
      .then((reg) => console.log('SW registrado', reg.scope))
      .catch((err) => console.error('Error:', err));
  });
}
```

**sw.js**:
```js
const CACHE = 'app-v1';

self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE).then((cache) => cache.addAll(['/', '/index.html']))
  );
});

self.addEventListener('fetch', (e) => {
  e.respondWith(
    caches.match(e.request).then((res) => res || fetch(e.request))
  );
});
```

</details>
