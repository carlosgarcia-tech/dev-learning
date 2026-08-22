# 02 — Rutas y data fetching

> Rutas dinámicas, generateStaticParams, Server Components, Client Components, fetch, cache, revalidate.

## Objetivos

- [ ] Crear rutas dinámicas con `[param]`
- [ ] Generar páginas estáticas con `generateStaticParams`
- [ ] Hacer fetch en Server Components
- [ ] Controlar caché y revalidación
- [ ] Pasar datos de servidor a cliente
- [ ] Entender `params` y `searchParams`

## Rutas dinámicas

Las carpetas con corchetes `[param]` crean rutas dinámicas.

```
app/
  blog/
    [slug]/
      page.jsx     # /blog/hola-mundo, /blog/segundo-post
  tienda/
    [categoria]/
      [id]/
        page.jsx   # /tienda/libros/123
```

```jsx
// app/blog/[slug]/page.jsx
export default function Post({ params }) {
  return <h1>Post: {params.slug}</h1>;
}
```

### Múltiples parámetros

```jsx
// app/tienda/[categoria]/[id]/page.jsx
export default function Producto({ params }) {
  return (
    <div>
      <p>Categoría: {params.categoria}</p>
      <p>ID: {params.id}</p>
    </div>
  );
}
```

### Catch-all `[...slug]`

Captura todos los segmentos anidados.

```
app/docs/[...slug]/page.jsx
  /docs          → slug: undefined
  /docs/a        → slug: ['a']
  /docs/a/b/c    → slug: ['a', 'b', 'c']
```

### `searchParams`

Query parameters de la URL.

```jsx
// app/buscar/page.jsx
export default function Buscar({ searchParams }) {
  const q = searchParams.q;
  return <p>Buscando: {q}</p>;
}
// /buscar?q=react → searchParams: { q: 'react' }
```

## `generateStaticParams`

Genera las rutas estáticas en build time para rutas dinámicas.

```jsx
// app/blog/[slug]/page.jsx
export async function generateStaticParams() {
  const posts = await fetch('https://api.example.com/posts').then((r) => r.json());

  return posts.map((post) => ({
    slug: post.slug
  }));
}

export default function Post({ params }) {
  return <h1>{params.slug}</h1>;
}
```

> Equivale a `getStaticPaths` del Pages Router.

## fetch en Server Components

En el App Router, `fetch` se puede usar directamente en Server Components con `async/await`.

```jsx
// app/page.jsx
export default async function Home() {
  const res = await fetch('https://api.example.com/posts');
  const posts = await res.json();

  return (
    <ul>
      {posts.map((p) => <li key={p.id}>{p.title}</li>)}
    </ul>
  );
}
```

## Caché y revalidación

Next.js extiende `fetch` con opciones de caché:

```js
// Cache estático (indefinido, como SSG)
fetch(url, { cache: 'force-cache' });  // default

// Sin caché (siempre fresco, como SSR)
fetch(url, { cache: 'no-store' });

// Revalidar cada N segundos (ISR)
fetch(url, { next: { revalidate: 60 } });
```

```jsx
// ISR: revalida cada 60s
export default async function Page() {
  const res = await fetch('https://api.example.com/data', {
    next: { revalidate: 60 }
  });
  const data = await res.json();
  return <h1>{data.title}</h1>;
}

// SSR: siempre dinámico
export default async function Page() {
  const res = await fetch('https://api.example.com/data', {
    cache: 'no-store'
  });
  const data = await res.json();
  return <h1>{data.title}</h1>;
}
```

| Opción | Comportamiento | Equivalente |
|---|---|---|
| `cache: 'force-cache'` | Cachea indefinidamente (default) | SSG |
| `cache: 'no-store'` | Sin caché, siempre fresco | SSR |
| `next: { revalidate: 60 }` | Revalida cada 60s | ISR |

## Pasar datos de servidor a cliente

Los Server Components pueden pasar datos serializables a Client Components como props.

```jsx
// app/page.jsx (Server Component)
import ListaClientes from './ListaClientes';

export default async function Page() {
  const res = await fetch('https://api.example.com/items');
  const items = await res.json();

  return <ListaClientes items={items} />;
}
```

```jsx
// app/ListaClientes.jsx
'use client';

import { useState } from 'react';

export default function ListaClientes({ items }) {
  const [filtro, setFiltro] = useState('');
  const filtrados = items.filter((i) => i.nombre.includes(filtro));

  return (
    <div>
      <input value={filtro} onChange={(e) => setFiltro(e.target.value)} />
      <ul>
        {filtrados.map((i) => <li key={i.id}>{i.nombre}</li>)}
      </ul>
    </div>
  );
}
```

> No puedes pasar funciones o elementos no serializables de servidor a cliente. Solo datos serializables (strings, números, arrays, objetos).

## `loading.jsx` con fetch

```jsx
// app/blog/page.jsx (Server Component)
export default async function Blog() {
  const posts = await fetch('https://api.example.com/posts').then((r) => r.json());

  return (
    <ul>
      {posts.map((p) => <li key={p.id}>{p.title}</li>)}
    </ul>
  );
}
```

```jsx
// app/blog/loading.jsx
export default function Loading() {
  return <p>Cargando blog...</p>;
}
```

Mientras el `fetch` del Blog se resuelve, Next.js muestra el `loading.jsx` automáticamente.

## Parallel y sequential fetching

```jsx
// Paralelo (más rápido)
export default async function Page() {
  const [user, posts] = await Promise.all([
    fetch('/api/user').then((r) => r.json()),
    fetch('/api/posts').then((r) => r.json())
  ]);
  return <Perfil user={user} posts={posts} />;
}

// Secuencial (si uno depende del otro)
export default async function Page() {
  const user = await fetch('/api/user').then((r) => r.json());
  const posts = await fetch(`/api/posts?user=${user.id}`).then((r) => r.json());
  return <Perfil user={user} posts={posts} />;
}
```

## Conceptos clave

- Las rutas dinámicas usan `[param]` y se leen en `params`.
- `generateStaticParams` pre-genera rutas dinámicas en build (SSG).
- `fetch` en Server Components es `async` y soporta caché.
- `cache: 'no-store'` = SSR; `next: { revalidate }` = ISR.
- Los Server Components pueden pasar datos serializables a Client Components.
- `searchParams` da acceso a los query params.
- `Promise.all` paraleliza fetches (más rápido).

## Errores comunes

- **Olvidar `await` en fetch del Server Component**: la promesa no se resuelve.
- **Pasar funciones de servidor a cliente**: no es serializable.
- **No usar `generateStaticParams`**: las rutas dinámicas se generan on-demand.
- **`cache: 'no-store'` en todo**: pierdes rendimiento de caché.
- **Confundir `params` y `searchParams`**: params es ruta, searchParams es query.
- **Catch-all sin `undefined`**: `[...slug]` puede ser `undefined` en la raíz.
- **Fetch en Client Component sin razón**: mejor en servidor para SEO/perf.
