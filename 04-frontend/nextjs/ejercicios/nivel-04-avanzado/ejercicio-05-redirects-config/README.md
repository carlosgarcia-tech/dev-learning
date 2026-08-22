# Ejercicio 05 — Redirects en next.config.js

## Enunciado

Crea un `next.config.js` con una regla de redirect de `/viejo` a `/nuevo`.

## Requisitos
- Un archivo `next.config.js`.
- `async redirects()` que retorna un array.
- Regla `source: '/viejo'`, `destination: '/nuevo'`.
- `module.exports`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```js
/** @type {import('next').NextConfig} */
const nextConfig = {
  async redirects() {
    return [
      {
        source: '/viejo',
        destination: '/nuevo',
        permanent: true
      }
    ];
  }
};

module.exports = nextConfig;
```
</details>
