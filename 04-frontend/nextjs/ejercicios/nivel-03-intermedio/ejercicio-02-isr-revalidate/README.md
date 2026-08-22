# Ejercicio 02 — ISR con revalidate

## Enunciado

Crea un `page.jsx` que use `revalidate` (ISR) para revalidar la página cada 60 segundos.

## Requisitos
- Un archivo `page.jsx`.
- `export const revalidate = 60` o `next: { revalidate: 60 }` en el fetch.
- `async` function con fetch.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
export const revalidate = 60;

export default async function Page() {
  const res = await fetch('https://api.example.com/data', {
    next: { revalidate: 60 }
  });
  const data = await res.json();
  return <h1>{data.title}</h1>;
}
```
</details>
