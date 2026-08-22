# Ejercicio 06 — Container queries

## Enunciado

Crea un `index.html` y un `style.css` con un contenedor que use `container-type: inline-size` y un `@container` que cambie el layout de una tarjeta según el ancho del contenedor.

## Requisitos

- Un contenedor con `container-type: inline-size`.
- Un `@container (min-width: 400px)` que aplique estilos distintos.
- Dentro del container, una tarjeta que cambie (ej: de columna a fila).
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El contenedor debe declarar `container-type: inline-size` para que el `@container` funcione.
- `@container (min-width: 400px)` aplica cuando el contenedor mide al menos 400px.
- A diferencia de media queries, responde al contenedor, no al viewport.

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
  <title>Container queries</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="contenedor">
    <div class="tarjeta">
      <div class="tarjeta__imagen">IMG</div>
      <div class="tarjeta__contenido">
        <h3>Título</h3>
        <p>Descripción de la tarjeta.</p>
      </div>
    </div>
  </div>
</body>
</html>
```

**style.css**:
```css
.contenedor {
  container-type: inline-size;
  max-width: 800px;
  margin: 0 auto;
}

.tarjeta {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 16px;
  border: 1px solid #ddd;
  border-radius: 8px;
}

@container (min-width: 400px) {
  .tarjeta {
    flex-direction: row;
    align-items: center;
  }
}

.tarjeta__imagen {
  width: 100px;
  height: 100px;
  background: #3b82f6;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
}
```

</details>
