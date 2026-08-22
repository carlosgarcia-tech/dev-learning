# Ejercicio 03 — Renderizado de listas con map y key

## Enunciado

Crea un componente `ListaTareas` que reciba `tareas` (array de objetos con `id` y `texto`) y los renderice con `.map()` y `key`.

## Requisitos

- Un archivo `ListaTareas.jsx`.
- Prop `tareas` (array).
- Uso de `.map()`.
- `key={tarea.id}` en cada item.
- Cada item en un `<li>`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `.map()` transforma cada item del array en JSX.
- `key` debe ser único y estable (usa el `id`, no el índice).
- El `map` va dentro de `{}` en el JSX.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**ListaTareas.jsx**:
```jsx
function ListaTareas({ tareas }) {
  return (
    <ul>
      {tareas.map((tarea) => (
        <li key={tarea.id}>{tarea.texto}</li>
      ))}
    </ul>
  );
}

export default ListaTareas;
```

</details>
