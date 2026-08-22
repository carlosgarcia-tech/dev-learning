# Ejercicio 03 — useParams: rutas dinámicas

## Enunciado

Crea un componente `Perfil` que use `useParams` para leer el `id` de la URL y mostrarlo.

## Requisitos

- Un archivo `Perfil.jsx`.
- `import { useParams } from 'react-router-dom'`.
- `const { id } = useParams()`.
- Mostrar el `id` en un `<h1>`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { useParams } from 'react-router-dom';

function Perfil() {
  const { id } = useParams();
  return <h1>Perfil del usuario {id}</h1>;
}

export default Perfil;
```

</details>
