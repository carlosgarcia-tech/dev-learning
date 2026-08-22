# Ejercicio 01 — React.memo

## Enunciado

Crea un componente `Tarjeta` envuelto en `React.memo` que reciba `titulo` y `onClick`.

## Requisitos

- Un archivo `Tarjeta.jsx`.
- `React.memo` envolviendo el componente.
- Props `titulo` y `onClick`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { memo } from 'react';

const Tarjeta = memo(function Tarjeta({ titulo, onClick }) {
  console.log('Render Tarjeta');
  return (
    <div className="tarjeta" onClick={onClick}>
      <h3>{titulo}</h3>
    </div>
  );
});

export default Tarjeta;
```

</details>
