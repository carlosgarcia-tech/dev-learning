# Ejercicio 04 — useEffect con dependencias

## Enunciado

Crea un componente `Reloj` que use `useEffect` con un `setInterval` que actualice la hora cada segundo, con cleanup.

## Requisitos

- Un archivo `Reloj.jsx`.
- `useState` para guardar la hora.
- `useEffect` con `setInterval`.
- `cleanup` (`clearInterval`) en el return del efecto.
- Array de dependencias `[]`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `setInterval(fn, 1000)` ejecuta cada segundo.
- `return () => clearInterval(timer)` en el useEffect limpia al desmontar.
- `new Date().toLocaleTimeString()` da la hora actual.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**Reloj.jsx**:
```jsx
import { useState, useEffect } from 'react';

function Reloj() {
  const [hora, setHora] = useState(new Date().toLocaleTimeString());

  useEffect(() => {
    const timer = setInterval(() => {
      setHora(new Date().toLocaleTimeString());
    }, 1000);

    return () => clearInterval(timer);
  }, []);

  return <p>{hora}</p>;
}

export default Reloj;
```

</details>
