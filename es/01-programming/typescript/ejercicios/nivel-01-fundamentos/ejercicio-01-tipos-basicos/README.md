# Ejercicio 01 — Tipos Básicos

- **Nivel:** 1/5
- **Tema:** Fundamentos de TypeScript
- **Tiempo estimado:** 15 minutos

## Enunciado

Crea un archivo TypeScript que:

1. Declare variables de los siguientes tipos:
   - `string` (nombre)
   - `number` (edad)
   - `boolean` (esEstudiante)
   - `null` y `undefined`
   - `void` (función sin retorno)
   - `any` (evita usarlo, pero decláralo)

2. Usa anotaciones de tipo explícitas.

3. Crea una función que reciba un `string` y un `number` y retorne un `string`.

4. Crea una función que reciba un `string | number` y retorne su tipo como string usando `typeof`.

5. Usa type assertions para convertir un `unknown` a `string` y luego a `number`.

## Requisitos

- [ ] El archivo compila sin errores (`npx tsc --noEmit index.ts`)
- [ ] Se declaran variables de todos los tipos básicos
- [ ] Existe una función `crearPresentacion` que retorna un string con nombre y edad
- [ ] Existe una función `identificarTipo` que identifica el tipo de un valor
- [ ] Se usa type assertion correctamente
- [ ] Los tests pasan: `node --test index.test.ts`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Recuerda que TypeScript usa `: tipo` para anotaciones.
2. Para union types usa `|`: `string | number`
3. `typeof valor` retorna un string con el tipo.
4. Para type assertion usa `as`: `unknownValue as string`
5. `void` se usa para funciones que no retornan nada.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```typescript
// 1. Variables básicas con anotaciones explícitas
let nombre: string = "Ana";
let edad: number = 30;
let esEstudiante: boolean = true;
let valorNulo: null = null;
let valorIndefinido: undefined = undefined;
let cualquierValor: any = "Cualquier cosa";

// 2. Función que retorna un string
function crearPresentacion(nombre: string, edad: number): string {
    return `Hola, me llamo ${nombre} y tengo ${edad} años.`;
}

// 3. Función que identifica el tipo
function identificarTipo(valor: string | number): string {
    if (typeof valor === "string") {
        return `Es un string: "${valor}"`;
    } else {
        return `Es un número: ${valor}`;
    }
}

// 4. Type assertions
let valorDesconocido: unknown = "123";
let valorString: string = valorDesconocido as string;
let valorNumero: number = Number(valorString);

// 5. Función void (sin retorno)
function saludar(): void {
    console.log("¡Hola!");
}

export {
    nombre,
    edad,
    esEstudiante,
    valorNulo,
    valorIndefinido,
    cualquierValor,
    crearPresentacion,
    identificarTipo,
    valorString,
    valorNumero,
    saludar
};
```

</details>
