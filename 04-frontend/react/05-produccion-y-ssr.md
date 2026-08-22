# 05 — Producción y SSR

> Next.js, SSR, SSG, ISR, Server Components, React 18 concurrent features, performance, testing.

## Objetivos

- [ ] Entender el renderizado en servidor (SSR) vs cliente (CSR)
- [ ] Conocer SSG e ISR
- [ ] Entender los Server Components
- [ ] Usar las concurrent features de React 18
- [ ] Optimizar el rendimiento de una app React
- [ ] Conocer las opciones de testing
- [ ] Preparar una app para producción

## Modos de renderizado

| Modo | Cuándo se renderiza | Ventaja |
|---|---|---|
| **CSR** (Client-Side Rendering) | En el navegador | Interactivo, sin servidor |
| **SSR** (Server-Side Rendering) | En el servidor por petición | SEO, datos frescos |
| **SSG** (Static Site Generation) | En build | Rápido, cacheable |
| **ISR** (Incremental Static Regeneration) | En build + revalidación | Rápido y actualizable |

### CSR (React puro)

```jsx
// El HTML inicial está vacío, el JS construye todo
createRoot(document.getElementById('root')).render(<App />);
```

- Ventaja: simple, sin servidor.
- Desventaja: SEO pobre, tiempo de carga inicial.

### SSR

El servidor genera HTML con datos en cada petición.

```jsx
// Next.js Pages Router
export async function getServerSideProps() {
  const res = await fetch('https://api.example.com/data');
  const data = await res.json();
  return { props: { data } };
}

function Page({ data }) {
  return <div>{data.title}</div>;
}
```

### SSG

El HTML se genera en build time.

```jsx
export async function getStaticProps() {
  const data = await fetchData();
  return { props: { data } };
}
```

### ISR

SSG con revalidación periódica.

```jsx
export async function getStaticProps() {
  const data = await fetchData();
  return {
    props: { data },
    revalidate: 60  // revalidar cada 60 segundos
  };
}
```

## Server Components

Introducidos en React 18 y adoptados por Next.js App Router. Los Server Components se ejecutan **en el servidor** y no se envían al cliente.

```jsx
// app/page.jsx (Server Component por defecto)
import { db } from '@/lib/db';

export default async function Page() {
  const usuarios = await db.user.findMany();
  return (
    <ul>
      {usuarios.map((u) => <li key={u.id}>{u.name}</li>)}
    </ul>
  );
}
```

| Server Component | Client Component |
|---|---|
| Se ejecuta en el servidor | En el cliente |
| Puede usar async/await directo | No puede ser async |
| No `useState`, `useEffect` | Sí hooks |
| No acceso al DOM | Sí |
| Menos JS al cliente | Más JS |

```jsx
// Client Component
'use client';
import { useState } from 'react';

export default function Contador() {
  const [c, setC] = useState(0);
  return <button onClick={() => setC(c + 1)}>{c}</button>;
}
```

> La directiva `'use client'` marca el límite del servidor.

## React 18: Concurrent Features

### `Suspense`

Permite mostrar un fallback mientras un componente carga.

```jsx
import { Suspense } from 'react';

function App() {
  return (
    <Suspense fallback={<p>Cargando...</p>}>
      <PerfilAsync />
    </Suspense>
  );
}
```

### `useTransition`

Marca una actualización como no urgente, permitiendo que la UI siga respondiendo.

```jsx
import { useTransition, useState } from 'react';

function Buscador() {
  const [query, setQuery] = useState('');
  const [isPending, startTransition] = useTransition();

  const handleChange = (e) => {
    setQuery(e.target.value);  // urgente: input responde rápido
    startTransition(() => {
      setResultados(buscar(e.target.value));  // no urgente
    });
  };

  return (
    <>
      <input value={query} onChange={handleChange} />
      {isPending && <p>Buscando...</p>}
      <Lista items={resultados} />
    </>
  );
}
```

### `useDeferredValue`

Retrasa un valor para no bloquear la UI.

