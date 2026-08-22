# 04 — Formularios y peticiones

> Formularios controlados, React Hook Form, Zod, fetch con React, SWR, React Query, TanStack Query.

## Objetivos

- [ ] Crear formularios controlados en React
- [ ] Validar formularios con Zod
- [ ] Usar React Hook Form para formularios escalables
- [ ] Hacer peticiones con fetch en componentes
- [ ] Gestionar caché y revalidación con SWR
- [ ] Usar TanStack Query (React Query) para datos de servidor
- [ ] Manejar loading, error y estados optimistas

## Formularios controlados

En React, los inputs son **controlados**: el estado guarda el valor y el `onChange` lo actualiza.

```jsx
import { useState } from 'react';

function Formulario() {
  const [nombre, setNombre] = useState('');
  const [email, setEmail] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log({ nombre, email });
  };

  return (
    <form onSubmit={handleSubmit}>
      <input value={nombre} onChange={(e) => setNombre(e.target.value)} placeholder="Nombre" />
      <input value={email} onChange={(e) => setEmail(e.target.value)} placeholder="Email" />
      <button type="submit">Enviar</button>
    </form>
  );
}
```

### Un solo estado para todo el form

```jsx
const [form, setForm] = useState({ nombre: '', email: '', edad: 0 });

const handleChange = (e) => {
  setForm({ ...form, [e.target.name]: e.target.value });
};

<input name="nombre" value={form.nombre} onChange={handleChange} />
<input name="email" value={form.email} onChange={handleChange} />
```

> **Inconveniente**: cada tecla provoca un re-render. Para formularios grandes, mejor React Hook Form.

## React Hook Form

Librería que gestiona formularios con menos re-renders y mejor rendimiento.

```bash
npm install react-hook-form
```

```jsx
import { useForm } from 'react-hook-form';

function Formulario() {
  const { register, handleSubmit, formState: { errors } } = useForm();

  const onSubmit = (data) => {
    console.log(data);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input
        {...register('nombre', { required: 'El nombre es obligatorio', minLength: 3 })}
        placeholder="Nombre"
      />
      {errors.nombre && <p>{errors.nombre.message}</p>}

      <input
        {...register('email', { required: true, pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/ })}
        placeholder="Email"
      />
      {errors.email && <p>Email no válido</p>}

      <button type="submit">Enviar</button>
    </form>
  );
}
```

### Ventajas de RHF

| Ventaja | Descripción |
|---|---|
| Menos re-renders | Inputs no controlados por defecto |
| Validación integrada | `required`, `min`, `pattern` |
| `handleSubmit` | Evita el boilerplate |
| Errores accesibles | `formState.errors` |
| Performance | Mejor que formularios controlados |

## Zod: validación con schema

Zod valida datos con un schema declarativo. Se integra con React Hook Form vía `zodResolver`.

```bash
npm install zod @hookform/resolvers
```

```jsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const schema = z.object({
  nombre: z.string().min(3, 'Mínimo 3 caracteres'),
  email: z.string().email('Email no válido'),
  edad: z.number().min(18, 'Debes ser mayor de edad')
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

      <input type="number" {...register('edad')} placeholder="Edad" />
      {errors.edad && <p>{errors.edad.message}</p>}

      <button type="submit">Enviar</button>
    </form>
  );
}
```

## fetch con React

```jsx
import { useState, useEffect } from 'react';

function Perfil({ userId }) {
  const [usuario, setUsuario] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    setLoading(true);
    fetch(`/api/users/${userId}`)
      .then((res) => {
        if (!res.ok) throw new Error('Error');
        return res.json();
      })
      .then(setUsuario)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [userId]);

  if (loading) return <p>Cargando...</p>;
  if (error) return <p>Error: {error.message}</p>;
  return <h1>{usuario.name}</h1>;
}
```

> Hacer fetch con `useEffect` tiene limitaciones: no caché, no revalidación, condiciones de carrera. Para apps serias, mejor SWR o TanStack Query.

## SWR

SWR (Stale-While-Revalidate) simplifica el fetch con caché y revalidación.

```bash
npm install swr
```

