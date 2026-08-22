// Service Worker cache-first aquí
const CACHE = 'cache-v1';

self.addEventListener('install', (e) => {
  // TODO: precachear recursos
});

self.addEventListener('activate', (e) => {
  // TODO: borrar caches antiguos
});

self.addEventListener('fetch', (e) => {
  // TODO: cache-first con fallback offline
});
