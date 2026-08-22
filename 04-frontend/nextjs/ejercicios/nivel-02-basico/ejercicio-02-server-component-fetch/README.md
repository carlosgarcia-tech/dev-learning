# Ejercicio 02 — Server Component con fetch

## Enunciado

Crea un Server Component `page.jsx` que haga fetch de datos y los muestre.

## Requisitos
- Un archivo `page.jsx`.
- `export default async function`.
- Uso de `fetch` con `await`.
- `await res.json()`.
- Renderiza los datos.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
export default async function Page() {
  const res = await fetch('https://jsonplaceholder.typicode.com/users');
  const users = await res.json();
  return (
    <ul>
      {users.map((u) => <li key={u.id}>{u.name}</li>)}
    </ul>
  );
}
```
</details>
