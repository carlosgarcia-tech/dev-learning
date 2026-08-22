# 01 — Fundamentos del DOM

> DOM, selectores, manipulación del DOM, eventos, event delegation, bubbling, capturing.

## Objetivos

- [ ] Entender qué es el DOM y cómo se construye
- [ ] Seleccionar elementos con distintos métodos
- [ ] Manipular el DOM: crear, modificar y eliminar elementos
- [ ] Gestionar clases, atributos y estilos
- [ ] Manejar eventos y entender el flujo (bubbling/capturing)
- [ ] Aplicar event delegation
- [ ] Evitar errores comunes de rendimiento

## ¿Qué es el DOM?

El **DOM** (Document Object Model) es una representación en forma de árbol del documento HTML. El navegador lo construye al parsear el HTML y permite a JavaScript leer y modificar la página dinámicamente.

```
document
  └── html
       ├── head
       │    ├── title
       │    └── meta
       └── body
            ├── header
            │    └── h1
            └── main
                 └── p
```

```js
// document es la raíz
console.log(document.documentElement);  // <html>
console.log(document.body);              // <body>
console.log(document.head);              // <head>
```

## Selectores

### Métodos modernos (recomendados)

```js
// Un solo elemento (el primero que coincida)
const el = document.querySelector('.clase');
const el2 = document.querySelector('#id');
const el3 = document.querySelector('div.tarjeta > h2');

// Varios elementos (NodeList)
const items = document.querySelectorAll('.item');
const parrafos = document.querySelectorAll('p');
```

### Métodos clásicos

```js
document.getElementById('id');              // un elemento
document.getElementsByClassName('clase');    // HTMLCollection (live)
document.getElementsByTagName('p');          // HTMLCollection (live)
```

| Método | Devuelve | ¿Live? |
|---|---|---|
| `querySelector` | Element o `null` | No |
| `querySelectorAll` | NodeList | No |
| `getElementById` | Element o `null` | — |
| `getElementsByClassName` | HTMLCollection | Sí |
| `getElementsByTagName` | HTMLCollection | Sí |

> `querySelectorAll` devuelve un **NodeList** que se puede recorrer con `forEach`. Las `HTMLCollection` no tienen `forEach` (hay que convertirlas con `Array.from()`).

```js
// Iterar NodeList
document.querySelectorAll('.item').forEach((item) => {
  console.log(item.textContent);
});

// Iterar HTMLCollection
Array.from(document.getElementsByClassName('item')).forEach((item) => {
  console.log(item.textContent);
});
```

## Manipular el contenido

```js
const el = document.querySelector('h1');

// Texto (sin HTML)
el.textContent = 'Hola mundo';

// HTML interno
el.innerHTML = '<span>Hola</span> <em>mundo</em>';

// Texto seguro (evita XSS si vienes de datos externos)
el.textContent = userInput;  // no interpreta HTML

// Atributos
const enlace = document.querySelector('a');
console.log(enlace.href);
enlace.setAttribute('target', '_blank');
enlace.removeAttribute('target');
```

> **Seguridad**: usa `textContent` en vez de `innerHTML` cuando el contenido viene del usuario o de una API. `innerHTML` puede inyectar scripts (XSS).

## Crear y eliminar elementos

```js
// Crear
const nuevo = document.createElement('div');
nuevo.textContent = 'Soy nuevo';
nuevo.className = 'caja';

// Añadir
document.body.appendChild(nuevo);           // al final
document.body.prepend(nuevo);               // al principio
document.body.append('texto', otroEl);      // múltiples nodos

// Insertar antes de
const ref = document.querySelector('.referencia');
ref.parentNode.insertBefore(nuevo, ref);

// Insertar adyacente
ref.insertAdjacentElement('beforebegin', nuevo);  // antes
ref.insertAdjacentElement('afterend', nuevo);     // después

// Reemplazar
ref.replaceWith(nuevo);

// Eliminar
nuevo.remove();
// o
nuevo.parentNode.removeChild(nuevo);
```

