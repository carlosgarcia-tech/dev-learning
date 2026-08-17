# Ejercicio 02 — Arrow functions

- **Nivel:** 2/5
- **Tema:** Arrow functions, retorno implícito
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `arrows.js` que:

1. Defina una arrow function `doble = (n) => ...` con retorno implícito.
2. Defina una arrow function de una línea `cuadrado` que devuelva `n * n`.
3. Defina una arrow con cuerpo de bloque `{}` y `return` explícito llamada `describir` que devuelva `"<nombre> tiene <edad> años"`.
4. Use `map` con una arrow para obtener los cuadrados de `[1, 2, 3, 4, 5]`.
5. Imprima todos los resultados.

Salida esperada:

```
doble(6): 12
cuadrado(9): 81
describir: Ana tiene 30 años
Cuadrados: [ 1, 4, 9, 16, 25 ]
```

## Requisitos

- [ ] Crear al menos 3 arrow functions, una con retorno implícito y una con bloque `{}`.
- [ ] Usar una arrow como callback dentro de `map`.
- [ ] Ejecutarlo localmente con `node arrows.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-02-arrow-functions.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Arrow con retorno implícito: `const doble = (n) => n * 2;`.
- Arrow con bloque: `const f = (x) => { ...; return x; };` — sin `return` devuelve `undefined`.
- `map` recibe una función y devuelve un nuevo array.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
const doble = (n) => n * 2;

const cuadrado = (n) => n * n;

const describir = (nombre, edad) => {
  return `${nombre} tiene ${edad} años`;
};

function calcularCuadrados(numeros) {
  return numeros.map((n) => n * n);
}

if (require.main === module) {
  console.log(`doble(6): ${doble(6)}`);
  console.log(`cuadrado(9): ${cuadrado(9)}`);
  console.log(`describir: ${describir("Ana", 30)}`);
  console.log(`Cuadrados: ${calcularCuadrados([1, 2, 3, 4, 5])}`);
}

module.exports = { doble, cuadrado, describir, calcularCuadrados };
````

</details>