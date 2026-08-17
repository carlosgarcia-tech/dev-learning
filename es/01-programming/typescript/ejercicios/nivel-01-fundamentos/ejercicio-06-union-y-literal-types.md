# Ejercicio 06 — Union y literal types

- **Nivel:** 1/5
- **Tema:** uniones `|`, tipos literales, narrowing con `switch`
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `union-literales.ts` que:

1. Declare un tipo literal `Direccion = "norte" | "sur" | "este" | "oeste"`.
2. Declare una variable `id` de tipo `number | string` y asígnale primero un número y luego un string (ambos válidos).
3. Escriba una función `etiquetaDir(d: Direccion): string` que con un `switch` devuelva un texto descriptivo para cada dirección.
4. Escriba una función `esTexto(valor: number | string): boolean` que devuelva `true` si el valor es `string`, usando narrowing con `typeof`.
5. Imprima ejemplos de cada caso.

Salida esperada (ejemplo):

```
Id como string: abc-123
Id como number: 9876
norte es hacia arriba
oeste es hacia la izquierda
esTexto("hola"): true
esTexto(42): false
```

## Requisitos

- [ ] Declarar un type literal con una unión de strings.
- [ ] Declarar una variable con unión `number | string` y asignar ambos tipos.
- [ ] Usar `switch` para recorrer todas las variantes del literal (todos los casos cubiertos).
- [ ] Usar `typeof` para hacer narrowing en la unión de primitivos.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist union-literales.ts` y luego `node dist/union-literales.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un type literal con unión: `type Direccion = "norte" | "sur" | "este" | "oeste";`.
- Si el `switch` cubre los 4 casos, la función queda exhaustiva y no necesita `return` extra.
- Narrowing: `if (typeof valor === "string") { valor.toUpperCase(); }`.
- Los casos del switch deben ser los literales exactos entre comillas.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist union-literales.ts && node dist/union-literales.js
type Direccion = "norte" | "sur" | "este" | "oeste";

function etiquetaDir(d: Direccion): string {
  switch (d) {
    case "norte":
      return "hacia arriba";
    case "sur":
      return "hacia abajo";
    case "este":
      return "hacia la derecha";
    case "oeste":
      return "hacia la izquierda";
  }
}

function esTexto(valor: number | string): boolean {
  return typeof valor === "string";
}

let id: number | string;
id = "abc-123";
console.log(`Id como string: ${id}`);
id = 9876;
console.log(`Id como number: ${id}`);

console.log(`norte ${etiquetaDir("norte")}`);
console.log(`oeste ${etiquetaDir("oeste")}`);
console.log(`esTexto("hola"): ${esTexto("hola")}`);
console.log(`esTexto(42): ${esTexto(42)}`);
````

</details>