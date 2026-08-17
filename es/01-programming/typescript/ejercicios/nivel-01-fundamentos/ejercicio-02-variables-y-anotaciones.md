# Ejercicio 02 — Variables y anotaciones

- **Nivel:** 1/5
- **Tema:** let/const, anotaciones, errores de asignación
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `variables.ts` que:

1. Declare con `const` y anotación un `precioUnitario` de tipo `number` y un `producto` de tipo `string`.
2. Declare con `let` un `cantidad` de tipo `number` que luego se reasigne (incremente).
3. Declare una variable `descuento` de tipo `number | undefined` e imprima su valor tal cual.
4. Incluya, **como comentario**, un ejemplo de asignación inválida que TypeScript debe rechazar (ej. asignar un string a una variable number). El archivo debe **compilar sin errores**, así que el código inválido va solo en comentario.
5. Imprima el total con descuento aplicado: `(precioUnitario * cantidad) * (1 - (descuento ?? 0))`.

Salida esperada (ejemplo):

```
Producto: Teclado
Precio unitario: 25
Cantidad final: 3
Descuento: undefined
Total con descuento: 75
```

## Requisitos

- [ ] Usar `const` para valores fijos y `let` para el que se reasigna.
- [ ] Anotar explícitamente el tipo de cada variable.
- [ ] Incluir en comentario una asignación inválida que demuestre la comprobación de tipos.
- [ ] Manejar `undefined` con `??` (nullish coalescing) en el cálculo.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist variables.ts` y luego `node dist/variables.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `let cantidad: number = 2;` y luego `cantidad += 1;`.
- El operador `??` devuelve el valor de la derecha si el de la izquierda es `null` o `undefined`: `descuento ?? 0`.
- El código inválido se escribe con `//` dentro del archivo, sin que forme parte del programa.
- Ejemplo de comentario: `// const invalido: number = "texto"; // ERROR en TypeScript`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist variables.ts && node dist/variables.js
const producto: string = "Teclado";
const precioUnitario: number = 25;

let cantidad: number = 2;
cantidad += 1;

const descuento: number | undefined = undefined;

// Asignación inválida que TypeScript rechaza (solo como ejemplo):
// precioUnitario = "caro";      // ERROR: string no asignable a number
// cantidad = "tres";            // ERROR: string no asignable a number

const total = precioUnitario * cantidad * (1 - (descuento ?? 0));

console.log(`Producto: ${producto}`);
console.log(`Precio unitario: ${precioUnitario}`);
console.log(`Cantidad final: ${cantidad}`);
console.log(`Descuento: ${descuento}`);
console.log(`Total con descuento: ${total}`);
````

</details>