# 02 — Hooks y estado

> useState, useEffect, useRef, useMemo, useCallback, useContext, useReducer, custom hooks, dependencias.

## Objetivos

- [ ] Gestionar estado con `useState`
- [ ] Sincronizar efectos con `useEffect`
- [ ] Referenciar valores y elementos con `useRef`
- [ ] Optimizar con `useMemo` y `useCallback`
- [ ] Compartir estado con `useContext`
- [ ] Manejar estado complejo con `useReducer`
- [ ] Crear hooks personalizados
- [ ] Entender el array de dependencias

## ¿Qué son los hooks?

Los hooks son funciones que dan acceso a características de React (estado, ciclo de vida, contexto...) desde componentes funcionales. Solo se pueden usar:
- En componentes funcionales.
- En el nivel superior (no dentro de ifs, bucles o funciones anidadas).

## `useState`

Guarda datos que al cambiar provocan un re-render.

```jsx
import { useState } from 'react';

function Contador() {
  const [cuenta, setCuenta] = useState(0);

  return <button onClick={() => setCuenta(cuenta + 1)}>Cuenta: {cuenta}</button>;
}
```

### Actualización funcional

Cuando el nuevo estado depende del anterior, usa una función:

```jsx
// Mal (puede perder actualizaciones)
setCuenta(cuenta + 1);

// Bien (siempre usa el último valor)
setCuenta((prev) => prev + 1);
```

### Estado con objetos

```jsx
const [usuario, setUsuario] = useState({ nombre: '', edad: 0 });

// Mal: pierde el resto
setUsuario({ nombre: 'Ana' });

// Bien: spread
setUsuario({ ...usuario, nombre: 'Ana' });

// Funcional
setUsuario((prev) => ({ ...prev, nombre: 'Ana' }));
```

## `useEffect`

Ejecuta efectos secundarios: peticiones, suscripciones, timers, manipulación del DOM.

```jsx
import { useEffect } from 'react';

function Componente() {
  useEffect(() => {
    console.log('Montado');

    // Cleanup (opcional): se ejecuta al desmontar
    return () => {
      console.log('Desmontado');
    };
  }, []); // array vacío: solo al montar
}
```

### Array de dependencias

| Dependencias | Cuándo se ejecuta |
|---|---|
| `[]` | Solo al montar |
| `[valor]` | Al montar y cuando `valor` cambia |
| Sin array | En cada render (evitar) |

```jsx
function Perfil({ userId }) {
  const [usuario, setUsuario] = useState(null);

  useEffect(() => {
    fetch(`/api/users/${userId}`)
      .then((res) => res.json())
      .then(setUsuario);
  }, [userId]); // se ejecuta al montar y cuando userId cambia

  return <div>{usuario?.nombre}</div>;
}
```

### Cleanup

```jsx
function Reloj() {
  const [hora, setHora] = useState(new Date());

  useEffect(() => {
    const timer = setInterval(() => setHora(new Date()), 1000);

    return () => clearInterval(timer); // limpieza al desmontar
  }, []);

  return <p>{hora.toLocaleTimeString()}</p>;
}
```

## `useRef`

Guarda un valor mutable que **no provoca re-render**. También para referenciar elementos del DOM.

```jsx
import { useRef } from 'react';

function Formulario() {
  const inputRef = useRef(null);

  const focus = () => inputRef.current.focus();

  return (
    <>
      <input ref={inputRef} />
      <button onClick={focus}>Foco</button>
    </>
  );
}
```

### Guardar valores sin re-render

```jsx
function Componente() {
  const contadorRef = useRef(0);

  const handleClick = () => {
    contadorRef.current++;
    console.log(contadorRef.current); // cambia pero no re-renderiza
  };

  return <button onClick={handleClick}>Clics: {contadorRef.current}</button>;
}
```

## `useMemo`

Memoriza el resultado de un cálculo costoso. Solo recalcula si las dependencias cambian.

```jsx
import { useMemo } from 'react';

function Lista({ items, filtro) {
  const itemsFiltrados = useMemo(() => {
    console.log('Filtrando...');
    return items.filter((item) => item.categoria === filtro);
  }, [items, filtro]);

  return (
    <ul>
      {itemsFiltrados.map((item) => <li key={item.id}>{item.nombre}</li>)}
    </ul>
  );
}
```

> No abuses de `useMemo`: la memorización tiene un coste. Úsalo solo en cálculos costosos o cuando previene re-renders innecesarios.

## `useCallback`

Memoriza una función para que no se recree en cada render. Útil cuando se pasa como prop a componentes memorizados.

```jsx
import { useCallback } from 'react';

function Padre() {
  const [count, setCount] = useState(0);

  const handleClick = useCallback(() => {
    console.log('Misma referencia');
  }, []);

  return <Hijo onClick={handleClick} />;
}
```

