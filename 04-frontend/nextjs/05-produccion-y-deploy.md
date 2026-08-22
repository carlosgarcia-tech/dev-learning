# 05 — Producción y deploy

> Optimización de imágenes, fonts, metadata, SEO, Vercel deploy, Docker, middlewares, i18n.

## Objetivos

- [ ] Optimizar imágenes con `next/image`
- [ ] Cargar fuentes con `next/font`
- [ ] Configurar metadata para SEO
- [ ] Desplegar en Vercel
- [ ] Desplegar con Docker
- [ ] Configurar internacionalización (i18n)

## Optimización de imágenes

`next/image` optimiza automáticamente: redimensiona, convierte a webp/avif y hace lazy loading.

```jsx
import Image from 'next/image';

export default function Page() {
  return (
    <Image
      src="/hero.jpg"
      alt="Hero"
      width={1200}
      height={630}
      priority  // cargar con prioridad (LCP)
    />
  );
}
```

### Imágenes remotas

```js
// next.config.js
module.exports = {
  images: {
    remotePatterns: [
      { protocol: 'https', hostname: 'cdn.example.com' }
    ]
  }
};
```

```jsx
<Image
  src="https://cdn.example.com/foto.jpg"
  alt="..."
  width={800}
  height={600}
  sizes="(max-width: 768px) 100vw, 50vw"
/>
```

| Prop | Para qué |
|---|---|
| `priority` | Carga prioritaria (hero, above the fold) |
| `sizes` | Indica el tamaño que ocupará (responsive) |
| `placeholder` | `blur` para efecto de blur mientras carga |
| `fill` | Ocupa el contenedor padre (necesita `position: relative`) |

```jsx
// Imagen que ocupa el contenedor
<div style={{ position: 'relative', width: '100%', height: '400px' }}>
  <Image src="/foto.jpg" alt="..." fill objectFit="cover" />
</div>
```

## Fuentes con `next/font`

`next/font` carga fuentes sin layout shift y sin peticiones externas.

```jsx
// app/layout.jsx
import { Inter } from 'next/font/google';

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-inter'
});

export default function RootLayout({ children }) {
  return (
    <html lang="es" className={inter.variable}>
      <body>{children}</body>
    </html>
  );
}
```

```css
/* globals.css */
body {
  font-family: var(--font-inter), sans-serif;
}
```

### Fuentes locales

```jsx
import localFont from 'next/font/local';

const miFont = localFont({
  src: './fonts/MiFuente.woff2',
  variable: '--font-mi-fuente'
});
```

## Metadata y SEO

```jsx
// app/layout.jsx
export const metadata = {
  title: {
    default: 'Mi App',
    template: '%s | Mi App'
  },
  description: 'Descripción de la app para SEO',
  keywords: ['react', 'nextjs', 'frontend'],
  authors: [{ name: 'Autor' }],
  openGraph: {
    title: 'Mi App',
    description: 'Descripción',
    url: 'https://miapp.com',
    siteName: 'Mi App',
    images: [{ url: '/og.jpg', width: 1200, height: 630 }],
    locale: 'es_ES',
    type: 'website'
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Mi App',
    description: 'Descripción',
    images: ['/og.jpg']
  },
  robots: {
    index: true,
    follow: true
  }
};
```

### Metadata por página

```jsx
// app/blog/[slug]/page.jsx
export async function generateMetadata({ params }) {
  const post = await fetch(`https://api.example.com/posts/${params.slug}`).then((r) => r.json());

  return {
    title: post.title,
    description: post.excerpt,
    openGraph: {
      images: [post.image]
    }
  };
}
```

### `sitemap.xml` y `robots.txt`

```js
// app/sitemap.js
export default async function sitemap() {
  const posts = await fetch('https://api.example.com/posts').then((r) => r.json());

  const urls = posts.map((p) => ({
    url: `https://miapp.com/blog/${p.slug}`,
    lastModified: p.updatedAt
  }));

  return [
    { url: 'https://miapp.com', lastModified: new Date() },
    { url: 'https://miapp.com/about', lastModified: new Date() },
    ...urls
  ];
}
```

```js
// app/robots.js
export default function robots() {
  return {
    rules: { userAgent: '*', allow: '/', disallow: '/admin/' },
    sitemap: 'https://miapp.com/sitemap.xml'
  };
}
```

## Deploy en Vercel

Vercel es la plataforma oficial de Next.js (creadores del framework).

```bash
# Instalar CLI
npm i -g vercel

