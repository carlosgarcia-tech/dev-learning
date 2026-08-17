# Ejercicio 05 — Config tsconfig

- **Nivel:** 4/5
- **Tema:** `tsconfig.json`, `strict`, `target`, `module`, `outDir`, `noEmitOnError`
- **Tiempo estimado:** 30 min

## Enunciado

Crea un proyecto mínimo con dos archivos:

1. `tsconfig.json` que configure:
   - `target: "ES2022"`, `module: "NodeNext"`, `moduleResolution: "NodeNext"`.
   - `strict: true`, `noUncheckedIndexedAccess: true`.
   - `outDir: "dist"`, `rootDir: "src"`, `noEmitOnError: true`.
   - `include: ["src"]`.
2. `src/main.ts` que importe una función desde `src/utils.ts` y la use. Utiliza un acceso por índice que **demuestre** `noUncheckedIndexedAccess` (devuelve `T | undefined` y lo manejas con `??`).

Salida esperada (ejemplo):

```
Suma de pares: 12
```

## Requisitos

- [ ] Crear un `tsconfig.json` con todas las opciones indicadas.
- [ ] Estructurar `src/` y compilar a `dist/`.
- [ ] Usar `noUncheckedIndexedAccess` de forma visible (indexar un array y manejar el `undefined` con `??`).
- [ ] Ejecutarlo localmente con `npx tsc` (usa el tsconfig) y luego `node dist/main.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `moduleResolution: "NodeNext"` requiere que los imports relativos terminen en `.js` al escribir TS.
- Con `noUncheckedIndexedAccess`, `arr[i]` es `T | undefined`, así que `arr[0]` necesita `??`.
- Al compilar con el tsconfig, `npx tsc` lee `rootDir`/`include` y emite en `dist/`.
- El orden: `npx tsc` primero (sin `--outDir`, porque ya va en el tsconfig) y luego `node dist/main.js`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`tsconfig.json`:

````json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "outDir": "dist",
    "rootDir": "src",
    "noEmitOnError": true
  },
  "include": ["src"]
}
````

`src/utils.ts`:

````typescript
export function sumarPares(numeros: number[]): number {
  return numeros.reduce((acc, n) => (n % 2 === 0 ? acc + n : acc), 0);
}
````

`src/main.ts`:

````typescript
// ejecutar con: npx tsc && node dist/main.js
import { sumarPares } from "./utils.js";

const numeros = [1, 2, 3, 4, 5];
const primero = numeros[0]; // number | undefined por noUncheckedIndexedAccess
const total = sumarPares(numeros);

console.log(`Suma de pares: ${total}`);
console.log(`Primero (manejado): ${primero ?? "sin datos"}`);
````

</details>