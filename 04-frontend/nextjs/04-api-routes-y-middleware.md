# 04 — API Routes y middleware

> Route Handlers, API routes, middleware, cookies, headers, redirects, rewrites.

## Objetivos

- [ ] Crear Route Handlers en el App Router
- [ ] Manejar GET, POST, PUT, DELETE
- [ ] Usar middleware para proteger rutas
- [ ] Leer y escribir cookies y headers
- [ ] Configurar redirects y rewrites
- [ ] Entender la diferencia con el Pages Router

## Route Handlers

Los Route Handlers reemplazan a las API Routes del Pages Router. Se definen en archivos `route.js`.

### Estructura

```
app/
  api/
    usuarios/
      route.js          # /api/usuarios
      [id]/
        route.js        # /api/usuarios/:id
```

### Métodos HTTP

```js
// app/api/usuarios/route.js

// GET /api/usuarios
export async function GET(request) {
  const usuarios = await db.user.findMany();
  return Response.json(usuarios);
}

// POST /api/usuarios
export async function POST(request) {
  const body = await request.json();
  const nuevo = await db.user.create({ data: body });
  return Response.json(nuevo, { status: 201 });
}
```

```js
// app/api/usuarios/[id]/route.js

// GET /api/usuarios/:id
export async function GET(request, { params }) {
  const usuario = await db.user.findUnique({ where: { id: params.id } });
  if (!usuario) return Response.json({ error: 'No encontrado' }, { status: 404 });
  return Response.json(usuario);
}

// PUT /api/usuarios/:id
export async function PUT(request, { params }) {
  const body = await request.json();
  const actualizado = await db.user.update({
    where: { id: params.id },
    data: body
  });
  return Response.json(actualizado);
}

// DELETE /api/usuarios/:id
export async function DELETE(request, { params }) {
  await db.user.delete({ where: { id: params.id } });
  return new Response(null, { status: 204 });
}
```

### El objeto `request`

```js
export async function GET(request) {
  const url = new URL(request.url);
  const searchParams = url.searchParams;
  const q = searchParams.get('q');

  const headers = request.headers;
  const auth = headers.get('authorization');

  return Response.json({ q, auth });
}
```

### Response

```js
// JSON
return Response.json({ ok: true });

// Con status
return Response.json({ error: 'No autorizado' }, { status: 401 });

// Con headers
return Response.json(data, {
  headers: { 'Cache-Control': 'no-store' }
});

// Vacío
return new Response(null, { status: 204 });
```

## Cookies y headers

### Leer cookies

```js
import { cookies } from 'next/headers';

export async function GET() {
  const cookieStore = cookies();
  const token = cookieStore.get('token');
  const all = cookieStore.getAll();

  return Response.json({ token: token?.value });
}
```

### Escribir cookies (en Route Handler)

```js
import { cookies } from 'next/headers';

export async function POST() {
  cookies().set('token', 'abc123', {
    httpOnly: true,
    secure: true,
    sameSite: 'strict',
    maxAge: 3600
  });

  return Response.json({ ok: true });
}
```

### Leer headers

```js
import { headers } from 'next/headers';

export async function GET() {
  const headersList = headers();
  const auth = headersList.get('authorization');
  const host = headersList.get('host');

  return Response.json({ auth, host });
}
```

## Middleware

El middleware se ejecuta **antes** de que se procese una ruta. Ideal para auth, redirects, i18n.

```js
// middleware.js (en la raíz del proyecto)
import { NextResponse } from 'next/server';
import { NextRequest } from 'next/server';

export function middleware(request) {
  const token = request.cookies.get('token');

  // Proteger rutas /dashboard
  if (request.nextUrl.pathname.startsWith('/dashboard') && !token) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/admin/:path*']
};
```

### Modificar request/response

```js
export function middleware(request) {
  // Añadir header a la request
  const requestHeaders = new Headers(request.headers);
  requestHeaders.set('x-path', request.nextUrl.pathname);

  // Añadir header a la response
  const response = NextResponse.next({
    request: { headers: requestHeaders }
  });
  response.headers.set('x-custom-header', 'valor');
  return response;
}
```

### Matcher

```js
export const config = {
  // Ejecutar solo en estas rutas
  matcher: [
    '/dashboard/:path*',
    '/api/:path*',
    '/((?!login|register|_next/static|_next/image|favicon.ico).*)'
  ]
};
```

## Redirects y rewrites

Se configuran en `next.config.js`.

### Redirects

Cambia la URL en el navegador (cambia la barra de direcciones).

```js
// next.config.js
module.exports = {
  async redirects() {
    return [
      {
        source: '/viejo',
        destination: '/nuevo',
        permanent: true  // 308
      },
      {
        source: '/blog/:slug',
        destination: '/posts/:slug',
        permanent: false  // 307
      }
    ];
  }
};
```

### Rewrites

Cambia la URL internamente (el navegador no lo ve).

```js
module.exports = {
  async rewrites() {
    return [
      {
        source: '/api/externa',
        destination: 'https://api.example.com/datos'  // proxy a API externa
      }
    ];
  }
};
```

> Los rewrites son útiles para hacer proxy a APIs externas y evitar CORS en desarrollo.

## Diferencia con Pages Router

| App Router (`route.js`) | Pages Router (`pages/api/`) |
|---|---|
| `export async function GET` | `export default function handler(req, res)` |
| `request.json()`, `Response.json()` | `req.body`, `res.status(200).json()` |
| Web API estándar | API de Express-like |

```js
// Pages Router (legado)
export default function handler(req, res) {
  if (req.method === 'GET') {
    res.status(200).json({ ok: true });
  }
  if (req.method === 'POST') {
    const { nombre } = req.body;
    res.status(201).json({ nombre });
  }
}
```

## Conceptos clave

- Los Route Handlers (`route.js`) reemplazan a las API Routes.
- Cada método HTTP es una función exportada: `GET`, `POST`, `PUT`, `DELETE`.
- `cookies()` y `headers()` (de `next/headers`) leen/escriben cookies y headers.
- El middleware se ejecuta antes de las rutas y puede proteger/redirect.
- `matcher` limita en qué rutas se ejecuta el middleware.
- Redirects cambian la URL visible; rewrites la cambian internamente (proxy).

## Errores comunes

- **Usar `res.json()` en Route Handlers**: es la API vieja, usa `Response.json()`.
- **Olvidar `export` en los métodos**: no se registran.
- **Middleware sin `matcher`**: se ejecuta en todas las rutas (incluido `_next`).
- **Cookies sin `httpOnly`**: riesgo de XSS.
- **No validar método HTTP**: cualquier método llega al handler.
- **`cookies()` fuera de contexto**: solo funciona en Server Components y Route Handlers.
- **Confundir redirect con rewrite**: redirect cambia la URL, rewrite no.
- **No manejar errores en la API**: respuestas 500 sin contexto.
