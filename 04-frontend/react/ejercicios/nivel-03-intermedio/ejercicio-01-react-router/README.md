# Ejercicio 01 — React Router básico

## Enunciado

Crea un `App.jsx` que configure React Router con dos rutas: `/` (Home) y `/about` (About).

## Requisitos

- Un archivo `App.jsx`.
- `import { createBrowserRouter, RouterProvider }`.
- Dos rutas: `/` y `/about`.
- Uso de `RouterProvider`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { createBrowserRouter, RouterProvider } from 'react-router-dom';

const router = createBrowserRouter([
  { path: '/', element: <h1>Home</h1> },
  { path: '/about', element: <h1>About</h1> }
]);

export default function App() {
  return <RouterProvider router={router} />;
}
```

</details>
