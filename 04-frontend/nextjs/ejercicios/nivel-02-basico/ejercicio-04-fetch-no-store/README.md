# Ejercicio 04 — fetch con cache no-store (SSR)

## Enunciado

Crea un `page.jsx` que use `fetch` con `cache: 'no-store'` para datos siempre frescos (SSR).

## Requisitos
- Un archivo `page.jsx`.
- `fetch` con `cache: 'no-store'`.
- `async` function.
- Renderiza los datos.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
export default async function Page() {
  const res = await fetch('https://api.example.com/stats', { cache: 'no-store' });
  const stats = await res.json();
  return <p>Visitas: {stats.visits}</p>;
}
```
</details>