### `insertAdjacentHTML`

```js
const cont = document.querySelector('.contenedor');
cont.insertAdjacentHTML('beforeend', '<p>Al final</p>');
cont.insertAdjacentHTML('afterbegin', '<p>Al principio</p>');
```

| Posición | Dónde |
|---|---|
| `beforebegin` | Antes del elemento |
| `afterbegin` | Dentro, al principio |
| `beforeend` | Dentro, al final |
| `afterend` | Después del elemento |

## Clases

```js
const el = document.querySelector('.boton');

el.classList.add('activo');
el.classList.remove('activo');
el.classList.toggle('activo');      // añade si no está, quita si está
el.classList.contains('activo');    // true/false
el.classList.replace('viejo', 'nuevo');
```

```js
// Evitar
el.className = 'boton activo';  // sobreescribe todas las clases
```

## Estilos

```js
const el = document.querySelector('.caja');

// Estilos inline (uno a uno)
el.style.color = 'red';
el.style.backgroundColor = '#3b82f6';  // camelCase, no background-color
el.style.fontSize = '18px';

// Múltiples estilos con cssText
el.style.cssText = 'color: red; background: blue;';

// Leer estilo computado
const computed = getComputedStyle(el);
console.log(computed.color);
```

> Para estilos dinámicos complejos, es mejor usar clases CSS (`classList.toggle`) que estilos inline.

## Atributos y data-*

```js
const el = document.querySelector('.tarjeta');

// Atributos
el.setAttribute('data-id', '42');
console.log(el.getAttribute('data-id'));  // '42'

// data-* (acceso directo con dataset)
el.dataset.id;        // '42'
el.dataset.categoria = 'libro';
el.dataset.idUsuario; // lee data-id-usuario
```

```html
<div class="tarjeta" data-id="42" data-categoria="libro"></div>
```

## Eventos

Los eventos son acciones que ocurren en la página (clic, tecla, scroll, carga...).

### addEventListener

```js
const boton = document.querySelector('button');

boton.addEventListener('click', (event) => {
  console.log('Clic en botón');
  console.log(event.target);      // elemento que recibió el clic
  console.log(event.currentTarget); // elemento con el listener
});
```

### Tipos de eventos comunes

| Evento | Cuándo |
|---|---|
| `click` | Clic |
| `dblclick` | Doble clic |
| `mouseenter` / `mouseleave` | Entra/sale el ratón |
| `mousemove` | Movimiento del ratón |
| `keydown` / `keyup` | Tecla pulsada/soltada |
| `submit` | Envío de formulario |
| `input` / `change` | Cambio en input |
| `scroll` | Scroll |
| `resize` | Redimensión de ventana |
| `load` / `DOMContentLoaded` | Carga |

### Objeto event

```js
elemento.addEventListener('click', (e) => {
  e.target;            // elemento que disparó el evento
  e.currentTarget;     // elemento con el listener
  e.type;              // 'click'
  e.preventDefault();  // evita la acción por defecto
  e.stopPropagation(); // evita que suba a los padres
  e.clientX;           // posición X del ratón
  e.clientY;          // posición Y
  e.key;               // tecla pulsada (eventos de teclado)
});
```

### Opciones

```js
elemento.addEventListener('click', handler, { once: true });   // se ejecuta una sola vez
elemento.addEventListener('click', handler, { passive: true }); // no llama preventDefault
```

## Bubbling y capturing

Los eventos se propagan en tres fases:

```
1. Capturing: del document hacia abajo hasta el target
2. Target: en el elemento que disparó el evento
3. Bubbling: del target hacia arriba hasta el document
```

```html
<div id="padre">
  <button id="hijo">Clic</button>
</div>
```

