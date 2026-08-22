# Ejercicio 05 — useNavigate

## Enunciado

Crea un componente `Login` que use `useNavigate` para redirigir a `/dashboard` tras el login.

## Requisitos

- Un archivo `Login.jsx`.
- `import { useNavigate } from 'react-router-dom'`.
- `const navigate = useNavigate()`.
- En el handler del submit, `navigate('/dashboard')`.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { useNavigate } from 'react-router-dom';
import { useState } from 'react';

function Login() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    // lógica de login...
    navigate('/dashboard');
  };

  return (
    <form onSubmit={handleSubmit}>
      <input value={email} onChange={(e) => setEmail(e.target.value)} />
      <button type="submit">Entrar</button>
    </form>
  );
}

export default Login;
```

</details>
