# Ejercicio 06 — Route Handler GET

## Enunciado

Crea un Route Handler que responda a GET en `/api/saludo` y devuelva un JSON.

## Requisitos

- Un archivo `route.js`.
- `export async function GET`.
- Retorna `Response.json(...)`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```js
export async function GET() {
  return Response.json({ mensaje: 'Hola desde la API' });
}
```

</details>