```jsx
import useSWR from 'swr';

const fetcher = (url) => fetch(url).then((res) => res.json());

function Perfil({ userId }) {
  const { data, error, isLoading } = useSWR(`/api/users/${userId}`, fetcher);

  if (isLoading) return <p>Cargando...</p>;
  if (error) return <p>Error</p>;
  return <h1>{data.name}</h1>;
}
```

### Mutaciones

```jsx
import useSWR, { mutate } from 'swr';

function ActualizarNombre({ userId }) {
  const { data } = useSWR(`/api/users/${userId}`, fetcher);

  const actualizar = async () => {
    await fetch(`/api/users/${userId}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: 'Nuevo nombre' })
    });
    mutate(`/api/users/${userId}`);  // revalidar
  };

  return <button onClick={actualizar}>Actualizar</button>;
}
```

## TanStack Query (React Query)

La solución más completa para datos de servidor: caché, revalidación, mutaciones, optimismo y devtools.

```bash
npm install @tanstack/react-query
```

### Configuración

```jsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

const queryClient = new QueryClient();

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <Perfil />
    </QueryClientProvider>
  );
}
```

### Queries

```jsx
import { useQuery } from '@tanstack/react-query';

function Perfil({ userId }) {
  const { data, isLoading, error } = useQuery({
    queryKey: ['user', userId],
    queryFn: async () => {
      const res = await fetch(`/api/users/${userId}`);
      if (!res.ok) throw new Error('Error');
      return res.json();
    }
  });

  if (isLoading) return <p>Cargando...</p>;
  if (error) return <p>Error: {error.message}</p>;
  return <h1>{data.name}</h1>;
}
```

### Mutaciones

```jsx
import { useMutation, useQueryClient } from '@tanstack/react-query';

function CrearUsuario() {
  const queryClient = useQueryClient();

  const mutacion = useMutation({
    mutationFn: (nuevo) =>
      fetch('/api/users', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(nuevo)
      }).then((res) => res.json()),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    }
  });

  return (
    <button onClick={() => mutacion.mutate({ name: 'Ana' })}>
      {mutacion.isPending ? 'Creando...' : 'Crear'}
    </button>
  );
}
```

### Actualización optimista

```jsx
const mutacion = useMutation({
  mutationFn: actualizarTodo,
  onMutate: async (nuevoTodo) => {
    await queryClient.cancelQueries({ queryKey: ['todos'] });
    const prev = queryClient.getQueryData(['todos']);
    queryClient.setQueryData(['todos'], (old) => [...old, nuevoTodo]);
    return { prev };
  },
  onError: (err, nuevo, context) => {
    queryClient.setQueryData(['todos'], context.prev);  // rollback
  },
  onSettled: () => {
    queryClient.invalidateQueries({ queryKey: ['todos'] });
  }
});
```

## Comparativa

| Solución | Caché | Revalidación | Mutaciones | Devtools |
|---|---|---|---|---|
| `fetch` + `useEffect` | No | No | Manual | No |
| SWR | Sí | Automática | `mutate` | Sí |
| TanStack Query | Sí | Automática | `useMutation` | Excelentes |

## Conceptos clave

- Los formularios controlados sincronizan el input con el estado.
- React Hook Form reduce re-renders y añade validación.
- Zod valida con schemas declarativos e integrables con RHF.
- `fetch` en `useEffect` no gestiona caché ni revalidación.
- SWR y TanStack Query añaden caché, revalidación y mutaciones.
- `queryKey` identifica un dato en caché.
- `invalidateQueries` fuerza la recarga de datos.

## Errores comunes

- **Inputs sin `value` y `onChange`**: inputs no controlados.
- **Olvidar `e.preventDefault()` en submit**: el form recarga la página.
- **`useEffect` sin cleanup en fetch**: condiciones de carrera.
- **No comprobar `res.ok`**: errores HTTP se ignoran.
- **`mutate` sin revalidar**: datos desactualizados.
- **Caché no invalidada tras mutación**: la UI no se actualiza.
- **`queryKey` mal definida**: datos compartidos que no deberían.
- **No usar `isPending`**: el usuario no ve feedback.
- **Validar solo en cliente**: valida también en el servidor.
