# Ejercicio 06 — Rewrites (proxy a API externa)

## Enunciado

Crea un `next.config.js` con una regla de rewrite que haga proxy de `/api/externa` a una API externa.

## Requisitos
- Un archivo `next.config.js`.
- `async rewrites()` que retorna un array.
- Regla `source: '/api/externa'`, `destination: 'https://api.example.com/datos'`.
- `module.exports`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```js
/** @type {import('next').NextConfig} */
const nextConfig = {
  async rewrites() {
    return [
      {
        source: '/api/externa',
        destination: 'https://api.example.com/datos'
      }
    ];
  }
};

module.exports = nextConfig;
```
</details>
