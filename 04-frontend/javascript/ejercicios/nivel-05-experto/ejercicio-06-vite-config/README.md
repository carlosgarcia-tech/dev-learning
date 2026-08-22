# Ejercicio 06 — Configuración de Vite

## Enunciado

Crea un proyecto con estructura de Vite: `package.json`, `index.html`, `vite.config.js` y `src/main.js`.

## Requisitos

- Un `package.json` con `"dev": "vite"` y `"build": "vite build"` en scripts, y `vite` como devDependency.
- Un `index.html` con `<script type="module" src="/src/main.js">`.
- Un `vite.config.js` que exporte la configuración.
- Un `src/main.js` con un `console.log`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `package.json` necesita `"type": "module"` para usar ES modules en Node.
- `vite.config.js` usa `defineConfig` de Vite.
- El `index.html` es el punto de entrada de Vite.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**package.json**:
```json
{
  "name": "mi-app-vite",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "devDependencies": {
    "vite": "^5.0.0"
  }
}
```

**index.html**:
```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vite App</title>
</head>
<body>
  <div id="app"></div>
  <script type="module" src="/src/main.js"></script>
</body>
</html>
```

**vite.config.js**:
```js
import { defineConfig } from 'vite';

export default defineConfig({
  server: {
    port: 3000,
    open: true
  },
  build: {
    outDir: 'dist'
  }
});
```

**src/main.js**:
```js
console.log('Vite app iniciada');
document.querySelector('#app').innerHTML = '<h1>Hola Vite</h1>';
```

</details>
