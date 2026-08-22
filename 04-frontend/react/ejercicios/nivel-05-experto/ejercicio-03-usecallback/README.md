# Ejercicio 03 — useCallback

## Enunciado

Crea un componente `Padre` que use `useCallback` para memoizar un handler que se pasa a un hijo.

## Requisitos

- Un archivo `Padre.jsx`.
- `useState` para un contador.
- `useCallback` para una función `handleClick`.
- Dependencias `[]` (o las necesarias).
- Pasa `handleClick` como prop a un hijo.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { useState, useCallback } from 'react';

function Padre() {
  const [count, setCount] = useState(0);

  const handleClick = useCallback(() => {
    setCount((c) => c + 1);
  }, []);

  return (
    <div>
      <p>{count}</p>
      <Hijo onClick={handleClick} />
    </div>
  );
}

function Hijo({ onClick }) {
  return <button onClick={onClick}>+1</button>;
}

export default Padre;
```

</details>
