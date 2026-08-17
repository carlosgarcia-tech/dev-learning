# Ejercicio 05 — Bucles

- **Nivel:** 1/5
- **Tema:** for, while, for...of
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `bucles.js` que:

1. Con un bucle `for`, imprima los números del 1 al 5.
2. Con un `while`, imprima una cuenta regresiva del 5 al 1.
3. Con un bucle `for...of`, recorra el array `["manzana", "pera", "uva"]` e imprima cada fruta.
4. Con un `for`, sume los números del 1 al 100 e imprima el total.

Salida esperada:

```
for: 1 2 3 4 5
while: 5 4 3 2 1
for...of: manzana, pera, uva
Suma del 1 al 100: 5050
```

## Requisitos

- [ ] Usar los tres tipos de bucle (`for`, `while`, `for...of`).
- [ ] La suma del 1 al 100 debe dar exactamente 5050.
- [ ] Ejecutarlo localmente con `node bucles.js` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `for (let i = 1; i <= 5; i++)` recorre del 1 al 5.
- En el `while` decrementa el contador: `i--`.
- `for (const fruta of frutas)` recorre los valores, no los índices.
- Para la suma acumula en una variable `total += i`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
// 1) for del 1 al 5
let salidaFor = "for:";
for (let i = 1; i <= 5; i++) {
  salidaFor += ` ${i}`;
}
console.log(salidaFor);

// 2) while: cuenta regresiva del 5 al 1
let salidaWhile = "while:";
let n = 5;
while (n >= 1) {
  salidaWhile += ` ${n}`;
  n--;
}
console.log(salidaWhile);

// 3) for...of
const frutas = ["manzana", "pera", "uva"];
console.log("for...of:", frutas.join(", "));

// 4) suma del 1 al 100
let total = 0;
for (let i = 1; i <= 100; i++) {
  total += i;
}
console.log(`Suma del 1 al 100: ${total}`);
````

</details>