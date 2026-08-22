# Ejercicio 04 — Cookies con next/headers

## Enunciado

Crea un Route Handler que lea y escriba cookies con `cookies()` de `next/headers`.

## Requisitos
- Un archivo `route.js`.
- `import { cookies } from 'next/headers'`.
- Lee una cookie con `cookies().get('token')`.
- Escribe una cookie con `cookies().set(...)`.
- `export async function GET`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```js
import { cookies } from 'next/headers';

export async function GET() {
  const token = cookies().get('token');

  if (!token) {
    cookies().set('token', 'nuevo-token', { httpOnly: true });
  }

  return Response.json({ token: token?.value || 'creado' });
}
```
</details>
