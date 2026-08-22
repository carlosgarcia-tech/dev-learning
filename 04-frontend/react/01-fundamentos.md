# 01 — Fundamentos de React

> Qué es React, JSX, componentes funcionales, props, renderizado, Virtual DOM, create-react-app/vite.

## Objetivos

- [ ] Entender qué es React y su filosofía
- [ ] Escribir JSX y entender sus reglas
- [ ] Crear componentes funcionales
- [ ] Pasar y usar props
- [ ] Comprender el renderizado y el Virtual DOM
- [ ] Configurar un proyecto con Vite
- [ ] Renderizar listas y condicionales

## ¿Qué es React?

React es una **librería de JavaScript** para construir interfaces de usuario, creada por Facebook (Meta) en 2013. Se basa en:

- **Componentes**: piezas reutilizables e independientes.
- **Estado**: datos que al cambiar provocan un re-render.
- **Declarativo**: describes *qué* se ve, no *cómo* se actualiza.
- **Unidireccional**: los datos fluyen de padres a hijos vía props.

```jsx
function App() {
  return <h1>Hola React</h1>;
}
```

## JSX

JSX es una extensión de sintaxis que permite escribir HTML dentro de JavaScript. El compilador (Babel/SWC) lo transforma a llamadas `React.createElement`.

```jsx
const elemento = <h1 className="titulo">Hola</h1>;

// Se compila a:
const elemento = React.createElement('h1', { className: 'titulo' }, 'Hola');
```

### Reglas del JSX

1. **Una sola raíz**: el return debe devolver un solo elemento (o un Fragment).

```jsx
// Bien
return (
  <div>
    <h1>Título</h1>
    <p>Párrafo</p>
  </div>
);

// Bien (Fragment)
return (
  <>
    <h1>Título</h1>
    <p>Párrafo</p>
  </>
);
```

2. **`className` en vez de `class`**.

```jsx
<div className="caja">  {/* no class="caja" */}
```

3. **Expresiones con `{}`**.

```jsx
const nombre = 'Ana';
return <h1>Hola, {nombre}</h1>;
return <p>Suma: {2 + 3}</p>;
return <img src={url} alt="..." />;
```

4. **Cerrar todas las etiquetas**.

```jsx
<input />       {/* self-closing */}
<img src="..." />
<br />
```

5. **Atributos en camelCase**.

```jsx
<div onClick={manejarClick}>     {/* no onclick */}
<label htmlFor="nombre">          {/* no for */}
```

## Componentes funcionales

Un componente es una función que devuelve JSX.

```jsx
function Saludo() {
  return <h1>Hola mundo</h1>;
}

// Arrow function (también válido)
const Despedida = () => <h1>Adiós</h1>;
```

### Uso

```jsx
function App() {
  return (
    <div>
      <Saludo />
      <Despedida />
    </div>
  );
}
```

> Los componentes empiezan con **mayúscula**. React distingue componentes (`<Saludo>`) de etiquetas HTML (`<div>`) por la mayúscula inicial.

## Props

Las props son datos que se pasan de un componente padre a un hijo. Son **inmutables** (el hijo no las modifica).

```jsx
function Tarjeta(props) {
  return (
    <div className="tarjeta">
      <h2>{props.titulo}</h2>
      <p>{props.descripcion}</p>
    </div>
  );
}

// Uso
<Tarjeta titulo="React" descripcion="Librería de UI" />
```

### Destructuring

```jsx
function Tarjeta({ titulo, descripcion }) {
  return (
    <div>
      <h2>{titulo}</h2>
      <p>{descripcion}</p>
    </div>
  );
}
```

### Props por defecto

```jsx
function Saludo({ nombre = 'mundo' }) {
  return <h1>Hola, {nombre}</h1>;
}

<Saludo />          // Hola, mundo
<Saludo nombre="Ana" />  // Hola, Ana
```

### `children`

Prop especial que contiene lo que va entre las etiquetas de apertura y cierre.

```jsx
function Contenedor({ children }) {
  return <div className="contenedor">{children}</div>;
}

<Contenedor>
  <h1>Título</h1>
  <p>Contenido</p>
</Contenedor>
```

## Renderizado condicional

```jsx
function Saludo({ logueado }) {
  if (logueado) {
    return <h1>Bienvenido</h1>;
  }
  return <h1>Por favor, inicia sesión</h1>;
}

// Operador ternario
function Badge({ activo }) {
  return <span className={activo ? 'verde' : 'rojo'}>{activo ? 'Activo' : 'Inactivo'}</span>;
}

// && (solo si true)
function Notificacion({ mensajes }) {
  return (
    <div>
      {mensajes.length > 0 && <p>Tienes {mensajes.length} mensajes</p>}
    </div>
  );
}
```