```js
// Bubbling (por defecto): hijo → padre
document.querySelector('#padre').addEventListener('click', () => {
  console.log('Padre');
});

document.querySelector('#hijo').addEventListener('click', () => {
  console.log('Hijo');
});
// Al hacer clic en el botón: "Hijo" → "Padre"
```

```js
// Capturing: padre → hijo (con tercer parámetro true)
document.querySelector('#padre').addEventListener('click', () => {
  console.log('Padre (capturing)');
}, true);
// Al hacer clic: "Padre (capturing)" → "Hijo"
```

### `stopPropagation`

```js
document.querySelector('#hijo').addEventListener('click', (e) => {
  e.stopPropagation();  // el evento no llega al padre
  console.log('Hijo');
});
```

## Event delegation

En vez de añadir un listener a cada elemento, se añade uno solo al contenedor padre y se usa `event.target`. Es más eficiente y funciona con elementos creados dinámicamente.

```js
// Mal: listener en cada botón
document.querySelectorAll('.eliminar').forEach((btn) => {
  btn.addEventListener('click', () => eliminar(btn));
});

// Bien: un solo listener en el contenedor (delegation)
document.querySelector('.lista').addEventListener('click', (e) => {
  if (e.target.matches('.eliminar')) {
    eliminar(e.target);
  }
});
```

```js
// closest busca el ancestro más cercano que coincida
document.querySelector('.lista').addEventListener('click', (e) => {
  const boton = e.target.closest('.eliminar');
  if (boton) {
    const item = boton.closest('.item');
    item.remove();
  }
});
```

> **Ventajas**: un solo listener (memoria), funciona con elementos creados después, menos código.

## DOMContentLoaded vs load

```js
// DOM listo (HTML parseado, sin esperar imágenes)
document.addEventListener('DOMContentLoaded', () => {
  console.log('DOM listo');
});

// Todo cargado (imágenes, estilos, iframes)
window.addEventListener('load', () => {
  console.log('Página completamente cargada');
});
```

## Rendimiento del DOM

- Minimiza las manipulaciones del DOM (son costosas).
- Usa `DocumentFragment` para insertar muchos elementos a la vez.
- Evita leer y escribir el DOM en bucles (fuerza reflow).

```js
// Mal: reflow en cada iteración
for (let i = 0; i < 100; i++) {
  const li = document.createElement('li');
  li.textContent = `Item ${i}`;
  lista.appendChild(li);  // reflow cada vez
}

// Bien: una sola inserción
const fragment = document.createDocumentFragment();
for (let i = 0; i < 100; i++) {
  const li = document.createElement('li');
  li.textContent = `Item ${i}`;
  fragment.appendChild(li);
}
lista.appendChild(fragment);  // un solo reflow
```

## Conceptos clave

- El DOM es el árbol que el navegador construye desde el HTML.
- `querySelector` y `querySelectorAll` son los selectores modernos.
- Usa `textContent` (no `innerHTML`) con datos externos para evitar XSS.
- `classList` es la forma correcta de gestionar clases.
- Los eventos se propagan en capturing (abajo) y bubbling (arriba).
- Event delegation: un listener en el padre en vez de muchos en los hijos.
- `DocumentFragment` evita reflows al insertar muchos elementos.

## Errores comunes

- **Seleccionar antes de que exista**: el script se ejecuta antes de que el DOM esté listo (usa `DOMContentLoaded` o `defer`).
- **Usar `innerHTML` con datos externos**: riesgo de XSS.
- **Añadir listeners en bucles**: mejor event delegation.
- **No usar `closest`**: se navega el DOM manualmente de forma frágil.
- **Leer layout en bucles** (offsetHeight, getComputedStyle): fuerza reflow.
- **Olvidar `removeEventListener`**: fugas de memoria en SPAs.
- **Confundir `target` y `currentTarget`**: target es quien disparó, currentTarget es quien tiene el listener.
- **`className =` sobreescribe**: usa `classList` para no perder clases.
- **No usar `passive: true` en scroll**: puede bloquear el scroll.
