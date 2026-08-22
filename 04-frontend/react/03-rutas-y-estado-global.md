# 03 — Rutas y estado global

> React Router, rutas anidadas, useParams, useNavigate, Context API, Redux, Zustand, Jotai.

## Objetivos

- [ ] Configurar React Router en una app
- [ ] Crear rutas y rutas anidadas
- [ ] Navegar con `<Link>`, `useNavigate` y `useParams`
- [ ] Compartir estado con Context API
- [ ] Conocer Redux Toolkit
- [ ] Usar Zustand como alternativa ligera
- [ ] Conocer Jotai para estado atómico

## React Router

React Router es la librería estándar para routing en React. La versión actual usa `createBrowserRouter` y el componente `<RouterProvider>`.

### Instalación

```bash
npm install react-router-dom
```

### Configuración básica

```jsx
import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import Home from './pages/Home';
import About from './pages/About';
import NotFound from './pages/NotFound';

const router = createBrowserRouter([
  { path: '/', element: <Home /> },
  { path: '/about', element: <About /> },
  { path: '*', element: <NotFound /> }
]);

function App() {
  return <RouterProvider router={router} />;
}
```

### Rutas con layout (Outlet)

```jsx
import { Outlet, Link } from 'react-router-dom';

function Layout() {
  return (
    <div>
      <nav>
        <Link to="/">Inicio</Link>
        <Link to="/about">About</Link>
      </nav>
      <main>
        <Outlet />  {/* aquí se renderiza la ruta hija */}
      </main>
    </div>
  );
}

const router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    children: [
      { index: true, element: <Home /> },
      { path: 'about', element: <About /> }
    ]
  }
]);
```

### Rutas dinámicas

```jsx
const router = createBrowserRouter([
  { path: '/users/:id', element: <Perfil /> }
]);

function Perfil() {
  const { id } = useParams();
  return <h1>Perfil del usuario {id}</h1>;
}
```

### Navegación programática

```jsx
import { useNavigate } from 'react-router-dom';

function Login() {
  const navigate = useNavigate();

  const handleLogin = () => {
    // lógica de login...
    navigate('/dashboard');
    // o con replace (no añade al historial)
    navigate('/dashboard', { replace: true });
  };

  return <button onClick={handleLogin}>Entrar</button>;
}
```

### `<Link>` y `<NavLink>`

```jsx
import { Link, NavLink } from 'react-router-dom';

<Link to="/about">About</Link>

// NavLink añade clase 'active' cuando la ruta coincide
<NavLink to="/about" className={({ isActive }) => isActive ? 'activo' : ''}>
  About
</NavLink>
```

### Hooks de router

| Hook | Para qué |
|---|---|
| `useParams()` | Leer parámetros de la URL |
| `useNavigate()` | Navegar programáticamente |
| `useLocation()` | Info de la URL actual |
| `useSearchParams()` | Query params |
| `useOutlet()` | Ruta hija renderizada |

```jsx
function Busqueda() {
  const [params, setParams] = useSearchParams();
  const query = params.get('q');
  return <p>Buscando: {query}</p>;
}
```

## Estado global: ¿cuándo hace falta?

| Estado | Dónde |
|---|---|
| Local a un componente | `useState` |
| Compartido entre hermanos cercanos | Subir al padre |
| Compartido por toda la app | Context o librería |
| Muy complejo, muchas acciones | Redux / Zustand |

> No uses estado global para todo. Si solo lo usa un componente, usa `useState`.

## Context API

Comparte datos entre componentes sin pasar props por todos los niveles (prop drilling).

```jsx
import { createContext, useContext, useState } from 'react';

const TemaContext = createContext();

function App() {
  const [tema, setTema] = useState('claro');

  return (
    <TemaContext.Provider value={{ tema, setTema }}>
      <Toolbar />
    </TemaContext.Provider>
  );
}

function Toolbar() {
  return <Boton />;
}

function Boton() {
  const { tema, setTema } = useContext(TemaContext);
  return (
    <button className={tema} onClick={() => setTema(tema === 'claro' ? 'oscuro' : 'claro')}>
      Cambiar tema
    </button>
  );
}
```

### Custom hook para Context

```jsx
function useTema() {
  const ctx = useContext(TemaContext);
  if (!ctx) throw new Error('useTema debe usarse dentro de TemaProvider');
  return ctx;
}

// Uso
function Boton() {
  const { tema } = useTema();
  return <button className={tema}>Botón</button>;
}
```

