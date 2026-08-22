# Ejercicio 01 — Formulario controlado

## Enunciado

Crea un componente `Formulario` con inputs controlados para nombre y email usando `useState`.

## Requisitos

- Un archivo `Formulario.jsx`.
- `useState` para nombre y email.
- Inputs con `value` y `onChange`.
- `preventDefault` en el submit.
- `console.log` de los datos.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

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

export default Formulario;
```

</details>
