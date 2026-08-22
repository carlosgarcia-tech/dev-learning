# Ejercicio 05 — useRef para foco

## Enunciado

Crea un componente `Formulario` que use `useRef` para poner el foco en un input al montar.

## Requisitos

- Un archivo `Formulario.jsx`.
- `useRef` para referenciar el input.
- `useEffect` con `[]` que haga `inputRef.current.focus()`.
- Un `<input ref={inputRef}>`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `const inputRef = useRef(null)` crea la referencia.
- `<input ref={inputRef}>` la asigna.
- `inputRef.current.focus()` pone el foco.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**Formulario.jsx**:
```jsx
import { useRef, useEffect } from 'react';

function Formulario() {
  const inputRef = useRef(null);

  useEffect(() => {
    inputRef.current.focus();
  }, []);

  return <input ref={inputRef} placeholder="Escribe..." />;
}

export default Formulario;
```

</details>
