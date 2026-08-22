# Ejercicio 05 — Eventos onClick

## Enunciado

Crea un componente `Boton` que reciba un prop `onClick` y un prop `texto`. Renderiza un botón que ejecuta `onClick` al pulsar.

## Requisitos

- Un archivo `Boton.jsx`.
- Props `onClick` y `texto`.
- `<button onClick={onClick}>{texto}</button>`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En JSX los eventos van en camelCase: `onClick` (no `onclick`).
- La prop `onClick` es una función que se pasa al botón.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**Boton.jsx**:
```jsx
function Boton({ onClick, texto }) {
  return <button onClick={onClick}>{texto}</button>;
}

export default Boton;
```

</details>
