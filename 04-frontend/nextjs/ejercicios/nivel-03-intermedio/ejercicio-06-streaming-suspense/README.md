# Ejercicio 06 — Streaming con Suspense

## Enunciado

Crea un `page.jsx` que use `Suspense` para cargar dos componentes asíncronos en paralelo.

## Requisitos
- Un archivo `page.jsx`.
- `import { Suspense } from 'react'`.
- Dos componentes `async` con fetch.
- `<Suspense fallback={...}>` envolviendo cada uno.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
import { Suspense } from 'react';

async function Usuarios() {
  const users = await fetch('https://api.example.com/users').then((r) => r.json());
  return <ul>{users.map((u) => <li key={u.id}>{u.name}</li>)}</ul>;
}

async function Posts() {
  const posts = await fetch('https://api.example.com/posts').then((r) => r.json());
  return <ul>{posts.map((p) => <li key={p.id}>{p.title}</li>)}</ul>;
}

export default function Page() {
  return (
    <div>
      <Suspense fallback={<p>Cargando usuarios...</p>}>
        <Usuarios />
      </Suspense>
      <Suspense fallback={<p>Cargando posts...</p>}>
        <Posts />
      </Suspense>
    </div>
  );
}
```
</details>