## Renderizado de listas

Usa `.map()` y el atributo `key`.

```jsx
function Lista({ items }) {
  return (
    <ul>
      {items.map((item) => (
        <li key={item.id}>{item.nombre}</li>
      ))}
    </ul>
  );
}

const productos = [
  { id: 1, nombre: 'Café' },
  { id: 2, nombre: 'Té' },
  { id: 3, nombre: 'Cacao' }
];

<Lista items={productos} />
```

> **`key`** debe ser único y estable (no el índice del array salvo que la lista sea estática). Ayuda a React a identificar qué items cambiaron.

## Eventos

```jsx
function Boton() {
  const handleClick = (e) => {
    console.log('Clic', e);
  };

  return <button onClick={handleClick}>Clic</button>;
}

// Con parámetro
function Lista({ items, onSelect }) {
  return (
    <ul>
      {items.map((item) => (
        <li key={item.id}>
          <button onClick={() => onSelect(item.id)}>{item.nombre}</button>
        </li>
      ))}
    </ul>
  );
}
```

## Estado: introducción a `useState`

El estado son datos que al cambiar provocan un re-render del componente.

```jsx
import { useState } from 'react';

function Contador() {
  const [cuenta, setCuenta] = useState(0);

  return (
    <div>
      <p>Cuenta: {cuenta}</p>
      <button onClick={() => setCuenta(cuenta + 1)}>+1</button>
      <button onClick={() => setCuenta(0)}>Reset</button>
    </div>
  );
}
```

> Los hooks se tratan en profundidad en la guía [02 — Hooks y estado](02-hooks-y-estado.md).

## Virtual DOM

React mantiene una copia en memoria del DOM (Virtual DOM). Cuando el estado cambia:

1. React crea un nuevo Virtual DOM.
2. Lo compara con el anterior (reconciliación / diffing).
3. Actualiza solo las diferencias en el DOM real.

```
Estado cambia → nuevo Virtual DOM → diff → actualizar DOM real (mínimo)
```

> Esto hace que React sea eficiente: no reescribe todo el DOM, solo los cambios.

## Configurar un proyecto con Vite

```bash
npm create vite@latest mi-app -- --template react
cd mi-app
npm install
npm run dev
```

```
mi-app/
  index.html
  src/
    main.jsx      # punto de entrada
    App.jsx       # componente raíz
    App.css
  package.json
  vite.config.js
```

```jsx
// src/main.jsx
import { createRoot } from 'react-dom/client';
import App from './App.jsx';

createRoot(document.getElementById('root')).render(<App />);
```

> Vite reemplazó a create-react-app (CRA) como herramienta recomendada por ser mucho más rápida.

## Estructura de un componente

```jsx
import { useState } from 'react';

function Contador({ inicial = 0 }) {
  // 1. Estado
  const [cuenta, setCuenta] = useState(inicial);

  // 2. Funciones
  const incrementar = () => setCuenta(cuenta + 1);

  // 3. Render
  return (
    <div>
      <p>Cuenta: {cuenta}</p>
      <button onClick={incrementar}>+1</button>
    </div>
  );
}

export default Contador;
```

## Conceptos clave

- React construye UI con **componentes** (funciones que devuelven JSX).
- Las **props** pasan datos de padre a hijo y son inmutables.
- El **estado** (`useState`) son datos que al cambiar re-renderizan.
- El **Virtual DOM** optimiza las actualizaciones del DOM real.
- JSX se compila a `React.createElement`.
- `key` es obligatorio en listas y debe ser estable.
- Los componentes empiezan con mayúscula.

## Errores comunes

- **Olvidar `import` React** (en algunos setups): en Vite moderno no hace falta, pero en otros sí.
- **`class` en vez de `className`**: JSX usa `className`.
- **Varias raíces**: el return debe devolver un solo elemento (o Fragment `<>`).
- **`key` con el índice**: en listas dinámicas causa bugs.
- **Olvidar `export`**: el componente no se puede importar.
- **Modificar props**: son inmutables, usa estado.
- **Eventos sin `on`**: `onClick`, no `onclick`.
- **Condiciones con `if` dentro de JSX**: no funciona, usa ternario o `&&`.
- **Olvidar `key`**: React lanza warning y puede renderizar mal.
