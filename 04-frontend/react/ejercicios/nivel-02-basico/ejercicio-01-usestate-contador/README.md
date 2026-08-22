# Ejercicio 01 — useState: contador

## Enunciado

Crea un componente `Contador` con `useState` que empiece en 0 y tenga botones para incrementar y decrementar.

## Requisitos

- Un archivo `Contador.jsx`.
- `import { useState } from 'react'`.
- Estado `cuenta` inicializado a `0`.
- Botón `+1` que incrementa.
- Botón `-1` que decrementa.
- Muestra el valor en un `<p>`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `const [cuenta, setCuenta] = useState(0)`.
- `setCuenta(cuenta + 1)` incrementa.
- Para evitar problemas con actualizaciones rápidas, usa `setCuenta((prev) => prev + 1)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**Contador.jsx**:
```jsx
import { useState } from 'react';

function Contador() {
  const [cuenta, setCuenta] = useState(0);

  return (
    <div>
      <p>Cuenta: {cuenta}</p>
      <button onClick={() => setCuenta((prev) => prev + 1)}>+1</button>
      <button onClick={() => setCuenta((prev) => prev - 1)}>-1</button>
    </div>
  );
}

export default Contador;
```

</details>
