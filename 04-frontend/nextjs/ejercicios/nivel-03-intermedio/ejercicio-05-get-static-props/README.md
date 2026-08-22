# Ejercicio 05 — getStaticProps (Pages Router)

## Enunciado

Crea una página del Pages Router que use `getStaticProps` con `revalidate` (ISR).

## Requisitos
- Un archivo `pagina.js`.
- `export async function getStaticProps()`.
- Retorna `{ props: {...}, revalidate: 60 }`.
- `export default` del componente.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```js
export async function getStaticProps() {
  const res = await fetch('https://api.example.com/posts');
  const posts = await res.json();
  return { props: { posts }, revalidate: 60 };
}

export default function Blog({ posts }) {
  return <ul>{posts.map((p) => <li key={p.id}>{p.title}</li>)}</ul>;
}
```
</details>
