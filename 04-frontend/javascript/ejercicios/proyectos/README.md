# Proyecto final — JavaScript (Frontend)

## App de tareas (Todo List) con vanilla JS

Construye una aplicación de tareas completa usando únicamente JavaScript vanilla (sin frameworks). El objetivo es demostrar dominio del DOM, eventos, fetch, Web APIs y módulos.

### Requisitos

- Manipulación del DOM: crear, editar y eliminar tareas dinámicamente.
- Eventos: clic, submit, y event delegation en la lista.
- Formulario controlado con validación (tarea no vacía, mínimo 3 caracteres).
- `fetch` a una API de prueba (ej: `jsonplaceholder.typicode.com/todos`) para cargar tareas iniciales.
- Loading state mientras carga la API.
- Manejo de errores con mensaje al usuario.
- `localStorage` para persistir las tareas.
- Filtrar tareas: todas, pendientes, completadas.
- IntersectionObserver para animar la entrada de tareas.
- ES modules: separar en `main.js`, `api.js`, `storage.js`, `dom.js`.
- Los tests pasan: `bash test.sh`

### Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa event delegation: un listener en el `<ul>` para todos los botones de eliminar.
- Para persistir, guarda el array de tareas en `localStorage` con `JSON.stringify`.
- Carga inicial con `fetch` y fallback a tareas vacías si hay error.
- Separa la lógica en módulos: `api.js` (fetch), `storage.js` (localStorage), `dom.js` (render).

</details>

### Solución

<details>
<summary>Mostrar solución</summary>

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Todo App</title>
</head>
<body>
  <h1>Todo App</h1>
  <form id="form">
    <input type="text" id="input" placeholder="Nueva tarea" minlength="3" required>
    <button type="submit">Añadir</button>
  </form>
  <div id="loader" style="display:none">Cargando...</div>
  <div id="error"></div>
  <div id="filtros">
    <button data-filtro="todas">Todas</button>
    <button data-filtro="pendientes">Pendientes</button>
    <button data-filtro="completadas">Completadas</button>
  </div>
  <ul id="lista"></ul>
  <script type="module" src="main.js"></script>
</body>
</html>
```

**api.js**:
```js
export async function cargarTareas() {
  const res = await fetch('https://jsonplaceholder.typicode.com/todos?_limit=5');
  if (!res.ok) throw new Error('Error al cargar');
  return res.json();
}
```

**storage.js**:
```js
const KEY = 'tareas';
export function guardar(tareas) { localStorage.setItem(KEY, JSON.stringify(tareas)); }
export function leer() { return JSON.parse(localStorage.getItem(KEY) || '[]'); }
```

**dom.js**:
```js
export function renderizar(lista, contenedor) {
  contenedor.innerHTML = lista.map(t => `
    <li data-id="${t.id}">
      <span style="${t.completed ? 'text-decoration:line-through' : ''}">${t.title}</span>
      <button class="toggle">✓</button>
      <button class="eliminar">✗</button>
    </li>
  `).join('');
}
```

**main.js**:
```js
import { cargarTareas } from './api.js';
import { guardar, leer } from './storage.js';
import { renderizar } from './dom.js';

let tareas = leer();
let filtro = 'todas';
const lista = document.querySelector('#lista');
const loader = document.querySelector('#loader');

function actualizar() {
  let filtradas = tareas;
  if (filtro === 'pendientes') filtradas = tareas.filter(t => !t.completed);
  if (filtro === 'completadas') filtradas = tareas.filter(t => t.completed);
  renderizar(filtradas, lista);
  guardar(tareas);
}

document.querySelector('#form').addEventListener('submit', (e) => {
  e.preventDefault();
  const input = document.querySelector('#input');
  if (input.value.trim().length < 3) return;
  tareas.push({ id: Date.now(), title: input.value, completed: false });
  input.value = '';
  actualizar();
});

lista.addEventListener('click', (e) => {
  const li = e.target.closest('li');
  if (!li) return;
  const id = Number(li.dataset.id);
  if (e.target.matches('.eliminar')) tareas = tareas.filter(t => t.id !== id);
  if (e.target.matches('.toggle')) {
    tareas = tareas.map(t => t.id === id ? { ...t, completed: !t.completed } : t);
  }
  actualizar();
});

document.querySelector('#filtros').addEventListener('click', (e) => {
  if (e.target.dataset.filtro) { filtro = e.target.dataset.filtro; actualizar(); }
});

async function init() {
  if (tareas.length === 0) {
    loader.style.display = 'block';
    try { tareas = await cargarTareas(); }
    catch (err) { document.querySelector('#error').textContent = err.message; }
    finally { loader.style.display = 'none'; }
  }
  actualizar();
}
init();
```

</details>
