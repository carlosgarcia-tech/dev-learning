# Ejercicio 06 — Props por defecto

## Enunciado

Crea un componente `Saludo` que reciba una prop `nombre` con valor por defecto "mundo".

## Requisitos

- Un archivo `Saludo.jsx`.
- Prop `nombre` con valor por defecto `'mundo'`.
- Renderiza `<h1>Hola, {nombre}</h1>`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los valores por defecto se asignan en el destructuring: `{ nombre = 'mundo' }`.
- Si no se pasa la prop, usa el valor por defecto.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**Saludo.jsx**:
```jsx
function Saludo({ nombre = 'mundo' }) {
  return <h1>Hola, {nombre}</h1>;
}

export default Saludo;
```

</details>
