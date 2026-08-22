# 05 — HTML moderno y avanzado

> Web Components, Custom Elements, Shadow DOM, templates, slots, web storage, geolocation, Intersection Observer, Service Workers, PWA.

## Objetivos

- [ ] Crear Web Components con Custom Elements
- [ ] Aislar estilos con Shadow DOM
- [ ] Reutilizar plantillas con `<template>` y `<slot>`
- [ ] Guardar datos con localStorage, sessionStorage e IndexedDB
- [ ] Obtener la ubicación del usuario con Geolocation
- [ ] Detectar elementos en pantalla con Intersection Observer
- [ ] Convertir un sitio en PWA con Service Worker y manifest
- [ ] Entender el ciclo de vida de un custom element

## Web Components

Los **Web Components** son un conjunto de APIs nativas del navegador que permiten crear **etiquetas HTML personalizadas** reutilizables y encapsuladas, sin necesidad de frameworks.

Tres pilares:
1. **Custom Elements**: definir nuevas etiquetas.
2. **Shadow DOM**: encapsular HTML y CSS.
3. **HTML Templates**: plantillas reutilizables con `<template>` y `<slot>`.

## Custom Elements

```js
// Definir un custom element
class MiBoton extends HTMLElement {
  constructor() {
    super();
    this.addEventListener('click', () => {
      alert('¡Clic en ' + this.getAttribute('label') + '!');
    });
  }

  connectedCallback() {
    this.innerHTML = `<button>${this.getAttribute('label')}</button>`;
  }
}

customElements.define('mi-boton', MiBoton);
```

```html
<mi-boton label="Saludar"></mi-boton>
```

### Reglas de nombramiento

- El nombre debe llevar un **guion** (`mi-boton`, no `miboton`).
- No se pueden usar nombres reservados del estándar.

### Ciclo de vida

| Método | Cuándo se ejecuta |
|---|---|
| `constructor()` | Al crear el elemento |
| `connectedCallback()` | Al insertarse en el DOM |
| `disconnectedCallback()` | Al quitarse del DOM |
| `attributeChangedCallback(name, old, new)` | Al cambiar un atributo observado |
| `adoptedCallback()` | Al moverse a otro documento |

```js
class Reloj extends HTMLElement {
  static get observedAttributes() {
    return ['formato'];
  }

  connectedCallback() {
    this.tick();
    this._timer = setInterval(() => this.tick(), 1000);
  }

  disconnectedCallback() {
    clearInterval(this._timer);
  }

  attributeChangedCallback(name, oldVal, newVal) {
    if (name === 'formato') this.tick();
  }

  tick() {
    const formato = this.getAttribute('formato') || '24h';
    const now = new Date();
    this.textContent = now.toLocaleTimeString('es-ES', {
      hour12: formato === '12h'
    });
  }
}

customElements.define('mi-reloj', Reloj);
```

```html
<mi-reloj formato="24h"></mi-reloj>
```

## Shadow DOM

El Shadow DOM crea un **subárbol aislado** del DOM principal: los estilos CSS externos no afectan al componente y viceversa.

```js
class TarjetaPerfil extends HTMLElement {
  constructor() {
    super();
    const shadow = this.attachShadow({ mode: 'open' });
    shadow.innerHTML = `
      <style>
        :host { display: block; }
        .tarjeta {
          border: 1px solid #ccc;
          padding: 16px;
          border-radius: 8px;
          font-family: sans-serif;
        }
        .nombre { font-size: 1.2rem; font-weight: bold; }
      </style>
      <div class="tarjeta">
        <div class="nombre"><slot name="nombre">Anónimo</slot></div>
        <div class="rol"><slot name="rol">Usuario</slot></div>
      </div>
    `;
  }
}

customElements.define('tarjeta-perfil', TarjetaPerfil);
```

```html
<tarjeta-perfil>
  <span slot="nombre">Ada Lovelace</span>
  <span slot="rol">Matemática</span>
</tarjeta-perfil>
```

| Modo | Acceso desde fuera |
|---|---|
| `open` | `element.shadowRoot` accesible |
| `closed` | No accesible (recomendado rara vez) |

## Templates y slots

El elemento `<template>` define contenido que **no se renderiza** hasta que se clona e inserta. Combinado con `<slot>`, permite plantillas con marcadores de posición.

```html
<template id="tpl-comentario">
  <style>
    .comentario { border: 1px solid #ddd; padding: 12px; margin: 8px 0; }
    .autor { font-weight: bold; color: #3b82f6; }
  </style>
  <div class="comentario">
    <div class="autor"><slot name="autor">Anónimo</slot></div>
    <p><slot name="texto"></slot></p>
    <slot>Contenido por defecto</slot>
  </div>
</template>

<comentario-web>
  <span slot="autor">Grace Hopper</span>
  <span slot="texto">Es mejor pedir perdón que pedir permiso.</span>
</comentario-web>
```

