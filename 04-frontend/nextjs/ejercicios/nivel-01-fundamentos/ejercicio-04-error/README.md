# Ejercicio 04 — error.jsx (Client Component)

## Enunciado

Crea un `error.jsx` que sea un Client Component con un botón de reintentar.

## Requisitos

- Un archivo `error.jsx`.
- `'use client'` en la primera línea.
- Props `error` y `reset`.
- Un botón con `onClick={reset}`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
'use client';

export default function Error({ error, reset }) {
  return (
    <div>
      <h2>Algo salió mal</h2>
      <p>{error.message}</p>
      <button onClick={reset}>Reintentar</button>
    </div>
  );
}
```

</details>
