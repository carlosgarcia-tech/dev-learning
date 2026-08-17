# Ejercicio 01 — Tipos básicos

- **Nivel:** 1/5
- **Tema:** primitivos, anotaciones, typeof, inferencia
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `tipos.ts` que:

1. Declare con anotación explícita una variable `nombre` (string), `edad` (number) y `activo` (boolean).
2. Declare una variable `ciudad` sin anotar y compruebe que TypeScript la infiere como `string` asignándole un texto.
3. Use `typeof` para imprimir en consola el tipo de cada variable (como en JS, en runtime).
4. Convierta un número a string y un string a número de forma explícita, e imprima ambos resultados.

Salida esperada (ejemplo):

```
Ana es de tipo string
30 es de tipo number
true es de tipo boolean
Lima es de tipo string
Convierte a string: "2026"
Convierte a number: 2026
```

## Requisitos

- [ ] Declarar al menos una variable con anotación explícita de cada primitivo.
- [ ] Verificar la inferencia con la variable `ciudad`.
- [ ] Usar `typeof` en runtime con `console.log`.
- [ ] Hacer una conversión explícita de tipo en cada dirección.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist tipos.ts` y luego `node dist/tipos.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La anotación va después de los dos puntos: `const nombre: string = "Ana";`.
- Para la inferencia, escribe `const ciudad = "Lima";` y luego `typeof ciudad` imprimirá `"string"`.
- `String(2026)` convierte un número a string; `Number("2026")` convierte un string a número.
- Si usas `const`, el tipo de `ciudad` será el literal `"Lima"`; con `let` será `string`. Para este ejercicio usa `let`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist tipos.ts && node dist/tipos.js
const nombre: string = "Ana";
const edad: number = 30;
const activo: boolean = true;

let ciudad = "Lima";

console.log(`${nombre} es de tipo ${typeof nombre}`);
console.log(`${edad} es de tipo ${typeof edad}`);
console.log(`${activo} es de tipo ${typeof activo}`);
console.log(`${ciudad} es de tipo ${typeof ciudad}`);

const comoString: string = String(2026);
const comoNumero: number = Number("2026");

console.log(`Convierte a string: "${comoString}"`);
console.log(`Convierte a number: ${comoNumero}`);
````

</details>