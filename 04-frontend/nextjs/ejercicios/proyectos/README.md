# Proyecto final — Next.js

## Blog completo con App Router, SSR e ISR

Construye un blog completo con Next.js App Router que demuestre dominio de routing, data fetching, API routes, SEO y deploy.

### Requisitos

- App Router con `layout.jsx` raíz con metadata SEO.
- Página de inicio (`/`) con lista de posts (SSG).
- Página de post dinámica (`/blog/[slug]`) con `generateStaticParams` (SSG) e ISR (`revalidate: 60`).
- Server Components para fetch de datos.
- Un Client Component para un formulario de comentarios (con `'use client'`).
- Route Handler `POST /api/comentarios` que reciba y devuelva el comentario.
- `loading.jsx` y `error.jsx` en las rutas.
- `next/image` para las imágenes de los posts.
- `next/font` para la tipografía.
- `generateMetadata` dinámico en la página de post.
- `sitemap.js` y `robots.js`.
- Middleware que redirija `/viejo` a `/`.
- Configuración de Docker (`Dockerfile` + `output: 'standalone'`).
- Los tests pasan: `bash test.sh`

### Pistas

<details>
<summary>Mostrar pistas</summary>

- Empieza por la estructura de carpetas en `app/`.
- Usa `generateStaticParams` para pre-generar las páginas de post.
- Para los comentarios, el Client Component hace fetch al Route Handler.
- `metadata` en layout para SEO global, `generateMetadata` en la página de post para SEO individual.
- No olvides `output: 'standalone'` en `next.config.js` para Docker.

</details>

### Solución

<details>
<summary>Mostrar solución</summary>

Estructura:
```
app/
  layout.jsx
  page.jsx
  loading.jsx
  error.jsx
  blog/
    [slug]/
      page.jsx
  api/
    comentarios/
      route.js
  sitemap.js
  robots.js
middleware.js
next.config.js
Dockerfile
```

**app/layout.jsx**:
```jsx
import { Inter } from 'next/font/google';
import './globals.css';

const inter = Inter({ subsets: ['latin'], variable: '--font-inter' });

export const metadata = {
  title: { default: 'Mi Blog', template: '%s | Mi Blog' },
  description: 'Blog sobre programación'
};

export default function RootLayout({ children }) {
  return (
    <html lang="es" className={inter.variable}>
      <body>{children}</body>
    </html>
  );
}
```

**app/page.jsx** (SSG):
```jsx
export default async function Home() {
  const posts = await fetch('https://api.example.com/posts').then((r) => r.json());
  return (
    <ul>
      {posts.map((p) => (
        <li key={p.id}>
          <Image src={p.image} alt={p.title} width={400} height={300} />
          <a href={`/blog/${p.slug}`}>{p.title}</a>
        </li>
      ))}
    </ul>
  );
}
```

**app/blog/[slug]/page.jsx** (SSG + ISR):
```jsx
export const revalidate = 60;

export async function generateStaticParams() {
  const posts = await fetch('https://api.example.com/posts').then((r) => r.json());
  return posts.map((p) => ({ slug: p.slug }));
}

export async function generateMetadata({ params }) {
  const post = await fetch(`https://api.example.com/posts/${params.slug}`).then((r) => r.json());
  return { title: post.title, description: post.excerpt };
}

export default async function Post({ params }) {
  const post = await fetch(`https://api.example.com/posts/${params.slug}`).then((r) => r.json());
  return (
    <article>
      <h1>{post.title}</h1>
      <Image src={post.image} alt={post.title} width={1200} height={630} priority />
      <p>{post.content}</p>
      <Comentarios postId={post.id} />
    </article>
  );
}
```

**app/api/comentarios/route.js**:
```js
export async function POST(request) {
  const body = await request.json();
  return Response.json({ ...body, id: Date.now() }, { status: 201 });
}
```

</details>
