# Ejercicio 05 — CSS Modules (estructura)

## Enunciado

Crea un archivo `Boton.module.css` con clases de un componente botón y un `index.html` que muestre cómo se usaría con un bundler (importando el módulo).

## Requisitos

- Un archivo `Boton.module.css` con al menos 2 clases (`.boton` y `.destacado`).
- El CSS usa propiedades como `background`, `padding`, `border-radius`.
- Un `index.html` que mencione en un comentario cómo se importaría el módulo en JS.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- CSS Modules genera nombres únicos automáticamente al compilar.
- En JS se importa así: `import styles from './Boton.module.css'`.
- El nombre del archivo debe llevar `.module.css`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**Boton.module.css**:
```css
.boton {
  background: #3b82f6;
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1rem;
  transition: background 0.2s ease;
}

.destacado {
  background: #ef4444;
  font-weight: bold;
}
```

**index.html**:
```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CSS Modules</title>
  <!-- 
    En un proyecto con bundler (Vite/Webpack):
    import styles from './Boton.module.css';
    <button className={styles.boton}>Botón</button>
  -->
</head>
<body>
  <h1>CSS Modules</h1>
  <p>Ver Boton.module.css</p>
</body>
</html>
```

</details>
