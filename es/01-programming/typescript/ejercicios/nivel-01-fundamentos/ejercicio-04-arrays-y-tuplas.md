# Ejercicio 04 — Arrays y tuplas

- **Nivel:** 1/5
- **Tema:** `number[]`, `Array<T>`, tuplas, acceso por índice
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `arrays.ts` que:

1. Declare `numeros` como `number[]` con `[1, 2, 3, 4, 5]` y calcule la suma con `reduce`.
2. Declare `letras` como `Array<string>` con `["a", "b", "c"]`, añada una letra con `push` y la imprima.
3. Declare una tupla `punto` de tipo `[number, number]` con `[10, 20]`.
4. Declare una tupla `usuario` de tipo `[string, number, boolean]`.
5. Imprima cada estructura y el acceso por posición de las tuplas.

Salida esperada (ejemplo):

```
Suma de numeros: 15
Letras: a,b,c,d
Punto: (10, 20)
Usuario: Ana, 30, true
```

## Requisitos

- [ ] Declarar un array con la sintaxis `T[]` y otro con `Array<T>`.
- [ ] Usar `push` para mutar el array de letras.
- [ ] Declarar dos tuplas con tipos y longitudes fijas.
- [ ] Imprimir el acceso por índice de cada tupla.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist arrays.ts` y luego `node dist/arrays.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `const numeros: number[] = [1, 2, 3, 4, 5];` y `numeros.reduce((acc, n) => acc + n, 0)`.
- `const letras: Array<string> = ["a", "b", "c"];` y `letras.push("d");`.
- Tupla: `const punto: [number, number] = [10, 20];` — acceso con `punto[0]`.
- Con `--strict` y `noUncheckedIndexedAccess`, `punto[0]` puede ser `undefined`; usa `??` o comprueba antes de imprimir.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist arrays.ts && node dist/arrays.js
const numeros: number[] = [1, 2, 3, 4, 5];
const suma = numeros.reduce((acc, n) => acc + n, 0);

const letras: Array<string> = ["a", "b", "c"];
letras.push("d");

const punto: [number, number] = [10, 20];
const usuario: [string, number, boolean] = ["Ana", 30, true];

console.log(`Suma de numeros: ${suma}`);
console.log(`Letras: ${letras.join(",")}`);
console.log(`Punto: (${punto[0]}, ${punto[1]})`);
console.log(`Usuario: ${usuario[0]}, ${usuario[1]}, ${usuario[2]}`);
````

</details>