# Ejercicio 04 — Overloads

- **Nivel:** 3/5
- **Tema:** sobrecarga de funciones, firmas múltiples, implementación
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `overloads.ts` que:

1. Defina una función `formatear` con dos firmas (overloads):
   - `formatear(valor: number, moneda: string): string` → devuelve `"<moneda> <valor.toFixed(2)>"`.
   - `formatear(valor: string): string` → devuelve el string en mayúsculas.
2. Escriba la implementación que recibe `number | string` y el parámetro opcional de moneda, con narrowing por `typeof`.
3. Defina otra función `procesar` con overloads:
   - `procesar(datos: number[]): number` → suma.
   - `procesar(datos: string[]): string` → concatena con `-`.
4. Implemente `procesar` recibiendo `number[] | string[]`.
5. Llame a ambas con distintos argumentos y compruebe que los tipos de retorno se infieren correctamente (asigna los resultados a variables tipadas).

Salida esperada (ejemplo):

```
formatear(19.9, USD): USD 19.90
formatear("hola"): HOLA
procesar([1,2,3]): 6
procesar(["a","b","c"]): a-b-c
```

## Requisitos

- [ ] Declarar al menos dos firmas de overload por función.
- [ ] Escribir la implementación con un tipo unión más amplio.
- [ ] Usar `typeof` para estrechar dentro de la implementación.
- [ ] Asignar cada retorno a una variable con el tipo correcto inferido.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist overloads.ts` y luego `node dist/overloads.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Las firmas de overload van **sin cuerpo**; la implementación final es la única con `{}`.
- La implementación debe ser compatible con todas las firmas (usa `number | string`).
- El parámetro opcional de moneda va solo en la primera firma; en la implementación es `moneda?: string`.
- Para `procesar`, el tipo `number[] | string[]` no permite sumar directamente: comprueba el primer elemento en runtime y luego usa una aserción `as number[]` (el overload ya garantizó que la entrada es homogénea).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist overloads.ts && node dist/overloads.js
function formatear(valor: number, moneda: string): string;
function formatear(valor: string): string;
function formatear(valor: number | string, moneda?: string): string {
  if (typeof valor === "number") {
    return `${moneda ?? ""} ${valor.toFixed(2)}`.trim();
  }
  return valor.toUpperCase();
}

function procesar(datos: number[]): number;
function procesar(datos: string[]): string;
function procesar(datos: number[] | string[]): number | string {
  if (datos.length === 0 || typeof datos[0] === "number") {
    return (datos as number[]).reduce((acc, n) => acc + n, 0);
  }
  return datos.join("-");
}

const conMoneda: string = formatear(19.9, "USD");
const enMayusculas: string = formatear("hola");
const suma: number = procesar([1, 2, 3]);
const unidas: string = procesar(["a", "b", "c"]);

console.log(`formatear(19.9, USD): ${conMoneda}`);
console.log(`formatear("hola"): ${enMayusculas}`);
console.log(`procesar([1,2,3]): ${suma}`);
console.log(`procesar(["a","b","c"]): ${unidas}`);
````

</details>