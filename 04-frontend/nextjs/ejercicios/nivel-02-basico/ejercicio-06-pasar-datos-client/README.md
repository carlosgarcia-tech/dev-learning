# Ejercicio 06 — Pasar datos a Client Component

## Enunciado

Crea un Server Component `page.jsx` que haga fetch y pase los datos a un Client Component `Lista.jsx`.

## Requisitos
- Un archivo `page.jsx` (Server Component, `async`).
- Un archivo `Lista.jsx` (Client Component, `'use client'`).
- `page.jsx` hace fetch y pasa datos como props a `<Lista items={...} />`.
- `Lista.jsx` recibe `items` como props.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

**page.jsx**:
```jsx
import Lista from './Lista';

export default async function Page() {
  const res = await fetch('https://api.example.com/items');
  const items = await res.json();
  return <Lista items={items} />;
}
```

**Lista.jsx**:
```jsx
'use client';
import { useState } from 'react';

export default function Lista({ items }) {
  const [filtro, setFiltro] = useState('');
  const filtrados = items.filter((i) => i.nombre.includes(filtro));
  return (
    <div>
      <input value={filtro} onChange={(e) => setFiltro(e.target.value)} />
      <ul>{filtrados.map((i) => <li key={i.id}>{i.nombre}</li>)}</ul>
    </div>
  );
}
```
</details>