> **Cuidado**: cuando el valor del Context cambia, todos los consumidores se re-renderizan. No pongas datos que cambian muy a menudo en Context.

## Redux Toolkit

Redux es una librería para estado global predecible. Redux Toolkit (RTK) es la forma moderna y simplificada.

```bash
npm install @reduxjs/toolkit react-redux
```

```jsx
// store.js
import { configureStore, createSlice } from '@reduxjs/toolkit';

const contadorSlice = createSlice({
  name: 'contador',
  initialState: { valor: 0 },
  reducers: {
    incrementar: (state) => { state.valor += 1; },  // Immer permite mutación
    decrementar: (state) => { state.valor -= 1; },
    sumar: (state, action) => { state.valor += action.payload; }
  }
});

export const { incrementar, decrementar, sumar } = contadorSlice.actions;

export const store = configureStore({
  reducer: { contador: contadorSlice.reducer }
});
```

```jsx
// main.jsx
import { Provider } from 'react-redux';
import { store } from './store';

createRoot(document.getElementById('root')).render(
  <Provider store={store}>
    <App />
  </Provider>
);
```

```jsx
// Componente
import { useSelector, useDispatch } from 'react-redux';
import { incrementar } from './store';

function Contador() {
  const valor = useSelector((state) => state.contador.valor);
  const dispatch = useDispatch();

  return (
    <div>
      <p>{valor}</p>
      <button onClick={() => dispatch(incrementar())}>+1</button>
    </div>
  );
}
```

## Zustand

Zustand es una alternativa ligera a Redux, sin boilerplate y sin providers.

```bash
npm install zustand
```

```jsx
import { create } from 'zustand';

const useContador = create((set) => ({
  valor: 0,
  incrementar: () => set((state) => ({ valor: state.valor + 1 })),
  reset: () => set({ valor: 0 })
}));

function Contador() {
  const { valor, incrementar } = useContador();

  return (
    <div>
      <p>{valor}</p>
      <button onClick={incrementar}>+1</button>
    </div>
  );
}
```

### Selector para evitar re-renders

```jsx
// Solo se re-renderiza cuando valor cambia
const valor = useContador((state) => state.valor);
```

## Jotai

Jotai usa un modelo **atómico**: cada pieza de estado es un átomo independiente.

```bash
npm install jotai
```

```jsx
import { atom, useAtom } from 'jotai';

const contadorAtom = atom(0);

function Contador() {
  const [valor, setValor] = useAtom(contadorAtom);

  return (
    <div>
      <p>{valor}</p>
      <button onClick={() => setValor(valor + 1)}>+1</button>
    </div>
  );
}
```

### Átomos derivados

```jsx
const dobleAtom = atom((get) => get(contadorAtom) * 2);

function Doble() {
  const [doble] = useAtom(dobleAtom);
  return <p>Doble: {doble}</p>;
}
```

## Comparativa de soluciones

| Solución | Cuándo usarla |
|---|---|
| `useState` | Estado local de un componente |
| Context API | Tema, usuario, configuración global |
| Redux Toolkit | Estado complejo con muchas acciones y middleware |
| Zustand | Estado global simple sin boilerplate |
| Jotai | Estado derivado y atómico |

## Conceptos clave

- React Router usa `createBrowserRouter` y `<RouterProvider>`.
- `<Outlet>` renderiza la ruta hija dentro de un layout.
- `useParams` lee parámetros de URL dinámicas.
- `useNavigate` navega programáticamente.
- Context evita el prop drilling pero provoca re-renders en todos los consumidores.
- Redux Toolkit simplifica Redux con `createSlice` y `configureStore`.
- Zustand es ligero y sin providers.
- Jotai usa átomos independientes y derivados.

## Errores comunes

- **Olvidar `<RouterProvider>`**: las rutas no funcionan.
- **Prop drilling**: pasar props por 5 niveles en vez de Context.
- **Context para todo**: re-renders innecesarios.
- **Redux para estado simple**: sobrecarga innecesaria.
- **`useNavigate` fuera del router**: error.
- **Rutas sin `*`**: la página 404 no aparece.
- **Olvidar `Provider` de Redux**: los componentes no encuentran el store.
- **Mutar estado en Redux sin Immer**: RTK lo permite, pero Redux puro no.
- **Selectores que devuelven nuevos objetos**: causan re-renders infinitos.
