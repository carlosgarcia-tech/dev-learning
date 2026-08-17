# 03 — Funciones y genéricos

## Objetivos

- [ ] Tipar parámetros, valores de retorno y variables de función.
- [ ] Usar parámetros opcionales, por defecto y `rest` tipados.
- [ ] Definir funciones como tipo (`type Fn = (...) => ...`).
- [ ] Declarar **overloads** para firmas múltiples de una misma función.
- [ ] Escribir funciones **genéricas** reutilizables con `<T>`.
- [ ] Aplicar restricciones (`extends`) y valores por defecto a los genéricos.

## Apuntes

### Firmas de función

La forma más básica de tipar una función es anotar parámetros y retorno:

```typescript
function sumar(a: number, b: number): number {
  return a + b;
}

const restar = (a: number, b: number): number => a - b;
```

El retorno casi siempre se **infiere**; anótalo cuando quieras ser explícito o exigir un tipo concreto. Si la función no devuelve nada, usa `void`:

```typescript
function log(mensaje: string): void {
  console.log(mensaje);
}
```

### Parámetros opcionales, por defecto y rest

```typescript
function saludar(nombre: string, saludo: string = "Hola"): string {
  return `${saludo}, ${nombre}`;
}

function formatear(nombre: string, prefijo?: string): string {
  return prefijo ? `${prefijo} ${nombre}` : nombre;
}

function unir(...partes: string[]): string {
  return partes.join("-");
}

console.log(unir("a", "b", "c")); // "a-b-c"
```

Los parámetros opcionales (`?`) y los de defecto (`=`) van **después** de los obligatorios. Dentro de la función, un parámetro opcional es `string | undefined` hasta que lo estrechas.

### Funciones como tipos

Una función puede asignarse a un tipo que describa su firma:

```typescript
type Transformador = (valor: string) => string;

const aMayusculas: Transformador = (v) => v.toUpperCase();
const alReves: Transformador = (v) => v.split("").reverse().join("");
```

Cuando una función tipo aparece en la firma de otra, el parámetro que la recibe puede inferir el tipo de su argumento:

```typescript
function aplicar(valor: string, fn: Transformador): string {
  return fn(valor);
}

console.log(aplicar("hola", aMayusculas)); // "HOLA"
```

### Overloads

Un **overload** permite a una función tener varias firmas públicas que comparten una implementación. Se declaran primero las firmas, y la implementación (más amplia) va al final:

```typescript
function convertir(valor: number): string;
function convertir(valor: string): number;
function convertir(valor: number | string): number | string {
  if (typeof valor === "number") {
    return valor.toString();
  }
  return Number(valor);
}

const n: number = convertir("42");    // ok, usa la 2.ª firma
const s: string = convertir(42);      // ok, usa la 1.ª firma
```

### Genéricos: tipos parametrizados

Un **genérico** (`<T>`) permite escribir una función que trabaja con "cualquier tipo" pero **manteniendo la relación** entre entrada y salida. Es como un parámetro de tipo.

```typescript
function primero<T>(items: T[]): T | undefined {
  return items[0];
}

const a = primero([1, 2, 3]);      // T = number
const b = primero(["a", "b"]);     // T = string

function identidad<T>(valor: T): T {
  return valor;
}
```

La diferencia clave con `any`: `identidad("x")` devuelve `string`, no pierde el tipo. Los genéricos también funcionan en interfaces, `type`, clases y arrow functions:

```typescript
interface Par<K, V> {
  clave: K;
  valor: V;
}

const par: Par<string, number> = { clave: "edad", valor: 30 };
```

```typescript
const envolver = <T>(valor: T): { valor: T } => ({ valor });
```

### Restricciones de genéricos

Con `extends` limitamos qué tipos puede tomar `T`:

```typescript
function longitud<T extends { length: number }>(valor: T): number {
  return valor.length;
}

longitud("hola");        // ok: string tiene length
longitud([1, 2, 3]);     // ok: array tiene length
// longitud(42);         // ERROR: number no tiene length
```

Un genérico puede tener un **valor por defecto** para cuando el tipo no se infiera:

```typescript
function crearMapa<K extends string, V = number>(): Map<K, V> {
  return new Map();
}

const mapa = crearMapa<"a" | "b">(); // V = number por defecto
```

### Claves genéricas con `keyof`

`keyof` devuelve las claves de un tipo como una unión de literales. Es la base para utilidades como `get`:

```typescript
interface Usuario {
  nombre: string;
  edad: number;
}

function obtener<U, K extends keyof U>(obj: U, clave: K): U[K] {
  return obj[clave];
}

const u: Usuario = { nombre: "Ana", edad: 30 };
const nombre: string = obtener(u, "nombre"); // ok
// obtener(u, "email");                      // ERROR: no es clave de Usuario
```

## Ejemplos de código

```typescript
// Función genérica con restricción
function copiar<T extends string | number>(items: T[]): T[] {
  return [...items];
}

console.log(copiar([1, 2, 3]));
```

```typescript
// Overloads + genéricos en un mini servicio
interface Respuesta<T> {
  ok: boolean;
  datos: T | null;
}

function procesar(valor: string): Respuesta<string>;
function procesar(valor: number): Respuesta<number>;
function procesar(valor: string | number): Respuesta<string | number> {
  return { ok: true, datos: valor };
}

console.log(procesar(42).datos); // number | null
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/) (funciones)
- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/) (genéricos y overloads)

## Errores comunes

- **Confundir `void` con `undefined`** → `void` es para funciones que no devuelven nada usable; `Promise<void>` para async sin retorno.
- **Parámetro opcional usado antes del narrowing** → `prefijo.toUpperCase()` falla si `prefijo` puede ser `undefined`.
- **Usar `any` en vez de un genérico** → pierdes la relación entre entrada y salida.
- **Olvidar `extends` en la restricción** → `K extends keyof U` es la sintaxis, no `K keyof U`.
- **Declarar overloads pero no la implementación final** → sin implementación, el código no compila.
- **Poner parámetros opcionales antes que obligatorios** → no compila; el orden es obligatorios → opcionales.

## Recursos

- [TypeScript — Funciones](https://www.typescriptlang.org/docs/handbook/2/functions.html)
- [TypeScript — Genéricos](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [TypeScript — Function overloads](https://www.typescriptlang.org/docs/handbook/2/functions.html#function-overloads)
- [Documentación oficial en español](https://www.typescriptlang.org/es/docs/)