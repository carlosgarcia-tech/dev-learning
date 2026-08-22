# Ejercicio 01 — Route Handler POST

## Enunciado

Crea un Route Handler `route.js` que responda a POST y devuelva el body recibido.

## Requisitos
- Un archivo `route.js`.
- `export async function POST(request)`.
- Lee el body con `await request.json()`.
- Retorna `Response.json(...)`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```js
export async function POST(request) {
  const body = await request.json();
  return Response.json({ recibido: body }, { status: 201 });
}
```
</details>
