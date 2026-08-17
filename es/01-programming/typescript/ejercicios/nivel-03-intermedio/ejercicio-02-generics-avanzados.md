# Ejercicio 02 — Genéricos avanzados

- **Nivel:** 3/5
- **Tema:** `keyof`, `U[K]`, genéricos en interfaces, valores por defecto
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `generics-avanzados.ts` que:

1. Defina `interface Usuario` con `id`, `nombre`, `email` y `edad`.
2. Escriba `obtenerCampo<U, K extends keyof U>(obj: U, clave: K): U[K]` (acceso tipado).
3. Escriba `cambiarCampo<U, K extends keyof U>(obj: U, clave: K, valor: U[K]): U` que devuelva una copia con el campo modificado.
4. Defina `interface Caja<T = string>` con un campo `contenido: T` (valor por defecto).
5. Cree una `Caja<string>`, una `Caja<number>` y una `Caja` sin parámetro (usa el default).
6. Imprima el resultado de `obtenerCampo` y `cambiarCampo` y el contenido de cada caja.

Salida esperada (ejemplo):

```
Edad actual: 30
Edad tras cambio: 31
Caja<string>: hola
Caja<number>: 42
Caja (default string): generico
```

## Requisitos

- [ ] Usar `keyof` en una restricción de genérico.
- [ ] Acceder con indexado `U[K]` y usarlo en el retorno y en parámetros.
- [ ] Definir una interface genérica con valor por defecto `<T = string>`.
- [ ] Instanciar la interface con dos tipos explícitos y una sin parámetro.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist generics-avanzados.ts` y luego `node dist/generics-avanzados.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `K extends keyof U` restringe la clave a las claves reales del objeto.
- `obj[clave]` con el tipo `U[K]` mantiene la relación exacta entre clave y valor.
- Para `cambiarCampo`, devuelve `{ ...obj, [clave]: valor }`.
- Default en interface: `interface Caja<T = string> { contenido: T; }`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist generics-avanzados.ts && node dist/generics-avanzados.js
interface Usuario {
  id: number;
  nombre: string;
  email: string;
  edad: number;
}

function obtenerCampo<U, K extends keyof U>(obj: U, clave: K): U[K] {
  return obj[clave];
}

function cambiarCampo<U, K extends keyof U>(obj: U, clave: K, valor: U[K]): U {
  return { ...obj, [clave]: valor };
}

interface Caja<T = string> {
  contenido: T;
}

const ana: Usuario = { id: 1, nombre: "Ana", email: "ana@correo.com", edad: 30 };

console.log(`Edad actual: ${obtenerCampo(ana, "edad")}`);
const actualizada = cambiarCampo(ana, "edad", 31);
console.log(`Edad tras cambio: ${actualizada.edad}`);

const cajaTexto: Caja<string> = { contenido: "hola" };
const cajaNumero: Caja<number> = { contenido: 42 };
const cajaDefault: Caja = { contenido: "generico" };

console.log(`Caja<string>: ${cajaTexto.contenido}`);
console.log(`Caja<number>: ${cajaNumero.contenido}`);
console.log(`Caja (default string): ${cajaDefault.contenido}`);
````

</details>