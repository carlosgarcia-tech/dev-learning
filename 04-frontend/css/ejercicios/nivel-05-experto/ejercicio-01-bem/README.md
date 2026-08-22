# Ejercicio 01 — Nomenclatura BEM

## Enunciado

Crea un `index.html` y un `style.css` con una tarjeta de producto usando nomenclatura BEM: bloque, elemento y modificador.

## Requisitos

- Un bloque `.tarjeta`.
- Al menos 2 elementos: `.tarjeta__titulo` y `.tarjeta__boton`.
- Un modificador: `.tarjeta--destacada` o `.tarjeta__boton--primario`.
- El CSS usa las clases BEM.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- BLOQUE: `.tarjeta`, ELEMENTO: `.tarjeta__titulo` (doble guion bajo), MODIFICADOR: `.tarjeta--destacada` (doble guion).
- El modificador va en el mismo elemento, no sustituye la clase base.

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
  <title>BEM</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="tarjeta">
    <h3 class="tarjeta__titulo">Producto</h3>
    <p class="tarjeta__precio">12,99 €</p>
    <button class="tarjeta__boton tarjeta__boton--primario">Comprar</button>
  </div>

  <div class="tarjeta tarjeta--destacada">
    <h3 class="tarjeta__titulo">Producto destacado</h3>
    <button class="tarjeta__boton">Ver</button>
  </div>
</body>
</html>
```

**style.css**:
```css
.tarjeta {
  border: 1px solid #ddd;
  padding: 16px;
  border-radius: 8px;
  max-width: 300px;
  margin: 16px;
}

.tarjeta__titulo { font-size: 1.2rem; }
.tarjeta__precio { color: #16a34a; font-size: 1.4rem; }

.tarjeta__boton {
  background: #6b7280;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
}

.tarjeta__boton--primario { background: #3b82f6; }

.tarjeta--destacada {
  border-color: #3b82f6;
  border-width: 2px;
}
```

</details>
