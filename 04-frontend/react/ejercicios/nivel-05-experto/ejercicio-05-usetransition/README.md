# Ejercicio 05 — useTransition

## Enunciado

Crea un componente `Buscador` que use `useTransition` para marcar la búsqueda como no urgente.

## Requisitos

- Un archivo `Buscador.jsx`.
- `useTransition` y `useState`.
- `startTransition` para envolver la actualización de resultados.
- Mostrar `isPending` cuando esté en curso.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { useState, useTransition } from 'react';

function Buscador() {
  const [query, setQuery] = useState('');
  const [resultados, setResultados] = useState([]);
  const [isPending, startTransition] = useTransition();

  const handleChange = (e) => {
    setQuery(e.target.value);
    startTransition(() => {
      setResultados(buscar(e.target.value));
    });
  };

  return (
    <div>
      <input value={query} onChange={handleChange} />
      {isPending && <p>Buscando...</p>}
      <ul>
        {resultados.map((r) => <li key={r.id}>{r.nombre}</li>)}
      </ul>
    </div>
  );
}

function buscar(q) {
  // simulación
  return q ? [{ id: 1, nombre: q }] : [];
}

export default Buscador;
```

</details>
