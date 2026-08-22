# 04 — Web APIs

> localStorage, sessionStorage, IndexedDB, IntersectionObserver, MutationObserver, Web Workers, Service Workers, geolocation.

## Objetivos

- [ ] Guardar datos con localStorage y sessionStorage
- [ ] Usar IndexedDB para grandes volúmenes de datos
- [ ] Detectar visibilidad con IntersectionObserver
- [ ] Observar cambios del DOM con MutationObserver
- [ ] Ejecutar tareas pesadas con Web Workers
- [ ] Habilitar offline con Service Workers
- [ ] Obtener la ubicación con Geolocation

## Web Storage

Guarda datos clave-valor (solo strings) en el navegador.

| API | Alcance | Persistencia | Tamaño |
|---|---|---|---|
| `localStorage` | Todo el origen | Hasta borrado manual | ~5MB |
| `sessionStorage` | Pestaña actual | Se cierra con la pestaña | ~5MB |

```js
// Guardar
localStorage.setItem('usuario', JSON.stringify({ nombre: 'Ana', edad: 30 }));

// Leer
const usuario = JSON.parse(localStorage.getItem('usuario'));

// Borrar
localStorage.removeItem('usuario');
localStorage.clear();

// Número de items
localStorage.length;
localStorage.key(0);  // nombre de la clave por índice
```

```js
// Escuchar cambios desde otras pestañas
window.addEventListener('storage', (e) => {
  console.log('Cambió', e.key, e.oldValue, '→', e.newValue);
});
```

> **Limitaciones**: síncrono (bloquea), solo strings, no guardar datos sensibles (cualquier script del origen puede leerlo).

## IndexedDB

Base de datos NoSQL en el navegador para grandes cantidades de datos. Asíncrona, con transacciones.

```js
function abrirDB() {
  return new Promise((resolve, reject) => {
    const req = indexedDB.open('MiDB', 1);

    req.onupgradeneeded = (e) => {
      const db = e.target.result;
      if (!db.objectStoreNames.contains('notas')) {
        db.createObjectStore('notas', { keyPath: 'id' });
      }
    };

    req.onsuccess = (e) => resolve(e.target.result);
    req.onerror = (e) => reject(e.target.error);
  });
}

async function guardarNota(nota) {
  const db = await abrirDB();
  const tx = db.transaction('notas', 'readwrite');
  tx.objectStore('notas').add(nota);

  return new Promise((resolve, reject) => {
    tx.oncomplete = resolve;
    tx.onerror = () => reject(tx.error);
  });
}

async function leerNotas() {
  const db = await abrirDB();
  const tx = db.transaction('notas', 'readonly');

  return new Promise((resolve, reject) => {
    const req = tx.objectStore('notas').getAll();
    req.onsuccess = () => resolve(req.result);
    req.onerror = () => reject(req.error);
  });
}

// Usar
guardarNota({ id: 1, titulo: 'Comprar', texto: 'Pan' })
  .then(() => leerNotas())
  .then((notas) => console.log(notas));
```

| Concepto | Equivalente SQL |
|---|---|
| `database` | Base de datos |
| `objectStore` | Tabla |
| `keyPath` | Clave primaria |
| `index` | Índice de búsqueda |
| `transaction` | Transacción atómica |

## IntersectionObserver

Detecta cuándo un elemento entra o sale del viewport. Mucho más eficiente que `scroll` + cálculos.

```js
const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      observer.unobserve(entry.target);  // una sola vez
    }
  });
}, {
  root: null,          // viewport
  rootMargin: '0px',
  threshold: 0.1       // 10% visible
});

document.querySelectorAll('.animar').forEach((el) => observer.observe(el));
```

### Lazy loading de imágenes

```js
const lazyObserver = new IntersectionObserver((entries, obs) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      const img = entry.target;
      img.src = img.dataset.src;
      obs.unobserve(img);
    }
  });
});

document.querySelectorAll('img[data-src]').forEach((img) => lazyObserver.observe(img));
```

### Infinite scroll

```js
const sentinel = document.querySelector('#sentinel');

const scrollObserver = new IntersectionObserver(async (entries) => {
  if (entries[0].isIntersecting) {
    await cargarMas();
  }
});

scrollObserver.observe(sentinel);
```

## MutationObserver

Observa cambios en el DOM (inserciones, borrados, atributos, texto).

```js
const observer = new MutationObserver((mutations) => {
  mutations.forEach((m) => {
    if (m.type === 'childList') {
      m.addedNodes.forEach((n) => console.log('Añadido:', n));
      m.removedNodes.forEach((n) => console.log('Eliminado:', n));
    }
    if (m.type === 'attributes') {
      console.log('Atributo cambiado:', m.attributeName);
    }
  });
});

observer.observe(document.body, {
  childList: true,      // cambios en hijos
  subtree: true,        // observar descendientes
  attributes: true,     // cambios de atributos
  characterData: true  // cambios de texto
});

observer.disconnect();  // parar
```

