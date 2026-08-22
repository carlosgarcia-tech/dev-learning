# Ejercicio 05 — searchParams

## Enunciado

Crea un `page.jsx` que lea `searchParams` y muestre el query param `q`.

## Requisitos
- Un archivo `page.jsx`.
- Props `{ searchParams }`.
- Muestra `searchParams.q` en un `<p>`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
export default function Buscar({ searchParams }) {
  return <p>Buscando: {searchParams.q}</p>;
}
```
</details>
