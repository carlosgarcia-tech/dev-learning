# Ejercicio 06 — Zustand store básico

## Enunciado

Crea un store de Zustand para un contador con `incrementar` y `reset`.

## Requisitos

- Un archivo `useContador.js`.
- `import { create } from 'zustand'`.
- Estado inicial `valor: 0`.
- Acción `incrementar`.
- Acción `reset`.
- `export` del hook.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { create } from 'zustand';

const useContador = create((set) => ({
  valor: 0,
  incrementar: () => set((state) => ({ valor: state.valor + 1 })),
  reset: () => set({ valor: 0 })
}));

export default useContador;
```

</details>
