# Ejercicio 03 — Middleware de protección

## Enunciado

Crea un `middleware.js` que redirija a `/login` si no hay cookie de `token` en rutas `/dashboard`.

## Requisitos
- Un archivo `middleware.js`.
- `import { NextResponse } from 'next/server'`.
- `export function middleware(request)`.
- Comprueba `request.cookies.get('token')`.
- `NextResponse.redirect` si no hay token.
- `export const config` con `matcher`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```js
import { NextResponse } from 'next/server';

export function middleware(request) {
  const token = request.cookies.get('token');

  if (request.nextUrl.pathname.startsWith('/dashboard') && !token) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*']
};
```
</details>
