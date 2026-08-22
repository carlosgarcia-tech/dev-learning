# Ejercicio 02 — Route Handler con params

## Enunciado

Crea un Route Handler en `app/api/usuarios/[id]/route.js` que responda a GET y DELETE usando `params`.

## Requisitos
- Un archivo `route.js`.
- `export async function GET(request, { params })`.
- `export async function DELETE(request, { params })`.
- Uso de `params.id`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```js
export async function GET(request, { params }) {
  return Response.json({ id: params.id });
}

export async function DELETE(request, { params }) {
  return Response.json({ eliminado: params.id });
}
```
</details>