## Web Workers

Ejecutan JavaScript en un **hilo separado**, sin bloquear la UI. Ideales para cálculos pesados.

```js
// main.js
const worker = new Worker('worker.js');

worker.postMessage({ numeros: [1, 2, 3, 4, 5] });

worker.onmessage = (e) => {
  console.log('Resultado:', e.data);  // 15
};

worker.onerror = (e) => {
  console.error('Error en worker:', e.message);
};
```

```js
// worker.js
self.onmessage = (e) => {
  const suma = e.data.numeros.reduce((a, b) => a + b, 0);
  self.postMessage(suma);
};
```

| Característica | Descripción |
|---|---|
| Hilo separado | No bloquea la UI |
| Sin acceso al DOM | No puede tocar `document` ni `window` |
| Comunicación por mensajes | `postMessage` |
| `self` | Equivale a `window` dentro del worker |
| `importScripts()` | Carga otros scripts en el worker |

### Inline Workers (desde un Blob)

```js
const codigo = `
  self.onmessage = (e) => {
    self.postMessage(e.data * 2);
  };
`;
const blob = new Blob([codigo], { type: 'application/javascript' });
const worker = new Worker(URL.createObjectURL(blob));
```

## Service Workers

Un Service Worker es un script en segundo plano que actúa como proxy de red. Habilita offline, push notifications y PWA.

```js
// sw.js
const CACHE = 'app-v1';
const ACTIVOS = ['/', '/index.html', '/styles.css', '/app.js'];

self.addEventListener('install', (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(ACTIVOS)));
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
    )
  );
});

self.addEventListener('fetch', (e) => {
  e.respondWith(
    caches.match(e.request).then((res) => res || fetch(e.request))
  );
});
```

```js
// Registrar en la página
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js')
      .then((reg) => console.log('SW registrado'))
      .catch((err) => console.error('Error:', err));
  });
}
```

## Geolocation

Obtiene la ubicación del usuario (con su permiso). Requiere HTTPS o localhost.

```js
if ('geolocation' in navigator) {
  navigator.geolocation.getCurrentPosition(
    (pos) => {
      console.log('Latitud:', pos.coords.latitude);
      console.log('Longitud:', pos.coords.longitude);
      console.log('Precisión:', pos.coords.accuracy);
    },
    (err) => {
      switch (err.code) {
        case 1: console.error('Permiso denegado'); break;
        case 2: console.error('Ubicación no disponible'); break;
        case 3: console.error('Timeout'); break;
      }
    },
    { enableHighAccuracy: true, timeout: 10000, maximumAge: 60000 }
  );
}

// Vigilar movimiento
const watchId = navigator.geolocation.watchPosition((pos) => {
  console.log(pos.coords.latitude, pos.coords.longitude);
});

// Dejar de vigilar
navigator.geolocation.clearWatch(watchId);
```

## Tabla resumen de APIs

| API | Para qué | ¿Bloquea? |
|---|---|---|
| localStorage / sessionStorage | Datos simples | Sí (síncrono) |
| IndexedDB | Datos grandes estructurados | No (asíncrono) |
| IntersectionObserver | Visibilidad de elementos | No |
| MutationObserver | Cambios del DOM | No (callback) |
| Web Workers | Cálculos pesados | No (otro hilo) |
| Service Workers | Offline, PWA | No (otro hilo) |
| Geolocation | Ubicación | No (callback) |

## Conceptos clave

- `localStorage` es síncrono y pequeño; IndexedDB es asíncrona y grande.
- IntersectionObserver reemplaza a `scroll` + `getBoundingClientRect`.
- MutationObserver observa cambios sin necesidad de polling.
- Los Web Workers no pueden acceder al DOM, se comunican por mensajes.
- Los Service Workers requieren HTTPS y viven fuera del hilo de la página.
- Geolocation requiere permiso explícito del usuario.

## Errores comunes

- **Guardar datos sensibles en localStorage**: cualquier script (XSS) puede leerlos.
- **Olvidar `JSON.parse`/`JSON.stringify`**: localStorage solo guarda strings.
- **IndexedDB síncrono**: no lo es, hay que usar callbacks/promesas.
- **No `unobserve`**: los observers siguen observando (fuga de memoria).
- **Manipular el DOM en un Web Worker**: no se puede.
- **Service Worker sin HTTPS**: no se registra.
- **No versionar la caché del SW**: usuarios con caché vieja.
- **Pedir geolocalización al cargar**: mejor tras una acción del usuario.
- **Olvidar `clearWatch`**: el GPS se queda activo (batería).
