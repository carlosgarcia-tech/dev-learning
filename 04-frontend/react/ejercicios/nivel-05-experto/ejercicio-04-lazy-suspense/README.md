# Ejercicio 04 — lazy + Suspense

## Enunciado

Crea un componente `App` que cargue perezosamente un componente `Heavy` con `lazy` y `Suspense`.

## Requisitos

- Un archivo `App.jsx`.
- `import { lazy, Suspense } from 'react'`.
- `const Heavy = lazy(() => import('./Heavy'))`.
- Uso de `<Suspense fallback={...}>`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { lazy, Suspense } from 'react';

const Heavy = lazy(() => import('./Heavy'));

function App() {
  return (
    <div>
      <h1>Mi App</h1>
      <Suspense fallback={<p>Cargando componente...</p>}>
        <Heavy />
      </Suspense>
    </div>
  );
}

export default App;
```

</details>
