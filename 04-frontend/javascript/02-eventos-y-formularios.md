# 02 — Eventos y formularios

> Tipos de eventos, event object, preventDefault, stopPropagation, validación de formularios, FormData.

## Objetivos

- [ ] Conocer los tipos de evento más comunes
- [ ] Usar el objeto event correctamente
- [ ] Aplicar `preventDefault` y `stopPropagation` cuando hace falta
- [ ] Validar formularios con JavaScript
- [ ] Recoger datos con FormData
- [ ] Manejar eventos de teclado y ratón
- [ ] Implementar envío de formularios con fetch

## Tipos de eventos

### Eventos de ratón

| Evento | Descripción |
|---|---|
| `click` | Clic completo (down + up) |
| `dblclick` | Doble clic |
| `mousedown` / `mouseup` | Botón pulsado / soltado |
| `mouseenter` / `mouseleave` | Entra / sale (no burbujea) |
| `mouseover` / `mouseout` | Entra / sale (burbujea) |
| `mousemove` | Movimiento del ratón |
| `contextmenu` | Clic derecho |

```js
elemento.addEventListener('click', (e) => {
  console.log('Botón:', e.button);     // 0=izquierdo, 1=medio, 2=derecho
  console.log('Posición:', e.clientX, e.clientY);
});
```

### Eventos de teclado

| Evento | Descripción |
|---|---|
| `keydown` | Tecla pulsada (se repite) |
| `keyup` | Tecla soltada |

```js
document.addEventListener('keydown', (e) => {
  console.log('Tecla:', e.key);        // 'Enter', 'Escape', 'a'
  console.log('Código:', e.code);      // 'Enter', 'KeyA'
  console.log('Ctrl:', e.ctrlKey);    // true/false
  console.log('Shift:', e.shiftKey);
});
```

### Eventos de formulario

| Evento | Descripción |
|---|---|
| `submit` | Envío del formulario |
| `input` | Cambio en tiempo real |
| `change` | Cambio al perder el foco |
| `focus` / `blur` | Gana / pierde foco |
| `focusin` / `focusout` | Gana / pierde foco (burbujea) |

## El objeto event

```js
elemento.addEventListener('click', (e) => {
  e.target;              // elemento que disparó el evento
  e.currentTarget;       // elemento con el listener
  e.type;                // tipo de evento ('click')
  e.preventDefault();    // evita acción por defecto
  e.stopPropagation();   // evita propagación
  e.stopImmediatePropagation(); // evita otros listeners en el mismo elemento
});
```

## `preventDefault`

Evita el comportamiento por defecto del evento.

```js
// Evitar que un enlace navegue
document.querySelector('a').addEventListener('click', (e) => {
  e.preventDefault();
  console.log('Enlace bloqueado');
});

// Evitar que un formulario recargue la página
form.addEventListener('submit', (e) => {
  e.preventDefault();
  console.log('Formulario interceptado');
});
```

## `stopPropagation`

Evita que el evento se propague a los elementos padre.

```js
document.querySelector('.modal').addEventListener('click', (e) => {
  e.stopPropagation();  // el clic no llega al overlay detrás
});

document.querySelector('.overlay').addEventListener('click', () => {
  cerrarModal();
});
```

## Validación de formularios

### Validación nativa (HTML5)

```html
<form>
  <input type="email" required>
  <input type="text" required minlength="3">
  <input type="text" pattern="[0-9]{5}">
</form>
```

### Validación con JavaScript

```js
const form = document.querySelector('#registro');

form.addEventListener('submit', (e) => {
  e.preventDefault();

  const nombre = form.nombre.value.trim();
  const email = form.email.value.trim();
  const errores = [];

  if (nombre.length < 3) {
    errores.push('El nombre debe tener al menos 3 caracteres');
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    errores.push('Email no válido');
  }

  if (errores.length > 0) {
    mostrarErrores(errores);
    return;
  }

  // Envío
  enviarFormulario(form);
});

function mostrarErrores(errores) {
  const div = document.querySelector('#errores');
  div.innerHTML = errores.map(e => `<p>${e}</p>`).join('');
}
```

### API de validación nativa

```js
const input = document.querySelector('#email');

input.addEventListener('input', () => {
  input.checkValidity();  // true/false
  input.setCustomValidity('');  // limpiar

  if (!input.validity.valid) {
    if (input.validity.typeMismatch) {
      input.setCustomValidity('Introduce un email válido');
    } else if (input.validity.valueMissing) {
      input.setCustomValidity('Este campo es obligatorio');
    }
  }
});
```

