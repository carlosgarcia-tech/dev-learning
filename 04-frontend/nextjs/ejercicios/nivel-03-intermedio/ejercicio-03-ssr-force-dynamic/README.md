# Ejercicio 03 — SSR con force-dynamic

## Enunciado

Crea un `page.jsx` que fuerce renderizado dinámico (SSR) con `export const dynamic = 'force-dynamic'`.

## Requisitos
- Un archivo `page.jsx`.
- `export const dynamic = 'force-dynamic'`.
- `async` function con fetch y `cache: 'no-store'`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
export const dynamic = 'force-dynamic';

export default async function Page() {
  const res = await fetch('https://api.example.com/stats', { cache: 'no-store' });
  const stats = await res.json();
  return <p>Visitas: {stats.visits}</p>;
}
```
</details>
