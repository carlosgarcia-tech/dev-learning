# Ejercicio 06 — Test con React Testing Library

## Enunciado

Crea un test para un componente `Contador` que verifica que incrementa al hacer clic.

## Requisitos

- Un archivo `Contador.test.jsx` (o `Contador.test.js`).
- `import { render, screen } from '@testing-library/react'`.
- `import userEvent from '@testing-library/user-event'`.
- Un test que renderiza `<Contador />`.
- `userEvent.click` en el botón.
- `expect` que el texto cambió.
- Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```jsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import Contador from './Contador';

test('incrementa al hacer clic', async () => {
  render(<Contador />);

  const boton = screen.getByRole('button');
  expect(boton).toHaveTextContent('0');

  await userEvent.click(boton);
  expect(boton).toHaveTextContent('1');
});
```

</details>
