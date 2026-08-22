# 03 — Fetch y async

> fetch API, promises, async/await, manejo de errores, interceptores, carga de datos, loading states.

## Objetivos

- [ ] Entender las promesas y su encadenamiento
- [ ] Usar `async`/`await` para código asíncrono legible
- [ ] Hacer peticiones HTTP con `fetch`
- [ ] Manejar errores de red y de respuesta
- [ ] Implementar estados de carga (loading)
- [ ] Crear interceptores básicos
- [ ] Evitar condiciones de carrera

## Promesas

Una promesa representa un valor que estará disponible en el futuro (o un error).

```js
const promesa = new Promise((resolve, reject) => {
  setTimeout(() => {
    const ok = true;
    if (ok) resolve('Datos recibidos');
    else reject(new Error('Algo falló'));
  });
});

promesa
  .then((data) => console.log(data))     // 'Datos recibidos'
  .catch((err) => console.error(err))     // captura errores
  .finally(() => console.log('Fin'));    // siempre se ejecuta
```

### Estados

| Estado | Descripción |
|---|---|
| `pending` | En curso |
| `fulfilled` | Completada con éxito |
| `rejected` | Falló |

### Encadenamiento

```js
fetch('/api/usuario/1')
  .then((res) => res.json())
  .then((usuario) => fetch(`/api/posts?autor=${usuario.id}`))
  .then((res) => res.json())
  .then((posts) => console.log(posts))
  .catch((err) => console.error('Error:', err));
```

### `Promise.all`, `race`, `allSettled`

```js
// Todas a la vez (falla si una falla)
Promise.all([fetch('/api/a'), fetch('/api/b')])
  .then(([a, b]) => { /* ambas completadas */ });

// La primera que termine
Promise.race([fetch('/api/a'), timeout(5000)])
  .then((res) => console.log('Primera'));

// Todas, recoger errores individualmente
Promise.allSettled([fetch('/api/a'), fetch('/api/b')])
  .then((resultados) => {
    resultados.forEach((r) => {
      if (r.status === 'fulfilled') console.log(r.value);
      else console.error(r.reason);
    });
  });
```

## async / await

`async`/`await` hace que el código asíncrono se lea como síncrono. Es azúcar sobre promesas.

```js
async function cargarUsuario(id) {
  const res = await fetch(`/api/usuario/${id}`);
  const usuario = await res.json();
  return usuario;
}

cargarUsuario(1).then((u) => console.log(u));
```

### Manejo de errores con try/catch

```js
async function cargarDatos() {
  try {
    const res = await fetch('/api/datos');
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const datos = await res.json();
    return datos;
  } catch (err) {
    console.error('Error:', err.message);
    return null;
  }
}
```

## fetch API

`fetch` hace peticiones HTTP y devuelve una promesa con la respuesta.

### GET

```js
// GET simple
const res = await fetch('/api/usuarios');
const usuarios = await res.json();

// Con query params
const params = new URLSearchParams({ page: 1, limit: 10 });
const res = await fetch(`/api/usuarios?${params}`);
const data = await res.json();
```

### POST

```js
// POST con JSON
const res = await fetch('/api/usuarios', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ nombre: 'Ana', email: 'ana@ejemplo.com' })
});

const data = await res.json();
```

```js
// POST con FormData (archivos)
const formData = new FormData();
formData.append('nombre', 'Ana');
formData.append('avatar', fileInput.files[0]);

const res = await fetch('/api/upload', {
  method: 'POST',
  body: formData  // no poner Content-Type, fetch lo calcula
});
```

### Métodos HTTP

| Método | Uso | Ejemplo |
|---|---|---|
| `GET` | Leer datos | `fetch('/api/users')` |
| `POST` | Crear | `fetch('/api/users', { method: 'POST', ... })` |
| `PUT` | Reemplazar | `{ method: 'PUT' }` |
| `PATCH` | Actualizar parcial | `{ method: 'PATCH' }` |
| `DELETE` | Eliminar | `{ method: 'DELETE' }` |

### La respuesta

```js
const res = await fetch('/api/datos');

res.ok;          // true si status 200-299
res.status;      // 200, 404, 500...
res.headers.get('Content-Type');

// Leer el cuerpo (solo una vez)
const json = await res.json();       // como JSON
const texto = await res.text();      // como texto
const blob = await res.blob();       // como blob (archivos)
```

### Headers

```js
const res = await fetch('/api/datos', {
  headers: {
    'Authorization': 'Bearer miToken',
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
});
```

## Manejo de errores

`fetch` solo rechaza la promesa si hay un **error de red**. Un 404 o 500 NO es un error para fetch: hay que comprobar `res.ok`.

