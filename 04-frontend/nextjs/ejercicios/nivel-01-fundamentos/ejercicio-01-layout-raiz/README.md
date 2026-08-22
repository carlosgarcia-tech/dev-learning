# Ejercicio 01 — layout.jsx raíz

## Enunciado

Crea el `layout.jsx` raíz de un proyecto Next.js con `metadata` y estructura HTML básica.

## Requisitos

- Un archivo `layout.jsx`.
- `export const metadata` con `title` y `description`.
- `export default function RootLayout({ children })`.
- Retorna `<html lang="es"><body>{children}</body></html>`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
export const metadata = {
  title: 'Mi App',
  description: 'Descripción de la app'
};

export default function RootLayout({ children }) {
  return (
    <html lang="es">
      <body>{children}</body>
    </html>
  );
}
```

</details>
