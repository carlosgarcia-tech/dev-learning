# Ejercicio 01 — next/image

## Enunciado

Crea un componente que use `next/image` para mostrar una imagen optimizada con `priority` y `width`/`height`.

## Requisitos
- Un archivo `Hero.jsx`.
- `import Image from 'next/image'`.
- `<Image>` con `src`, `alt`, `width`, `height` y `priority`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
import Image from 'next/image';

export default function Hero() {
  return (
    <Image
      src="/hero.jpg"
      alt="Imagen hero"
      width={1200}
      height={630}
      priority
    />
  );
}
```
</details>
