# Ejercicio 04 — children prop

## Enunciado

Crea un componente `Tarjeta` que reciba `children` y los renderice dentro de un div con `className="tarjeta"`.

## Requisitos

- Un archivo `Tarjeta.jsx`.
- Prop `children`.
- Renderiza `{children}` dentro de un `<div className="tarjeta">`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `children` es una prop especial que contiene lo que va entre las etiquetas.
- Se accede como cualquier otra prop: `{children}`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**Tarjeta.jsx**:
```jsx
function Tarjeta({ children }) {
  return (
    <div className="tarjeta">
      {children}
    </div>
  );
}

export default Tarjeta;
```

</details>
