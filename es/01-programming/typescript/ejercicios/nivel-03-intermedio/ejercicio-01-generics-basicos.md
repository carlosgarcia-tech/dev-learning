# Ejercicio 01 — Genéricos básicos

- **Nivel:** 3/5
- **Tema:** `<T>`, funciones genéricas, inferencia, restricciones
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `generics.ts` que:

1. Escriba `identidad<T>(valor: T): T`.
2. Escriba `primero<T>(items: T[]): T | undefined` que devuelva `items[0]`.
3. Escriba `envolver<T>(valor: T): { valor: T }`.
4. Escriba `longitud<T extends { length: number }>(valor: T): number` (con restricción).
5. Escriba `intercambiar<A, B>(par: [A, B]): [B, A]` que devuelva la tupla invertida.
6. Imprima resultados donde se vea la inferencia de tipos (número, string y objeto).

Salida esperada (ejemplo):

```
Identidad de 42: 42 (tipo number)
Primero de [a,b,c]: a
Envolver 7: { valor: 7 }
Longitud de hola: 4
Longitud de [1,2,3]: 3
Intercambio de [1, x]: x,1
```

## Requisitos

- [ ] Escribir al menos 4 funciones genéricas con `<T>`.
- [ ] Usar una restricción `T extends ...` en al menos una.
- [ ] Comprobar que `T[]` y `[A, B]` mantienen el tipo en la salida.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist generics.ts` y luego `node dist/generics.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El tipo `T` se infiere de los argumentos: no hace falta anotarlo en la llamada.
- Restricción: `T extends { length: number }` permite strings, arrays, etc.
- Para la tupla invertida: `return [par[1], par[0]];`.
- Si `items` está vacío, `items[0]` es `undefined`; el retorno `T | undefined` lo refleja.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist generics.ts && node dist/generics.js
function identidad<T>(valor: T): T {
  return valor;
}

function primero<T>(items: T[]): T | undefined {
  return items[0];
}

function envolver<T>(valor: T): { valor: T } {
  return { valor };
}

function longitud<T extends { length: number }>(valor: T): number {
  return valor.length;
}

function intercambiar<A, B>(par: [A, B]): [B, A] {
  return [par[1], par[0]];
}

const n: number = identidad(42);
console.log(`Identidad de 42: ${n} (tipo ${typeof n})`);
console.log(`Primero de [a,b,c]: ${primero(["a", "b", "c"])}`);
console.log(`Envolver 7: ${JSON.stringify(envolver(7))}`);
console.log(`Longitud de hola: ${longitud("hola")}`);
console.log(`Longitud de [1,2,3]: ${longitud([1, 2, 3])}`);

const invertido = intercambiar([1, "x"]);
console.log(`Intercambio de [1, x]: ${invertido[0]},${invertido[1]}`);
````

</details>