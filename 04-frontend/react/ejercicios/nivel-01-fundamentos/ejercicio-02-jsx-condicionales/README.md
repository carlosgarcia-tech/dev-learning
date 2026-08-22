# Ejercicio 02 — JSX: expresiones y condicionales

## Enunciado

Crea un componente `Saludo` que reciba `nombre` y `logueado` (booleano). Si está logueado muestra "Hola, {nombre}", si no, "Inicia sesión".

## Requisitos

- Un archivo `Saludo.jsx`.
- Props `nombre` y `logueado`.
- Operador ternario para renderizar condicional.
- Expresión `{nombre}` dentro del JSX.
- `export default`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `{condicion ? 'A' : 'B'}` renderiza A o B.
- Las variables se interpolan con `{variable}`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**Saludo.jsx**:
```jsx
function Saludo({ nombre, logueado }) {
  return (
    <h1>
      {logueado ? `Hola, ${nombre}` : 'Inicia sesión'}
    </h1>
  );
}

export default Saludo;
```

</details>
