# Ejercicio 01 — Funciones

- **Nivel:** 2/5
- **Tema:** Declaración, expresión, parámetros, return
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `funciones.js` que:

1. Declare una función `saludar(nombre)` por **declaración** que devuelva `Hola, <nombre>!` y la llames con tu nombre.
2. Declare una función por **expresión** `esPar(n)` que devuelva `true` si el número es par.
3. Cree una función `sumarTodos(...numeros)` que use **rest** y devuelva la suma de todos los argumentos.
4. Cree una función `potencia(base, exponente = 2)` con **valor por defecto**.
5. Llame a todas e imprima los resultados.

Salida esperada (ejemplo):

```
Hola, Ana!
7 es par: false
8 es par: true
Suma de 1,2,3,4: 10
Suma sin argumentos: 0
3^2 (por defecto): 9
3^4: 81
```

## Requisitos

- [ ] Usar una declaración de función y una expresión de función.
- [ ] Usar parámetros rest (`...`) en al menos una función.
- [ ] Usar un valor por defecto en un parámetro.
- [ ] Ejecutarlo localmente con `node funciones.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-01-funciones.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Expresión: `const esPar = function (n) { return n % 2 === 0; };`.
- Rest: `function sumarTodos(...numeros)` → `numeros` es un array.
- Para la suma usa `reduce` o un bucle `for`.
- Valor por defecto: `function potencia(base, exponente = 2)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function saludar(nombre) {
  return `Hola, ${nombre}!`;
}

const esPar = function (n) {
  return n % 2 === 0;
};

function sumarTodos(...numeros) {
  return numeros.reduce((acc, n) => acc + n, 0);
}

function potencia(base, exponente = 2) {
  return base ** exponente;
}

if (require.main === module) {
  console.log(saludar("Ana"));
  console.log(`7 es par: ${esPar(7)}`);
  console.log(`8 es par: ${esPar(8)}`);
  console.log(`Suma de 1,2,3,4: ${sumarTodos(1, 2, 3, 4)}`);
  console.log(`Suma sin argumentos: ${sumarTodos()}`);
  console.log(`3^2 (por defecto): ${potencia(3)}`);
  console.log(`3^4: ${potencia(3, 4)}`);
}

module.exports = { saludar, esPar, sumarTodos, potencia };
````

</details>