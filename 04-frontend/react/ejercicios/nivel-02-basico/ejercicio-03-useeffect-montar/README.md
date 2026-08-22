# Ejercicio 03 — useEffect al montar

## Enunciado

Crea un componente `Mensaje` que use `useEffect` con array vacío para mostrar un mensaje por consola al montar.

## Requisitos

- Un archivo `Mensaje.jsx`.
- `import { useEffect } from 'react'`.
- `useEffect` con `[]` (array vacío).
- `console.log` dentro del efecto.
- `export default`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `useEffect(() => { ... }, [])` se ejecuta solo al montar.
- El array vacío `[]` significa "sin dependencias".
- Es útil para logs, peticiones iniciales o suscripciones.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**Mensaje.jsx**:
```jsx
import { useEffect } from 'react';

function Mensaje() {
  useEffect(() => {
    console.log('Componente montado');
  }, []);

  return <h1>Hola</h1>;
}

export default Mensaje;
```

</details>
