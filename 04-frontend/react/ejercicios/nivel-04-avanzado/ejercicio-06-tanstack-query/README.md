# Ejercicio 06 — TanStack Query (useQuery)

## Enunciado

Crea un componente `Perfil` que use `useQuery` de TanStack Query.

## Requisitos

- Un archivo `Perfil.jsx`.
- `import { useQuery } from '@tanstack/react-query'`.
- `queryKey` con `['user']`.
- `queryFn` con fetch.
- Render condicional: `isLoading`, `error`, datos.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { useQuery } from '@tanstack/react-query';

function Perfil() {
  const { data, isLoading, error } = useQuery({
    queryKey: ['user'],
    queryFn: async () => {
      const res = await fetch('https://jsonplaceholder.typicode.com/users/1');
      if (!res.ok) throw new Error('Error');
      return res.json();
    }
  });

  if (isLoading) return <p>Cargando...</p>;
  if (error) return <p>Error: {error.message}</p>;
  return <h1>{data.name}</h1>;
}

export default Perfil;
```

</details>