```js
class ComentarioWeb extends HTMLElement {
  constructor() {
    super();
    const shadow = this.attachShadow({ mode: 'open' });
    const tpl = document.getElementById('tpl-comentario');
    shadow.appendChild(tpl.content.cloneNode(true));
  }
}
customElements.define('comentario-web', ComentarioWeb);
```

## Web Storage

Permite guardar datos en el navegador de forma sencilla (clave-valor, solo texto).

| API | Alcance | Persistencia |
|---|---|---|
| `localStorage` | Todo el origen | Hasta borrado manual |
| `sessionStorage` | Pestaña actual | Se cierra con la pestaña |

```js
// Guardar
localStorage.setItem('usuario', 'Ana');
localStorage.setItem('preferencias', JSON.stringify({ tema: 'oscuro', idioma: 'es' }));

// Leer
const usuario = localStorage.getItem('usuario');        // 'Ana'
const prefs = JSON.parse(localStorage.getItem('preferencias')); // { tema: 'oscuro', ... }

// Borrar
localStorage.removeItem('usuario');
localStorage.clear();
```

```js
// Escuchar cambios desde otras pestañas
window.addEventListener('storage', (e) => {
  console.log('Cambió', e.key, 'de', e.oldValue, 'a', e.newValue);
});
```

> **Limitaciones**: ~5MB por origen, síncrono (bloquea), solo strings, **no guardar datos sensibles** (cualquier script puede leerlos).

## IndexedDB

Base de datos **NoSQL** en el navegador para cantidades grandes de datos estructurados. Asíncrona y con transacciones.

```js
// Abrir/crear base de datos
const request = indexedDB.open('MiBase', 1);

request.onupgradeneeded = (e) => {
  const db = e.target.result;
  if (!db.objectStoreNames.contains('notas')) {
    const store = db.createObjectStore('notas', { keyPath: 'id' });
    store.createIndex('titulo', 'titulo', { unique: false });
  }
};

request.onsuccess = (e) => {
  const db = e.target.result;

  // Añadir
  const tx = db.transaction('notas', 'readwrite');
  tx.objectStore('notas').add({ id: 1, titulo: 'Comprar', texto: 'Pan y leche' });

  tx.oncomplete = () => console.log('Guardado');

  // Leer todo
  const txRead = db.transaction('notas', 'readonly');
  txRead.objectStore('notas').getAll().onsuccess = (ev) => {
    console.log(ev.target.result);
  };
};
```

| Concepto | Descripción |
|---|---|
| `database` | La base de datos |
| `object store` | Equivalente a una tabla |
| `keyPath` | Clave primaria |
| `index` | Índice para buscar |
| `transaction` | Operación atómica |

## Geolocation

Obtiene la ubicación del usuario (con su permiso).

```js
if ('geolocation' in navigator) {
  navigator.geolocation.getCurrentPosition(
    (pos) => {
      console.log('Latitud:', pos.coords.latitude);
      console.log('Longitud:', pos.coords.longitude);
      console.log('Precisión:', pos.coords.accuracy, 'm');
    },
    (err) => {
      console.error('Error:', err.message);
    },
    { enableHighAccuracy: true, timeout: 10000 }
  );
} else {
  console.log('Geolocalización no disponible');
}

// Vigilar movimiento continuo
const watchId = navigator.geolocation.watchPosition((pos) => {
  console.log(pos.coords.latitude, pos.coords.longitude);
});

// Dejar de vigilar
navigator.geolocation.clearWatch(watchId);
```

> **Privacidad**: el navegador pide permiso al usuario. Requiere HTTPS (o localhost). No pidas ubicación sin un motivo claro.

## Intersection Observer

Detecta cuándo un elemento entra o sale de la pantalla. Ideal para lazy loading, animaciones al hacer scroll e infinite scroll.

```js
const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      observer.unobserve(entry.target); // una sola vez
    }
  });
}, {
  root: null,           // viewport
  rootMargin: '0px',
  threshold: 0.1        // 10% visible
});

document.querySelectorAll('.animar').forEach((el) => observer.observe(el));
```

### Lazy loading de imágenes con Intersection Observer

```html
<img data-src="foto.jpg" alt="..." class="lazy">
```

```js
const lazyObserver = new IntersectionObserver((entries, obs) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      const img = entry.target;
      img.src = img.dataset.src;
      img.onload = () => img.classList.add('cargada');
      obs.unobserve(img);
    }
  });
});

document.querySelectorAll('img.lazy').forEach((img) => lazyObserver.observe(img));
```

## Mutation Observer

Observa cambios en el DOM (inserciones, borrados, atributos).

