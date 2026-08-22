# 03 — SSR, SSG e ISR

> getServerSideProps (Pages Router), SSR, SSG, ISR, App Router data fetching, streaming.

## Objetivos

- [ ] Diferenciar SSR, SSG e ISR
- [ ] Usar `getServerSideProps` en el Pages Router
- [ ] Aplicar cada modo en el App Router
- [ ] Usar `generateStaticParams` y `revalidate`
- [ ] Implementar streaming con Suspense
- [ ] Elegir el modo de renderizado adecuado

## Modos de renderizado

| Modo | Cuándo se genera | Ventaja | Caso de uso |
|---|---|---|---|
| **SSG** | En build | Muy rápido, cacheable | Blogs, docs, landing |
| **SSR** | En cada petición | Datos siempre frescos | Dashboards, datos en tiempo real |
| **ISR** | En build + revalidación | Rápido y actualizable | E-commerce, noticias |
| **CSR** | En el navegador | Interactivo | Apps internas |

## Pages Router (legado)

El Pages Router usa funciones especiales para el data fetching.

### `getServerSideProps` (SSR)

```jsx
// pages/post.jsx
export async function getServerSideProps(context) {
  const res = await fetch(`https://api.example.com/post/${context.params.id}`);
  const post = await res.json();

  return {
    props: { post }  // se pasa al componente
  };
}

export default function Post({ post }) {
  return <h1>{post.title}</h1>;
}
```

Se ejecuta en el **servidor en cada petición**.

### `getStaticProps` (SSG)

```jsx
// pages/blog.jsx
export async function getStaticProps() {
  const res = await fetch('https://api.example.com/posts');
  const posts = await res.json();

  return {
    props: { posts },
    revalidate: 60  // ISR: revalidar cada 60s
  };
}

export default function Blog({ posts }) {
  return (
    <ul>
      {posts.map((p) => <li key={p.id}>{p.title}</li>)}
    </ul>
  );
}
```

### `getStaticPaths` (rutas dinámicas SSG)

```jsx
// pages/blog/[slug].jsx
export async function getStaticPaths() {
  const posts = await fetch('https://api.example.com/posts').then((r) => r.json());

  return {
    paths: posts.map((p) => ({ params: { slug: p.slug } })),
    fallback: false  // false: 404 si no existe; 'blocking': genera on-demand
  };
}

export async function getStaticProps({ params }) {
  const post = await fetch(`https://api.example.com/posts/${params.slug}`).then((r) => r.json());
  return { props: { post } };
}

export default function Post({ post }) {
  return <h1>{post.title}</h1>;
}
```

## App Router (moderno)

En el App Router no hay funciones especiales: se controla con las opciones de `fetch` y `generateStaticParams`.

### SSG (Static Site Generation)

```jsx
// app/blog/page.jsx
export default async function Blog() {
  // force-cache es el default: cachea en build
  const res = await fetch('https://api.example.com/posts', { cache: 'force-cache' });
  const posts = await res.json();

  return (
    <ul>
      {posts.map((p) => <li key={p.id}>{p.title}</li>)}
    </ul>
  );
}
```

### SSR (Server-Side Rendering)

```jsx
// app/dashboard/page.jsx
export const dynamic = 'force-dynamic';  // siempre SSR

export default async function Dashboard() {
  const res = await fetch('https://api.example.com/stats', { cache: 'no-store' });
  const stats = await res.json();

  return <h1>Visitas: {stats.visits}</h1>;
}
```

### ISR (Incremental Static Regeneration)

```jsx
// app/productos/[id]/page.jsx
export const revalidate = 60;  // revalidar cada 60s

export default async function Producto({ params }) {
  const res = await fetch(`https://api.example.com/productos/${params.id}`, {
    next: { revalidate: 60 }
  });
  const producto = await res.json();

  return <h1>{producto.nombre}</h1>;
}
```

### `generateStaticParams`

```jsx
// app/blog/[slug]/page.jsx
export async function generateStaticParams() {
  const posts = await fetch('https://api.example.com/posts').then((r) => r.json());

  return posts.map((post) => ({ slug: post.slug }));
}

