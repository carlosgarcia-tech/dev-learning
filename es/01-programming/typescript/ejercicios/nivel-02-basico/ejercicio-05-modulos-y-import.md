# Ejercicio 05 — Módulos y import

- **Nivel:** 2/5
- **Tema:** `export`/`import`, módulos ES, `import type`
- **Tiempo estimado:** 20 min

## Enunciado

Crea **dos archivos**:

1. `modelo.ts` que exporte:
   - Una `interface Usuario` con `id`, `nombre` y `email`.
   - Una `type UsuarioNuevo = Omit<Usuario, "id">`.
   - Una función `crearUsuario(datos: UsuarioNuevo, id: number): Usuario`.
2. `modulos.ts` que importe desde `modelo.ts` la función y los tipos, cree dos usuarios y los imprima como tabla (`console.table`).

Salida esperada (ejemplo):

```
┌─────────┬────┬──────────┬──────────────────┐
│ (index) │ id │ nombre   │ email            │
├─────────┼────┼──────────┼──────────────────┤
│ 0       │ 1  │ 'Ana'    │ 'ana@correo.com' │
│ 1       │ 2  │ 'Luis'   │ 'luis@correo.com'│
└─────────┴────┴──────────┴──────────────────┘
```

## Requisitos

- [ ] Exportar al menos una interface, un type y una función.
- [ ] Importar la función y los tipos desde `modulos.ts`.
- [ ] Usar `import type` para los tipos puros (obliga a que se borren al compilar).
- [ ] Ejecutarlo localmente con `npx tsc --strict --module NodeNext --moduleResolution NodeNext --outDir dist modulos.ts` y luego `node dist/modulos.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Exporta con `export interface Usuario { ... }` y `export type UsuarioNuevo = ...`.
- Importa la función con `import { crearUsuario } from "./modelo.js";` (nota el `.js` al compilar a módulos ES).
- Tipos puros: `import type { Usuario, UsuarioNuevo } from "./modelo.js";`.
- `console.table` sirve para imprimir arrays de objetos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`modelo.ts`:

````typescript
// ejecutar con: npx tsc --strict --module NodeNext --moduleResolution NodeNext --outDir dist modulos.ts && node dist/modulos.js
export interface Usuario {
  id: number;
  nombre: string;
  email: string;
}

export type UsuarioNuevo = Omit<Usuario, "id">;

export function crearUsuario(datos: UsuarioNuevo, id: number): Usuario {
  return { id, ...datos };
}
````

`modulos.ts`:

````typescript
import { crearUsuario } from "./modelo.js";
import type { Usuario, UsuarioNuevo } from "./modelo.js";

const datosAna: UsuarioNuevo = { nombre: "Ana", email: "ana@correo.com" };
const datosLuis: UsuarioNuevo = { nombre: "Luis", email: "luis@correo.com" };

const usuarios: Usuario[] = [
  crearUsuario(datosAna, 1),
  crearUsuario(datosLuis, 2),
];

console.table(usuarios);
````

</details>