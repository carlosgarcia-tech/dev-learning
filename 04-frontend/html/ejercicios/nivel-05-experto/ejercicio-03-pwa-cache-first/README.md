# Ejercicio 03 — PWA con estrategia cache-first

## Enunciado

Crea un service worker `sw.js` que implemente una estrategia **cache-first** con fallback a red y página offline. Y un `index.html` que lo registre.

## Requisitos

- `index.html` con `<link rel="manifest">` y registro del SW.
- `sw.js` con evento `install` que precachee recursos en un cache.
- `sw.js` con evento `activate` que borre caches antiguos.
- `sw.js` con evento `fetch` que responda: cache → red → página offline.
- `sw.js` que use `caches.match` y `fetch`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Cache-first: intenta el cache primero, si no está va a la red.
- En `activate`, itera `caches.keys()` y borra los que no son la versión actual con `caches.delete()`.
- El fallback offline suele ser una página `offline.html`.

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
  <title>PWA Cache-First</title>
  <link rel="manifest" href="manifest.json">
</head>
<body>
  <h1>PWA Cache-First</h1>
  <script>
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', () => {
        navigator.serviceWorker.register('/sw.js');
      });
    }
  </script>
</body>
</html>
```

**sw.js**:
```js
const CACHE = 'cache-v1';
const ACTIVOS = ['/', '/index.html', '/offline.html'];

self.addEventListener('install', (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(ACTIVOS)));
  self.skipWaiting();
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', (e) => {
  e.respondWith(
    caches.match(e.request).then((res) => {
      if (res) return res;
      return fetch(e.request).catch(() => caches.match('/offline.html'));
    })
  );
});
```

</details>
