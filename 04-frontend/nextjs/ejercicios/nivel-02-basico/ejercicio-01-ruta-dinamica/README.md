# Ejercicio 01 — Ruta dinámica [slug]

## Enunciado

Crea un `page.jsx` en `app/blog/[slug]/` que lea `params.slug` y lo muestre.

## Requisitos
- Un archivo `page.jsx`.
- Props `{ params }`.
- Muestra `params.slug` en un `<h1>`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
export default function Post({ params }) {
  return <h1>Post: {params.slug}</h1>;
}
```
</details>