```js
const observer = new MutationObserver((mutations) => {
  mutations.forEach((m) => {
    if (m.type === 'childList') {
      m.addedNodes.forEach((n) => console.log('Añadido:', n));
    }
  });
});

observer.observe(document.body, {
  childList: true,
  subtree: true,
  attributes: true
});

observer.disconnect(); // parar
```

## Web Workers

Ejecutan JavaScript en un **hilo separado**, sin bloquear la UI. Ideales para tareas pesadas (cálculos, procesamiento).

```js
// main.js
const worker = new Worker('worker.js');

worker.postMessage({ numeros: [1, 2, 3, 4, 5] });

worker.onmessage = (e) => {
  console.log('Resultado:', e.data);
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

## Service Workers

Un Service Worker es un script que el navegador ejecuta **en segundo plano**, separado de la página. Actúa como proxy de red y habilita offline, push notifications y PWA.

### Ciclo de vida

```
install → activate → fetch (escucha peticiones)
```

```js
// sw.js
const CACHE = 'mi-cache-v1';
const ACTIVOS = [
  '/',
  '/index.html',
  '/styles.css',
  '/app.js',
  '/offline.html'
];

self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE).then((cache) => cache.addAll(ACTIVOS))
  );
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
    caches.match(e.request).then((res) => res || fetch(e.request).catch(() => caches.match('/offline.html')))
  );
});
```

```js
// Registrar en la página
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js')
      .then((reg) => console.log('SW registrado', reg.scope))
      .catch((err) => console.error('Error SW:', err));
  });
}
```

## PWA: Progressive Web App

Una PWA es una web que se comporta como una app: instalable, offline y con notificaciones. Necesita:

1. **HTTPS**
2. **Service Worker** (offline)
3. **Web App Manifest** (instalable)

### Manifest

```json
{
  "name": "Mi App",
  "short_name": "MiApp",
  "description": "Una app de ejemplo",
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
      "type": "image/png",
      "purpose": "any maskable"
    }
  ]
}
```

```html
<link rel="manifest" href="/manifest.json">
<meta name="theme-color" content="#3b82f6">
```

### Evento de instalación

```js
let eventoInstalacion;
window.addEventListener('beforeinstallprompt', (e) => {
  e.preventDefault();
  eventoInstalacion = e;
  mostrarBotonInstalar();
});

botonInstalar.addEventListener('click', async () => {
  if (eventoInstalacion) {
    eventoInstalacion.prompt();
    const { outcome } = await eventoInstalacion.userChoice;
    console.log('Usuario eligió:', outcome);
    eventoInstalacion = null;
  }
});
```

## Tabla resumen de APIs

| API | Para qué |
|---|---|
| Custom Elements | Crear etiquetas propias |
| Shadow DOM | Encapsular estilos |
| Templates/Slots | Plantillas reutilizables |
| localStorage/sessionStorage | Guardar datos simples |
| IndexedDB | Base de datos grande |
| Geolocation | Ubicación |
| Intersection Observer | Detectar visibilidad |
| Mutation Observer | Observar cambios del DOM |
| Web Workers | Cálculos en paralelo |
| Service Workers | Offline y PWA |
| Web App Manifest | Instalabilidad |

## Conceptos clave

- Los Web Components son nativos: funcionan sin React, Vue ni Angular.
- El Shadow DOM aísla CSS: los estilos de fuera no entran y los de dentro no salen.
- `<template>` no renderiza hasta que se clona con `content.cloneNode(true)`.
- `<slot>` define agujeros rellenables desde el uso del componente.
- `localStorage` es síncrono y pequeño; IndexedDB es asíncrono y grande.
- Intersection Observer es mucho más eficiente que `scroll` + cálculos.
- Los Service Workers requieren HTTPS y viven fuera del hilo de la página.
- Una PWA combina manifest + service worker para parecer una app nativa.

## Errores comunes

- **Nombre de custom element sin guion**: `miboton` no se registra, debe ser `mi-boton`.
- **Manipular el DOM en `constructor`**: mejor en `connectedCallback` (aún no está en el DOM).
- **Olvidar `disconnectedCallback`**: quedan timers y listeners colgando (fuga de memoria).
- **CSS global que filtra al Shadow DOM**: no debería, pero `:host` es la forma correcta de estilar el host.
- **Guardar contraseñas en localStorage**: es legible por cualquier script (XSS lo expone).
- **IndexedDB síncrono**: no lo es, hay que usar callbacks/promesas.
- **Service Worker sin HTTPS**: no se registra (salvo localhost).
- **No versionar la caché del SW**: al cambiar `sw.js` los usuarios siguen con caché vieja.
- **Pedir geolocalización al cargar**: mejor tras una acción del usuario.
- **Olvidar `unobserve`**: el observer sigue observando elementos ya procesados.
