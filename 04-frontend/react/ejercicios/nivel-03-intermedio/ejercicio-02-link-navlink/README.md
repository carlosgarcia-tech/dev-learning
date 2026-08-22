# Ejercicio 02 — Link y NavLink

## Enunciado

Crea un componente `Navbar` que use `<Link>` y `<NavLink>` para navegar entre páginas.

## Requisitos

- Un archivo `Navbar.jsx`.
- `import { Link, NavLink } from 'react-router-dom'`.
- Al menos un `<Link to="/">`.
- Al menos un `<NavLink to="/about">`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { Link, NavLink } from 'react-router-dom';

function Navbar() {
  return (
    <nav>
      <Link to="/">Inicio</Link>
      <NavLink to="/about" className={({ isActive }) => isActive ? 'activo' : ''}>
        About
      </NavLink>
    </nav>
  );
}

export default Navbar;
```

</details>
