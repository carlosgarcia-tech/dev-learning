# Ejercicio 04 — Conditional types

- **Nivel:** 4/5
- **Tema:** `T extends U ? X : Y`, distribución sobre uniones, `infer`
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `conditional-types.ts` que:

1. Defina `type SinNull<T> = T extends null | undefined ? never : T`.
2. Defina `type ElementoDeArray<T> = T extends (infer E)[] ? E : T` usando `infer`.
3. Defina `type PromesaDe<T> = T extends Promise<infer V> ? V : T` (desenvuelve una promesa).
4. Defina `type Etiqueta<T> = T extends string ? "es-string" : T extends number ? "es-number" : "otro"`.
5. Verifique en tiempo de **compilación** (con `const` tipadas) que: `SinNull<string | null>` es `string`, `ElementoDeArray<string[]>` es `string`, `PromesaDe<Promise<number>>` es `number`, y `Etiqueta<"x">` es `"es-string"`. Imprima los valores de ejemplo en runtime.

Salida esperada (ejemplo):

```
SinNull string|null compila como: texto
Elemento de string[]: a
Promesa de Promise<number>: 42
Etiqueta de "x": es-string
```

## Requisitos

- [ ] Definir al menos 3 conditional types.
- [ ] Usar `infer` en al menos uno.
- [ ] Comprobar la distribución sobre una unión (`string | null`).
- [ ] Asignar valores a variables tipadas con los conditional types resultantes.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist conditional-types.ts` y luego `node dist/conditional-types.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Sintaxis: `T extends U ? X : Y`; sin paréntesis se evalúa como `(T extends U) ? X : Y`.
- `infer E` declara una variable de tipo capturada: `T extends (infer E)[] ? E : T`.
- Los condicionales **distribuyen** sobre uniones cuando el tipo de la izquierda es un parámetro de tipo.
- Los conditional types son solo de compilación: en runtime solo imprimes los valores.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist conditional-types.ts && node dist/conditional-types.js
type SinNull<T> = T extends null | undefined ? never : T;
type ElementoDeArray<T> = T extends (infer E)[] ? E : T;
type PromesaDe<T> = T extends Promise<infer V> ? V : T;
type Etiqueta<T> = T extends string ? "es-string" : T extends number ? "es-number" : "otro";

const texto: SinNull<string | null> = "texto";
const elemento: ElementoDeArray<string[]> = "a";
const numero: PromesaDe<Promise<number>> = 42;
const etiqueta: Etiqueta<"x"> = "es-string";

// Comentarios de compilación (estos tipos NO existen en runtime):
// const error: SinNull<null> = null;  // ERROR: never no admite ningún valor
// const n: PromesaDe<Promise<number>> = "no"; // ERROR: debe ser number

console.log(`SinNull string|null compila como: ${texto}`);
console.log(`Elemento de string[]: ${elemento}`);
console.log(`Promesa de Promise<number>: ${numero}`);
console.log(`Etiqueta de "x": ${etiqueta}`);
````

</details>