| Propiedad de `validity` | true si... |
|---|---|
| `valueMissing` | está vacío y es `required` |
| `typeMismatch` | no cumple el tipo (email, url) |
| `patternMismatch` | no cumple el `pattern` |
| `tooShort` / `tooLong` | no cumple `minlength`/`maxlength` |
| `rangeUnderflow` / `rangeOverflow` | fuera de `min`/`max` |
| `valid` | válido en general |

## FormData

`FormData` recoge todos los datos de un formulario de forma sencilla.

```js
const form = document.querySelector('#registro');

form.addEventListener('submit', (e) => {
  e.preventDefault();

  const formData = new FormData(form);

  // Obtener un valor
  const nombre = formData.get('nombre');

  // Iterar todos los valores
  for (const [key, value] of formData.entries()) {
    console.log(key, value);
  }

  // Convertir a objeto
  const datos = Object.fromEntries(formData.entries());
  console.log(datos);

  // Enviar con fetch
  fetch('/api/registro', {
    method: 'POST',
    body: formData  // envía como multipart/form-data
  });
});
```

### Manipular FormData

```js
const fd = new FormData();
fd.append('nombre', 'Ana');
fd.append('email', 'ana@ejemplo.com');
fd.append('intereses', 'deportes');
fd.append('intereses', 'musica');  // múltiples valores

fd.get('nombre');               // 'Ana'
fd.getAll('intereses');         // ['deportes', 'musica']
fd.has('email');                // true
fd.delete('email');
fd.set('nombre', 'Carlos');
```

| Método | Descripción |
|---|---|
| `get(name)` | Primer valor |
| `getAll(name)` | Todos los valores (arrays) |
| `has(name)` | Si existe |
| `append(name, value)` | Añadir |
| `set(name, value)` | Reemplazar |
| `delete(name)` | Eliminar |
| `entries()` | Iterador de pares |

## Eventos de input en tiempo real

```js
const input = document.querySelector('#busqueda');

// input: cada vez que cambia el valor
input.addEventListener('input', (e) => {
  console.log('Valor actual:', e.target.value);
});

// Debounce: esperar a que el usuario deje de escribir
function debounce(fn, delay) {
  let timer;
  return function(...args) {
    clearTimeout(timer);
    timer = setTimeout(() => fn.apply(this, args), delay);
  };
}

input.addEventListener('input', debounce((e) => {
  buscar(e.target.value);
}, 300));
```

## Enviar formulario con fetch

```js
form.addEventListener('submit', async (e) => {
  e.preventDefault();

  const datos = Object.fromEntries(new FormData(form).entries());

  try {
    const res = await fetch('/api/registro', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(datos)
    });

    if (!res.ok) throw new Error('Error en el servidor');

    const resultado = await res.json();
    console.log('Registro OK:', resultado);
  } catch (err) {
    console.error('Error:', err.message);
  }
});
```

## Atajos de teclado

```js
document.addEventListener('keydown', (e) => {
  // Ctrl+S o Cmd+S
  if ((e.ctrlKey || e.metaKey) && e.key === 's') {
    e.preventDefault();
    guardar();
  }

  // Escape para cerrar modal
  if (e.key === 'Escape') {
    cerrarModal();
  }
});
```

## Conceptos clave

- `preventDefault` evita la acción por defecto (navegar, recargar).
- `stopPropagation` evita que el evento suba a los padres.
- `input` se dispara en cada cambio; `change` al perder el foco.
- `FormData` recoge los datos de un formulario de forma sencilla.
- La API `validity` permite validación personalizada con la validación nativa.
- `debounce` evita hacer peticiones en cada tecla (espera a que el usuario pare).
- `Object.fromEntries(formData.entries())` convierte FormData a objeto.

## Errores comunes

- **Olvidar `preventDefault` en submit**: el formulario recarga la página.
- **No validar en el servidor**: el usuario puede saltarse el JS.
- **`input` vs `change`**: `input` es continuo, `change` es al perder foco.
- **No usar `debounce` en búsquedas**: una petición por cada tecla.
- **`FormData` con `JSON.stringify`**: FormData no se stringifica, se envía directo.
- **Confundir `keyCode` (obsoleto) con `key`**: usa `e.key`.
- **No limpiar mensajes de error**: se acumulan.
- **Validar solo al enviar**: mejor también en `input` para feedback inmediato.
