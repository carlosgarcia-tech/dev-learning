# Ejercicio 03 — Funciones tipadas avanzadas

- **Nivel:** 2/5
- **Tema:** funciones como tipos, `rest`, parámetros opcionales, callbacks
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `funciones-avanzadas.ts` que:

1. Defina un `type Operacion = (a: number, b: number) => number`.
2. Escriba `aplicar(op: Operacion, a: number, b: number): number` que invoque la operación.
3. Pase a `aplicar` las operaciones suma, resta y multiplicación.
4. Escriba `unirTodo(separador: string, ...palabras: string[]): string` que una las palabras con el separador.
5. Escriba `procesar(numeros: number[], callback: (n: number) => number): number[]` que devuelva el `map` de `callback` sobre los números.
6. Imprima los resultados de todos los casos.

Salida esperada (ejemplo):

```
Suma: 12
Resta: -2
Multiplicacion: 35
unirTodo: a-b-c-d
Cuadrados: 1,4,9,16
```

## Requisitos

- [ ] Definir un `type` que describa una firma de función.
- [ ] Tipar un parámetro con ese tipo y pasarlo como argumento.
- [ ] Usar `...rest` tipado en una función.
- [ ] Escribir una función que reciba y use un callback tipado.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist funciones-avanzadas.ts` y luego `node dist/funciones-avanzadas.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `type Operacion = (a: number, b: number) => number;`.
- `rest`: `function unirTodo(separador: string, ...palabras: string[]): string { return palabras.join(separador); }`.
- Para el callback: `numeros.map(callback)`; el `map` ya infiere el tipo del retorno.
- Una arrow puede asignarse a `Operacion`: `const suma: Operacion = (a, b) => a + b;`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist funciones-avanzadas.ts && node dist/funciones-avanzadas.js
type Operacion = (a: number, b: number) => number;

function aplicar(op: Operacion, a: number, b: number): number {
  return op(a, b);
}

function unirTodo(separador: string, ...palabras: string[]): string {
  return palabras.join(separador);
}

function procesar(numeros: number[], callback: (n: number) => number): number[] {
  return numeros.map(callback);
}

const suma: Operacion = (a, b) => a + b;
const resta: Operacion = (a, b) => a - b;
const multiplicacion: Operacion = (a, b) => a * b;

console.log(`Suma: ${aplicar(suma, 5, 7)}`);
console.log(`Resta: ${aplicar(resta, 5, 7)}`);
console.log(`Multiplicacion: ${aplicar(multiplicacion, 5, 7)}`);
console.log(`unirTodo: ${unirTodo("-", "a", "b", "c", "d")}`);
console.log(`Cuadrados: ${procesar([1, 2, 3, 4], (n) => n * n).join(",")}`);
````

</details>