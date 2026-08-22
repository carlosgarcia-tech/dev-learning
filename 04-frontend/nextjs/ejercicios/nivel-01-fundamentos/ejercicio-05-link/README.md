# Ejercicio 05 — Navegación con Link

## Enunciado

Crea un componente Navbar que use `<Link>` de Next.js para navegar entre páginas.

## Requisitos

- Un archivo `Navbar.jsx`.
- `import Link from 'next/link'`.
- Al menos 2 `<Link href="...">`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import Link from 'next/link';

export default function Navbar() {
  return (
    <nav>
      <Link href="/">Inicio</Link>
      <Link href="/about">About</Link>
      <Link href="/blog">Blog</Link>
    </nav>
  );
}
```

</details>
