# Ejercicio 04 — Destructuring y spread

- **Nivel:** 2/5
- **Tema:** Destructuring, spread/rest
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `destructuring.js` que:

1. Dado `const persona = { nombre: "Luis", edad: 28, ciudad: "Quito" }`, extraiga `nombre` y `ciudad` con **destructuring** e imprímalos.
2. Extraiga la propiedad `edad` con un alias: `edad: anios`, e imprima `anios`.
3. Con destructuring en array `const punto = [10, 20, 30]`, extraiga `x` y `y`, y con **rest** capture el resto en `resto`.
4. Combine dos arrays con **spread** `[...a, ...b]` y copie el objeto `persona` añadiendo `activo: true` con spread.
5. Cree una función `unir(...args)` que use rest y devuelva la concatenación de todos los argumentos.

Salida esperada:

```
nombre: Luis, ciudad: Quito
anios: 28
x: 10, y: 20, resto: [ 30 ]
Combinado: [ 1, 2, 3, 4, 5, 6 ]
Copia: { nombre: 'Luis', edad: 28, ciudad: 'Quito', activo: true }
unir: a,b,c
```

## Requisitos

- [ ] Usar destructuring de objeto con y sin alias.
- [ ] Usar destructuring de array con rest.
- [ ] Usar spread en arrays y en objetos.
- [ ] Ejecutarlo localmente con `node destructuring.js` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Alias: `const { edad: anios } = persona;`.
- Rest en arrays: `const [x, y, ...resto] = punto;`.
- Spread de objetos: `{ ...persona, activo: true }` (crea copia, no comparte referencia).
- `unir(...args)` recibe argumentos variados y `args` es un array.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
const persona = { nombre: "Luis", edad: 28, ciudad: "Quito" };
const { nombre, ciudad } = persona;
console.log(`nombre: ${nombre}, ciudad: ${ciudad}`);

const { edad: anios } = persona;
console.log(`anios: ${anios}`);

const punto = [10, 20, 30];
const [x, y, ...resto] = punto;
console.log(`x: ${x}, y: ${y}, resto: ${resto}`);

const a = [1, 2, 3];
const b = [4, 5, 6];
const combinado = [...a, ...b];
console.log(`Combinado: ${combinado}`);

const copia = { ...persona, activo: true };
console.log("Copia:", copia);

function unir(...args) {
  return args.join(",");
}
console.log(`unir: ${unir("a", "b", "c")}`);
````

</details>