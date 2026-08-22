# Ejercicio 02 — next/font

## Enunciado

Crea un `layout.jsx` que cargue una fuente de Google con `next/font` y la aplique.

## Requisitos
- Un archivo `layout.jsx`.
- `import { Inter } from 'next/font/google'` (o similar).
- Configura la fuente con `subsets` y `variable`.
- Aplica la `variable` en `<html>`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
import { Inter } from 'next/font/google';

const inter = Inter({ subsets: ['latin'], variable: '--font-inter' });

export default function RootLayout({ children }) {
  return (
    <html lang="es" className={inter.variable}>
      <body>{children}</body>
    </html>
  );
}
```
</details>
