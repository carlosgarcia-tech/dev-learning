# 01 — Tipos básicos de TypeScript

## Objetivos

- [ ] Escribir anotaciones de tipo en variables, parámetros y valores de retorno.
- [ ] Distinguir los tipos primitivos (`string`, `number`, `boolean`) y sus reglas.
- [ ] Tipar arrays de varias formas y entender las tuplas.
- [ ] Usar `enum` y decidir entre enum numérico, de string y `as const`.
- [ ] Combinar tipos con uniones (`|`), literales y `type` para valores limitados.
- [ ] Hacer que el código compile bajo `--strict`.

## Apuntes

### ¿Por qué TypeScript?

TypeScript compila a JavaScript: tu código TS es *borrado de tipos* al compilar, por lo que **no hay costo en tiempo de ejecución**. Los tipos son una herramienta de comprobación en tiempo de desarrollo que detecta errores antes de ejecutar.

- El compilador `tsc` revisa tu código y emite errores de tipo.
- El archivo de configuración `tsconfig.json` define cómo compila.
- Con `--strict` se activan las comprobaciones recomendadas (¡úsalo siempre!).

```bash
npx tsc --strict --noEmit hola.ts   # solo comprueba tipos
npx tsc --outDir dist hola.ts       # compila y genera JS
node dist/hola.js
```

### Anotaciones de tipo

Escribimos `variable: tipo`. La anotación va después de `:`.

```typescript
const nombre: string = "Ana";
const edad: number = 30;
const activo: boolean = true;

function saludar(nombre: string): string {
  return `Hola, ${nombre}`;
}
```

Cuando la inicialización ya deja claro el tipo (ej. `const x = 5`), TypeScript lo **infiere** y no hace falta anotarlo. La inferencia de tipos es una de las mayores ventajas del lenguaje.

```typescript
let contador = 0;          // inferido: number
contador = "cero";         // ERROR: string no asignable a number
```

### Tipos primitivos

- `string` — texto: `"hola"`, `'hola'`, `` `hola ${x}` ``.
- `number` — enteros y decimales (todos los números JS).
- `boolean` — `true` | `false`.
- `bigint` — enteros grandes con `n`: `10n`.
- `symbol` — valores únicos con `Symbol()`.
- `null` y `undefined` — vacío y "sin asignar".

Con `--strict`, variables sin valor son `undefined` y acceder a propiedades de algo `null`/`undefined` da error de compilación, evitando un gran número de bugs.

```typescript
const entero: number = 42;
const decimal: number = 3.14;
const grande: bigint = 10n;
const unico: symbol = Symbol("id");

function doblar(n: number): number {
  return n * 2;
}
```

### Arrays y tuplas

Los arrays se tipan de dos maneras equivalentes:

```typescript
const numeros: number[] = [1, 2, 3];
const letras: Array<string> = ["a", "b"];

numeros.push(4);     // ok
numeros.push("x");   // ERROR: string no es number
```

Una **tupla** es un array con longitud y tipos fijos por posición. Útil para pares clave/valor o coordenadas.

```typescript
const par: [string, number] = ["edad", 30];
const punto: [number, number] = [10, 20];

par[0] = 31;     // ERROR: posición 0 debe ser string
par[1] = 31;     // ok
```

### Enums

Un `enum` agrupa un conjunto de constantes relacionadas. Por defecto es **numérico** y comienza en 0.

```typescript
enum Color {
  Rojo,     // 0
  Verde,    // 1
  Azul,     // 2
}

const c: Color = Color.Verde;
console.log(Color[1]); // "Verde" (inverso solo en enums numéricos)
```

Los enums de **string** son más legibles y no dependen de posiciones:

```typescript
enum EstadoPedido {
  Pendiente = "pendiente",
  Enviado = "enviado",
  Entregado = "entregado",
}

const estado: EstadoPedido = EstadoPedido.Entregado;
```

Para conjuntos pequeños de constantes, `as const` suele ser la alternativa moderna preferida (sin generar código en runtime):

```typescript
const Direcciones = ["norte", "sur", "este", "oeste"] as const;
type Direccion = (typeof Direcciones)[number];
```

### Uniones y tipos literales

Una **unión** (`|`) permite que un valor tenga uno de varios tipos:

```typescript
let id: number | string;
id = 123;    // ok
id = "abc";  // ok
id = true;   // ERROR
```

Un **tipo literal** restringe un valor a un conjunto finito de strings o números:

```typescript
type Direccion = "norte" | "sur" | "este" | "oeste";
type Resultado = "exito" | "fracaso";
type AnosValidos = 18 | 21 | 25;

function mover(dir: Direccion): void {
  console.log(`Moviendo hacia ${dir}`);
}

mover("norte"); // ok
mover("arriba"); // ERROR: no está en la unión
```

Los tipos literales combinados con uniones permiten modelar estados finitos, y junto con `switch` habilitan el **narrowing** (estrechamiento) automático de tipos.

### El tipo `any` y el propósito de los tipos

`any` desactiva la comprobación de tipos para un valor. Es la "puerta de escape" que debes evitar en la medida de lo posible, porque reintroduce los fallos que TypeScript previene.

```typescript
let peligro: any = 42;
peligro = "texto"; // ok, sin control
peligro.foo.bar(); // compila, pero puede reventar en runtime
```

Prefiere `unknown` (guía 05) cuando no sepas el tipo real, en vez de `any`.

## Ejemplos de código

```typescript
// Mezcla de anotaciones, uniones, tuplas y enums
enum Moneda {
  EUR = "EUR",
  USD = "USD",
}

type Importe = [cantidad: number, moneda: Moneda];

function formatear(importe: Importe): string {
  return `${importe[0]} ${importe[1]}`;
}

console.log(formatear([12.5, Moneda.EUR])); // "12.5 EUR"
```

```typescript
// Unión de literales + narrowing con switch
type Color = "rojo" | "verde" | "azul";

function hexColor(color: Color): string {
  switch (color) {
    case "rojo":
      return "#ff0000";
    case "verde":
      return "#00ff00";
    case "azul":
      return "#0000ff";
  }
}

console.log(hexColor("rojo")); // "#ff0000"
```

## Ejercicios relacionados

- [Ejercicios nivel 01 — Fundamentos](../ejercicios/nivel-01-fundamentos/)

## Errores comunes

- **No usar `--strict`** → los errores de `null`/`undefined` pasan desapercibidos hasta ejecutar.
- **Anotar de más** → escribir `const x: number = 5` es redundante; deja que TypeScript infiera.
- **Confundir tuplas con arrays** → `[string, number]` no es lo mismo que `(string | number)[]`.
- **Usar `any` como muleta** → pierdes toda la seguridad que compraste con TypeScript.
- **Acceder a `enum[n]` en enums de string** → el mapeo inverso solo existe en enums numéricos.
- **Asignar un tipo de unión a una variable y olvidar el narrowing** → no puedes usar `id.toFixed()` si `id` puede ser `string`.

## Recursos

- [TypeScript — Manual: Tipos básicos](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html)
- [TypeScript — Enums](https://www.typescriptlang.org/docs/handbook/enums.html)
- [TypeScript — Tuplas](https://www.typescriptlang.org/docs/handbook/2/objects.html#tuple-types)
- [TypeScript Playground](https://www.typescriptlang.org/play)
- [Documentación oficial en español](https://www.typescriptlang.org/es/docs/)