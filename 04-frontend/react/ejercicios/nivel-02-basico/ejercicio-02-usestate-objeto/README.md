# Ejercicio 02 — useState con objeto

## Enunciado

Crea un componente `Formulario` con `useState` que guarde un objeto `{ nombre, email }` y dos inputs controlados.

## Requisitos

- Un archivo `Formulario.jsx`.
- `useState` con un objeto inicial `{ nombre: '', email: '' }`.
- Un `input` para `nombre` y otro para `email`.
- Ambos controlados (`value` y `onChange`).
- `onChange` actualiza el estado con spread (`...form`).
- `export default`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Al actualizar un campo: `setForm({ ...form, [e.target.name]: e.target.value })`.
- Los inputs deben llevar `name` para que el handler sea genérico.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**Formulario.jsx**:
```jsx
import { useState } from 'react';

function Formulario() {
  const [form, setForm] = useState({ nombre: '', email: '' });

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  return (
    <form>
      <input name="nombre" value={form.nombre} onChange={handleChange} />
      <input name="email" value={form.email} onChange={handleChange} />
    </form>
  );
}

export default Formulario;
```

</details>
