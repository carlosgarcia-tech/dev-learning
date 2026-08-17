# Ejercicio 03 — Funciones tipadas

- **Nivel:** 1/5
- **Tema:** parámetros tipados, retorno, void, arrow functions
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `funciones.ts` que:

1. Defina una función `sumar(a, b)` con parámetros y retorno `number`.
2. Defina una función `saludar(nombre, saludo?)` donde `saludo` sea opcional con un valor por defecto `"Hola"`, y devuelva `string`.
3. Defina una función `imprimirResultado` que reciba un `string` y devuelva `void`, imprimiéndolo con `console.log`.
4. Defina una arrow function `alCuadrado` de tipo `(n: number) => number`.
5. Imprima los resultados de las cuatro en consola.

Salida esperada (ejemplo):

```
La suma es 12
Hola, Ana
¡Buenos días, Luis!
El cuadrado de 7 es 49
```

## Requisitos

- [ ] Tipar los parámetros y el valor de retorno de cada función.
- [ ] Usar un parámetro opcional con valor por defecto.
- [ ] Declarar una función que devuelva `void`.
- [ ] Usar al menos una arrow function tipada.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist funciones.ts` y luego `node dist/funciones.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Firma básica: `function sumar(a: number, b: number): number { return a + b; }`.
- Parámetro por defecto: `function saludar(nombre: string, saludo = "Hola"): string`.
- El tipo `void` se usa cuando no se devuelve nada.
- Arrow function: `const alCuadrado = (n: number): number => n * n;`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist funciones.ts && node dist/funciones.js
function sumar(a: number, b: number): number {
  return a + b;
}

function saludar(nombre: string, saludo = "Hola"): string {
  return `${saludo}, ${nombre}`;
}

function imprimirResultado(mensaje: string): void {
  console.log(mensaje);
}

const alCuadrado = (n: number): number => n * n;

const suma = sumar(5, 7);
const saludo1 = saludar("Ana");
const saludo2 = saludar("Luis", "¡Buenos días!");
const cuadrado = alCuadrado(7);

imprimirResultado(`La suma es ${suma}`);
imprimirResultado(saludo1);
imprimirResultado(saludo2);
imprimirResultado(`El cuadrado de 7 es ${cuadrado}`);
````

</details>