export default async function Post({ params }) {
  const post = await fetch(`https://api.example.com/posts/${params.slug}`).then((r) => r.json());
  return <article><h1>{post.title}</h1><p>{post.body}</p></article>;
}
```

### Tabla comparativa

| Pages Router | App Router |
|---|---|
| `getStaticProps` | `fetch` con `cache: 'force-cache'` |
| `getServerSideProps` | `fetch` con `cache: 'no-store'` o `dynamic = 'force-dynamic'` |
| `getStaticPaths` | `generateStaticParams` |
| `revalidate` en props | `revalidate` en fetch o `export const revalidate` |

## Variables de segmento

```jsx
// app/blog/page.jsx

// Forzar dinámico (SSR)
export const dynamic = 'force-dynamic';

// Revalidación (ISR)
export const revalidate = 60;

// Forzar estático (SSG)
export const dynamic = 'force-static';

// Configurar runtime
export const runtime = 'nodejs';  // o 'edge'
```

## Streaming con Suspense

El streaming envía HTML por partes: el esqueleto primero y los datos cuando estén listos.

```jsx
// app/page.jsx
import { Suspense } from 'react';

export default function Page() {
  return (
    <div>
      <h1>Mi página</h1>

      <Suspense fallback={<p>Cargando usuarios...</p>}>
        <Usuarios />
      </Suspense>

      <Suspense fallback={<p>Cargando posts...</p>}>
        <Posts />
      </Suspense>
    </div>
  );
}

async function Usuarios() {
  const users = await fetch('https://api.example.com/users').then((r) => r.json());
  return <ul>{users.map((u) => <li key={u.id}>{u.name}</li>)}</ul>;
}

async function Posts() {
  const posts = await fetch('https://api.example.com/posts').then((r) => r.json());
  return <ul>{posts.map((p) => <li key={p.id}>{p.title}</li>)}</ul>;
}
```

> Con streaming, el usuario ve la página inmediatamente y cada sección aparece cuando su fetch se completa.

## On-demand revalidation

Fuerza la revalidación desde fuera (webhook, cron, mutación).

```js
// app/api/revalidate/route.js
import { revalidatePath } from 'next/cache';

export async function POST(request) {
  const { path } = await request.json();
  revalidatePath(path);
  return Response.json({ revalidated: true });
}
```

```js
// Revalidar una etiqueta (grupo de cachés)
import { revalidateTag } from 'next/cache';

// En el fetch: next: { tags: ['productos'] }
revalidateTag('productos');
```

## Conceptos clave

- SSG genera en build (rápido); SSR en cada petición (fresco); ISR híbrido.
- En el App Router, el modo se controla con opciones de `fetch` y variables de segmento.
- `generateStaticParams` reemplaza a `getStaticPaths`.
- `dynamic = 'force-dynamic'` fuerza SSR.
- `revalidate` (variable o en fetch) habilita ISR.
- Streaming con `Suspense` envía HTML por partes.
- `revalidatePath` y `revalidateTag` permiten revalidación on-demand.

## Errores comunes

- **Usar `getServerSideProps` en el App Router**: no existe, usa `fetch` con `no-store`.
- **Olvidar `export const dynamic`**: la página puede comportarse distinto a lo esperado.
- **No usar `generateStaticParams` con rutas dinámicas**: se generan on-demand (más lento).
- **`fallback: false` sin todas las rutas**: 404 en rutas no generadas.
- **Streaming sin `Suspense`**: no se transmite por partes.
- **Revalidación sin etiquetas**: difícil invalidar cachés en grupo.
- **Confundir revalidate de tiempo con on-demand**: uno es automático, el otro manual.
