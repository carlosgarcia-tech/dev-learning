# Ejercicio 01 — SSG con generateStaticParams

## Enunciado

Crea un `page.jsx` en `app/blog/[slug]/` con `generateStaticParams` que pre-genera rutas estáticas.

## Requisitos
- Un archivo `page.jsx`.
- `export async function generateStaticParams()`.
- Retorna un array de objetos `{ slug: ... }`.
- `export default` del componente.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
export async function generateStaticParams() {
  const posts = await fetch('https://api.example.com/posts').then((r) => r.json());
  return posts.map((post) => ({ slug: post.slug }));
}

export default function Post({ params }) {
  return <h1>{params.slug}</h1>;
}
```
</details>