> `useCallback(fn, deps)` equivale a `useMemo(() => fn, deps)`.

## `useContext`

Accede al Context sin anidar `Consumer`.

```jsx
import { createContext, useContext } from 'react';

const TemaContext = createContext('claro');

function App() {
  return (
    <TemaContext.Provider value="oscuro">
      <Boton />
    </TemaContext.Provider>
  );
}

function Boton() {
  const tema = useContext(TemaContext);
  return <button className={tema}>Botón</button>;
}
```

> Context se trata en profundidad en la guía [03 — Rutas y estado global](03-rutas-y-estado-global.md).

## `useReducer`

Alternativa a `useState` para estado complejo con lógica de transiciones.

```jsx
import { useReducer } from 'react';

const initialState = { cuenta: 0 };

function reducer(state, action) {
  switch (action.type) {
    case 'incrementar':
      return { cuenta: state.cuenta + 1 };
    case 'decrementar':
      return { cuenta: state.cuenta - 1 };
    case 'reset':
      return initialState;
    default:
      return state;
  }
}

function Contador() {
  const [state, dispatch] = useReducer(reducer, initialState);

  return (
    <div>
      <p>{state.cuenta}</p>
      <button onClick={() => dispatch({ type: 'incrementar' })}>+1</button>
      <button onClick={() => dispatch({ type: 'decrementar' })}>-1</button>
      <button onClick={() => dispatch({ type: 'reset' })}>Reset</button>
    </div>
  );
}
```

### `useState` vs `useReducer`

| `useState` | `useReducer` |
|---|---|
| Estado simple | Estado complejo |
| Pocas actualizaciones | Múltiples acciones |
| Lógica simple | Lógica de transición |

## Custom hooks

Funciones que empiezan con `use` y combinan otros hooks. Permiten reutilizar lógica.

```jsx
function useLocalStorage(key, inicial) {
  const [valor, setValor] = useState(() => {
    const guardado = localStorage.getItem(key);
    return guardado ? JSON.parse(guardado) : inicial;
  });

  useEffect(() => {
    localStorage.setItem(key, JSON.stringify(valor));
  }, [key, valor]);

  return [valor, setValor];
}

// Uso
function App() {
  const [nombre, setNombre] = useLocalStorage('nombre', '');
  return <input value={nombre} onChange={(e) => setNombre(e.target.value)} />;
}
```

```jsx
// Hook para fetch
function useFetch(url) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch(url)
      .then((res) => {
        if (!res.ok) throw new Error('Error');
        return res.json();
      })
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [url]);

  return { data, loading, error };
}
```

## Reglas de los hooks

1. Solo en el nivel superior (no dentro de ifs, bucles o funciones).
2. Solo en componentes funcionales u otros hooks.
3. Los nombres empiezan con `use`.

```jsx
// Mal
function Componente({ condicion }) {
  if (condicion) {
    const [x, setX] = useState(0); // ERROR
  }
}

// Bien
function Componente({ condicion }) {
  const [x, setX] = useState(0);
  const valor = condicion ? x : null;
}
```

## Array de dependencias

El array de dependencias controla cuándo se ejecuta un efecto o se recalcula un memo.

```jsx
useEffect(() => {
  console.log('count cambió', count);
}, [count]);

// ESLint warning: si usas una variable dentro pero no la incluyes
```

> Usa la regla `react-hooks/exhaustive-deps` de ESLint para detectar dependencias faltantes.

## Conceptos clave

- `useState` guarda estado que provoca re-render al cambiar.
- `useEffect` ejecuta efectos y el cleanup se ejecuta al desmontar.
- El array de dependencias controla cuándo se ejecuta un efecto.
- `useRef` guarda valores mutables sin re-render y referencia elementos del DOM.
- `useMemo` memoriza cálculos; `useCallback` memoriza funciones.
- `useReducer` es ideal para estado complejo con transiciones.
- Los custom hooks reutilizan lógica entre componentes.

## Errores comunes

- **Olvidar dependencias en `useEffect`**: efecto ejecuta con valores antiguos.
- **Dependencias extra**: efecto se ejecuta más de lo necesario.
- **Olvidar cleanup**: timers y listeners se acumulan (fuga de memoria).
- **`useState` con objeto sin spread**: se pierden propiedades.
- **Actualizar estado en bucle**: cada `setX` provoca un re-render.
- **`useMemo` para todo**: más costoso que el cálculo que evita.
- **Modificar `ref.current` para re-renderizar**: no provoca re-render.
- **Hooks en condiciones**: rompe el orden de los hooks.
- **`useEffect` sin array**: se ejecuta en cada render (bucle).
- **Olvidar `key` en listas**: bugs de renderizado.