# Desplegar
vercel

# Producción
vercel --prod
```

O conecta tu repo de GitHub a Vercel para auto-deploy en cada push.

### Variables de entorno

```bash
# En Vercel dashboard o CLI
vercel env add DATABASE_URL
vercel env add NEXT_PUBLIC_API_URL
```

### Dominios personalizados

En el dashboard de Vercel: Settings → Domains → Añadir dominio.

## Deploy con Docker

```dockerfile
# Dockerfile
FROM node:18-alpine AS base

# Instalar dependencias
FROM base AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

# Build
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Producción
FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
EXPOSE 3000
CMD ["node", "server.js"]
```

```js
// next.config.js
module.exports = {
  output: 'standalone'  // necesario para Docker
};
```

```bash
docker build -t mi-app .
docker run -p 3000:3000 mi-app
```

## Internacionalización (i18n)

### App Router i18n

```
app/
  [lang]/
    page.jsx        # /es, /en
    about/
      page.jsx      # /es/about, /en/about
  i18n.js
```

```js
// i18n.js
export const locales = ['es', 'en'];
export const defaultLocale = 'es';

export const dictionaries = {
  es: () => import('./dictionaries/es.json').then((m) => m.default),
  en: () => import('./dictionaries/en.json').then((m) => m.default)
};
```

```jsx
// app/[lang]/page.jsx
import { dictionaries } from '../../i18n';

export default async function Page({ params }) {
  const t = await dictionaries[params.lang]();
  return <h1>{t.welcome}</h1>;
}
```

### Middleware para detectar idioma

```js
// middleware.js
import { NextResponse } from 'next/server';
import { match } from '@formatjs/intl-localematcher';
import Negotiator from 'negotiator';

const locales = ['es', 'en'];
const defaultLocale = 'es';

export function middleware(request) {
  const headers = { 'accept-language': request.headers.get('accept-language') || '' };
  const languages = new Negotiator({ headers }).languages();
  const lang = match(languages, locales, defaultLocale);

  return NextResponse.next();
}

export const config = {
  matcher: ['/((?!api|_next|.*\\..*).*)']
};
```

## Optimizaciones de producción

### `next/script`

```jsx
import Script from 'next/script';

<Script
  src="https://analytics.example.com/script.js"
  strategy="afterInteractive"
/>
```

| Estrategia | Cuándo carga |
|---|---|
| `beforeInteractive` | Antes de hidratar |
| `afterInteractive` | Después de hidratar |
| `lazyOnload` | En idle |

### `next/dynamic` (lazy)

```jsx
import dynamic from 'next/dynamic';

const Mapa = dynamic(() => import('./Mapa'), {
  loading: () => <p>Cargando mapa...</p>,
  ssr: false  // solo cliente
});
```

## Conceptos clave

- `next/image` optimiza imágenes (webp, lazy, responsive).
- `next/font` carga fuentes sin layout shift.
- `metadata` en layout y `generateMetadata` en páginas manejan el SEO.
- `sitemap.js` y `robots.js` generan archivos SEO automáticamente.
- Vercel es el deploy más simple para Next.js.
- `output: 'standalone'` habilita el deploy con Docker.
- El i18n en App Router usa carpetas `[lang]` y middleware.

## Errores comunes

- **`<img>` en vez de `<Image>`**: pierdes optimización.
- **No configurar `remotePatterns`**: las imágenes remotas no cargan.
- **Olvidar `width` y `height`**: layout shift (CLS).
- **No usar `next/font`**: peticiones externas y FOUT.
- **Metadata estática en todo**: pierdes SEO dinámico por página.
- **No generar sitemap**: Google no indexa bien.
- **Docker sin `output: 'standalone'`**: imagen enorme.
- **i18n sin middleware**: no detecta el idioma del navegador.
- **Scripts bloqueantes**: usan `strategy` incorrecta.
