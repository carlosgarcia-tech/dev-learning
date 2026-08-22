# Ejercicio 04 — Context API básico

## Enunciado

Crea un Context para el tema (claro/oscuro) con un Provider y un hook `useTema`.

## Requisitos

- Un archivo `TemaContext.jsx`.
- `createContext()`.
- Un `TemaProvider` con `useState`.
- `export function useTema()` que use `useContext`.
- `export default` o `export` nombrado.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { createContext, useContext, useState } from 'react';

const TemaContext = createContext();

export function TemaProvider({ children }) {
  const [tema, setTema] = useState('claro');
  return (
    <TemaContext.Provider value={{ tema, setTema }}>
      {children}
    </TemaContext.Provider>
  );
}

export function useTema() {
  return useContext(TemaContext);
}
```

</details>
