# Ejercicio 06 — Custom hook useLocalStorage

## Enunciado

Crea un custom hook `useLocalStorage` que guarde un valor en `localStorage` y lo sincronice con el estado.

## Requisitos

- Un archivo `useLocalStorage.js`.
- Función que empiece con `use`.
- `useState` inicializado leyendo `localStorage`.
- `useEffect` que guarde en `localStorage` cuando el valor cambie.
- Retorna `[valor, setValor]`.
- `export` (nombrado o default).
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Lee el valor inicial de `localStorage.getItem(key)` con `JSON.parse`.
- `useEffect(() => { localStorage.setItem(key, JSON.stringify(valor)) }, [key, valor])`.
- El estado inicial puede ser una función: `useState(() => leer(key))`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**useLocalStorage.js**:
```jsx
import { useState, useEffect } from 'react';

export function useLocalStorage(key, inicial) {
  const [valor, setValor] = useState(() => {
    const guardado = localStorage.getItem(key);
    return guardado ? JSON.parse(guardado) : inicial;
  });

  useEffect(() => {
    localStorage.setItem(key, JSON.stringify(valor));
  }, [key, valor]);

  return [valor, setValor];
}
```

</details>
