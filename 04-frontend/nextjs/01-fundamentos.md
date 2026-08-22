# 01 — Fundamentos de Next.js

> Qué es Next.js, App Router, file-based routing, layout, page, loading, error, route handlers.

## Objetivos

- [ ] Entender qué es Next.js y qué aporta sobre React
- [ ] Conocer el App Router y el routing basado en archivos
- [ ] Crear layouts, pages, loading y error
- [ ] Diferenciar Server y Client Components
- [ ] Usar Route Handlers para APIs
- [ ] Configurar un proyecto Next.js

## ¿Qué es Next.js?

Next.js es un **framework de React** creado por Vercel que añade:
- **Routing basado en archivos**: cada archivo en `app/` es una ruta.
- **Renderizado híbrido**: SSR, SSG, ISR y CSR.
- **Server Components**: componentes que se ejecutan en el servidor.
- **Optimizaciones**: imágenes, fuentes, scripts.
- **API routes**: endpoints en el mismo proyecto.

```bash
npx create-next-app@latest mi-app
```

## App Router

El App Router (carpeta `app/`) es el sistema moderno de routing. Sustituyó al Pages Router (`pages/`).

```
app/
  layout.jsx       # layout raíz (obligatorio)
  page.jsx         # ruta "/"
  globals.css
  about/
    page.jsx       # ruta "/about"
  blog/
    page.jsx       # ruta "/blog"
    [slug]/
      page.jsx     # ruta "/blog/:slug"
```

## Convenciones de archivos

| Archivo | Para qué |
|---|---|
| `page.jsx` | La UI de una ruta (obligatorio para que la ruta exista) |
| `layout.jsx` | Contenedor que envuelve la página y sus hijas |
| `loading.jsx` | UI mientras carga (Suspense) |
| `error.jsx` | UI de error (error boundary) |
| `not-found.jsx` | UI para 404 |
| `route.js` | Endpoint de API (Route Handler) |
| `template.jsx` | Como layout pero se re-crea en cada navegación |

## `layout.jsx`

El layout envuelve las páginas. Es **persistente**: no se vuelve a renderizar al navegar.

```jsx
// app/layout.jsx
import './globals.css';

export const metadata = {
  title: 'Mi App',
  description: 'Descripción para SEO'
};

export default function RootLayout({ children }) {
  return (
    <html lang="es">
      <body>
        <nav>Mi navegación</nav>
        <main>{children}</main>
      </body>
    </html>
  );
}
```

> El layout raíz **debe** contener `<html>` y `<body>`.

## `page.jsx`

La UI de cada ruta.

```jsx
// app/page.jsx
export default function Home() {
  return <h1>Inicio</h1>;
}
```

```jsx
// app/about/page.jsx
export default function About() {
  return <h1>About</h1>;
}
```

## `loading.jsx`

Se muestra automáticamente mientras la página carga (usando Suspense).

```jsx
// app/blog/loading.jsx
export default function Loading() {
  return <p>Cargando blog...</p>;
}
```

## `error.jsx`

Captura errores de la ruta. **Debe ser un Client Component**.

```jsx
// app/error.jsx
'use client';

export default function Error({ error, reset }) {
  return (
    <div>
      <h2>Algo salió mal</h2>
      <p>{error.message}</p>
      <button onClick={reset}>Reintentar</button>
    </div>
  );
}
```

## Server vs Client Components

En el App Router, **todos los componentes son Server Components por defecto**.

```jsx
// Server Component (default)
// - Se ejecuta en el servidor
// - Puede usar async/await para fetch
// - No puede usar useState, useEffect, onClick

export default async function Page() {
  const data = await fetch('https://api.example.com/data').then((r) => r.json());
  return <h1>{data.title}</h1>;
}
```

```jsx
// Client Component
'use client';

import { useState } from 'react';

export default function Contador() {
  const [c, setC] = useState(0);
  return <button onClick={() => setC(c + 1)}>{c}</button>;
}
```

| Server Component | Client Component |
|---|---|
| Por defecto | Necesita `'use client'` |
| Acceso a BD, archivos | `useState`, `useEffect` |
| `async`/`await` directo | Eventos (`onClick`) |
| No JS al cliente | Sí envía JS |

> Los Server Components pueden importar Client Components, pero no al revés (un Client Component no puede importar directamente uno de servidor, pero sí como `children`).

## Route Handlers

Un Route Handler es un endpoint de API definido en un archivo `route.js`.

```js
// app/api/usuarios/route.js
export async function GET() {
  const usuarios = await db.user.findMany();
  return Response.json(usuarios);
}

export async function POST(request) {
  const body = await request.json();
  const nuevo = await db.user.create({ data: body });
  return Response.json(nuevo, { status: 201 });
}
```

```
GET    /api/usuarios        → export function GET
POST   /api/usuarios        → export function POST
GET    /api/usuarios/:id    → app/api/usuarios/[id]/route.js
```

## Estructura de un proyecto

```
mi-app/
  app/
    layout.jsx
    page.jsx
    globals.css
    about/
      page.jsx
    blog/
      page.jsx
      [slug]/
        page.jsx
    api/
      usuarios/
        route.js
  public/
    favicon.ico
    images/
  package.json
  next.config.js
```

## `next.config.js`

```js
/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['example.com']
  },
  experimental: {
    // features experimentales
  }
};

module.exports = nextConfig;
```

## Navegación con `<Link>`

```jsx
import Link from 'next/link';

<Link href="/about">About</Link>
<Link href="/blog/primera-entrada">Post</Link>
```

## Conceptos clave

- El App Router usa la carpeta `app/` y routing basado en archivos.
- `page.jsx` define la UI de una ruta; `layout.jsx` la envuelve.
- `loading.jsx` y `error.jsx` manejan carga y errores.
- Todos los componentes son Server Components por defecto.
- `'use client'` marca dónde empieza el código de cliente.
- Los Route Handlers (`route.js`) crean endpoints de API.
- `metadata` en el layout define el SEO.

## Errores comunes

- **Usar `useState` en Server Component**: error, hay que añadir `'use client'`.
- **Olvidar `export default`**: la página no se renderiza.
- **No tener `layout.jsx` raíz**: Next.js requiere un layout raíz.
- **Importar Client Components en Server Components mal**: revisa la dirección.
- **Olvidar `metadata`**: SEO por defecto pobre.
- **`error.jsx` sin `'use client'`**: no funciona (necesita `reset`).
- **Usar `pages/` y `app/` a la vez**: confusión de routing.
