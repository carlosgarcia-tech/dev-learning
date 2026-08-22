# Ejercicio 01 — Componente funcional con props

## Enunciado

Crea un componente `Tarjeta` que reciba `titulo` y `descripcion` como props y los muestre en JSX.

## Requisitos

- Un archivo `Tarjeta.jsx`.
- Componente funcional `Tarjeta`.
- Recibe props `titulo` y `descripcion` (con destructuring).
- Devuelve JSX con un `h2` para el título y un `p` para la descripción.
- Usa `className="tarjeta"` en el contenedor.
- `export default Tarjeta`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Destructura en los parámetros: `function Tarjeta({ titulo, descripcion })`.
- `className` en JSX (no `class`).
- `export default` al final o antes de `function`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**Tarjeta.jsx**:
```jsx
function Tarjeta({ titulo, descripcion }) {
  return (
    <div className="tarjeta">
      <h2>{titulo}</h2>
      <p>{descripcion}</p>
    </div>
  );
}

export default Tarjeta;
```

</details>