```js
async function fetchSeguro(url) {
  try {
    const res = await fetch(url);

    if (!res.ok) {
      throw new Error(`Error ${res.status}: ${res.statusText}`);
    }

    return await res.json();
  } catch (err) {
    if (err instanceof TypeError) {
      console.error('Error de red:', err.message);
    } else {
      console.error('Error HTTP:', err.message);
    }
    return null;
  }
}
```

| Error | Causa |
|---|---|
| `TypeError: Failed to fetch` | Red, CORS, sin conexión |
| `res.status === 404` | Recurso no encontrado |
| `res.status === 401` | No autenticado |
| `res.status === 403` | Sin permisos |
| `res.status === 500` | Error del servidor |

## Loading states

```js
async function cargarUsuarios() {
  const loader = document.querySelector('#loader');
  const lista = document.querySelector('#lista');

  loader.style.display = 'block';
  lista.innerHTML = '';

  try {
    const res = await fetch('/api/usuarios');
    if (!res.ok) throw new Error('Error al cargar');
    const usuarios = await res.json();

    lista.innerHTML = usuarios.map(u => `<li>${u.nombre}</li>`).join('');
  } catch (err) {
    lista.innerHTML = `<li class="error">Error: ${err.message}</li>`;
  } finally {
    loader.style.display = 'none';
  }
}
```

## Interceptores básicos

Un interceptor añade lógica antes o después de cada petición (auth, logging, retry).

```js
// Función fetch personalizada con interceptores
async function apiFetch(url, options = {}) {
  // Añadir token
  const token = localStorage.getItem('token');
  if (token) {
    options.headers = {
      ...options.headers,
      'Authorization': `Bearer ${token}`
    };
  }

  // Hacer la petición
  let res = await fetch(url, options);

  // Si token expirado, refrescar y reintentar
  if (res.status === 401) {
    const nuevoToken = await refrescarToken();
    if (nuevoToken) {
      options.headers['Authorization'] = `Bearer ${nuevoToken}`;
      res = await fetch(url, options);  // reintentar
    }
  }

  return res;
}
```

## Evitar condiciones de carrera

Si el usuario hace varias peticiones rápidas, las respuestas pueden llegar en orden distinto.

```js
let ultimoId = 0;

async function buscar(query) {
  const id = ++ultimoId;
  const res = await fetch(`/api/buscar?q=${query}`);
  const datos = await res.json();

  // Solo actualizar si es la última petición
  if (id === ultimoId) {
    renderizar(datos);
  }
}
```

```js
// Con AbortController (cancelar peticiones)
let controller;

async function buscar(query) {
  if (controller) controller.abort();  // cancelar la anterior

  controller = new AbortController();

  try {
    const res = await fetch(`/api/buscar?q=${query}`, {
      signal: controller.signal
    });
    const datos = await res.json();
    renderizar(datos);
  } catch (err) {
    if (err.name === 'AbortError') return;  // cancelada, ignorar
    console.error(err);
  }
}
```

## Paginación e infinite scroll

```js
let pagina = 1;
let cargando = false;

async function cargarMas() {
  if (cargando) return;
  cargando = true;

  const res = await fetch(`/api/posts?page=${pagina}`);
  const { items, hasMore } = await res.json();

  renderizar(items);
  pagina++;
  cargando = false;

  return hasMore;
}

// Infinite scroll con IntersectionObserver
const observer = new IntersectionObserver(async (entries) => {
  if (entries[0].isIntersecting) {
    const hayMas = await cargarMas();
    if (!hayMas) observer.disconnect();
  }
});

observer.observe(document.querySelector('#sentinel'));
```

## Conceptos clave

- `fetch` solo rechaza por errores de red; hay que comprobar `res.ok`.
- `async`/`await` es más legible que `.then()` pero sigue siendo asíncrono.
- `Promise.all` ejecuta peticiones en paralelo (más rápido).
- `AbortController` cancela peticiones en curso.
- Las condiciones de carrera se evitan con un ID o AbortController.
- `try/catch` captura errores en `async/await`.
- `finally` ejecuta código siempre (ideal para ocultar loaders).

## Errores comunes

- **Olvidar `await`**: la función devuelve una Promise sin resolver.
- **No comprobar `res.ok`**: un 404 no lanza error.
- **No manejar `catch`**: errores silenciados.
- **Llamar `res.json()` dos veces**: el cuerpo solo se lee una vez.
- **Condiciones de carrera**: respuestas llegan en orden distinto.
- **No cancelar peticiones**: peticiones obsoletas siguen ejecutándose.
- **`Promise.all` con una que falla**: todas fallan (usar `allSettled` si conviene).
- **No usar `URLSearchParams`**: construir URLs a mano es propenso a errores.
- **Olvidar el `Content-Type`**: el servidor no entiende el body.
