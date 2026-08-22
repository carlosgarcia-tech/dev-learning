# Proyecto final — React

## App de recetas con búsqueda y favoritos

Construye una aplicación de recetas completa con React que demuestre dominio de componentes, hooks, routing, estado global, formularios y peticiones.

### Requisitos

- Componentes funcionales con props y composición.
- `useState` y `useEffect` para estado y efectos.
- React Router con rutas dinámicas (`/receta/:id`).
- Context API para favoritos (lista compartida entre páginas).
- fetch a una API de recetas (ej: TheMealDB) con loading y error.
- Formulario de búsqueda controlado con debounce.
- React Hook Form + Zod para un formulario de añadir receta propia.
- `localStorage` para persistir favoritos.
- `React.memo` en la tarjeta de receta para optimizar.
- Lazy loading de la página de detalle con `Suspense`.
- Testing con React Testing Library en al menos un componente.
- Los tests pasan: `bash test.sh`

### Pistas

<details>
<summary>Mostrar pistas</summary>

- Estructura: `pages/` (Home, Receta, Favoritos), `components/` (TarjetaReceta, Buscador, Layout), `context/` (FavoritosContext).
- API gratuita: `https://www.themealdb.com/api/json/v1/1/search.php?s=`.
- Persiste favoritos en `localStorage` con un `useEffect` que escuche cambios.
- Usa `lazy(() => import('./pages/Receta'))` para code splitting.

</details>

### Solución

<details>
<summary>Mostrar solución</summary>

Estructura del proyecto:
```
src/
  main.jsx
  App.jsx
  context/FavoritosContext.jsx
  components/TarjetaReceta.jsx
  components/Buscador.jsx
  components/Layout.jsx
  pages/Home.jsx
  pages/Receta.jsx
  pages/Favoritos.jsx
```

**context/FavoritosContext.jsx**:
```jsx
import { createContext, useContext, useState, useEffect } from 'react';

const FavoritosContext = createContext();

export function FavoritosProvider({ children }) {
  const [favoritos, setFavoritos] = useState(() =>
    JSON.parse(localStorage.getItem('favoritos') || '[]')
  );

  useEffect(() => {
    localStorage.setItem('favoritos', JSON.stringify(favoritos));
  }, [favoritos]);

  const toggle = (receta) => {
    setFavoritos((prev) => {
      const existe = prev.find((r) => r.idMeal === receta.idMeal);
      return existe
        ? prev.filter((r) => r.idMeal !== receta.idMeal)
        : [...prev, receta];
    });
  };

  return (
    <FavoritosContext.Provider value={{ favoritos, toggle }}>
      {children}
    </FavoritosContext.Provider>
  );
}

export const useFavoritos = () => useContext(FavoritosContext);
```

**App.jsx**:
```jsx
import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import { FavoritosProvider } from './context/FavoritosContext';
import Layout from './components/Layout';
import Home from './pages/Home';
import Favoritos from './pages/Favoritos';
import { lazy, Suspense } from 'react';

const Receta = lazy(() => import('./pages/Receta'));

const router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    children: [
      { index: true, element: <Home /> },
      { path: 'receta/:id', element: <Suspense fallback={<p>Cargando...</p>}><Receta /></Suspense> },
      { path: 'favoritos', element: <Favoritos /> }
    ]
  }
]);

export default function App() {
  return (
    <FavoritosProvider>
      <RouterProvider router={router} />
    </FavoritosProvider>
  );
}
```

**components/TarjetaReceta.jsx**:
```jsx
import { memo } from 'react';
import { Link } from 'react-router-dom';
import { useFavoritos } from '../context/FavoritosContext';

const TarjetaReceta = memo(function TarjetaReceta({ receta }) {
  const { favoritos, toggle } = useFavoritos();
  const esFav = favoritos.some((r) => r.idMeal === receta.idMeal);

  return (
    <div className="tarjeta">
      <Link to={`/receta/${receta.idMeal}`}>
        <img src={receta.strMealThumb} alt={receta.strMeal} />
        <h3>{receta.strMeal}</h3>
      </Link>
      <button onClick={() => toggle(receta)}>
        {esFav ? '★' : '☆'}
      </button>
    </div>
  );
});

export default TarjetaReceta;
```

**pages/Home.jsx**:
```jsx
import { useState, useEffect } from 'react';
import TarjetaReceta from '../components/TarjetaReceta';

export default function Home() {
  const [recetas, setRecetas] = useState([]);
  const [query, setQuery] = useState('pasta');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    fetch(`https://www.themealdb.com/api/json/v1/1/search.php?s=${query}`)
      .then((res) => res.json())
      .then((data) => setRecetas(data.meals || []))
      .finally(() => setLoading(false));
  }, [query]);

  if (loading) return <p>Cargando...</p>;

  return (
    <div>
      <input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Buscar..." />
      <div className="grid">
        {recetas.map((r) => <TarjetaReceta key={r.idMeal} receta={r} />)}
      </div>
    </div>
  );
}
```

</details>
