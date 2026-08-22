# Ejercicio 04 — fetch en useEffect

## Enunciado

Crea un componente `Perfil` que haga fetch de un usuario al montar con `useEffect` y muestre loading y error.

## Requisitos

- Un archivo `Perfil.jsx`.
- `useState` para `usuario`, `loading` y `error`.
- `useEffect` con `[]` que haga fetch.
- Comprobación de `res.ok` con `throw`.
- Render condicional: loading, error, datos.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { useState, useEffect } from 'react';

function Perfil() {
  const [usuario, setUsuario] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch('https://jsonplaceholder.typicode.com/users/1')
      .then((res) => {
        if (!res.ok) throw new Error('Error');
        return res.json();
      })
      .then(setUsuario)
      .catch(setError)
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <p>Cargando...</p>;
  if (error) return <p>Error: {error.message}</p>;
  return <h1>{usuario.name}</h1>;
}

export default Perfil;
```

</details>
