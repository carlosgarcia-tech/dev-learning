# Ejercicio 02 — useMemo

## Enunciado

Crea un componente `Lista` que use `useMemo` para filtrar una lista de items por categoría.

## Requisitos

- Un archivo `Lista.jsx`.
- `useState` para la categoría.
- `useMemo` que filtre items por categoría.
- Dependencias `[items, categoria]` en el `useMemo`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { useState, useMemo } from 'react';

function Lista({ items }) {
  const [categoria, setCategoria] = useState('todas');

  const filtrados = useMemo(() => {
    if (categoria === 'todas') return items;
    return items.filter((item) => item.categoria === categoria);
  }, [items, categoria]);

  return (
    <div>
      <select value={categoria} onChange={(e) => setCategoria(e.target.value)}>
        <option value="todas">Todas</option>
        <option value="libro">Libros</option>
        <option value="pelicula">Películas</option>
      </select>
      <ul>
        {filtrados.map((item) => <li key={item.id}>{item.nombre}</li>)}
      </ul>
    </div>
  );
}

export default Lista;
```

</details>
