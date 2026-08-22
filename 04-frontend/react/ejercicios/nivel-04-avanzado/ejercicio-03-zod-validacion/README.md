# Ejercicio 03 — Zod + React Hook Form

## Enunciado

Crea un formulario con React Hook Form validado por Zod usando `zodResolver`.

## Requisitos

- Un archivo `Formulario.jsx`.
- `import { z } from 'zod'` y `import { zodResolver }`.
- Schema con `nombre` (min 3) y `email` (email válido).
- `useForm` con `resolver: zodResolver(schema)`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const schema = z.object({
  nombre: z.string().min(3, 'Mínimo 3 caracteres'),
  email: z.string().email('Email no válido')
});

function Formulario() {
  const { register, handleSubmit, formState: { errors } } = useForm({
    resolver: zodResolver(schema)
  });

  const onSubmit = (data) => console.log(data);

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('nombre')} placeholder="Nombre" />
      {errors.nombre && <p>{errors.nombre.message}</p>}

      <input {...register('email')} placeholder="Email" />
      {errors.email && <p>{errors.email.message}</p>}

      <button type="submit">Enviar</button>
    </form>
  );
}

export default Formulario;
```

</details>
