# Ejercicio 03 — Client Component con 'use client'

## Enunciado

Crea un Client Component `Contador.jsx` con `useState` que empiece con `'use client'`.

## Requisitos
- Un archivo `Contador.jsx`.
- `'use client'` en la primera línea.
- `import { useState } from 'react'`.
- Estado y botón de incrementar.
- `export default`.
- Los tests pasan: `bash test.sh`

## Solución
<details><summary>Mostrar solución</summary>

```jsx
'use client';
import { useState } from 'react';

export default function Contador() {
  const [c, setC] = useState(0);
  return <button onClick={() => setC(c + 1)}>{c}</button>;
}
```
</details>