```jsx
import { useDeferredValue, useState } from 'react';

function Buscador() {
  const [query, setQuery] = useState('');
  const deferredQuery = useDeferredValue(query);

  return (
    <>
      <input value={query} onChange={(e) => setQuery(e.target.value)} />
      <ListaPesada query={deferredQuery} />
    </>
  );
}
```

### Automatic batching

React 18 agrupa múltiples actualizaciones de estado en un solo re-render, incluso en promesas y timers.

```jsx
function App() {
  const [a, setA] = useState(0);
  const [b, setB] = useState(0);

  const handleClick = async () => {
    await fetch('/api');
    setA(1);  // antes: 2 re-renders
    setB(2);  // ahora: 1 re-render (batching)
  };

  return <button onClick={handleClick}>Click</button>;
}
```

## Performance

### `React.memo`

Evita re-render si las props no cambiaron.

```jsx
const Tarjeta = React.memo(function Tarjeta({ titulo }) {
  console.log('Render Tarjeta');
  return <div>{titulo}</div>;
});
```

### Code splitting con `lazy`

```jsx
import { lazy, Suspense } from 'react';

const Contacto = lazy(() => import('./Contacto'));

function App() {
  return (
    <Suspense fallback={<Spinner />}>
      <Contacto />
    </Suspense>
  );
}
```

### Virtualización de listas

Para listas grandes (miles de items), usa virtualización:

```jsx
import { useVirtualizer } from '@tanstack/react-virtual';

// Solo renderiza los items visibles
```

### Optimización de imágenes

```jsx
import next/image;  // En Next.js
<Image src="/hero.jpg" alt="..." width={1200} height={630} priority />
```

## Testing

### React Testing Library

Testea componentes como los usaría un usuario.

```bash
npm install @testing-library/react @testing-library/jest-dom
```

```jsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import Contador from './Contador';

test('incrementa al hacer clic', async () => {
  render(<Contador />);
  const boton = screen.getByRole('button');

  expect(boton).toHaveTextContent('0');
  await userEvent.click(boton);
  expect(boton).toHaveTextContent('1');
});
```

### Jest + Vitest

Vitest es el test runner moderno, compatible con la API de Jest.

```js
// vitest.config.js
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'jsdom'
  }
});
```

```jsx
import { describe, it, expect } from 'vitest';

describe('Contador', () => {
  it('empieza en 0', () => {
    render(<Contador />);
    expect(screen.getByText('0')).toBeInTheDocument();
  });
});
```

## Preparar para producción

### Build

```bash
# Vite
npm run build  # genera dist/

# Next.js
npm run build  # genera .next/
```

### Variables de entorno

```bash
# .env
VITE_API_URL=https://api.midominio.com  # Vite
NEXT_PUBLIC_API_URL=https://api.midominio.com  # Next.js
```

### Lighthouse

Mide performance, accesibilidad, SEO y buenas prácticas. Objetivos:
- Performance > 90
- Accessibility > 90
- LCP < 2.5s
- CLS < 0.1

## Conceptos clave

- CSR renderiza en el navegador; SSR/SSG en el servidor.
- Los Server Components se ejecutan en el servidor y no envían JS al cliente.
- `'use client'` marca dónde empieza el código de cliente.
- `useTransition` y `useDeferredValue` mantienen la UI responsiva.
- Automatic batching agrupa actualizaciones en un re-render.
- `React.memo` evita re-renders innecesarios.
- `lazy` + `Suspense` divide el bundle en chunks.
- React Testing Library testea como un usuario.

## Errores comunes

- **CSR para todo**: SEO pobre y carga lenta inicial.
- **Server Components con `useState`**: no está permitido.
- **Olvidar `'use client'`**: los hooks no funcionan en Server Components.
- **`useTransition` para todo**: solo para actualizaciones no urgentes.
- **`React.memo` sin `useCallback` en props**: las funciones se recrean y anulan el memo.
- **Listas sin virtualizar**: miles de DOM nodes lentos.
- **No usar `priority` en imagen hero**: LCP lento.
- **Variables de entorno sin prefijo**: no llegan al cliente (`VITE_` / `NEXT_PUBLIC_`).
- **No testear interacciones**: solo se testea el render estático.
