# Ejercicio 05 — SWR

## Enunciado

Crea un componente `Perfil` que use SWR para obtener datos de usuario.

## Requisitos

- Un archivo `Perfil.jsx`.
- `import useSWR from 'swr'`.
- Una función `fetcher`.
- Uso de `useSWR` con la URL y el fetcher.
- Render condicional: `isLoading`, `error`, datos.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import useSWR from 'swr';

const fetcher = (url) => fetch(url).then((res) => res.json());

function Perfil() {
  const { data, error, isLoading } = useSWR('https://jsonplaceholder.typicode.com/users/1', fetcher);

  if (isLoading) return <p>Cargando...</p>;
  if (error) return <p>Error</p>;
  return <h1>{data.name}</h1>;
}

export default Perfil;
```

</details>
