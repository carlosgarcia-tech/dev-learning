# Ejercicio 02 — IntersectionObserver lazy load

## Enunciado

Crea un `script.js` que use `IntersectionObserver` para detectar cuándo una imagen entra en pantalla y cargar su `src`.

## Requisitos

- `script.js` con `defer`.
- Uso de `new IntersectionObserver`.
- Imágenes con `data-src` (no `src`).
- En el callback, si `isIntersecting`, copiar `data-src` a `src`.
- `observer.unobserve` después de cargar.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Las imágeneslazy usan `data-src` en vez de `src` para no cargar al inicio.
- `entry.target` es el elemento observado.
- `observer.unobserve(entry.target)` deja de observar tras cargar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**index.html**:
```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lazy load</title>
  <script src="script.js" defer></script>
</head>
<body>
  <div style="height: 100vh;">Scroll down</div>
  <img data-src="https://picsum.photos/400/300" alt="Imagen 1" width="400" height="300">
  <img data-src="https://picsum.photos/400/300" alt="Imagen 2" width="400" height="300">
  <img data-src="https://picsum.photos/400/300" alt="Imagen 3" width="400" height="300">
</body>
</html>
```

**script.js**:
```js
const observer = new IntersectionObserver((entries, obs) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      const img = entry.target;
      img.src = img.dataset.src;
      obs.unobserve(img);
    }
  });
});

document.querySelectorAll('img[data-src]').forEach((img) => observer.observe(img));
```

</details>
