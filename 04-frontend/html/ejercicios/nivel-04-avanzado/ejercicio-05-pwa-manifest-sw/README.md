# Ejercicio 05 — PWA: manifest y service worker

## Enunciado

Crea un `index.html` que registre un service worker y enlace un manifest. Crea también los archivos `manifest.json` y `sw.js`.

## Requisitos

- `index.html` con `<link rel="manifest" href="manifest.json">`.
- `index.html` con un `<script>` que registre el service worker con `navigator.serviceWorker.register('/sw.js')`.
- `manifest.json` con `name`, `short_name`, `start_url`, `display` e `icons`.
- `sw.js` con un listener de `install` que abra un cache.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El registro del SW va dentro de `window.addEventListener('load', ...)`.
- `manifest.json` es un archivo JSON con la configuración de la PWA.
- En `sw.js`, `caches.open('v1')` crea/abre un cache.

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
  <title>Mi PWA</title>
  <link rel="manifest" href="manifest.json">
  <meta name="theme-color" content="#3b82f6">
</head>
<body>
  <h1>Mi PWA</h1>
  <script>
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', () => {
        navigator.serviceWorker.register('/sw.js')
          .then((reg) => console.log('SW registrado', reg.scope))
          .catch((err) => console.error('Error', err));
      });
    }
  </script>
</body>
</html>
```

**manifest.json**:
```json
{
  "name": "Mi PWA",
  "short_name": "MiPWA",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#3b82f6",
  "icons": [
    {
      "src": "/icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

**sw.js**:
```js
const CACHE = 'mi-pwa-v1';

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
