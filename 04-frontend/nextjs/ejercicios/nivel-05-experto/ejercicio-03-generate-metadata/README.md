# Ejercicio 03 — generateMetadata

## Enunciado

Crea un `page.jsx` con `generateMetadata` que genere SEO dinámico basado en `params`.

## Requisitos
- Un archivo `page.jsx`.
- `export async function generateMetadata({ params })`.
- Retorna `{ title, description }`.
- `export default` del componente.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
export async function generateMetadata({ params }) {
  const post = await fetch(`https://api.example.com/posts/${params.slug}`).then((r) => r.json());
  return {
    title: post.title,
    description: post.excerpt
  };
}

export default function Post({ params }) {
  return <h1>{params.slug}</h1>;
}
```
</details>
