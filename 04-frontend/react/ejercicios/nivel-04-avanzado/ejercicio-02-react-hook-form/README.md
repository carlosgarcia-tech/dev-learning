# Ejercicio 02 — React Hook Form básico

## Enunciado

Crea un formulario con React Hook Form: campos `nombre` y `email` con validación `required`.

## Requisitos

- Un archivo `Formulario.jsx`.
- `import { useForm } from 'react-hook-form'`.
- Uso de `register`, `handleSubmit` y `formState.errors`.
- Campos `nombre` y `email` con `required`.
- Mostrar errores si los hay.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { useForm } from 'react-hook-form';

function Formulario() {
  const { register, handleSubmit, formState: { errors } } = useForm();

  const onSubmit = (data) => console.log(data);

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('nombre', { required: 'Requerido' })} placeholder="Nombre" />
      {errors.nombre && <p>{errors.nombre.message}</p>}

      <input {...register('email', { required: 'Requerido' })} placeholder="Email" />
      {errors.email && <p>{errors.email.message}</p>}

      <button type="submit">Enviar</button>
    </form>
  );
}

export default Formulario;
```

</details>
