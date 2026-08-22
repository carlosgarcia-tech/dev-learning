# Ejercicio 04 — sitemap.js

## Enunciado

Crea un `sitemap.js` que genere URLs dinámicamente para el sitemap.

## Requisitos
- Un archivo `sitemap.js`.
- `export default async function sitemap()`.
- Retorna un array con objetos `{ url, lastModified }`.
- Al menos una URL dinámica (de un fetch).
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```js
export default async function sitemap() {
  const posts = await fetch('https://api.example.com/posts').then((r) => r.json());

  const urls = posts.map((post) => ({
    url: `https://miapp.com/blog/${post.slug}`,
    lastModified: new Date(post.updatedAt)
  }));

  return [
    { url: 'https://miapp.com', lastModified: new Date() },
    ...urls
  ];
}
```
</details>
